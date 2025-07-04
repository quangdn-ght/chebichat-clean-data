-- Dictionary Schema for Chinese-Vietnamese Dictionary
-- Optimized for storage and query performance with 12,000+ records

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For text search optimization
CREATE EXTENSION IF NOT EXISTS "unaccent"; -- For Vietnamese text search

-- Create enum types for better performance and data integrity
CREATE TYPE word_type AS ENUM (
  'danh từ', 'động từ', 'tính từ', 'trạng từ', 'đại từ', 'giới từ', 
  'liên từ', 'thán từ', 'số từ', 'lượng từ', 'phó từ', 'other'
);

-- Main dictionary table
CREATE TABLE dictionary (
  -- Use Chinese as primary key for optimal performance
  chinese VARCHAR(100) PRIMARY KEY,
  
  -- Core Chinese data
  pinyin VARCHAR(200) NOT NULL,
  
  -- Word classification
  type word_type NOT NULL,
  
  -- Meanings (indexed for search)
  meaning_vi TEXT NOT NULL,
  meaning_en TEXT NOT NULL,
  
  -- Examples
  example_cn TEXT NOT NULL,
  example_vi TEXT NOT NULL,
  example_en TEXT NOT NULL,
  
  -- Grammar explanation
  grammar TEXT,
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Search optimization fields
  search_vector tsvector GENERATED ALWAYS AS (
    to_tsvector('simple', chinese || ' ' || pinyin || ' ' || meaning_vi || ' ' || meaning_en)
  ) STORED
);

-- Indexes for performance optimization
-- Primary key index is automatically created for chinese (PRIMARY KEY)

-- Pinyin search index
CREATE INDEX idx_dictionary_pinyin ON dictionary USING gin(pinyin gin_trgm_ops);

-- Vietnamese meaning search index
CREATE INDEX idx_dictionary_meaning_vi ON dictionary USING gin(meaning_vi gin_trgm_ops);

-- English meaning search index  
CREATE INDEX idx_dictionary_meaning_en ON dictionary USING gin(meaning_en gin_trgm_ops);

-- Word type filter index
CREATE INDEX idx_dictionary_type ON dictionary (type);

-- Full text search index
CREATE INDEX idx_dictionary_search_vector ON dictionary USING gin(search_vector);

-- Composite index for type-based queries (optimized since chinese is already primary)
CREATE INDEX idx_dictionary_type_pinyin ON dictionary (type, pinyin);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_dictionary_updated_at 
  BEFORE UPDATE ON dictionary 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();

-- Statistics view for monitoring
CREATE VIEW dictionary_stats AS
SELECT 
  COUNT(*) as total_words,
  COUNT(DISTINCT type) as unique_types,
  type,
  COUNT(*) as count_by_type,
  AVG(LENGTH(chinese)) as avg_chinese_length,
  AVG(LENGTH(meaning_vi)) as avg_meaning_vi_length,
  MIN(created_at) as earliest_entry,
  MAX(created_at) as latest_entry
FROM dictionary 
GROUP BY type
ORDER BY count_by_type DESC;

-- Search function for Vietnamese queries (handles accents)
CREATE OR REPLACE FUNCTION search_dictionary_vietnamese(search_term TEXT)
RETURNS TABLE (
  chinese VARCHAR(100),
  pinyin VARCHAR(200),
  type word_type,
  meaning_vi TEXT,
  meaning_en TEXT,
  example_cn TEXT,
  example_vi TEXT,
  example_en TEXT,
  grammar TEXT,
  similarity REAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    d.chinese, d.pinyin, d.type, d.meaning_vi, d.meaning_en,
    d.example_cn, d.example_vi, d.example_en, d.grammar,
    GREATEST(
      similarity(d.meaning_vi, search_term),
      similarity(d.example_vi, search_term),
      similarity(unaccent(d.meaning_vi), unaccent(search_term)),
      similarity(unaccent(d.example_vi), unaccent(search_term))
    ) as sim
  FROM dictionary d
  WHERE 
    d.meaning_vi ILIKE '%' || search_term || '%' 
    OR d.example_vi ILIKE '%' || search_term || '%'
    OR unaccent(d.meaning_vi) ILIKE '%' || unaccent(search_term) || '%'
    OR unaccent(d.example_vi) ILIKE '%' || unaccent(search_term) || '%'
    OR d.search_vector @@ plainto_tsquery('simple', search_term)
  ORDER BY sim DESC, d.chinese ASC
  LIMIT 50;
END;
$$ LANGUAGE plpgsql;

-- Search function for Chinese queries
CREATE OR REPLACE FUNCTION search_dictionary_chinese(search_term TEXT)
RETURNS TABLE (
  chinese VARCHAR(100),
  pinyin VARCHAR(200),
  type word_type,
  meaning_vi TEXT,
  meaning_en TEXT,
  example_cn TEXT,
  example_vi TEXT,
  example_en TEXT,
  grammar TEXT,
  similarity REAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    d.chinese, d.pinyin, d.type, d.meaning_vi, d.meaning_en,
    d.example_cn, d.example_vi, d.example_en, d.grammar,
    GREATEST(
      similarity(d.chinese, search_term),
      similarity(d.pinyin, search_term),
      similarity(d.example_cn, search_term)
    ) as sim
  FROM dictionary d
  WHERE 
    d.chinese ILIKE '%' || search_term || '%' 
    OR d.pinyin ILIKE '%' || search_term || '%'
    OR d.example_cn ILIKE '%' || search_term || '%'
    OR d.search_vector @@ plainto_tsquery('simple', search_term)
  ORDER BY sim DESC, d.chinese ASC
  LIMIT 50;
END;
$$ LANGUAGE plpgsql;

-- Performance monitoring view
CREATE VIEW dictionary_performance_stats AS
SELECT 
  schemaname,
  tablename,
  attname,
  n_distinct,
  correlation,
  null_frac,
  avg_width
FROM pg_stats 
WHERE tablename = 'dictionary';

-- Comments for documentation
COMMENT ON TABLE dictionary IS 'Main dictionary table storing Chinese-Vietnamese word entries with Chinese as primary key for optimal performance';
COMMENT ON COLUMN dictionary.chinese IS 'Chinese characters - primary key for fast lookups and ensuring uniqueness';
COMMENT ON COLUMN dictionary.search_vector IS 'Generated tsvector for full-text search across all text fields';
COMMENT ON INDEX idx_dictionary_pinyin IS 'Trigram index for pinyin search with fuzzy matching';
COMMENT ON INDEX idx_dictionary_search_vector IS 'Full-text search index for complex queries';

-- Supabase-specific role and permission setup
-- This section configures proper permissions for Supabase environment

-- Grant permissions to authenticated users (Supabase auth)
DO $$
BEGIN
    -- Grant usage on schema to authenticated role
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        GRANT USAGE ON SCHEMA public TO authenticated;
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO authenticated;
    END IF;
    
    -- Grant usage to anon role for public read access
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
        GRANT USAGE ON SCHEMA public TO anon;
    END IF;
END $$;

-- Supabase RLS setup (can be customized based on requirements)
-- Note: RLS is disabled during import for performance, can be enabled later

-- Additional optimizations for Chinese primary key
-- Create a unique constraint to enforce data integrity
ALTER TABLE dictionary ADD CONSTRAINT dictionary_chinese_unique UNIQUE (chinese);

-- Function to get word by Chinese characters (optimized for primary key)
CREATE OR REPLACE FUNCTION get_word_by_chinese(word_chinese TEXT)
RETURNS TABLE (
  chinese VARCHAR(100),
  pinyin VARCHAR(200),
  type word_type,
  meaning_vi TEXT,
  meaning_en TEXT,
  example_cn TEXT,
  example_vi TEXT,
  example_en TEXT,
  grammar TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    d.chinese, d.pinyin, d.type, d.meaning_vi, d.meaning_en,
    d.example_cn, d.example_vi, d.example_en, d.grammar
  FROM dictionary d
  WHERE d.chinese = word_chinese;
END;
$$ LANGUAGE plpgsql;

-- Function for batch lookup by Chinese characters (optimized)
CREATE OR REPLACE FUNCTION get_words_by_chinese_list(word_list TEXT[])
RETURNS TABLE (
  chinese VARCHAR(100),
  pinyin VARCHAR(200),
  type word_type,
  meaning_vi TEXT,
  meaning_en TEXT,
  example_cn TEXT,
  example_vi TEXT,
  example_en TEXT,
  grammar TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    d.chinese, d.pinyin, d.type, d.meaning_vi, d.meaning_en,
    d.example_cn, d.example_vi, d.example_en, d.grammar
  FROM dictionary d
  WHERE d.chinese = ANY(word_list)
  ORDER BY d.chinese;
END;
$$ LANGUAGE plpgsql;

-- Function to check if Chinese word exists (fast primary key lookup)
CREATE OR REPLACE FUNCTION word_exists(word_chinese TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (SELECT 1 FROM dictionary WHERE chinese = word_chinese);
END;
$$ LANGUAGE plpgsql;

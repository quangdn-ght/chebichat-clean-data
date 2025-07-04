-- Radicals Poem Schema for Chinese Character Mnemonic System
-- Optimized for storage and query performance with radical-dictionary relationships
-- Stores Vietnamese poetic descriptions for Chinese characters/radicals

-- Enable required extensions (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For text search optimization
CREATE EXTENSION IF NOT EXISTS "unaccent"; -- For Vietnamese text search

-- Create enum type for radical categories (can be extended)
CREATE TYPE radical_category AS ENUM (
  'basic_radical',        -- Basic radicals (部首)
  'compound_character',   -- Compound characters
  'pictograph',          -- Pictographic characters
  'ideograph',           -- Ideographic characters
  'phonetic_compound',   -- Phonetic compounds
  'other'
);

-- Main radicals poem table
CREATE TABLE radicals_poem (
  -- Use Chinese character as primary key for optimal performance and uniqueness
  chinese VARCHAR(10) PRIMARY KEY,
  
  -- Vietnamese poetic description (core data)
  poem_description TEXT NOT NULL,
  
  -- Optional categorization
  category radical_category DEFAULT 'other',
  
  -- Optional stroke count for educational purposes
  stroke_count SMALLINT CHECK (stroke_count > 0 AND stroke_count <= 50),
  
  -- Optional radical number (traditional radical system)
  radical_number SMALLINT CHECK (radical_number > 0 AND radical_number <= 300),
  
  -- Optional additional notes or variations
  notes TEXT,
  
  -- Search optimization - normalized Vietnamese text for better search
  normalized_description TEXT,
  
  -- Full-text search vector
  search_vector tsvector,
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Performance indexes
-- Primary key index is automatically created for chinese

-- Vietnamese poem description search (trigram for fuzzy matching)
CREATE INDEX idx_radicals_poem_description ON radicals_poem USING gin(poem_description gin_trgm_ops);

-- Normalized description search for accent-insensitive search
CREATE INDEX idx_radicals_poem_normalized ON radicals_poem USING gin(normalized_description gin_trgm_ops);

-- Category filter index
CREATE INDEX idx_radicals_poem_category ON radicals_poem (category);

-- Stroke count index for educational queries
CREATE INDEX idx_radicals_poem_stroke_count ON radicals_poem (stroke_count) WHERE stroke_count IS NOT NULL;

-- Radical number index
CREATE INDEX idx_radicals_poem_radical_number ON radicals_poem (radical_number) WHERE radical_number IS NOT NULL;

-- Full-text search index
CREATE INDEX idx_radicals_poem_search_vector ON radicals_poem USING gin(search_vector);

-- Composite index for category + stroke count queries
CREATE INDEX idx_radicals_poem_category_stroke ON radicals_poem (category, stroke_count) WHERE stroke_count IS NOT NULL;

-- Function to update updated_at timestamp and search fields
CREATE OR REPLACE FUNCTION update_radicals_poem_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    
    -- Update normalized description (accent-free, lowercase)
    NEW.normalized_description = lower(unaccent(NEW.poem_description));
    
    -- Update search vector
    NEW.search_vector = to_tsvector('simple', NEW.chinese || ' ' || NEW.poem_description || ' ' || COALESCE(NEW.notes, ''));
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Function to populate search fields on insert
CREATE OR REPLACE FUNCTION populate_radicals_poem_search_fields()
RETURNS TRIGGER AS $$
BEGIN
    -- Populate normalized description (accent-free, lowercase)
    NEW.normalized_description = lower(unaccent(NEW.poem_description));
    
    -- Populate search vector
    NEW.search_vector = to_tsvector('simple', NEW.chinese || ' ' || NEW.poem_description || ' ' || COALESCE(NEW.notes, ''));
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to populate search fields on insert
CREATE TRIGGER populate_radicals_poem_search_fields_insert
  BEFORE INSERT ON radicals_poem 
  FOR EACH ROW 
  EXECUTE FUNCTION populate_radicals_poem_search_fields();

-- Trigger to automatically update updated_at and search fields on update
CREATE TRIGGER update_radicals_poem_updated_at 
  BEFORE UPDATE ON radicals_poem 
  FOR EACH ROW 
  EXECUTE FUNCTION update_radicals_poem_updated_at();

-- Relationship view: Join radicals with dictionary entries
-- This shows which radicals appear in dictionary words
CREATE VIEW radicals_dictionary_relation AS
SELECT 
  r.chinese as radical_char,
  r.poem_description,
  r.category,
  r.stroke_count,
  d.chinese as dictionary_word,
  d.pinyin,
  d.type as word_type,
  d.meaning_vi,
  d.meaning_en,
  -- Check if radical appears at start, middle, or end
  CASE 
    WHEN d.chinese LIKE r.chinese || '%' THEN 'prefix'
    WHEN d.chinese LIKE '%' || r.chinese || '%' THEN 'contains'
    WHEN d.chinese LIKE '%' || r.chinese THEN 'suffix'
    ELSE 'exact_match'
  END as position_in_word
FROM radicals_poem r
JOIN dictionary d ON d.chinese LIKE '%' || r.chinese || '%'
ORDER BY r.chinese, d.chinese;

-- Statistics view for monitoring
CREATE VIEW radicals_poem_stats AS
SELECT 
  COUNT(*) as total_radicals,
  COUNT(DISTINCT category) as unique_categories,
  category,
  COUNT(*) as count_by_category,
  AVG(LENGTH(chinese)) as avg_char_length,
  AVG(LENGTH(poem_description)) as avg_description_length,
  AVG(stroke_count) as avg_stroke_count,
  MIN(created_at) as earliest_entry,
  MAX(created_at) as latest_entry
FROM radicals_poem 
GROUP BY category
ORDER BY count_by_category DESC;

-- Search function for Vietnamese poem descriptions (handles accents)
CREATE OR REPLACE FUNCTION search_radicals_by_description(search_term TEXT)
RETURNS TABLE (
  chinese VARCHAR(10),
  poem_description TEXT,
  category radical_category,
  stroke_count SMALLINT,
  radical_number SMALLINT,
  notes TEXT,
  similarity REAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.chinese, r.poem_description, r.category, r.stroke_count, 
    r.radical_number, r.notes,
    GREATEST(
      similarity(r.poem_description, search_term),
      similarity(r.normalized_description, lower(unaccent(search_term))),
      similarity(COALESCE(r.notes, ''), search_term)
    ) as sim
  FROM radicals_poem r
  WHERE 
    r.poem_description ILIKE '%' || search_term || '%' 
    OR r.normalized_description ILIKE '%' || lower(unaccent(search_term)) || '%'
    OR r.notes ILIKE '%' || search_term || '%'
    OR r.search_vector @@ plainto_tsquery('simple', search_term)
  ORDER BY sim DESC, r.chinese ASC
  LIMIT 30;
END;
$$ LANGUAGE plpgsql;

-- Search function for Chinese characters
CREATE OR REPLACE FUNCTION search_radicals_by_chinese(search_term TEXT)
RETURNS TABLE (
  chinese VARCHAR(10),
  poem_description TEXT,
  category radical_category,
  stroke_count SMALLINT,
  radical_number SMALLINT,
  notes TEXT,
  similarity REAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.chinese, r.poem_description, r.category, r.stroke_count, 
    r.radical_number, r.notes,
    similarity(r.chinese, search_term) as sim
  FROM radicals_poem r
  WHERE 
    r.chinese ILIKE '%' || search_term || '%' 
    OR r.search_vector @@ plainto_tsquery('simple', search_term)
  ORDER BY sim DESC, r.chinese ASC
  LIMIT 30;
END;
$$ LANGUAGE plpgsql;

-- Function to get radical by exact Chinese character
CREATE OR REPLACE FUNCTION get_radical_by_chinese(char_chinese TEXT)
RETURNS TABLE (
  chinese VARCHAR(10),
  poem_description TEXT,
  category radical_category,
  stroke_count SMALLINT,
  radical_number SMALLINT,
  notes TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.chinese, r.poem_description, r.category, r.stroke_count, 
    r.radical_number, r.notes
  FROM radicals_poem r
  WHERE r.chinese = char_chinese;
END;
$$ LANGUAGE plpgsql;

-- Function to find dictionary words containing a radical
CREATE OR REPLACE FUNCTION get_dictionary_words_with_radical(radical_char TEXT)
RETURNS TABLE (
  radical_chinese VARCHAR(10),
  radical_poem TEXT,
  dictionary_chinese VARCHAR(100),
  pinyin VARCHAR(200),
  meaning_vi TEXT,
  meaning_en TEXT,
  position_type TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.chinese as radical_chinese,
    r.poem_description as radical_poem,
    d.chinese as dictionary_chinese,
    d.pinyin,
    d.meaning_vi,
    d.meaning_en,
    CASE 
      WHEN d.chinese = r.chinese THEN 'exact_match'
      WHEN d.chinese LIKE r.chinese || '%' THEN 'prefix'
      WHEN d.chinese LIKE '%' || r.chinese || '%' THEN 'contains'
      WHEN d.chinese LIKE '%' || r.chinese THEN 'suffix'
      ELSE 'other'
    END as position_type
  FROM radicals_poem r
  JOIN dictionary d ON d.chinese LIKE '%' || r.chinese || '%'
  WHERE r.chinese = radical_char
  ORDER BY 
    CASE 
      WHEN d.chinese = r.chinese THEN 1
      WHEN d.chinese LIKE r.chinese || '%' THEN 2
      WHEN d.chinese LIKE '%' || r.chinese THEN 3
      ELSE 4
    END,
    d.chinese;
END;
$$ LANGUAGE plpgsql;

-- Function to get radicals by category
CREATE OR REPLACE FUNCTION get_radicals_by_category(cat radical_category)
RETURNS TABLE (
  chinese VARCHAR(10),
  poem_description TEXT,
  stroke_count SMALLINT,
  radical_number SMALLINT,
  notes TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.chinese, r.poem_description, r.stroke_count, r.radical_number, r.notes
  FROM radicals_poem r
  WHERE r.category = cat
  ORDER BY 
    COALESCE(r.stroke_count, 999), 
    COALESCE(r.radical_number, 999), 
    r.chinese;
END;
$$ LANGUAGE plpgsql;

-- Function to get radicals by stroke count range
CREATE OR REPLACE FUNCTION get_radicals_by_stroke_range(min_strokes SMALLINT, max_strokes SMALLINT)
RETURNS TABLE (
  chinese VARCHAR(10),
  poem_description TEXT,
  category radical_category,
  stroke_count SMALLINT,
  notes TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.chinese, r.poem_description, r.category, r.stroke_count, r.notes
  FROM radicals_poem r
  WHERE r.stroke_count BETWEEN min_strokes AND max_strokes
  ORDER BY r.stroke_count, r.chinese;
END;
$$ LANGUAGE plpgsql;

-- Performance monitoring view
CREATE VIEW radicals_poem_performance_stats AS
SELECT 
  schemaname,
  tablename,
  attname,
  n_distinct,
  correlation,
  null_frac,
  avg_width
FROM pg_stats 
WHERE tablename = 'radicals_poem';

-- Supabase-specific role and permission setup
DO $$
BEGIN
    -- Grant permissions to authenticated users (Supabase auth)
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        GRANT USAGE ON SCHEMA public TO authenticated;
        GRANT SELECT ON radicals_poem TO authenticated;
        GRANT SELECT ON radicals_dictionary_relation TO authenticated;
        GRANT SELECT ON radicals_poem_stats TO authenticated;
    END IF;
    
    -- Grant usage to anon role for public read access
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
        GRANT USAGE ON SCHEMA public TO anon;
        GRANT SELECT ON radicals_poem TO anon;
        GRANT SELECT ON radicals_dictionary_relation TO anon;
        GRANT SELECT ON radicals_poem_stats TO anon;
    END IF;
END $$;

-- Comments for documentation
COMMENT ON TABLE radicals_poem IS 'Stores Vietnamese poetic descriptions for Chinese characters and radicals to aid in memorization';
COMMENT ON COLUMN radicals_poem.chinese IS 'Chinese character/radical - primary key for fast lookups';
COMMENT ON COLUMN radicals_poem.poem_description IS 'Vietnamese poetic mnemonic description of the character';
COMMENT ON COLUMN radicals_poem.normalized_description IS 'Accent-free lowercase version for improved Vietnamese search (populated by trigger)';
COMMENT ON COLUMN radicals_poem.search_vector IS 'Full-text search vector across all text fields (populated by trigger)';
COMMENT ON VIEW radicals_dictionary_relation IS 'Shows relationships between radicals and dictionary words containing them';
COMMENT ON INDEX idx_radicals_poem_description IS 'Trigram index for fuzzy Vietnamese text search';
COMMENT ON INDEX idx_radicals_poem_normalized IS 'Index for accent-insensitive Vietnamese search';

-- Sample data insertion function for testing
CREATE OR REPLACE FUNCTION insert_sample_radicals_data()
RETURNS VOID AS $$
BEGIN
  INSERT INTO radicals_poem (chinese, poem_description, category, stroke_count) VALUES
  ('黄', 'Bụng lớn vàng vọt, tượng hình người khuyết tật.', 'pictograph', 11),
  ('它', 'Rắn uốn lượn mềm, chữ xưa vẽ dáng rắn.', 'pictograph', 5),
  ('直', 'Mắt nhìn thẳng băng, đường ngay không ngoặt.', 'ideograph', 8),
  ('带', 'Thắt lưng quấn quanh, dệt nên nét đẹp.', 'pictograph', 9)
  ON CONFLICT (chinese) DO UPDATE SET
    poem_description = EXCLUDED.poem_description,
    category = EXCLUDED.category,
    stroke_count = EXCLUDED.stroke_count;
END;
$$ LANGUAGE plpgsql;

-- Create additional constraint to ensure data quality
ALTER TABLE radicals_poem ADD CONSTRAINT radicals_poem_description_not_empty 
  CHECK (LENGTH(TRIM(poem_description)) > 0);

-- Create index for efficient Chinese character length queries
CREATE INDEX idx_radicals_poem_char_length ON radicals_poem (LENGTH(chinese));

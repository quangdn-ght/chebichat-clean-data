-- Optimized Supabase Schema for Chinese Text Learning Data
-- This schema is designed for efficient storage and querying of Chinese text analysis data

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Create enum types for better performance and data integrity
CREATE TYPE processing_status AS ENUM ('pending', 'processing', 'completed', 'failed');
CREATE TYPE hsk_level AS ENUM ('hsk1', 'hsk2', 'hsk3', 'hsk4', 'hsk5', 'hsk6', 'hsk7', 'other');

-- 1. Categories table (normalized)
CREATE TABLE categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Sources table (normalized)
CREATE TABLE sources (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(200) UNIQUE NOT NULL,
  description TEXT,
  total_items INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Processing batches table (to track bulk processing)
CREATE TABLE processing_batches (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  processed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  total_items INTEGER NOT NULL DEFAULT 0,
  successful_items INTEGER NOT NULL DEFAULT 0,
  failed_items INTEGER NOT NULL DEFAULT 0,
  status processing_status DEFAULT 'pending',
  summary JSONB, -- Store the summary statistics
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Main letters table (core content)
CREATE TABLE letters (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  batch_id UUID REFERENCES processing_batches(id) ON DELETE SET NULL,
  
  -- Core content
  original TEXT NOT NULL,
  pinyin TEXT,
  vietnamese TEXT,
  
  -- References
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  source_id UUID REFERENCES sources(id) ON DELETE SET NULL,
  
  -- Processing status
  processed BOOLEAN DEFAULT false,
  processing_status processing_status DEFAULT 'pending',
  
  -- Text statistics (denormalized for performance)
  character_count INTEGER,
  word_count INTEGER,
  unique_word_count INTEGER,
  average_word_length DECIMAL(10,6),
  
  -- HSK statistics (denormalized for fast filtering)
  hsk1_count INTEGER DEFAULT 0,
  hsk2_count INTEGER DEFAULT 0,
  hsk3_count INTEGER DEFAULT 0,
  hsk4_count INTEGER DEFAULT 0,
  hsk5_count INTEGER DEFAULT 0,
  hsk6_count INTEGER DEFAULT 0,
  hsk7_count INTEGER DEFAULT 0,
  other_count INTEGER DEFAULT 0,
  total_hsk_words INTEGER DEFAULT 0,
  
  -- HSK percentages (computed for fast queries)
  hsk1_percentage DECIMAL(5,2) DEFAULT 0,
  hsk2_percentage DECIMAL(5,2) DEFAULT 0,
  hsk3_percentage DECIMAL(5,2) DEFAULT 0,
  hsk4_percentage DECIMAL(5,2) DEFAULT 0,
  hsk5_percentage DECIMAL(5,2) DEFAULT 0,
  hsk6_percentage DECIMAL(5,2) DEFAULT 0,
  hsk7_percentage DECIMAL(5,2) DEFAULT 0,
  other_percentage DECIMAL(5,2) DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. HSK words table (normalized for detailed word analysis)
CREATE TABLE letter_words (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  letter_id UUID REFERENCES letters(id) ON DELETE CASCADE NOT NULL,
  word TEXT NOT NULL,
  hsk_level hsk_level NOT NULL,
  frequency INTEGER DEFAULT 1, -- How many times this word appears in the letter
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure unique word per letter per level
  UNIQUE(letter_id, word, hsk_level)
);

-- 6. Vocabulary frequency table (for overall statistics)
CREATE TABLE vocabulary_frequency (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  letter_id UUID REFERENCES letters(id) ON DELETE CASCADE NOT NULL,
  word TEXT NOT NULL,
  frequency INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure unique word per letter
  UNIQUE(letter_id, word)
);

-- Create indexes for optimal query performance

-- Letters table indexes
CREATE INDEX idx_letters_batch_id ON letters(batch_id);
CREATE INDEX idx_letters_category_id ON letters(category_id);
CREATE INDEX idx_letters_source_id ON letters(source_id);
CREATE INDEX idx_letters_processed ON letters(processed);
CREATE INDEX idx_letters_processing_status ON letters(processing_status);
CREATE INDEX idx_letters_created_at ON letters(created_at DESC);

-- HSK level indexes for filtering
CREATE INDEX idx_letters_hsk1_count ON letters(hsk1_count);
CREATE INDEX idx_letters_hsk2_count ON letters(hsk2_count);
CREATE INDEX idx_letters_hsk3_count ON letters(hsk3_count);
CREATE INDEX idx_letters_hsk4_count ON letters(hsk4_count);
CREATE INDEX idx_letters_hsk5_count ON letters(hsk5_count);
CREATE INDEX idx_letters_hsk6_count ON letters(hsk6_count);
CREATE INDEX idx_letters_total_hsk_words ON letters(total_hsk_words);

-- Composite indexes for common queries
CREATE INDEX idx_letters_category_hsk_level ON letters(category_id, hsk1_count, hsk2_count, hsk3_count);
CREATE INDEX idx_letters_source_difficulty ON letters(source_id, total_hsk_words, other_percentage);

-- Text search indexes
CREATE INDEX idx_letters_original_gin ON letters USING GIN (to_tsvector('simple', original));
CREATE INDEX idx_letters_vietnamese_gin ON letters USING GIN (to_tsvector('english', vietnamese));
CREATE INDEX idx_letters_pinyin_gin ON letters USING GIN (to_tsvector('simple', pinyin));

-- Letter words indexes
CREATE INDEX idx_letter_words_letter_id ON letter_words(letter_id);
CREATE INDEX idx_letter_words_word ON letter_words(word);
CREATE INDEX idx_letter_words_hsk_level ON letter_words(hsk_level);
CREATE INDEX idx_letter_words_word_hsk ON letter_words(word, hsk_level);

-- Vocabulary frequency indexes
CREATE INDEX idx_vocab_freq_letter_id ON vocabulary_frequency(letter_id);
CREATE INDEX idx_vocab_freq_word ON vocabulary_frequency(word);
CREATE INDEX idx_vocab_freq_frequency ON vocabulary_frequency(frequency DESC);

-- Trigram indexes for fuzzy search
CREATE INDEX idx_letters_original_trgm ON letters USING GIN (original gin_trgm_ops);
CREATE INDEX idx_letter_words_word_trgm ON letter_words USING GIN (word gin_trgm_ops);

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE processing_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE letters ENABLE ROW LEVEL SECURITY;
ALTER TABLE letter_words ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary_frequency ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for public read access
CREATE POLICY "Public read access for categories" ON categories FOR SELECT USING (true);
CREATE POLICY "Public read access for sources" ON sources FOR SELECT USING (true);
CREATE POLICY "Public read access for processing_batches" ON processing_batches FOR SELECT USING (true);
CREATE POLICY "Public read access for letters" ON letters FOR SELECT USING (true);
CREATE POLICY "Public read access for letter_words" ON letter_words FOR SELECT USING (true);
CREATE POLICY "Public read access for vocabulary_frequency" ON vocabulary_frequency FOR SELECT USING (true);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Create trigger for letters table
CREATE TRIGGER update_letters_updated_at
  BEFORE UPDATE ON letters
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Function to calculate HSK statistics when inserting/updating words
CREATE OR REPLACE FUNCTION update_letter_hsk_stats()
RETURNS TRIGGER AS $$
DECLARE
  letter_rec RECORD;
BEGIN
  -- Get current letter stats
  SELECT 
    COUNT(*) FILTER (WHERE hsk_level = 'hsk1') as hsk1_count,
    COUNT(*) FILTER (WHERE hsk_level = 'hsk2') as hsk2_count,
    COUNT(*) FILTER (WHERE hsk_level = 'hsk3') as hsk3_count,
    COUNT(*) FILTER (WHERE hsk_level = 'hsk4') as hsk4_count,
    COUNT(*) FILTER (WHERE hsk_level = 'hsk5') as hsk5_count,
    COUNT(*) FILTER (WHERE hsk_level = 'hsk6') as hsk6_count,
    COUNT(*) FILTER (WHERE hsk_level = 'hsk7') as hsk7_count,
    COUNT(*) FILTER (WHERE hsk_level = 'other') as other_count,
    COUNT(*) as total_count
  INTO letter_rec
  FROM letter_words 
  WHERE letter_id = COALESCE(NEW.letter_id, OLD.letter_id);
  
  -- Update the letters table with calculated statistics
  UPDATE letters SET
    hsk1_count = letter_rec.hsk1_count,
    hsk2_count = letter_rec.hsk2_count,
    hsk3_count = letter_rec.hsk3_count,
    hsk4_count = letter_rec.hsk4_count,
    hsk5_count = letter_rec.hsk5_count,
    hsk6_count = letter_rec.hsk6_count,
    hsk7_count = letter_rec.hsk7_count,
    other_count = letter_rec.other_count,
    total_hsk_words = letter_rec.total_count,
    -- Calculate percentages
    hsk1_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.hsk1_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    hsk2_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.hsk2_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    hsk3_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.hsk3_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    hsk4_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.hsk4_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    hsk5_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.hsk5_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    hsk6_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.hsk6_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    hsk7_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.hsk7_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    other_percentage = CASE WHEN letter_rec.total_count > 0 THEN ROUND((letter_rec.other_count::DECIMAL / letter_rec.total_count * 100), 2) ELSE 0 END,
    updated_at = NOW()
  WHERE id = COALESCE(NEW.letter_id, OLD.letter_id);
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE 'plpgsql';

-- Create triggers to automatically update HSK statistics
CREATE TRIGGER update_letter_hsk_stats_insert
  AFTER INSERT ON letter_words
  FOR EACH ROW
  EXECUTE FUNCTION update_letter_hsk_stats();

CREATE TRIGGER update_letter_hsk_stats_update
  AFTER UPDATE ON letter_words
  FOR EACH ROW
  EXECUTE FUNCTION update_letter_hsk_stats();

CREATE TRIGGER update_letter_hsk_stats_delete
  AFTER DELETE ON letter_words
  FOR EACH ROW
  EXECUTE FUNCTION update_letter_hsk_stats();

-- Create optimized views for common queries

-- View for letters with aggregated word data (for API responses)
CREATE VIEW letters_with_words AS
SELECT 
  l.*,
  c.name as category_name,
  s.name as source_name,
  COALESCE(
    json_object_agg(
      lw.hsk_level, 
      lw.words
    ) FILTER (WHERE lw.hsk_level IS NOT NULL), 
    '{}'::json
  ) as words_by_level,
  COALESCE(
    json_object_agg(
      vf.word,
      vf.frequency
    ) FILTER (WHERE vf.word IS NOT NULL),
    '{}'::json
  ) as vocabulary_frequency
FROM letters l
LEFT JOIN categories c ON l.category_id = c.id
LEFT JOIN sources s ON l.source_id = s.id
LEFT JOIN (
  SELECT 
    lw_inner.letter_id,
    lw_inner.hsk_level,
    json_agg(lw_inner.word ORDER BY lw_inner.word) as words
  FROM letter_words lw_inner
  GROUP BY lw_inner.letter_id, lw_inner.hsk_level
) lw ON l.id = lw.letter_id
LEFT JOIN vocabulary_frequency vf ON l.id = vf.letter_id
GROUP BY l.id, c.name, s.name;

-- View for HSK difficulty analysis
CREATE VIEW letters_difficulty_analysis AS
SELECT 
  l.id,
  l.original,
  l.category_id,
  l.source_id,
  c.name as category_name,
  s.name as source_name,
  l.total_hsk_words,
  l.character_count,
  l.word_count,
  -- Difficulty score calculation (lower HSK levels = easier)
  ROUND(
    (l.hsk1_count * 1.0 + l.hsk2_count * 2.0 + l.hsk3_count * 3.0 + 
     l.hsk4_count * 4.0 + l.hsk5_count * 5.0 + l.hsk6_count * 6.0 + 
     l.hsk7_count * 7.0 + l.other_count * 8.0) / 
    NULLIF(l.total_hsk_words, 0), 2
  ) as difficulty_score,
  -- Beginner friendly score (HSK 1-3 percentage)
  ROUND(
    (l.hsk1_percentage + l.hsk2_percentage + l.hsk3_percentage), 2
  ) as beginner_friendly_percentage,
  l.created_at
FROM letters l
LEFT JOIN categories c ON l.category_id = c.id
LEFT JOIN sources s ON l.source_id = s.id
WHERE l.processed = true;

-- Insert default data
INSERT INTO categories (name, description) VALUES 
  ('life', 'Life advice and philosophy'),
  ('motivation', 'Motivational content'),
  ('wisdom', 'Wisdom and insights'),
  ('success', 'Success and achievement'),
  ('personal_growth', 'Personal development'),
  ('relationships', 'Relationships and social interactions'),
  ('work', 'Work and career advice'),
  ('health', 'Health and wellness'),
  ('learning', 'Learning and education'),
  ('finance', 'Money and financial advice');

INSERT INTO sources (name, description) VALUES 
  ('999 letters to yourself', 'Collection of 999 inspirational letters for personal growth');

-- Function to insert a complete letter with all associated data
CREATE OR REPLACE FUNCTION insert_complete_letter(
  p_original TEXT,
  p_batch_id UUID DEFAULT NULL,
  p_pinyin TEXT DEFAULT NULL,
  p_vietnamese TEXT DEFAULT NULL,
  p_category_name VARCHAR(50) DEFAULT NULL,
  p_source_name VARCHAR(200) DEFAULT NULL,
  p_words JSONB DEFAULT NULL,
  p_vocabulary JSONB DEFAULT NULL,
  p_text_stats JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  letter_id UUID;
  category_id UUID;
  source_id UUID;
  hsk_level_key TEXT;
  word_item TEXT;
  vocab_word TEXT;
  vocab_freq INTEGER;
BEGIN
  -- Get or create category
  IF p_category_name IS NOT NULL THEN
    INSERT INTO categories (name) VALUES (p_category_name) 
    ON CONFLICT (name) DO NOTHING;
    SELECT id INTO category_id FROM categories WHERE name = p_category_name;
  END IF;
  
  -- Get or create source
  IF p_source_name IS NOT NULL THEN
    INSERT INTO sources (name) VALUES (p_source_name) 
    ON CONFLICT (name) DO NOTHING;
    SELECT id INTO source_id FROM sources WHERE name = p_source_name;
  END IF;
  
  -- Insert letter with text statistics
  INSERT INTO letters (
    batch_id, original, pinyin, vietnamese, category_id, source_id,
    character_count, word_count, unique_word_count, average_word_length,
    processed
  )
  VALUES (
    p_batch_id, p_original, p_pinyin, p_vietnamese, category_id, source_id,
    COALESCE((p_text_stats->>'characterCount')::INTEGER, 0),
    COALESCE((p_text_stats->>'wordCount')::INTEGER, 0),
    COALESCE((p_text_stats->>'uniqueWordCount')::INTEGER, 0),
    COALESCE((p_text_stats->>'averageWordLength')::DECIMAL, 0),
    true
  )
  RETURNING id INTO letter_id;
  
  -- Insert HSK words if provided
  IF p_words IS NOT NULL THEN
    FOR hsk_level_key IN SELECT jsonb_object_keys(p_words)
    LOOP
      FOR word_item IN SELECT jsonb_array_elements_text(p_words->hsk_level_key)
      LOOP
        INSERT INTO letter_words (letter_id, word, hsk_level)
        VALUES (letter_id, word_item, hsk_level_key::hsk_level)
        ON CONFLICT (letter_id, word, hsk_level) DO NOTHING;
      END LOOP;
    END LOOP;
  END IF;
  
  -- Insert vocabulary frequency if provided
  IF p_vocabulary IS NOT NULL THEN
    FOR vocab_word IN SELECT jsonb_object_keys(p_vocabulary)
    LOOP
      vocab_freq := (p_vocabulary->>vocab_word)::INTEGER;
      INSERT INTO vocabulary_frequency (letter_id, word, frequency)
      VALUES (letter_id, vocab_word, vocab_freq)
      ON CONFLICT (letter_id, word) DO UPDATE SET frequency = EXCLUDED.frequency;
    END LOOP;
  END IF;
  
  RETURN letter_id;
END;
$$ LANGUAGE plpgsql;

-- Create indexes for better JSON query performance on processing_batches
CREATE INDEX idx_processing_batches_summary_gin ON processing_batches USING GIN (summary);

-- Comments explaining design decisions:
-- 1. Denormalized HSK counts in letters table for fast filtering and sorting
-- 2. Separate letter_words table for detailed word analysis and flexibility
-- 3. Vocabulary frequency table for word usage patterns
-- 4. Processing batches to track bulk operations
-- 5. Comprehensive indexing strategy for common query patterns
-- 6. Triggers to automatically maintain HSK statistics
-- 7. Views for common API response formats
-- 8. Functions for complex insert operations
-- 9. Full-text search capabilities with GIN indexes
-- 10. Trigram indexes for fuzzy search functionality

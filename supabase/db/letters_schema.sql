-- Create categories table
CREATE TABLE categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create sources table
CREATE TABLE sources (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create letters table
CREATE TABLE letters (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  original TEXT NOT NULL,
  pinyin TEXT,
  vietnamese TEXT,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  source_id UUID REFERENCES sources(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create HSK words table for normalized word storage
CREATE TABLE hsk_words (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  letter_id UUID REFERENCES letters(id) ON DELETE CASCADE NOT NULL,
  word TEXT NOT NULL,
  hsk_level INTEGER NOT NULL CHECK (hsk_level BETWEEN 1 AND 6),
  is_other BOOLEAN DEFAULT FALSE, -- for words not in HSK
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Composite index for faster queries
  INDEX idx_hsk_words_letter_level (letter_id, hsk_level),
  INDEX idx_hsk_words_word (word),
  INDEX idx_hsk_words_level (hsk_level)
);

-- Alternative: If you prefer JSON storage for words (less normalized but simpler queries)
-- You can add this column to letters table instead of separate hsk_words table:
-- ALTER TABLE letters ADD COLUMN words JSONB;
-- CREATE INDEX idx_letters_words_gin ON letters USING GIN (words);

-- Create indexes for better performance
CREATE INDEX idx_letters_category ON letters(category_id);
CREATE INDEX idx_letters_source ON letters(source_id);
CREATE INDEX idx_letters_created_at ON letters(created_at DESC);
CREATE INDEX idx_letters_original_text ON letters USING GIN (to_tsvector('english', original));
CREATE INDEX idx_letters_vietnamese_text ON letters USING GIN (to_tsvector('english', vietnamese));

-- Enable Row Level Security (RLS) if needed for multi-user access
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE letters ENABLE ROW LEVEL SECURITY;
ALTER TABLE hsk_words ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (adjust based on your access requirements)
-- For public read access (adjust as needed):
CREATE POLICY "Public read access for categories" ON categories
  FOR SELECT USING (true);

CREATE POLICY "Public read access for sources" ON sources
  FOR SELECT USING (true);

CREATE POLICY "Public read access for letters" ON letters
  FOR SELECT USING (true);

CREATE POLICY "Public read access for hsk_words" ON hsk_words
  FOR SELECT USING (true);

-- If you want user-specific access, use these instead:
-- CREATE POLICY "Users can view all letters" ON letters
--   FOR SELECT USING (auth.role() = 'authenticated');

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at for letters
CREATE TRIGGER update_letters_updated_at
  BEFORE UPDATE ON letters
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert default categories and sources
INSERT INTO categories (name, description) VALUES 
  ('life', 'Life advice and philosophy'),
  ('motivation', 'Motivational content'),
  ('wisdom', 'Wisdom and insights'),
  ('success', 'Success and achievement'),
  ('personal_growth', 'Personal development');

INSERT INTO sources (name, description) VALUES 
  ('999 letters to yourself', 'Collection of 999 inspirational letters');

-- Create view for easy querying with aggregated HSK words
CREATE VIEW letters_with_hsk_summary AS
SELECT 
  l.*,
  c.name as category_name,
  s.name as source_name,
  COALESCE(
    json_object_agg(
      'hsk' || hw.hsk_level, 
      hw.words
    ) FILTER (WHERE hw.hsk_level IS NOT NULL), 
    '{}'::json
  ) as words,
  COALESCE(
    json_agg(hw.other_words) FILTER (WHERE hw.is_other = true),
    '[]'::json
  ) as other_words
FROM letters l
LEFT JOIN categories c ON l.category_id = c.id
LEFT JOIN sources s ON l.source_id = s.id
LEFT JOIN (
  SELECT 
    letter_id,
    hsk_level,
    json_agg(word) as words,
    NULL as other_words,
    false as is_other
  FROM hsk_words 
  WHERE is_other = false
  GROUP BY letter_id, hsk_level
  
  UNION ALL
  
  SELECT 
    letter_id,
    NULL as hsk_level,
    NULL as words,
    word as other_words,
    true as is_other
  FROM hsk_words 
  WHERE is_other = true
) hw ON l.id = hw.letter_id
GROUP BY l.id, c.name, s.name;

-- Function to insert a letter with HSK words
CREATE OR REPLACE FUNCTION insert_letter_with_words(
  p_original TEXT,
  p_pinyin TEXT DEFAULT NULL,
  p_vietnamese TEXT DEFAULT NULL,
  p_category_name VARCHAR(50) DEFAULT NULL,
  p_source_name VARCHAR(100) DEFAULT NULL,
  p_words JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  letter_id UUID;
  category_id UUID;
  source_id UUID;
  hsk_level_key TEXT;
  hsk_level_num INTEGER;
  word_item TEXT;
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
  
  -- Insert letter
  INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id)
  VALUES (p_original, p_pinyin, p_vietnamese, category_id, source_id)
  RETURNING id INTO letter_id;
  
  -- Insert HSK words if provided
  IF p_words IS NOT NULL THEN
    -- Handle HSK level words
    FOR hsk_level_key IN SELECT jsonb_object_keys(p_words) WHERE jsonb_object_keys(p_words) LIKE 'hsk%'
    LOOP
      hsk_level_num := CAST(SUBSTRING(hsk_level_key FROM 4) AS INTEGER);
      
      FOR word_item IN SELECT jsonb_array_elements_text(p_words->hsk_level_key)
      LOOP
        INSERT INTO hsk_words (letter_id, word, hsk_level, is_other)
        VALUES (letter_id, word_item, hsk_level_num, false);
      END LOOP;
    END LOOP;
    
    -- Handle 'other' words
    IF p_words ? 'other' THEN
      FOR word_item IN SELECT jsonb_array_elements_text(p_words->'other')
      LOOP
        INSERT INTO hsk_words (letter_id, word, hsk_level, is_other)
        VALUES (letter_id, word_item, NULL, true);
      END LOOP;
    END IF;
  END IF;
  
  RETURN letter_id;
END;
$$ LANGUAGE plpgsql;

-- Add multilingual fields to attractions table
-- Run this SQL in your Supabase SQL Editor to add the required columns for multilingual content

-- Add Vietnamese name column
ALTER TABLE attractions
ADD COLUMN IF NOT EXISTS name_vi TEXT;

-- Add English name column
ALTER TABLE attractions
ADD COLUMN IF NOT EXISTS name_en TEXT;

-- Add Vietnamese description column (400-800 words)
ALTER TABLE attractions
ADD COLUMN IF NOT EXISTS description_vi TEXT;

-- Add short Chinese description column (1-2 sentences)
ALTER TABLE attractions
ADD COLUMN IF NOT EXISTS short_description_zh TEXT;

-- Add short Vietnamese description column (2-3 sentences)
ALTER TABLE attractions
ADD COLUMN IF NOT EXISTS short_description_vi TEXT;

-- Create indexes for better search performance
CREATE INDEX IF NOT EXISTS idx_attractions_name_vi 
ON attractions USING btree (name_vi);

CREATE INDEX IF NOT EXISTS idx_attractions_name_en 
ON attractions USING btree (name_en);

-- Create full-text search index for Vietnamese content
CREATE INDEX IF NOT EXISTS idx_attractions_search_vi 
ON attractions USING gin (
  to_tsvector('simple'::regconfig, 
    COALESCE(name_vi, '') || ' ' || COALESCE(description_vi, '')
  )
);

-- Add comment to describe the columns
COMMENT ON COLUMN attractions.name_vi IS 'Vietnamese translation of attraction name';
COMMENT ON COLUMN attractions.name_en IS 'English translation of attraction name';
COMMENT ON COLUMN attractions.description_vi IS 'Detailed Vietnamese description (400-800 words)';
COMMENT ON COLUMN attractions.short_description_zh IS 'Short Chinese summary (1-2 sentences)';
COMMENT ON COLUMN attractions.short_description_vi IS 'Short Vietnamese summary (2-3 sentences)';

-- Verify the columns were added
SELECT 
  column_name, 
  data_type, 
  is_nullable
FROM information_schema.columns
WHERE table_name = 'attractions'
  AND column_name IN ('name_vi', 'name_en', 'description_vi', 'short_description_zh', 'short_description_vi')
ORDER BY ordinal_position;

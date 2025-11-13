-- Add short_description fields to provinces table
-- This allows storing concise descriptions in both Chinese and Vietnamese

-- Add short_description column (Chinese)
ALTER TABLE public.provinces 
ADD COLUMN IF NOT EXISTS short_description TEXT;

-- Add short_description_vi column (Vietnamese)
ALTER TABLE public.provinces 
ADD COLUMN IF NOT EXISTS short_description_vi TEXT;

-- Add comments for documentation
COMMENT ON COLUMN public.provinces.short_description IS 'Concise 1-2 sentence description in Chinese';
COMMENT ON COLUMN public.provinces.short_description_vi IS 'Concise 2-3 sentence description in Vietnamese';

-- Verify the changes
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'provinces'
  AND column_name LIKE '%description%';

-- Add image_url field to the dictionary table
ALTER TABLE public.dictionary 
ADD COLUMN image_url text;

-- Add an index to improve performance for image_url queries
CREATE INDEX idx_dictionary_image_url ON public.dictionary (image_url);

-- Add a comment to document the field
COMMENT ON COLUMN public.dictionary.image_url IS 'URL or filename of the image associated with the dictionary entry';

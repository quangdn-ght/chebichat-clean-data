-- Create character bookmarks table
CREATE TABLE character_bookmarks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  characters TEXT NOT NULL,
  pinyin TEXT,
  meanings TEXT[], -- Array of meanings
  raw_data TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure unique bookmarks per user per character
  UNIQUE(user_id, characters)
);

-- Create index for faster queries
CREATE INDEX idx_character_bookmarks_user_id ON character_bookmarks(user_id);
CREATE INDEX idx_character_bookmarks_created_at ON character_bookmarks(created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE character_bookmarks ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own bookmarks" ON character_bookmarks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own bookmarks" ON character_bookmarks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own bookmarks" ON character_bookmarks
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own bookmarks" ON character_bookmarks
  FOR DELETE USING (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_character_bookmarks_updated_at
  BEFORE UPDATE ON character_bookmarks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

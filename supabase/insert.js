
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Initialize Supabase client
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing Supabase URL or Key in environment variables');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

// Check if tables exist and create them if they don't
async function ensureTablesExist() {
  try {
    console.log('🔍 Checking if tables exist...');
    
    // Try to query the categories table
    const { data, error } = await supabase.from('categories').select('count', { count: 'exact', head: true });
    
    if (error && error.code === '42P01') {
      console.log('📝 Tables do not exist. Creating them...');
      
      // Create tables using SQL
      const createTablesSQL = `
        -- Create categories table
        CREATE TABLE IF NOT EXISTS categories (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          name VARCHAR(100) UNIQUE NOT NULL,
          description TEXT,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );

        -- Create sources table
        CREATE TABLE IF NOT EXISTS sources (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          name VARCHAR(200) UNIQUE NOT NULL,
          description TEXT,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );

        -- Create letters table
        CREATE TABLE IF NOT EXISTS letters (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          original TEXT NOT NULL UNIQUE,
          pinyin TEXT,
          vietnamese TEXT,
          category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
          source_id UUID REFERENCES sources(id) ON DELETE SET NULL,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );

        -- Create HSK words table
        CREATE TABLE IF NOT EXISTS letter_hsk_words (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          letter_id UUID REFERENCES letters(id) ON DELETE CASCADE,
          hsk_level INTEGER NOT NULL CHECK (hsk_level >= 1 AND hsk_level <= 6),
          words TEXT[] NOT NULL,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          UNIQUE(letter_id, hsk_level)
        );

        -- Create other words table
        CREATE TABLE IF NOT EXISTS letter_other_words (
          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
          letter_id UUID REFERENCES letters(id) ON DELETE CASCADE,
          words TEXT[] NOT NULL,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          UNIQUE(letter_id)
        );

        -- Create indexes
        CREATE INDEX IF NOT EXISTS idx_letters_category_id ON letters(category_id);
        CREATE INDEX IF NOT EXISTS idx_letters_source_id ON letters(source_id);
        CREATE INDEX IF NOT EXISTS idx_letter_hsk_words_letter_id ON letter_hsk_words(letter_id);
        CREATE INDEX IF NOT EXISTS idx_letter_hsk_words_level ON letter_hsk_words(hsk_level);
      `;
      
      // Since we can't execute raw SQL through the client, let's try a different approach
      console.log('⚠️  Cannot create tables through client. Please create them manually in Supabase Dashboard.');
      console.log('📋 Copy and paste this SQL in your Supabase SQL Editor:');
      console.log(createTablesSQL);
      return false;
    } else if (error) {
      console.error('❌ Error checking tables:', error);
      return false;
    } else {
      console.log('✅ Tables exist');
      return true;
    }
  } catch (error) {
    console.error('❌ Error ensuring tables exist:', error);
    return false;
  }
}

// Direct insertion method using individual table insertions
async function insertDataDirectly() {
  try {
    console.log('🚀 Starting direct data insertion...');
    
    // Check if tables exist first
    const tablesExist = await ensureTablesExist();
    if (!tablesExist) {
      console.log('❌ Tables do not exist. Please create them first.');
      return;
    }
    
    // Read and parse the level.json file
    const levelData = JSON.parse(fs.readFileSync('../qwen/level.json', 'utf-8'));
    
    console.log(`📝 Found ${levelData.length} letters to insert`);
    
    // Insert categories
    console.log('📂 Inserting categories...');
    const { error: categoriesError } = await supabase
      .from('categories')
      .insert([
        { name: 'life', description: 'life related content' }
      ]);
    
    if (categoriesError && categoriesError.code !== '23505') { // Ignore duplicate key error
      console.error('❌ Error inserting categories:', categoriesError);
      return;
    }
    
    // Insert sources
    console.log('📚 Inserting sources...');
    const { error: sourcesError } = await supabase
      .from('sources')
      .insert([
        { name: '999 letters to yourself', description: 'Source: 999 letters to yourself' }
      ]);
    
    if (sourcesError && sourcesError.code !== '23505') { // Ignore duplicate key error
      console.error('❌ Error inserting sources:', sourcesError);
      return;
    }
    
    // Get category and source IDs
    const { data: categories } = await supabase.from('categories').select('id, name');
    const { data: sources } = await supabase.from('sources').select('id, name');
    
    if (!categories || !sources) {
      console.error('❌ Could not fetch categories or sources');
      return;
    }
    
    const categoryMap = Object.fromEntries(categories.map(c => [c.name, c.id]));
    const sourceMap = Object.fromEntries(sources.map(s => [s.name, s.id]));
    
    let successCount = 0;
    let errorCount = 0;
    
    // Insert letters in smaller batches
    const batchSize = 10;
    
    for (let i = 0; i < levelData.length; i += batchSize) {
      const batch = levelData.slice(i, i + batchSize);
      
      console.log(`🔄 Processing letters batch ${Math.floor(i / batchSize) + 1}/${Math.ceil(levelData.length / batchSize)}...`);
      
      // Prepare letters for insertion
      const lettersToInsert = batch.map(item => ({
        original: item.original,
        pinyin: item.pinyin || null,
        vietnamese: item.vietnamese || null,
        category_id: categoryMap[item.category] || categoryMap['life'],
        source_id: sourceMap[item.source] || sourceMap['999 letters to yourself']
      }));
      
      // Insert letters
      const { data: insertedLetters, error: lettersError } = await supabase
        .from('letters')
        .insert(lettersToInsert)
        .select('id, original');
      
      if (lettersError) {
        console.error(`❌ Error inserting letters batch ${Math.floor(i / batchSize) + 1}:`, lettersError);
        errorCount += batch.length;
        continue;
      }
      
      successCount += insertedLetters.length;
      
      // Create a map for quick lookup
      const letterIdMap = Object.fromEntries(insertedLetters.map(l => [l.original, l.id]));
      
      // Insert HSK words for each letter
      for (const item of batch) {
        const letterId = letterIdMap[item.original];
        if (!letterId || !item.words) continue;
        
        // Prepare HSK words
        const hskWordsToInsert = [];
        const otherWordsToInsert = [];
        
        Object.entries(item.words).forEach(([level, words]) => {
          if (level.startsWith('hsk') && words.length > 0) {
            const hskLevel = parseInt(level.replace('hsk', ''));
            hskWordsToInsert.push({
              letter_id: letterId,
              hsk_level: hskLevel,
              words: words
            });
          } else if (level === 'other' && words.length > 0) {
            otherWordsToInsert.push({
              letter_id: letterId,
              words: words
            });
          }
        });
        
        // Insert HSK words
        if (hskWordsToInsert.length > 0) {
          const { error: hskError } = await supabase
            .from('letter_hsk_words')
            .insert(hskWordsToInsert);
          
          if (hskError) {
            console.error(`❌ Error inserting HSK words for letter ${item.original.substring(0, 50)}...`, hskError);
          }
        }
        
        // Insert other words
        if (otherWordsToInsert.length > 0) {
          const { error: otherError } = await supabase
            .from('letter_other_words')
            .insert(otherWordsToInsert);
          
          if (otherError) {
            console.error(`❌ Error inserting other words for letter ${item.original.substring(0, 50)}...`, otherError);
          }
        }
      }
      
      // Small delay between batches
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    console.log('\n🎉 Direct data insertion completed!');
    console.log(`📊 Results:`);
    console.log(`   ✅ Letters inserted: ${successCount}`);
    console.log(`   ❌ Letters failed: ${errorCount}`);
    
  } catch (error) {
    console.error('❌ Fatal error:', error.message);
    process.exit(1);
  }
}

// Main execution
async function main() {
  console.log('🚀 Starting Supabase data insertion...');
  await insertDataDirectly();
}

// Run the script
main();
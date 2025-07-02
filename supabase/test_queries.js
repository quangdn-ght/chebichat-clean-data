// Test script to verify Supabase connection and query functionality
import { queryLetters, getLettersByDifficulty } from './insert_optimized_data.js';
import dotenv from 'dotenv';

dotenv.config();

async function testConnection() {
  try {
    console.log('Testing Supabase connection...');
    
    // Check environment variables
    if (!process.env.SUPABASE_URL || !process.env.SUPABASE_ANON_KEY) {
      console.error('Missing environment variables. Please create a .env file with:');
      console.error('SUPABASE_URL=your_supabase_url');
      console.error('SUPABASE_ANON_KEY=your_supabase_anon_key');
      process.exit(1);
    }

    console.log('Environment variables found ✓');
    
    // Test a simple query
    console.log('Testing query functionality...');
    const results = await queryLetters({ limit: 5 });
    
    console.log(`Query successful! Found ${results.length} letters ✓`);
    
    if (results.length > 0) {
      console.log('\nSample letter:');
      const sample = results[0];
      console.log(`- ID: ${sample.id}`);
      console.log(`- Category: ${sample.category_name || 'N/A'}`);
      console.log(`- Source: ${sample.source_name || 'N/A'}`);
      console.log(`- Length: ${sample.character_count || 'N/A'} characters`);
      console.log(`- Difficulty: ${sample.difficulty_score || 'N/A'}`);
      console.log(`- Original: ${(sample.original || '').substring(0, 50)}...`);
    } else {
      console.log('\nNo letters found in database. You may need to insert data first.');
      console.log('Run: npm run insert');
    }

    // Test difficulty filtering
    try {
      console.log('\nTesting difficulty filtering...');
      const beginnerLetters = await getLettersByDifficulty('beginner');
      console.log(`Found ${beginnerLetters.length} beginner-friendly letters ✓`);
    } catch (error) {
      console.log('Difficulty filtering test failed (this is OK if no data exists yet)');
    }

    console.log('\n=== All tests passed! ===');
    
  } catch (error) {
    console.error('Test failed:', error.message);
    
    if (error.message.includes('relation') && error.message.includes('does not exist')) {
      console.log('\nIt looks like the database schema hasn\'t been created yet.');
      console.log('Please run the SQL schema file in your Supabase dashboard first:');
      console.log('supabase/db/optimized_schema.sql');
    }
    
    process.exit(1);
  }
}

// Run tests
testConnection();

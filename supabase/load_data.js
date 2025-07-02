// Script to load your JSON data and insert it into Supabase
import { insertCompleteDataBatch } from './insert_optimized_data.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function loadAndInsertData() {
  try {
    // Look for your data file - adjust the path as needed
    const possibleDataFiles = [
      '../result_with_pinyin.json',
      '../qwen/output/import_processed.json',
      '../qwen/import.json'
    ];

    let dataFile = null;
    let jsonData = null;

    // Try to find your data file
    for (const filePath of possibleDataFiles) {
      const fullPath = path.resolve(__dirname, filePath);
      if (fs.existsSync(fullPath)) {
        console.log(`Found data file: ${fullPath}`);
        dataFile = fullPath;
        break;
      }
    }

    if (!dataFile) {
      console.log('No data file found. Looking for files in parent directories...');
      
      // List files in parent directory to help identify the correct data file
      const parentDir = path.resolve(__dirname, '..');
      const files = fs.readdirSync(parentDir);
      console.log('Available files in parent directory:', files.filter(f => f.endsWith('.json')));
      
      console.log('\nPlease specify the correct path to your data file.');
      console.log('Example usage:');
      console.log('node load_data.js path/to/your/data.json');
      
      // Check if file path was provided as command line argument
      if (process.argv[2]) {
        const providedPath = process.argv[2];
        const resolvedPath = path.resolve(providedPath);
        if (fs.existsSync(resolvedPath)) {
          dataFile = resolvedPath;
          console.log(`Using provided file: ${dataFile}`);
        } else {
          console.error(`File not found: ${resolvedPath}`);
          process.exit(1);
        }
      } else {
        process.exit(1);
      }
    }

    // Load the JSON data
    console.log(`Loading data from: ${dataFile}`);
    const rawData = fs.readFileSync(dataFile, 'utf8');
    jsonData = JSON.parse(rawData);

    // Validate the data structure
    if (!jsonData.metadata || !jsonData.data) {
      console.error('Invalid data structure. Expected format:');
      console.error('{');
      console.error('  "metadata": { "totalItems": 123, ... },');
      console.error('  "data": [ { "original": "...", "words": {...}, ... } ]');
      console.error('}');
      process.exit(1);
    }

    console.log(`Data loaded successfully:`);
    console.log(`- Total items: ${jsonData.metadata.totalItems}`);
    console.log(`- Data entries: ${jsonData.data.length}`);

    // Confirm before inserting
    console.log('\nReady to insert data into Supabase.');
    console.log('Make sure your .env file contains:');
    console.log('SUPABASE_URL=your_supabase_url');
    console.log('SUPABASE_ANON_KEY=your_supabase_anon_key');
    console.log('\nStarting insertion...\n');

    // Insert the data
    const result = await insertCompleteDataBatch(jsonData);
    
    console.log('\n=== INSERTION COMPLETE ===');
    console.log(`Batch ID: ${result.batchId}`);
    console.log(`Successfully processed: ${result.processed}`);
    console.log(`Errors: ${result.errors.length}`);
    
    if (result.errors.length > 0) {
      console.log('\nErrors encountered:');
      result.errors.forEach((error, index) => {
        console.log(`${index + 1}. Index ${error.index}: ${error.error}`);
      });
    }

  } catch (error) {
    console.error('Failed to load and insert data:', error);
    
    if (error.message.includes('SUPABASE_URL')) {
      console.log('\nMake sure to create a .env file with your Supabase credentials:');
      console.log('SUPABASE_URL=https://your-project.supabase.co');
      console.log('SUPABASE_ANON_KEY=your-anon-key');
    }
    
    process.exit(1);
  }
}

// Run the script
loadAndInsertData();

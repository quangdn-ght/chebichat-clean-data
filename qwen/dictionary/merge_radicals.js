import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function mergeRadicalFiles() {
  const radicalsDir = path.join(__dirname, 'output', 'radicals');
  const outputFile = path.join(__dirname, 'output', 'merged_radicals.json');
  
  try {
    // Read all JSON files in the radicals directory
    const files = fs.readdirSync(radicalsDir)
      .filter(file => file.endsWith('.json'))
      .sort(); // Sort to ensure consistent order
    
    console.log(`Found ${files.length} JSON files to merge`);
    
    // Initialize the merged object
    let mergedData = {};
    
    // Process each file
    files.forEach((file, index) => {
      const filePath = path.join(radicalsDir, file);
      console.log(`Processing file ${index + 1}/${files.length}: ${file}`);
      
      try {
        // Read and parse the JSON file
        const fileContent = fs.readFileSync(filePath, 'utf8');
        const data = JSON.parse(fileContent);
        
        // Check if data is an array (as expected)
        if (Array.isArray(data)) {
          // Merge each object in the array into the main object
          data.forEach(item => {
            // Each item should be an object with one key-value pair
            Object.assign(mergedData, item);
          });
        } else {
          console.warn(`Warning: ${file} does not contain an array`);
        }
      } catch (error) {
        console.error(`Error processing file ${file}:`, error.message);
      }
    });
    
    // Write the merged data to output file
    fs.writeFileSync(outputFile, JSON.stringify(mergedData, null, 2), 'utf8');
    
    console.log(`\nMerge completed!`);
    console.log(`Total characters merged: ${Object.keys(mergedData).length}`);
    console.log(`Output saved to: ${outputFile}`);
    
    // Display a sample of the merged data
    const sampleKeys = Object.keys(mergedData).slice(0, 5);
    console.log('\nSample merged data:');
    sampleKeys.forEach(key => {
      console.log(`"${key}": "${mergedData[key]}"`);
    });
    
    return mergedData;
    
  } catch (error) {
    console.error('Error during merge process:', error.message);
    throw error;
  }
}

// Run the merge function
mergeRadicalFiles();

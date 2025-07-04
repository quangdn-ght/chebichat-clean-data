#!/usr/bin/env node

/**
 * HSK Data Validation Script
 * Validates the structure and content of hsk-complete.json
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const HSK_DATA_FILE = path.join(__dirname, 'import', 'hsk-complete.json');

async function validateHskData() {
  try {
    console.log('🔍 Validating HSK data file...');
    console.log(`📁 File path: ${HSK_DATA_FILE}`);
    
    if (!fs.existsSync(HSK_DATA_FILE)) {
      throw new Error(`HSK data file not found: ${HSK_DATA_FILE}`);
    }

    const fileContent = fs.readFileSync(HSK_DATA_FILE, 'utf8');
    const hskData = JSON.parse(fileContent);
    
    console.log(`✅ Successfully parsed JSON with ${hskData.length} entries`);
    
    // Validate structure
    if (!Array.isArray(hskData)) {
      throw new Error('HSK data must be an array');
    }

    if (hskData.length === 0) {
      throw new Error('HSK data array is empty');
    }

    // Check first few entries
    const sampleSize = Math.min(10, hskData.length);
    console.log(`\n🔍 Validating first ${sampleSize} entries...`);
    
    const validationErrors = [];
    const levelCounts = {};
    
    for (let i = 0; i < sampleSize; i++) {
      const entry = hskData[i];
      
      if (!entry.chinese) {
        validationErrors.push(`Entry ${i}: Missing 'chinese' field`);
      }
      
      if (!entry.level) {
        validationErrors.push(`Entry ${i}: Missing 'level' field`);
      } else {
        levelCounts[entry.level] = (levelCounts[entry.level] || 0) + 1;
      }
      
      console.log(`   ${i + 1}. Chinese: "${entry.chinese}" | Level: "${entry.level}"`);
    }
    
    if (validationErrors.length > 0) {
      console.error('\n❌ Validation errors found:');
      validationErrors.forEach(error => console.error(`   ${error}`));
      throw new Error('Data validation failed');
    }
    
    // Count all levels
    console.log('\n📊 Level distribution (sample):');
    Object.entries(levelCounts).forEach(([level, count]) => {
      console.log(`   ${level}: ${count} entries`);
    });
    
    // Check for duplicates in sample
    const chineseWords = hskData.slice(0, 100).map(entry => entry.chinese);
    const uniqueWords = new Set(chineseWords);
    
    if (chineseWords.length !== uniqueWords.size) {
      console.log('⚠️  Warning: Duplicate Chinese words detected in first 100 entries');
    }
    
    console.log('\n✅ HSK data validation completed successfully!');
    console.log(`📊 Total entries: ${hskData.length}`);
    console.log(`📊 Sample validation: ${sampleSize} entries checked`);
    
    return true;
    
  } catch (error) {
    console.error('❌ HSK data validation failed:', error.message);
    return false;
  }
}

// Run validation
validateHskData().then(success => {
  process.exit(success ? 0 : 1);
});

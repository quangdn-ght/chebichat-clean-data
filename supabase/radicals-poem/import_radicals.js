const { createClient } = require('@supabase/supabase-js');
const fs = require('fs').promises;
const path = require('path');
require('dotenv').config();

// Supabase configuration
const supabaseUrl = process.env.SUPABASE_URL || 'your-supabase-url';
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'your-supabase-anon-key';

const supabase = createClient(supabaseUrl, supabaseKey);

/**
 * Import radicals poem data from JSON file to Supabase
 */
class RadicalsPoemImporter {
  constructor() {
    this.batchSize = 100; // Import in batches for better performance
    this.importStats = {
      total: 0,
      success: 0,
      errors: 0,
      duplicates: 0
    };
  }

  /**
   * Load and parse JSON data from file
   */
  async loadJsonData(filePath) {
    try {
      const fileContent = await fs.readFile(filePath, 'utf8');
      const data = JSON.parse(fileContent);
      
      console.log(`📖 Loaded ${Object.keys(data).length} radicals from ${filePath}`);
      return data;
    } catch (error) {
      throw new Error(`Failed to load JSON file: ${error.message}`);
    }
  }

  /**
   * Estimate stroke count for a Chinese character (basic heuristic)
   */
  estimateStrokeCount(char) {
    if (char.length !== 1) return null;
    
    // Basic stroke count estimation based on character complexity
    // This is a rough approximation - ideally you'd use a proper stroke count database
    const codePoint = char.codePointAt(0);
    
    // Very basic heuristic based on Unicode ranges
    if (codePoint >= 0x4E00 && codePoint <= 0x4F9F) {
      // CJK Unified Ideographs - basic range
      return Math.min(20, Math.max(1, Math.floor((codePoint - 0x4E00) / 1000) + 3));
    }
    
    return null; // Unknown
  }

  /**
   * Categorize radical based on character analysis
   */
  categorizeRadical(char, description) {
    // Common Kangxi radicals
    const basicRadicals = ['一', '丨', '丿', '丶', '乙', '亅', '二', '人', '儿', '入', '八', '冂', '冖', '冫', '几', '凵', '刀', '力', '勹', '匕', '匚', '匸', '十', '卜', '卩', '厂', '厶', '又'];
    
    // Nature/pictographic elements
    const pictographicChars = ['日', '月', '木', '水', '火', '土', '山', '川', '雨', '云', '风', '雷', '电', '虫', '鱼', '鸟', '马', '牛', '羊', '猪', '狗', '猫', '虎', '龙', '象', '鹿', '人', '口', '手', '足', '目', '耳', '心', '头', '面', '身', '眼', '鼻', '舌', '牙', '发', '须'];
    
    // Numbers
    const numbers = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '百', '千', '万'];
    
    if (basicRadicals.includes(char)) {
      return 'basic_radical';
    } else if (pictographicChars.includes(char)) {
      return 'pictograph';
    } else if (numbers.includes(char)) {
      return 'ideograph';
    } else if (description && (description.includes('tượng') || description.includes('hình'))) {
      return 'pictograph';
    } else if (description && description.includes('số')) {
      return 'ideograph';
    }
    
    return 'other';
  }

  /**
   * Transform JSON entry to database record
   */
  transformEntry(chinese, description) {
    return {
      chinese: chinese,
      poem_description: description,
      category: this.categorizeRadical(chinese, description),
      stroke_count: this.estimateStrokeCount(chinese),
      notes: null,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };
  }

  /**
   * Import data in batches
   */
  async importBatch(records) {
    try {
      const { data, error } = await supabase
        .from('radicals_poem')
        .upsert(records, { 
          onConflict: 'chinese',
          ignoreDuplicates: false 
        })
        .select();

      if (error) {
        console.error('❌ Batch import error:', error);
        this.importStats.errors += records.length;
        return false;
      }

      this.importStats.success += records.length;
      console.log(`✅ Successfully imported batch of ${records.length} records`);
      return true;
    } catch (error) {
      console.error('❌ Batch import exception:', error);
      this.importStats.errors += records.length;
      return false;
    }
  }

  /**
   * Check if table exists and has proper structure
   */
  async validateTableStructure() {
    try {
      const { data, error } = await supabase
        .from('radicals_poem')
        .select('chinese, poem_description')
        .limit(1);

      if (error && error.code === 'PGRST116') {
        throw new Error('Table "radicals_poem" does not exist. Please run the schema creation script first.');
      }

      if (error) {
        throw new Error(`Table validation error: ${error.message}`);
      }

      console.log('✅ Table structure validated');
      return true;
    } catch (error) {
      console.error('❌ Table validation failed:', error.message);
      return false;
    }
  }

  /**
   * Get import statistics
   */
  async getImportStatistics() {
    try {
      const { data, error } = await supabase.rpc('get_import_statistics');
      
      if (error) {
        console.error('❌ Failed to get statistics:', error);
        return null;
      }

      return data;
    } catch (error) {
      console.error('❌ Statistics error:', error);
      return null;
    }
  }

  /**
   * Main import function
   */
  async importRadicals(jsonFilePath) {
    console.log('🚀 Starting radicals poem import...');
    
    // Validate table structure
    const isValid = await this.validateTableStructure();
    if (!isValid) {
      throw new Error('Table validation failed. Please ensure the schema is properly created.');
    }

    // Load JSON data
    const jsonData = await this.loadJsonData(jsonFilePath);
    const entries = Object.entries(jsonData);
    
    this.importStats.total = entries.length;
    console.log(`📊 Total entries to import: ${this.importStats.total}`);

    // Transform entries to database records
    const records = entries.map(([chinese, description]) => 
      this.transformEntry(chinese, description)
    );

    // Import in batches
    const batches = [];
    for (let i = 0; i < records.length; i += this.batchSize) {
      batches.push(records.slice(i, i + this.batchSize));
    }

    console.log(`📦 Processing ${batches.length} batches of max ${this.batchSize} records each...`);

    for (let i = 0; i < batches.length; i++) {
      const batch = batches[i];
      console.log(`⏳ Processing batch ${i + 1}/${batches.length} (${batch.length} records)...`);
      
      await this.importBatch(batch);
      
      // Small delay to avoid overwhelming the database
      await new Promise(resolve => setTimeout(resolve, 100));
    }

    // Print final statistics
    console.log('\n📈 Import Summary:');
    console.log(`   Total entries: ${this.importStats.total}`);
    console.log(`   Successfully imported: ${this.importStats.success}`);
    console.log(`   Errors: ${this.importStats.errors}`);
    console.log(`   Success rate: ${((this.importStats.success / this.importStats.total) * 100).toFixed(2)}%`);

    // Get database statistics
    const dbStats = await this.getImportStatistics();
    if (dbStats) {
      console.log('\n📊 Database Statistics:');
      dbStats.forEach(stat => {
        console.log(`   ${stat.description}: ${stat.value}`);
      });
    }

    return this.importStats;
  }

  /**
   * Validate imported data
   */
  async validateImportedData() {
    try {
      const { data, error } = await supabase.rpc('validate_radicals_data');
      
      if (error) {
        console.error('❌ Validation error:', error);
        return null;
      }

      console.log('\n🔍 Data Validation Results:');
      data.forEach(result => {
        if (result.issue_count > 0) {
          console.log(`⚠️  ${result.details}: ${result.issue_count} issues`);
        } else {
          console.log(`✅ ${result.details}: No issues`);
        }
      });

      return data;
    } catch (error) {
      console.error('❌ Validation exception:', error);
      return null;
    }
  }

  /**
   * Analyze dictionary relationships
   */
  async analyzeDictionaryRelationships() {
    try {
      const { data, error } = await supabase.rpc('analyze_dictionary_relationships');
      
      if (error) {
        console.error('❌ Relationship analysis error:', error);
        return null;
      }

      console.log('\n🔗 Dictionary Relationship Analysis:');
      console.log(`Found relationships for ${data.length} radicals`);
      
      // Show top 10 radicals with most relationships
      const top10 = data.slice(0, 10);
      top10.forEach(item => {
        console.log(`   ${item.radical_char}: ${item.related_words_count} related words (e.g., ${item.sample_words.slice(0, 3).join(', ')})`);
      });

      return data;
    } catch (error) {
      console.error('❌ Relationship analysis exception:', error);
      return null;
    }
  }
}

// Main execution
async function main() {
  const importer = new RadicalsPoemImporter();
  
  try {
    // Path to your JSON file
    const jsonFilePath = path.join(__dirname, './import/merged_radicals.json');
    
    // Check if file exists
    try {
      await fs.access(jsonFilePath);
    } catch (error) {
      console.error(`❌ JSON file not found: ${jsonFilePath}`);
      console.log('Please ensure the merged_radicals.json file exists in the import directory.');
      process.exit(1);
    }

    // Import the data
    const stats = await importer.importRadicals(jsonFilePath);
    
    // Validate the imported data
    await importer.validateImportedData();
    
    // Analyze dictionary relationships (if dictionary table exists)
    await importer.analyzeDictionaryRelationships();
    
    console.log('\n🎉 Import process completed!');
    
  } catch (error) {
    console.error('💥 Import failed:', error.message);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = RadicalsPoemImporter;

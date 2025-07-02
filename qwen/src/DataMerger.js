const fs = require('fs');
const path = require('path');
const ChineseTextProcessor = require('./ChineseTextProcessor');
const HSKAnalyzer = require('./HSKAnalyzer');
const PinyinGenerator = require('./PinyinGenerator.js');

/**
 * DataMerger - Main class for processing Chinese text data and generating structured output
 */
class DataMerger {
  constructor(options = {}) {
    this.textProcessor = new ChineseTextProcessor();
    this.hskAnalyzer = new HSKAnalyzer();
    this.pinyinGenerator = new PinyinGenerator();
    
    this.options = {
      defaultCategory: options.defaultCategory || 'life',
      defaultSource: options.defaultSource || '999 letters to yourself',
      outputFormat: options.outputFormat || 'json',
      includeStatistics: options.includeStatistics || true,
      ...options
    };
  }

  /**
   * Process input data and generate structured output
   * @param {string|Array} input - Input file path or data array
   * @param {string} outputPath - Output file path
   * @returns {Object} Processing results
   */
  async processData(input, outputPath) {
    try {
      console.log('🚀 Starting data processing...');
      
      // Step 1: Load input data
      const inputData = await this.loadInputData(input);
      console.log(`📖 Loaded ${inputData.length} items`);
      
      // Step 2: Process each item
      const processedData = await this.processItems(inputData);
      console.log(`✅ Processed ${processedData.length} items`);
      
      // Step 3: Generate output
      const result = await this.generateOutput(processedData, outputPath);
      console.log(`💾 Saved results to ${outputPath}`);
      
      return result;
    } catch (error) {
      console.error('❌ Error processing data:', error.message);
      throw error;
    }
  }

  /**
   * Load input data from file or array
   * @param {string|Array} input - Input source
   * @returns {Array} Input data array
   */
  async loadInputData(input) {
    if (Array.isArray(input)) {
      return input;
    }

    if (typeof input === 'string') {
      if (!fs.existsSync(input)) {
        throw new Error(`Input file not found: ${input}`);
      }
      
      const content = fs.readFileSync(input, 'utf8');
      return JSON.parse(content);
    }

    throw new Error('Invalid input format. Expected file path or array.');
  }

  /**
   * Process individual items
   * @param {Array} inputData - Array of input items
   * @returns {Array} Processed items
   */
  async processItems(inputData) {
    const processedItems = [];
    
    for (let i = 0; i < inputData.length; i++) {
      const item = inputData[i];
      console.log(`🔄 Processing item ${i + 1}/${inputData.length}: ${item.original?.substring(0, 50)}...`);
      
      try {
        const processedItem = await this.processItem(item);
        processedItems.push(processedItem);
      } catch (error) {
        console.warn(`⚠️ Error processing item ${i + 1}:`, error.message);
        // Include item with error information
        processedItems.push({
          ...item,
          error: error.message,
          processed: false
        });
      }
    }
    
    return processedItems;
  }

  /**
   * Process a single item
   * @param {Object} item - Input item
   * @returns {Object} Processed item
   */
  async processItem(item) {
    const original = item.original || item.chinese || '';
    
    if (!original) {
      throw new Error('No original text found in item');
    }

    // Step 1: Segment text into words
    const words = this.textProcessor.segmentText(original);
    
    // Step 2: Analyze HSK levels
    const hskAnalysis = this.hskAnalyzer.analyzeWords(words);
    
    // Step 3: Generate pinyin
    const pinyin = this.pinyinGenerator.generatePinyin(original);
    
    // Step 4: Create structured output
    const processedItem = {
      original: original,
      words: hskAnalysis,
      pinyin: pinyin,
      vietnamese: item.vietnamese || null,
      category: item.category || this.options.defaultCategory,
      source: item.source || this.options.defaultSource,
      processed: true
    };

    // Add statistics if requested
    if (this.options.includeStatistics) {
      processedItem.statistics = this.hskAnalyzer.getStatistics(hskAnalysis);
      processedItem.textStats = this.textProcessor.getTextStatistics(original);
    }

    return processedItem;
  }

  /**
   * Generate output file
   * @param {Array} processedData - Processed items
   * @param {string} outputPath - Output file path
   * @returns {Object} Results summary
   */
  async generateOutput(processedData, outputPath) {
    // Ensure output directory exists
    const outputDir = path.dirname(outputPath);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    // Generate summary statistics
    const summary = this.generateSummary(processedData);
    
    // Prepare output data
    const outputData = {
      metadata: {
        processedAt: new Date().toISOString(),
        totalItems: processedData.length,
        successfulItems: processedData.filter(item => item.processed).length,
        failedItems: processedData.filter(item => !item.processed).length,
        summary: summary
      },
      data: processedData
    };

    // Write output file
    if (this.options.outputFormat === 'json') {
      fs.writeFileSync(outputPath, JSON.stringify(outputData, null, 2), 'utf8');
    } else {
      throw new Error(`Unsupported output format: ${this.options.outputFormat}`);
    }

    return {
      outputPath: outputPath,
      summary: summary,
      metadata: outputData.metadata
    };
  }

  /**
   * Generate processing summary
   * @param {Array} processedData - Processed items
   * @returns {Object} Summary statistics
   */
  generateSummary(processedData) {
    const summary = {
      totalWords: 0,
      hskDistribution: {
        hsk1: 0, hsk2: 0, hsk3: 0, hsk4: 0, hsk5: 0, hsk6: 0, other: 0
      },
      categories: {},
      sources: {},
      averageLength: 0,
      languageCoverage: {
        hasVietnamese: 0,
        hasPinyin: 0
      }
    };

    const successfulItems = processedData.filter(item => item.processed);
    
    successfulItems.forEach(item => {
      // Count words by HSK level
      if (item.words) {
        Object.entries(item.words).forEach(([level, words]) => {
          if (summary.hskDistribution[level] !== undefined) {
            summary.hskDistribution[level] += words.length;
            summary.totalWords += words.length;
          }
        });
      }

      // Count categories
      if (item.category) {
        summary.categories[item.category] = (summary.categories[item.category] || 0) + 1;
      }

      // Count sources
      if (item.source) {
        summary.sources[item.source] = (summary.sources[item.source] || 0) + 1;
      }

      // Language coverage
      if (item.vietnamese) summary.languageCoverage.hasVietnamese++;
      if (item.pinyin) summary.languageCoverage.hasPinyin++;
    });

    // Calculate average text length
    const totalLength = successfulItems.reduce((sum, item) => sum + (item.original?.length || 0), 0);
    summary.averageLength = successfulItems.length > 0 ? Math.round(totalLength / successfulItems.length) : 0;

    // Calculate percentages
    summary.hskPercentages = {};
    Object.entries(summary.hskDistribution).forEach(([level, count]) => {
      summary.hskPercentages[level] = summary.totalWords > 0 ? 
        ((count / summary.totalWords) * 100).toFixed(1) : 0;
    });

    return summary;
  }

  /**
   * Merge two datasets
   * @param {string} baseFile - Base data file path
   * @param {string} mergeFile - File to merge from
   * @param {string} outputFile - Output file path
   * @param {Object} options - Merge options
   * @returns {Object} Merge results
   */
  async mergeDatasets(baseFile, mergeFile, outputFile, options = {}) {
    console.log('🔀 Starting dataset merge...');
    
    try {
      const baseData = await this.loadInputData(baseFile);
      const mergeData = await this.loadInputData(mergeFile);
      
      console.log(`📖 Base dataset: ${baseData.length} items`);
      console.log(`🔤 Merge dataset: ${mergeData.length} items`);
      
      // Create lookup map for merge data
      const mergeMap = new Map();
      mergeData.forEach(item => {
        const key = (item.original || item.chinese || '').trim();
        if (key) {
          mergeMap.set(key, item);
        }
      });
      
      // Merge datasets
      const mergedData = baseData.map(baseItem => {
        const key = (baseItem.original || baseItem.chinese || '').trim();
        const mergeItem = mergeMap.get(key);
        
        if (mergeItem) {
          return {
            original: key,
            vietnamese: mergeItem.vietnamese || baseItem.vietnamese,
            category: mergeItem.category || baseItem.category || this.options.defaultCategory,
            source: mergeItem.source || baseItem.source || this.options.defaultSource,
            ...baseItem
          };
        }
        
        return baseItem;
      });
      
      // Process merged data
      const result = await this.processData(mergedData, outputFile);
      
      console.log('✅ Dataset merge completed');
      return result;
      
    } catch (error) {
      console.error('❌ Error merging datasets:', error.message);
      throw error;
    }
  }
}

module.exports = DataMerger;

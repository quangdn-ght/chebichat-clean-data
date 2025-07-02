const nodejieba = require('nodejieba');

/**
 * ChineseTextProcessor - Handles Chinese text segmentation and processing
 */
class ChineseTextProcessor {
  constructor() {
    this.isInitialized = false;
    this.init();
  }

  /**
   * Initialize the text processor
   */
  init() {
    try {
      // Initialize nodejieba for Chinese word segmentation
      console.log('🔧 Initializing Chinese text processor...');
      this.isInitialized = true;
      console.log('✅ Chinese text processor initialized');
    } catch (error) {
      console.error('❌ Error initializing text processor:', error.message);
      this.isInitialized = false;
    }
  }

  /**
   * Segment Chinese text into words
   * @param {string} text - Chinese text to segment
   * @returns {Array} Array of segmented words
   */
  segmentText(text) {
    if (!this.isInitialized) {
      console.warn('⚠️ Text processor not initialized, using fallback method');
      return this.fallbackSegmentation(text);
    }

    try {
      const cleanText = this.cleanText(text);
      const words = nodejieba.cut(cleanText);
      return this.filterWords(words);
    } catch (error) {
      console.error('❌ Error segmenting text:', error.message);
      return this.fallbackSegmentation(text);
    }
  }

  /**
   * Clean and normalize Chinese text
   * @param {string} text - Raw text
   * @returns {string} Cleaned text
   */
  cleanText(text) {
    if (!text) return '';
    
    return text
      .replace(/[""'']/g, '"')  // Normalize quotes
      .replace(/[，。！？；：]/g, match => match) // Keep Chinese punctuation
      .replace(/\s+/g, '') // Remove extra whitespace
      .trim();
  }

  /**
   * Filter and clean segmented words
   * @param {Array} words - Raw segmented words
   * @returns {Array} Filtered words
   */
  filterWords(words) {
    const stopWords = new Set([
      '的', '了', '在', '是', '我', '你', '他', '她', '它', '们',
      '这', '那', '有', '没', '不', '也', '都', '很', '更', '最',
      '一', '二', '三', '四', '五', '六', '七', '八', '九', '十',
      '，', '。', '！', '？', '；', '：', '"', '"', "'", "'",
      ' ', '\n', '\t', '\r'
    ]);

    return words
      .filter(word => {
        const cleanWord = word.trim();
        return cleanWord.length > 0 && 
               !stopWords.has(cleanWord) &&
               /[\u4e00-\u9fff]/.test(cleanWord); // Contains Chinese characters
      })
      .map(word => word.trim());
  }

  /**
   * Fallback segmentation method when nodejieba is not available
   * @param {string} text - Chinese text
   * @returns {Array} Array of characters/words
   */
  fallbackSegmentation(text) {
    const cleanText = this.cleanText(text);
    // Simple character-based segmentation as fallback
    const chars = cleanText.split('').filter(char => /[\u4e00-\u9fff]/.test(char));
    
    // Try to identify common multi-character words
    const commonWords = ['的时候', '一个', '没有', '不是', '可以', '应该', '因为', '所以', '但是', '如果'];
    let result = [];
    let i = 0;
    
    while (i < chars.length) {
      let found = false;
      
      // Check for common multi-character words
      for (const word of commonWords) {
        if (cleanText.substring(i).startsWith(word)) {
          result.push(word);
          i += word.length;
          found = true;
          break;
        }
      }
      
      if (!found) {
        result.push(chars[i]);
        i++;
      }
    }
    
    return this.filterWords(result);
  }

  /**
   * Extract vocabulary from text with frequency count
   * @param {string} text - Chinese text
   * @returns {Object} Vocabulary with frequency counts
   */
  extractVocabulary(text) {
    const words = this.segmentText(text);
    const vocabulary = {};
    
    words.forEach(word => {
      vocabulary[word] = (vocabulary[word] || 0) + 1;
    });
    
    return vocabulary;
  }

  /**
   * Get text statistics
   * @param {string} text - Chinese text
   * @returns {Object} Text statistics
   */
  getTextStatistics(text) {
    const cleanText = this.cleanText(text);
    const words = this.segmentText(text);
    const vocabulary = this.extractVocabulary(text);
    
    return {
      characterCount: cleanText.length,
      wordCount: words.length,
      uniqueWordCount: Object.keys(vocabulary).length,
      averageWordLength: words.length > 0 ? words.reduce((sum, word) => sum + word.length, 0) / words.length : 0,
      vocabulary: vocabulary
    };
  }
}

module.exports = ChineseTextProcessor;

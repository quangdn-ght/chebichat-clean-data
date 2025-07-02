const { pinyin } = require('pinyin-pro');

/**
 * PinyinGenerator - Generates pinyin for Chinese text using pinyin-pro library
 */
class PinyinGenerator {
  constructor() {
    // Test pinyin-pro availability
    try {
      pinyin('测试', { toneType: 'symbol' });
      console.log('✅ Pinyin-pro library loaded successfully');
    } catch (error) {
      console.log('⚠️ Pinyin-pro library not available, will use basic fallback');
    }
  }

  /**
   * Generate pinyin for Chinese text using pinyin-pro library
   * @param {string} text - Chinese text
   * @returns {string} Pinyin representation
   */
  generatePinyin(text) {
    if (!text) return '';

    try {
      // Use pinyin-pro library for accurate pinyin generation
      const pinyinResult = pinyin(text, {
        toneType: 'symbol',  // Use tone symbols (ā, á, ǎ, à)
        type: 'array'        // Return as array for better control
      });
      
      return pinyinResult.join(' ');
    } catch (error) {
      console.log('⚠️ Pinyin-pro failed, returning original text');
      return text;
    }
  }
}

module.exports = PinyinGenerator;

const fs = require('fs');
const path = require('path');

/**
 * HSKAnalyzer - Analyzes Chinese words and categorizes them by HSK levels
 */
class HSKAnalyzer {
  constructor() {
    this.hskData = null;
    this.loadHSKData();
  }

  /**
   * Load HSK vocabulary data
   */
  loadHSKData() {
    try {
      const hskPath = path.join(__dirname, '../lib/complete-hsk-vocabulary/complete.json');
      if (fs.existsSync(hskPath)) {
        this.hskData = JSON.parse(fs.readFileSync(hskPath, 'utf8'));
        console.log('✅ HSK data loaded successfully');
      } else {
        console.warn('⚠️ HSK data file not found, will use fallback method');
        this.hskData = this.createFallbackHSKData();
      }
    } catch (error) {
      console.error('❌ Error loading HSK data:', error.message);
      this.hskData = this.createFallbackHSKData();
    }
  }

  /**
   * Create fallback HSK data structure
   */
  createFallbackHSKData() {
    return {
      1: new Set(['的', '是', '我', '你', '他', '她', '在', '有', '不', '了', '好', '人', '时候', '都', '会', '说', '一个', '去', '来', '看', '吃', '喝', '走', '跑', '坐', '站', '睡觉', '工作', '学习', '读书']),
      2: new Set(['别人', '已经', '还', '但', '就', '过', '要看', '也不', '早晨', '晚上', '到', '得', '现在', '今天', '明天', '昨天', '年', '月', '日', '小时', '分钟']),
      3: new Set(['该', '刷', '单词', '加班', '平凡', '而是', '手机', '电脑', '网络', '互联网', '技术', '科学', '医生', '老师', '学生']),
      4: new Set(['却', '坚持到底', '连', '肯定', '深夜', '付出', '努力', '成功', '失败', '困难', '挑战', '机会', '希望', '梦想']),
      5: new Set(['熬夜', '挣扎', '背', '压力', '责任', '义务', '权利', '自由', '独立', '依赖', '信任', '尊重']),
      6: new Set(['碌碌无为', '复杂', '简单', '深刻', '表面', '本质', '现象', '理论', '实践', '哲学', '心理学'])
    };
  }

  /**
   * Analyze words and categorize by HSK level
   * @param {Array} words - Array of Chinese words
   * @returns {Object} Words categorized by HSK level
   */
  analyzeWords(words) {
    const result = {
      hsk1: [],
      hsk2: [],
      hsk3: [],
      hsk4: [],
      hsk5: [],
      hsk6: [],
      other: []
    };

    words.forEach(word => {
      const cleanWord = word.trim();
      if (!cleanWord) return;

      let found = false;
      
      // Check each HSK level
      for (let level = 1; level <= 6; level++) {
        if (this.isWordInHSKLevel(cleanWord, level)) {
          result[`hsk${level}`].push(cleanWord);
          found = true;
          break;
        }
      }

      // If not found in any HSK level, add to 'other'
      if (!found) {
        result.other.push(cleanWord);
      }
    });

    // Remove duplicates from each level
    Object.keys(result).forEach(level => {
      result[level] = [...new Set(result[level])];
    });

    return result;
  }

  /**
   * Check if a word belongs to a specific HSK level
   * @param {string} word - Chinese word
   * @param {number} level - HSK level (1-6)
   * @returns {boolean}
   */
  isWordInHSKLevel(word, level) {
    if (!this.hskData || !this.hskData[level]) {
      return false;
    }

    // Check if word exists in the HSK level data
    if (this.hskData[level] instanceof Set) {
      return this.hskData[level].has(word);
    } else if (Array.isArray(this.hskData[level])) {
      return this.hskData[level].includes(word);
    } else if (typeof this.hskData[level] === 'object') {
      // Handle different data structures
      return Object.values(this.hskData[level]).flat().includes(word);
    }

    return false;
  }

  /**
   * Get statistics for HSK analysis
   * @param {Object} analyzedWords - Result from analyzeWords
   * @returns {Object} Statistics
   */
  getStatistics(analyzedWords) {
    const stats = {
      total: 0,
      byLevel: {},
      coverage: {}
    };

    Object.entries(analyzedWords).forEach(([level, words]) => {
      const count = words.length;
      stats.byLevel[level] = count;
      stats.total += count;
    });

    // Calculate coverage percentages
    Object.entries(stats.byLevel).forEach(([level, count]) => {
      stats.coverage[level] = stats.total > 0 ? ((count / stats.total) * 100).toFixed(1) : 0;
    });

    return stats;
  }
}

module.exports = HSKAnalyzer;

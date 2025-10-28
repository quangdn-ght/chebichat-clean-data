# Chinese Text Processor

A comprehensive Node.js package for processing Chinese text and analyzing HSK word levels. This package provides tools for text segmentation, HSK level analysis, pinyin generation, and data merging.

## 📖 Documentation

- **[English Documentation](README.md)** - Complete guide in English
- **[Vietnamese Documentation](README_VI.md)** - Hướng dẫn đầy đủ bằng tiếng Việt
- **[Quick Start Guide](QUICKSTART_VI.md)** - Hướng dẫn nhanh cho người Việt

## Features

- 🔤 **Chinese Text Segmentation**: Advanced text processing with nodejieba
- 🎯 **HSK Level Analysis**: Categorize words by HSK levels (1-6)
- 📝 **Pinyin Generation**: Generate pinyin for Chinese characters
- 🔀 **Data Merging**: Merge datasets with Vietnamese translations
- 📊 **Statistics**: Comprehensive analysis and reporting
- 🏗️ **Modular Architecture**: Reusable components for easy maintenance

## Installation

```bash
npm install
```

## Usage

### Basic Usage

```javascript
const { DataMerger } = require('./index');

const processor = new DataMerger({
  defaultCategory: 'life',
  defaultSource: '999 letters to yourself',
  includeStatistics: true
});

// Process Chinese text with Vietnamese translations
await processor.processData('./result.json', './output/processed.json');
```

### Input Format

```json
[
  {
    "original": "别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。",
    "vietnamese": "Khi người khác đang thức khuya, bạn lại đi ngủ; khi người khác đã thức dậy, bạn vẫn cố gắng nán lại thêm vài phút."
  }
]
```

### Output Format

```json
{
  "original": "别人在熬夜的时候，你在睡觉...",
  "words": {
    "hsk1": ["在", "的", "时候", "你", "睡觉", "起床"],
    "hsk2": ["别人", "已经", "还", "但", "就", "过"],
    "hsk3": ["该", "刷", "单词", "加班", "平凡"],
    "hsk4": ["却", "坚持到底", "连", "肯定", "深夜"],
    "hsk5": ["熬夜", "挣扎", "背"],
    "hsk6": ["碌碌无为"]
  },
  "pinyin": "bié rén zài áo yè de shí hòu...",
  "vietnamese": "Khi người khác đang thức khuya...",
  "category": "life",
  "source": "999 letters to yourself"
}
```

## Components

### ChineseTextProcessor
Handles Chinese text segmentation and processing.

```javascript
const { ChineseTextProcessor } = require('./index');
const processor = new ChineseTextProcessor();
const words = processor.segmentText('中文文本');
```

### HSKAnalyzer
Analyzes words and categorizes them by HSK levels.

```javascript
const { HSKAnalyzer } = require('./index');
const analyzer = new HSKAnalyzer();
const analysis = analyzer.analyzeWords(['你好', '世界']);
```

### PinyinGenerator
Generates pinyin for Chinese text.

```javascript
const { PinyinGenerator } = require('./index');
const generator = new PinyinGenerator();
const pinyin = generator.generatePinyin('你好世界');
```

### DataMerger
Main class for processing and merging data.

```javascript
const { DataMerger } = require('./index');
const merger = new DataMerger();
await merger.processData(inputData, outputPath);
```

## Scripts

### Main Application
```bash
npm start
# or
node app.js
```
Processes `result.json` and outputs to `./output/step6_hsk_analysis.json`

### Run Tests
```bash
npm test
# or
node test.js
```
Runs comprehensive tests including processing `import.json`

#### Test Cases Overview

1. **Test 1: Chinese Text Processing** - Text segmentation and statistics
2. **Test 2: HSK Level Analysis** - Word classification by HSK levels
3. **Test 3: Pinyin Generation** - Accurate pinyin using pinyin-pro library  
4. **Test 4: Data Merger** - Combine Chinese text with Vietnamese translations
5. **Test 5: Import.json Processing** - Process 241 items with full analysis

**Expected Results:**
- ✅ 241/241 items processed successfully
- 📝 6,560 Chinese words extracted and analyzed
- 🎯 Words categorized into HSK levels 1-6
- 📁 Complete output saved to `./output/import_processed.json`

### Custom Input Processing
You can process any JSON file with the same structure as `result.json` or `import.json`:

```bash
# Example: Process import.json
node -e "
const { DataMerger } = require('./index');
const fs = require('fs').promises;
(async () => {
  const merger = new DataMerger();
  const data = JSON.parse(await fs.readFile('./import.json', 'utf8'));
  await merger.processData(data, './output/custom_output.json');
})();"
```

## Example Processing Results

When processing `import.json` (241 items), the package successfully:
- ✅ Processed 241/241 items (100% success rate)
- 📝 Extracted 6,560 Chinese words total
- 🎯 Categorized words by HSK levels:
  - HSK1: 424 words (6.5%)
  - HSK2: 293 words (4.5%)
  - HSK3: 38 words (0.6%)
  - HSK4: 165 words (2.5%)
  - HSK5: 17 words (0.3%)
  - HSK6: 9 words (0.1%)
  - Other: 5,614 words (85.6%)

- `npm start` - Run the main application
- `npm test` - Run tests

## File Structure

```
qwen/
├── src/
│   ├── ChineseTextProcessor.js
│   ├── HSKAnalyzer.js
│   ├── PinyinGenerator.js
│   └── DataMerger.js
├── output/
├── app.js
├── test.js
├── index.js
└── package.json
```

## API Reference

### DataMerger Options

- `defaultCategory` (string): Default category for items
- `defaultSource` (string): Default source for items
- `outputFormat` (string): Output format ('json')
- `includeStatistics` (boolean): Include processing statistics

### Processing Steps

1. **Step 6**: Process Chinese text with Vietnamese translations
2. **Step 7**: Merge with existing datasets

## Dependencies

- `nodejieba`: Chinese text segmentation
- `fs`: File system operations
- `path`: Path utilities

## License

MIT

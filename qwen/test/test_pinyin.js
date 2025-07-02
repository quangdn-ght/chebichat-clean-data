const { PinyinGenerator } = require('../index');

console.log('🔤 Testing Pinyin Generation with pinyin-pro');
console.log('=============================================\n');

const generator = new PinyinGenerator();

// Test cases
const testCases = [
  '别人在熬夜的时候，你在睡觉',
  '当一个人忽略你时，不要伤心',
  '你今天的努力，是幸运的伏笔',
  '世上没有一件工作不辛苦',
  '我不敢休息，因为我没有存款'
];

console.log('Testing pinyin generation...\n');

testCases.forEach((text, index) => {
  console.log(`Test ${index + 1}:`);
  console.log(`Input:  ${text}`);
  console.log(`Pinyin: ${generator.generatePinyin(text)}`);
  console.log('');
});

console.log('✅ Pinyin generation test completed!');

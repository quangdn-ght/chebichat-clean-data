import OpenAI from 'openai';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

// ESM equivalent of __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
dotenv.config({ path: path.join(__dirname, '../../.env') });

// Configuration
const CONFIG = {
  apiKey: process.env.DASHSCOPE_API_KEY,
  model: process.env.QWEN_MODEL || 'qwen-max',
  batchSize: 10, // Process 10 idioms at a time
  retryDelay: 2000, // 2 seconds delay for rate limiting
  maxRetries: 3
};

// Initialize OpenAI client with Qwen endpoint
const openai = new OpenAI({
  apiKey: CONFIG.apiKey,
  baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// Categories for classification
const CATEGORIES = [
  '比喻形象',
  '人情世故',
  '智慧谋略',
  '学习勤奋',
  '自然时光',
  '战争政治',
  '情绪状态',
  '人生哲学',
  '数字成语',
  '品德修养'
];

// System prompt in Chinese
const SYSTEM_PROMPT = `你是一个中文成语分类专家。请根据成语的深层含义和常见用法，将每个成语归入以下10个类别之一（只能选一个）：
- 比喻形象
- 人情世故
- 智慧谋略
- 学习勤奋
- 自然时光
- 战争政治
- 情绪状态
- 人生哲学
- 数字成语
- 品德修养

输出格式：仅返回类别名称，每行一个，不要解释。`;

/**
 * Sleep utility for rate limiting
 */
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Call Qwen API to classify a batch of idioms using OpenAI SDK
 */
async function classifyBatch(idioms, retryCount = 0) {
  const userPrompt = `请分类以下成语：\n${idioms.map((idiom, idx) => `${idx + 1}. ${idiom}`).join('\n')}`;

  try {
    const completion = await openai.chat.completions.create({
      model: CONFIG.model,
      messages: [
        {
          role: 'system',
          content: SYSTEM_PROMPT
        },
        {
          role: 'user',
          content: userPrompt
        }
      ],
      temperature: 0.1, // Low temperature for consistent classification
      top_p: 0.8
    });

    // Extract classifications from response
    const content = completion.choices[0].message.content || '';
    const classifications = content.trim().split('\n').map(c => c.trim()).filter(Boolean);
    
    // Validate classifications
    if (classifications.length !== idioms.length) {
      console.warn(`⚠️  Expected ${idioms.length} classifications, got ${classifications.length}. Retrying...`);
      if (retryCount < CONFIG.maxRetries) {
        await sleep(CONFIG.retryDelay);
        return classifyBatch(idioms, retryCount + 1);
      }
    }

    return classifications;
  } catch (error) {
    // Handle rate limiting
    if (error.status === 429 && retryCount < CONFIG.maxRetries) {
      console.log(`⚠️  Rate limit hit, retrying in ${CONFIG.retryDelay}ms... (Attempt ${retryCount + 1}/${CONFIG.maxRetries})`);
      await sleep(CONFIG.retryDelay);
      return classifyBatch(idioms, retryCount + 1);
    }
    
    if (retryCount < CONFIG.maxRetries) {
      console.log(`⚠️  Error occurred, retrying... (Attempt ${retryCount + 1}/${CONFIG.maxRetries})`);
      console.log(`    Error: ${error.message}`);
      await sleep(CONFIG.retryDelay);
      return classifyBatch(idioms, retryCount + 1);
    }
    throw error;
  }
}

/**
 * Split array into chunks
 */
function chunkArray(array, size) {
  const chunks = [];
  for (let i = 0; i < array.length; i += size) {
    chunks.push(array.slice(i, i + size));
  }
  return chunks;
}

/**
 * Main classification function
 */
async function classifyIdioms() {
  console.log('🚀 Starting Chinese idiom classification...\n');

  // Validate API key
  if (!CONFIG.apiKey) {
    throw new Error('❌ DASHSCOPE_API_KEY not found in environment variables');
  }

  // Read input file
  const inputPath = path.join(__dirname, 'chengyu-chinese.json');
  const inputData = JSON.parse(await fs.readFile(inputPath, 'utf-8'));
  const idioms = inputData.map(item => item.chinese);
  
  console.log(`📚 Loaded ${idioms.length} idioms from ${path.basename(inputPath)}`);
  console.log(`🔧 Using model: ${CONFIG.model}`);
  console.log(`📦 Batch size: ${CONFIG.batchSize} idioms per request\n`);

  // Initialize results
  const results = {};
  CATEGORIES.forEach(cat => {
    results[cat] = [];
  });

  const stats = {
    total: idioms.length,
    classified: 0,
    failed: [],
    distribution: {}
  };

  // Process in batches
  const batches = chunkArray(idioms, CONFIG.batchSize);
  
  for (let i = 0; i < batches.length; i++) {
    const batch = batches[i];
    const startIdx = i * CONFIG.batchSize;
    
    try {
      console.log(`📊 Processing batch ${i + 1}/${batches.length} (idioms ${startIdx + 1}-${startIdx + batch.length})...`);
      
      const classifications = await classifyBatch(batch);
      
      // Map idioms to categories
      batch.forEach((idiom, idx) => {
        const category = classifications[idx];
        
        if (CATEGORIES.includes(category)) {
          results[category].push(idiom);
          stats.classified++;
        } else {
          // If category is invalid, try to find closest match or mark as failed
          console.warn(`⚠️  Invalid category "${category}" for idiom "${idiom}"`);
          stats.failed.push({ idiom, category });
          
          // Fallback: assign to first category
          results[CATEGORIES[0]].push(idiom);
          stats.classified++;
        }
      });
      
      console.log(`✅ Batch ${i + 1}/${batches.length} completed (${stats.classified}/${stats.total})\n`);
      
      // Delay between batches to avoid rate limiting
      if (i < batches.length - 1) {
        await sleep(CONFIG.retryDelay);
      }
      
    } catch (error) {
      console.error(`❌ Failed to process batch ${i + 1}:`, error.message);
      
      // Mark all idioms in this batch as failed
      batch.forEach(idiom => {
        stats.failed.push({ idiom, error: error.message });
        // Assign to first category as fallback
        results[CATEGORIES[0]].push(idiom);
        stats.classified++;
      });
    }
  }

  // Calculate distribution
  CATEGORIES.forEach(cat => {
    stats.distribution[cat] = results[cat].length;
  });

  // Save results
  const outputPath = path.join(__dirname, 'classified_idioms.json');
  await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf-8');
  console.log(`\n💾 Results saved to ${path.basename(outputPath)}`);

  // Save stats
  const statsPath = path.join(__dirname, 'stats.json');
  await fs.writeFile(statsPath, JSON.stringify(stats, null, 2), 'utf-8');
  console.log(`📈 Statistics saved to ${path.basename(statsPath)}`);

  // Print summary
  console.log('\n' + '='.repeat(50));
  console.log('📊 CLASSIFICATION SUMMARY');
  console.log('='.repeat(50));
  console.log(`Total idioms: ${stats.total}`);
  console.log(`Successfully classified: ${stats.classified}`);
  console.log(`Failed: ${stats.failed.length}`);
  console.log('\n📈 Distribution by category:');
  
  Object.entries(stats.distribution)
    .sort((a, b) => b[1] - a[1])
    .forEach(([cat, count]) => {
      const percentage = ((count / stats.total) * 100).toFixed(1);
      console.log(`  ${cat.padEnd(15)} ${count.toString().padStart(3)} (${percentage}%)`);
    });

  if (stats.failed.length > 0) {
    console.log(`\n⚠️  ${stats.failed.length} idioms had classification issues. Check stats.json for details.`);
  }

  console.log('='.repeat(50));
  console.log('✅ Classification complete!\n');
}

// Run the script
classifyIdioms().catch(error => {
  console.error('\n❌ Fatal error:', error.message);
  process.exit(1);
});

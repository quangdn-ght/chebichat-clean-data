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
  model: 'qwen-max',
  temperature: 0.7,
  retryDelay: 2000,
  maxRetries: 3
};

// Initialize OpenAI client with Qwen endpoint
const openai = new OpenAI({
  apiKey: CONFIG.apiKey,
  baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// System prompt for Qwen-Max
const SYSTEM_PROMPT = `You are a professional travel content generator and cultural translator specializing in Chinese tourism.

Your task is to process a Chinese-language description of a famous tourist attraction in China and produce a structured JSON output with the following fields:

1. name (original Chinese name)
2. name_vi (Vietnamese translation of the name)
3. name_en (English translation of the name)
4. description_vi (a detailed, eloquent, and culturally rich Vietnamese description, 400–800 words, mirroring depth, tone, and structure of professional travel content)
5. short_description_zh (a concise 1–2 sentence summary in Chinese, capturing the essence)
6. short_description_vi (a natural, engaging 2–3 sentence summary in Vietnamese)

The Vietnamese description must:
- Faithfully reflect all key information: geography, cultural significance, historical background, ethnic connections, geological features, scenic zones (e.g., glaciers, meadows, forests, water features), seasonal changes, visitor experience, and legends.
- Use poetic and evocative language where appropriate (e.g., "uốn lượn như rồng bạc", "tuyết trắng như ngọc").
- Include specific names (e.g., local ethnic terms, peak names, valley names) with Vietnamese transliteration and brief explanations.
- Mention elevation, dimensions, unique records (e.g., "lowest-latitude glacier in the Northern Hemisphere"), and infrastructure (e.g., cable cars, parks).
- Preserve spiritual or mythological context (e.g., sacred mountains, deities, folklore).
- Be factually accurate, coherent, and formatted as a single flowing paragraph (no bullet points in description_vi).

Output: Only valid JSON in the exact schema below. No extra text, no markdown, no explanations.

Schema:
{
  "name": "string",
  "name_vi": "string",
  "name_en": "string",
  "description_vi": "string",
  "short_description_zh": "string",
  "short_description_vi": "string"
}`;

/**
 * Sleep utility for rate limiting
 */
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Call Qwen API to generate attraction content
 */
async function generateAttractionContent(chineseDescription, retryCount = 0) {
  try {
    console.log(`📡 Calling Qwen-Max API (attempt ${retryCount + 1})...`);
    
    const completion = await openai.chat.completions.create({
      model: CONFIG.model,
      messages: [
        {
          role: 'system',
          content: SYSTEM_PROMPT
        },
        {
          role: 'user',
          content: `Process this Chinese attraction description:\n\n${chineseDescription}`
        }
      ],
      temperature: CONFIG.temperature,
      response_format: { type: "json_object" }
    });

    const content = completion.choices[0].message.content || '';
    
    // Parse and validate JSON
    let result;
    try {
      result = JSON.parse(content);
    } catch (parseError) {
      // Try to extract JSON from response if it's wrapped in markdown
      const jsonMatch = content.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        result = JSON.parse(jsonMatch[0]);
      } else {
        throw new Error('Failed to parse JSON from response');
      }
    }

    // Validate required fields
    const requiredFields = ['name', 'name_vi', 'name_en', 'description_vi', 'short_description_zh', 'short_description_vi'];
    const missingFields = requiredFields.filter(field => !result[field]);
    
    if (missingFields.length > 0) {
      throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
    }

    // Validate description_vi length (should be 400-800 words approximately)
    const wordCount = result.description_vi.split(/\s+/).length;
    if (wordCount < 200) {
      console.warn(`⚠️  Warning: description_vi is too short (${wordCount} words). Expected 400-800 words.`);
    }

    console.log(`✅ Successfully generated content (description: ${wordCount} words)`);
    
    return result;
    
  } catch (error) {
    // Handle rate limiting
    if (error.status === 429 && retryCount < CONFIG.maxRetries) {
      console.log(`⚠️  Rate limit hit, retrying in ${CONFIG.retryDelay}ms...`);
      await sleep(CONFIG.retryDelay);
      return generateAttractionContent(chineseDescription, retryCount + 1);
    }
    
    // Retry on other errors
    if (retryCount < CONFIG.maxRetries) {
      console.log(`⚠️  Error occurred, retrying... (${error.message})`);
      await sleep(CONFIG.retryDelay);
      return generateAttractionContent(chineseDescription, retryCount + 1);
    }
    
    throw error;
  }
}

/**
 * Process a single attraction
 */
async function processAttraction(chineseDescription) {
  console.log('\n' + '='.repeat(60));
  console.log('🏔️  PROCESSING ATTRACTION');
  console.log('='.repeat(60));
  console.log(`Input length: ${chineseDescription.length} characters\n`);

  try {
    const result = await generateAttractionContent(chineseDescription);
    
    console.log('\n' + '='.repeat(60));
    console.log('✅ RESULT');
    console.log('='.repeat(60));
    console.log(`Name (中文): ${result.name}`);
    console.log(`Name (Tiếng Việt): ${result.name_vi}`);
    console.log(`Name (English): ${result.name_en}`);
    console.log(`\nShort Description (中文):\n${result.short_description_zh}`);
    console.log(`\nShort Description (Tiếng Việt):\n${result.short_description_vi}`);
    console.log(`\nDescription (Tiếng Việt) - ${result.description_vi.split(/\s+/).length} words:\n${result.description_vi.substring(0, 200)}...`);
    console.log('='.repeat(60));
    
    return result;
    
  } catch (error) {
    console.error('\n❌ Error processing attraction:', error.message);
    throw error;
  }
}

/**
 * Process multiple attractions from a file
 */
async function processAttractionBatch(inputFile, outputFile) {
  console.log('🚀 Starting attraction content generation...\n');

  // Validate API key
  if (!CONFIG.apiKey) {
    throw new Error('❌ DASHSCOPE_API_KEY not found in environment variables');
  }

  console.log(`🔧 Configuration:`);
  console.log(`   Model: ${CONFIG.model}`);
  console.log(`   Temperature: ${CONFIG.temperature}`);
  console.log(`   Max retries: ${CONFIG.maxRetries}`);
  console.log(`   Retry delay: ${CONFIG.retryDelay}ms\n`);

  // Read input file
  const inputPath = path.resolve(inputFile);
  const inputData = JSON.parse(await fs.readFile(inputPath, 'utf-8'));
  
  console.log(`📚 Loaded ${inputData.length} attractions from ${path.basename(inputPath)}\n`);

  const results = [];
  const errors = [];

  for (let i = 0; i < inputData.length; i++) {
    const item = inputData[i];
    console.log(`\n📍 Processing attraction ${i + 1}/${inputData.length}`);
    
    try {
      const result = await processAttraction(item.description || item.description_zh || item.content);
      
      // Merge with original data
      results.push({
        ...item,
        ...result,
        processed_at: new Date().toISOString()
      });
      
      // Save progress after each successful processing
      const outputPath = path.resolve(outputFile);
      await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf-8');
      console.log(`💾 Progress saved (${results.length}/${inputData.length})`);
      
      // Delay between requests to avoid rate limiting
      if (i < inputData.length - 1) {
        await sleep(CONFIG.retryDelay);
      }
      
    } catch (error) {
      console.error(`❌ Failed to process attraction ${i + 1}:`, error.message);
      errors.push({
        index: i,
        item: item,
        error: error.message
      });
    }
  }

  // Save final results
  const outputPath = path.resolve(outputFile);
  await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf-8');
  console.log(`\n💾 Final results saved to ${path.basename(outputPath)}`);

  // Save errors if any
  if (errors.length > 0) {
    const errorPath = outputPath.replace('.json', '-errors.json');
    await fs.writeFile(errorPath, JSON.stringify(errors, null, 2), 'utf-8');
    console.log(`⚠️  Errors saved to ${path.basename(errorPath)}`);
  }

  // Print summary
  console.log('\n' + '='.repeat(60));
  console.log('📊 PROCESSING SUMMARY');
  console.log('='.repeat(60));
  console.log(`Total attractions: ${inputData.length}`);
  console.log(`Successfully processed: ${results.length}`);
  console.log(`Failed: ${errors.length}`);
  console.log('='.repeat(60));
  console.log('✅ Batch processing complete!\n');
}

/**
 * Example usage for single attraction
 */
async function exampleSingleAttraction() {
  const exampleDescription = `玉龙雪山位于云南省丽江市玉龙纳西族自治县，是中国最南的雪山，也是横断山脉的沙鲁里山南段的名山。玉龙雪山最高海拔5596米，山顶终年积雪，由13座雪峰组成，主峰扇子陡最高海拔5596米，山体南北长35公里，东西宽13公里。玉龙雪山在纳西语中被称为"欧鲁"，意为"天山"。其十三峰由北向南纵向排列，如矫健的玉龙横卧山巅，故名"玉龙雪山"。玉龙雪山以其壮丽的自然风光和独特的民族文化闻名于世，是纳西族及丽江各民族心目中的神山，主神"三朵"就是玉龙雪山的化身。`;

  const result = await processAttraction(exampleDescription);
  
  // Save example result
  const outputPath = path.join(__dirname, 'example-output.json');
  await fs.writeFile(outputPath, JSON.stringify(result, null, 2), 'utf-8');
  console.log(`\n💾 Example saved to ${path.basename(outputPath)}`);
}

// Main execution
if (import.meta.url === `file://${process.argv[1]}`) {
  const args = process.argv.slice(2);
  
  if (args.length === 0) {
    // Run example if no arguments
    console.log('📝 Running example with sample attraction...\n');
    exampleSingleAttraction().catch(error => {
      console.error('\n❌ Fatal error:', error.message);
      process.exit(1);
    });
  } else if (args.length === 2) {
    // Process batch from file
    const [inputFile, outputFile] = args;
    processAttractionBatch(inputFile, outputFile).catch(error => {
      console.error('\n❌ Fatal error:', error.message);
      process.exit(1);
    });
  } else {
    console.log(`
Usage:
  node attraction-generator.js                          # Run example
  node attraction-generator.js <input.json> <output.json>  # Process batch

Input JSON format:
[
  {
    "description": "Chinese description text...",
    "attraction_code": 12345,
    ... other fields
  }
]
    `);
    process.exit(1);
  }
}

export { processAttraction, processAttractionBatch };

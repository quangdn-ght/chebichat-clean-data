import OpenAI from 'openai';
import { createClient } from '@supabase/supabase-js';
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
  // Qwen API
  apiKey: process.env.DASHSCOPE_API_KEY,
  model: 'qwen-max',
  temperature: 0.7,
  retryDelay: 2000,
  maxRetries: 3,
  
  // Supabase
  supabaseUrl: process.env.SUPABASE_URL,
  supabaseKey: process.env.SUPABASE_SERVICE_ROLE_KEY,
  
  // Processing
  batchSize: 10, // Process 10 attractions at a time
  saveProgressInterval: 5 // Save progress every 5 successful processings
};

// Initialize OpenAI client with Qwen endpoint
const openai = new OpenAI({
  apiKey: CONFIG.apiKey,
  baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// Initialize Supabase client
const supabase = createClient(CONFIG.supabaseUrl, CONFIG.supabaseKey);

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
 * Fetch attractions from Supabase
 */
async function fetchAttractionsFromSupabase(limit = null, offset = 0) {
  console.log('📡 Fetching attractions from Supabase...');
  
  try {
    let query = supabase
      .from('attractions')
      .select('id, attraction_code, name, description, province_id, region_id, category_id')
      .not('description', 'is', null)
      .order('attraction_code', { ascending: true });
    
    if (limit) {
      query = query.range(offset, offset + limit - 1);
    }
    
    const { data, error } = await query;
    
    if (error) {
      throw new Error(`Supabase error: ${error.message}`);
    }
    
    console.log(`✅ Fetched ${data.length} attractions from Supabase`);
    return data;
    
  } catch (error) {
    console.error('❌ Failed to fetch from Supabase:', error.message);
    throw error;
  }
}

/**
 * Update attraction in Supabase with generated content
 */
async function updateAttractionInSupabase(attractionId, generatedContent) {
  try {
    const updateData = {
      name_vi: generatedContent.name_vi,
      name_en: generatedContent.name_en,
      description_vi: generatedContent.description_vi,
      short_description_zh: generatedContent.short_description_zh,
      short_description_vi: generatedContent.short_description_vi,
      updated_at: new Date().toISOString()
    };
    
    const { error } = await supabase
      .from('attractions')
      .update(updateData)
      .eq('id', attractionId);
    
    if (error) {
      throw new Error(`Supabase update error: ${error.message}`);
    }
    
    return true;
  } catch (error) {
    console.error(`❌ Failed to update attraction ${attractionId}:`, error.message);
    return false;
  }
}

/**
 * Call Qwen API to generate attraction content
 */
async function generateAttractionContent(name, description, retryCount = 0) {
  try {
    const userPrompt = `Process this Chinese attraction:

Name: ${name}
Description: ${description}`;
    
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

    // Validate description_vi length
    const wordCount = result.description_vi.split(/\s+/).length;
    if (wordCount < 200) {
      console.warn(`⚠️  Warning: description_vi is short (${wordCount} words)`);
    }
    
    return result;
    
  } catch (error) {
    // Handle rate limiting
    if (error.status === 429 && retryCount < CONFIG.maxRetries) {
      console.log(`⚠️  Rate limit hit, retrying in ${CONFIG.retryDelay}ms...`);
      await sleep(CONFIG.retryDelay);
      return generateAttractionContent(name, description, retryCount + 1);
    }
    
    // Retry on other errors
    if (retryCount < CONFIG.maxRetries) {
      console.log(`⚠️  Error occurred, retrying... (${error.message})`);
      await sleep(CONFIG.retryDelay);
      return generateAttractionContent(name, description, retryCount + 1);
    }
    
    throw error;
  }
}

/**
 * Process a single attraction
 */
async function processAttraction(attraction, updateDatabase = false) {
  const { id, attraction_code, name, description } = attraction;
  
  console.log(`\n${'='.repeat(60)}`);
  console.log(`📍 Processing: ${name} (Code: ${attraction_code})`);
  console.log(`${'='.repeat(60)}`);

  try {
    const result = await generateAttractionContent(name, description);
    
    const wordCount = result.description_vi.split(/\s+/).length;
    console.log(`✅ Generated content (${wordCount} words)`);
    console.log(`   Vietnamese name: ${result.name_vi}`);
    console.log(`   English name: ${result.name_en}`);
    
    // Update database if requested
    if (updateDatabase) {
      console.log(`💾 Updating Supabase...`);
      const updated = await updateAttractionInSupabase(id, result);
      if (updated) {
        console.log(`✅ Database updated successfully`);
      }
    }
    
    return {
      success: true,
      attraction_code,
      original: { id, name, description },
      generated: result
    };
    
  } catch (error) {
    console.error(`❌ Failed to process attraction ${attraction_code}:`, error.message);
    return {
      success: false,
      attraction_code,
      original: { id, name, description },
      error: error.message
    };
  }
}

/**
 * Process multiple attractions in batch
 */
async function processAttractionBatch(options = {}) {
  const {
    limit = null,
    offset = 0,
    updateDatabase = false,
    saveToFile = true,
    outputFile = 'output/processed-attractions.json'
  } = options;
  
  console.log('\n🚀 Starting Attraction Content Generation from Supabase\n');
  console.log(`${'='.repeat(60)}`);
  console.log('⚙️  CONFIGURATION');
  console.log(`${'='.repeat(60)}`);
  console.log(`Model: ${CONFIG.model}`);
  console.log(`Temperature: ${CONFIG.temperature}`);
  console.log(`Batch size: ${CONFIG.batchSize}`);
  console.log(`Limit: ${limit || 'All'}`);
  console.log(`Offset: ${offset}`);
  console.log(`Update database: ${updateDatabase ? 'Yes' : 'No'}`);
  console.log(`Save to file: ${saveToFile ? 'Yes' : 'No'}`);
  console.log(`${'='.repeat(60)}\n`);

  // Validate configuration
  if (!CONFIG.apiKey) {
    throw new Error('❌ DASHSCOPE_API_KEY not found in environment variables');
  }
  if (!CONFIG.supabaseUrl || !CONFIG.supabaseKey) {
    throw new Error('❌ Supabase credentials not found in environment variables');
  }

  // Fetch attractions from Supabase
  const attractions = await fetchAttractionsFromSupabase(limit, offset);
  
  if (attractions.length === 0) {
    console.log('⚠️  No attractions found to process');
    return;
  }

  const results = {
    total: attractions.length,
    processed: 0,
    successful: 0,
    failed: 0,
    items: []
  };

  // Process each attraction
  for (let i = 0; i < attractions.length; i++) {
    const attraction = attractions[i];
    
    console.log(`\n📊 Progress: ${i + 1}/${attractions.length}`);
    
    const result = await processAttraction(attraction, updateDatabase);
    results.items.push(result);
    results.processed++;
    
    if (result.success) {
      results.successful++;
    } else {
      results.failed++;
    }
    
    // Save progress periodically
    if (saveToFile && (i + 1) % CONFIG.saveProgressInterval === 0) {
      const outputPath = path.resolve(__dirname, outputFile);
      await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf-8');
      console.log(`💾 Progress saved (${results.successful}/${attractions.length} successful)`);
    }
    
    // Delay between requests to avoid rate limiting
    if (i < attractions.length - 1) {
      await sleep(CONFIG.retryDelay);
    }
  }

  // Save final results
  if (saveToFile) {
    const outputPath = path.resolve(__dirname, outputFile);
    await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf-8');
    console.log(`\n💾 Final results saved to ${outputFile}`);
    
    // Save errors separately if any
    if (results.failed > 0) {
      const errors = results.items.filter(item => !item.success);
      const errorPath = outputPath.replace('.json', '-errors.json');
      await fs.writeFile(errorPath, JSON.stringify(errors, null, 2), 'utf-8');
      console.log(`⚠️  Errors saved to ${path.basename(errorPath)}`);
    }
  }

  // Print summary
  console.log(`\n${'='.repeat(60)}`);
  console.log('📊 PROCESSING SUMMARY');
  console.log(`${'='.repeat(60)}`);
  console.log(`Total attractions: ${results.total}`);
  console.log(`Successfully processed: ${results.successful} ✅`);
  console.log(`Failed: ${results.failed} ❌`);
  console.log(`Success rate: ${((results.successful / results.total) * 100).toFixed(1)}%`);
  if (updateDatabase) {
    console.log(`Database updated: ${results.successful} records`);
  }
  console.log(`${'='.repeat(60)}`);
  console.log('✅ Batch processing complete!\n');
  
  return results;
}

/**
 * Process a single attraction by ID or code
 */
async function processSingleByCode(attractionCode, updateDatabase = false) {
  console.log(`🔍 Fetching attraction with code ${attractionCode}...`);
  
  const { data, error } = await supabase
    .from('attractions')
    .select('id, attraction_code, name, description, province_id, region_id, category_id')
    .eq('attraction_code', attractionCode)
    .single();
  
  if (error || !data) {
    throw new Error(`Attraction with code ${attractionCode} not found`);
  }
  
  const result = await processAttraction(data, updateDatabase);
  
  // Save result
  const outputPath = path.join(__dirname, 'output', `attraction-${attractionCode}.json`);
  await fs.writeFile(outputPath, JSON.stringify(result, null, 2), 'utf-8');
  console.log(`\n💾 Result saved to ${path.basename(outputPath)}`);
  
  return result;
}

// CLI interface
if (import.meta.url === `file://${process.argv[1]}`) {
  const args = process.argv.slice(2);
  
  // Parse command line arguments
  const options = {
    limit: null,
    offset: 0,
    updateDatabase: false,
    saveToFile: true,
    code: null
  };
  
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--limit' && args[i + 1]) {
      options.limit = parseInt(args[i + 1]);
      i++;
    } else if (args[i] === '--offset' && args[i + 1]) {
      options.offset = parseInt(args[i + 1]);
      i++;
    } else if (args[i] === '--update-db') {
      options.updateDatabase = true;
    } else if (args[i] === '--no-save') {
      options.saveToFile = false;
    } else if (args[i] === '--code' && args[i + 1]) {
      options.code = parseInt(args[i + 1]);
      i++;
    } else if (args[i] === '--help' || args[i] === '-h') {
      console.log(`
🏔️  Supabase Attraction Content Processor

Usage:
  node supabase-attraction-processor.js [options]

Options:
  --limit <number>      Process only N attractions (default: all)
  --offset <number>     Skip first N attractions (default: 0)
  --code <number>       Process single attraction by attraction_code
  --update-db           Update Supabase database with generated content
  --no-save             Don't save results to file
  --help, -h            Show this help message

Examples:
  # Process first 10 attractions (dry run)
  node supabase-attraction-processor.js --limit 10

  # Process attractions 20-30 and update database
  node supabase-attraction-processor.js --limit 10 --offset 20 --update-db

  # Process single attraction by code
  node supabase-attraction-processor.js --code 10001 --update-db

  # Process all attractions and update database
  node supabase-attraction-processor.js --update-db
      `);
      process.exit(0);
    }
  }
  
  // Execute
  (async () => {
    try {
      if (options.code) {
        await processSingleByCode(options.code, options.updateDatabase);
      } else {
        await processAttractionBatch(options);
      }
    } catch (error) {
      console.error('\n❌ Fatal error:', error.message);
      process.exit(1);
    }
  })();
}

export { 
  processAttraction, 
  processAttractionBatch, 
  processSingleByCode,
  fetchAttractionsFromSupabase,
  updateAttractionInSupabase
};

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
  batchSize: 10,
  saveProgressInterval: 5
};

// Initialize OpenAI client with Qwen endpoint
const openai = new OpenAI({
  apiKey: CONFIG.apiKey,
  baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// Initialize Supabase client
const supabase = createClient(CONFIG.supabaseUrl, CONFIG.supabaseKey);

// System prompt for region content generation
const SYSTEM_PROMPT = `You are a professional travel content generator and cultural translator specializing in Chinese tourism and geography.

Your task is to process information about a Chinese region/city and produce a structured JSON output with the following fields:

1. name (original Chinese name - keep as provided)
2. name_vi (Vietnamese translation/transliteration of the region name)
3. short_description (a concise 1-2 sentence summary in Chinese, capturing the essence and key characteristics of the region)
4. short_description_vi (a natural, engaging 2-3 sentence summary in Vietnamese)

The descriptions should:
- Highlight the region's geographic location, cultural significance, or famous features
- Use natural, engaging language appropriate for travel content
- Be factually accurate and informative
- For Chinese: use simple, clear language (1-2 sentences, 50-100 characters)
- For Vietnamese: use natural, flowing language (2-3 sentences, 100-200 words)
- Include notable attractions, cultural heritage, or unique characteristics if known

Output: Only valid JSON in the exact schema below. No extra text, no markdown, no explanations.

Schema:
{
  "name": "string",
  "name_vi": "string",
  "short_description": "string",
  "short_description_vi": "string"
}`;

/**
 * Sleep utility for rate limiting
 */
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Call Qwen API to generate region content
 */
async function generateRegionContent(regionName, retryCount = 0) {
  try {
    console.log(`📡 Calling Qwen-Max API for "${regionName}" (attempt ${retryCount + 1})...`);
    
    const completion = await openai.chat.completions.create({
      model: CONFIG.model,
      messages: [
        {
          role: 'system',
          content: SYSTEM_PROMPT
        },
        {
          role: 'user',
          content: `Process this Chinese region: ${regionName}\n\nProvide Vietnamese translation and concise descriptions in both Chinese and Vietnamese.`
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
        throw new Error(`Failed to parse JSON: ${content.substring(0, 200)}`);
      }
    }
    
    // Validate required fields
    const requiredFields = ['name', 'name_vi', 'short_description', 'short_description_vi'];
    const missingFields = requiredFields.filter(field => !result[field]);
    
    if (missingFields.length > 0) {
      throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
    }
    
    console.log(`✅ Generated content for "${regionName}"`);
    return result;
    
  } catch (error) {
    console.error(`❌ Error generating content (attempt ${retryCount + 1}):`, error.message);
    
    if (retryCount < CONFIG.maxRetries) {
      console.log(`⏳ Retrying in ${CONFIG.retryDelay}ms...`);
      await sleep(CONFIG.retryDelay);
      return generateRegionContent(regionName, retryCount + 1);
    }
    
    throw error;
  }
}

/**
 * Fetch regions from Supabase
 */
async function fetchRegionsFromSupabase(limit = null, offset = 0) {
  console.log('📡 Fetching regions from Supabase...');
  
  try {
    let query = supabase
      .from('regions')
      .select('id, region_code, name, name_vi, name_en, province_id')
      .or('name_vi.is.null,short_description.is.null,short_description_vi.is.null')
      .not('name', 'is', null)
      .order('region_code', { ascending: true });
    
    if (limit) {
      query = query.range(offset, offset + limit - 1);
    }
    
    const { data, error } = await query;
    
    if (error) {
      throw new Error(`Supabase query error: ${error.message}`);
    }
    
    console.log(`✅ Fetched ${data.length} regions`);
    return data;
    
  } catch (error) {
    console.error('❌ Error fetching regions:', error);
    throw error;
  }
}

/**
 * Update region in Supabase
 */
async function updateRegionInSupabase(regionId, generatedData) {
  try {
    const updateData = {
      name_vi: generatedData.name_vi,
      short_description: generatedData.short_description,
      short_description_vi: generatedData.short_description_vi,
      updated_at: new Date().toISOString()
    };
    
    const { data, error } = await supabase
      .from('regions')
      .update(updateData)
      .eq('id', regionId)
      .select();
    
    if (error) {
      throw new Error(`Update error: ${error.message}`);
    }
    
    console.log(`✅ Updated region ID ${regionId} in database`);
    return data;
    
  } catch (error) {
    console.error(`❌ Error updating region ${regionId}:`, error);
    throw error;
  }
}

/**
 * Process a single region
 */
export async function processRegion(region, updateDb = false) {
  const startTime = Date.now();
  
  try {
    console.log(`\n${'='.repeat(80)}`);
    console.log(`Processing Region ID: ${region.id}`);
    console.log(`Region Code: ${region.region_code}`);
    console.log(`Name: ${region.name}`);
    console.log(`${'='.repeat(80)}`);
    
    // Generate content using Qwen API
    const generated = await generateRegionContent(region.name);
    
    // Log generated content
    console.log('\n📝 Generated Content:');
    console.log(`   Name (ZH): ${generated.name}`);
    console.log(`   Name (VI): ${generated.name_vi}`);
    console.log(`   Short Desc (ZH): ${generated.short_description}`);
    console.log(`   Short Desc (VI): ${generated.short_description_vi}`);
    
    const result = {
      id: region.id,
      region_code: region.region_code,
      original_name: region.name,
      ...generated,
      processing_time: Date.now() - startTime,
      status: 'success',
      updated_db: false
    };
    
    // Update database if requested
    if (updateDb) {
      await updateRegionInSupabase(region.id, generated);
      result.updated_db = true;
    }
    
    console.log(`\n✅ Completed in ${result.processing_time}ms`);
    return result;
    
  } catch (error) {
    console.error(`\n❌ Failed to process region ${region.id}:`, error.message);
    
    return {
      id: region.id,
      region_code: region.region_code,
      original_name: region.name,
      error: error.message,
      processing_time: Date.now() - startTime,
      status: 'failed',
      updated_db: false
    };
  }
}

/**
 * Main processing function
 */
export async function processRegions(options = {}) {
  const {
    limit = null,
    offset = 0,
    updateDb = false,
    saveResults = true
  } = options;
  
  console.log('\n🚀 Starting Region Content Generation');
  console.log(`   Limit: ${limit || 'all'}`);
  console.log(`   Offset: ${offset}`);
  console.log(`   Update DB: ${updateDb}`);
  console.log(`   Model: ${CONFIG.model}`);
  
  try {
    // Fetch regions
    const regions = await fetchRegionsFromSupabase(limit, offset);
    
    if (regions.length === 0) {
      console.log('\n✅ No regions to process!');
      return { results: [], summary: { total: 0, success: 0, failed: 0 } };
    }
    
    console.log(`\n📊 Will process ${regions.length} regions\n`);
    
    // Process regions sequentially
    const results = [];
    let successCount = 0;
    let failedCount = 0;
    
    for (let i = 0; i < regions.length; i++) {
      const region = regions[i];
      console.log(`\n[${i + 1}/${regions.length}] Processing "${region.name}"...`);
      
      const result = await processRegion(region, updateDb);
      results.push(result);
      
      if (result.status === 'success') {
        successCount++;
      } else {
        failedCount++;
      }
      
      // Save progress periodically
      if (saveResults && (i + 1) % CONFIG.saveProgressInterval === 0) {
        await saveProgress(results, successCount, failedCount);
      }
      
      // Rate limiting: wait 1 second between requests
      if (i < regions.length - 1) {
        await sleep(1000);
      }
    }
    
    // Save final results
    if (saveResults) {
      await saveFinalResults(results, successCount, failedCount);
    }
    
    // Print summary
    printSummary(results, successCount, failedCount);
    
    return {
      results,
      summary: {
        total: regions.length,
        success: successCount,
        failed: failedCount
      }
    };
    
  } catch (error) {
    console.error('\n❌ Fatal error:', error);
    throw error;
  }
}

/**
 * Save progress to file
 */
async function saveProgress(results, successCount, failedCount) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `region-progress-${timestamp}.json`;
  const filepath = path.join(__dirname, 'output', filename);
  
  await fs.mkdir(path.join(__dirname, 'output'), { recursive: true });
  await fs.writeFile(filepath, JSON.stringify({
    timestamp: new Date().toISOString(),
    processed: results.length,
    success: successCount,
    failed: failedCount,
    results
  }, null, 2));
  
  console.log(`\n💾 Progress saved to ${filename}`);
}

/**
 * Save final results
 */
async function saveFinalResults(results, successCount, failedCount) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  
  // Create output directory
  await fs.mkdir(path.join(__dirname, 'output'), { recursive: true });
  
  // Save all results
  const allResultsFile = path.join(__dirname, 'output', `regions-all-${timestamp}.json`);
  await fs.writeFile(allResultsFile, JSON.stringify(results, null, 2));
  console.log(`\n💾 All results saved to ${allResultsFile}`);
  
  // Save successful results
  const successResults = results.filter(r => r.status === 'success');
  if (successResults.length > 0) {
    const successFile = path.join(__dirname, 'output', `regions-success-${timestamp}.json`);
    await fs.writeFile(successFile, JSON.stringify(successResults, null, 2));
    console.log(`💾 Success results saved to ${successFile}`);
  }
  
  // Save failed results
  const failedResults = results.filter(r => r.status === 'failed');
  if (failedResults.length > 0) {
    const failedFile = path.join(__dirname, 'output', `regions-failed-${timestamp}.json`);
    await fs.writeFile(failedFile, JSON.stringify(failedResults, null, 2));
    console.log(`💾 Failed results saved to ${failedFile}`);
  }
}

/**
 * Print summary
 */
function printSummary(results, successCount, failedCount) {
  console.log('\n' + '='.repeat(80));
  console.log('📊 PROCESSING SUMMARY');
  console.log('='.repeat(80));
  console.log(`Total Processed: ${results.length}`);
  console.log(`✅ Success: ${successCount}`);
  console.log(`❌ Failed: ${failedCount}`);
  
  if (results.length > 0) {
    const totalTime = results.reduce((sum, r) => sum + r.processing_time, 0);
    const avgTime = totalTime / results.length;
    console.log(`⏱️  Average Time: ${avgTime.toFixed(0)}ms per region`);
    console.log(`⏱️  Total Time: ${(totalTime / 1000).toFixed(1)}s`);
  }
  
  console.log('='.repeat(80) + '\n');
}

/**
 * CLI interface
 */
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const args = process.argv.slice(2);
  const options = {
    limit: null,
    offset: 0,
    updateDb: false,
    saveResults: true
  };
  
  // Parse command line arguments
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--limit' && args[i + 1]) {
      options.limit = parseInt(args[i + 1]);
      i++;
    } else if (args[i] === '--offset' && args[i + 1]) {
      options.offset = parseInt(args[i + 1]);
      i++;
    } else if (args[i] === '--update-db') {
      options.updateDb = true;
    } else if (args[i] === '--no-save') {
      options.saveResults = false;
    }
  }
  
  processRegions(options)
    .then(() => {
      console.log('✅ Processing complete!');
      process.exit(0);
    })
    .catch(error => {
      console.error('❌ Processing failed:', error);
      process.exit(1);
    });
}

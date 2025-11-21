import OpenAI from 'openai';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs/promises';
import { cleanHtmlEntities } from './fetch-html-entity-items.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.join(__dirname, '../../.env') });

// Configuration
const CONFIG = {
  apiKey: process.env.DASHSCOPE_API_KEY,
  model: 'qwen-max',
  temperature: 0.7,
  retryDelay: 3000,
  maxRetries: 3,
  supabaseUrl: process.env.SUPABASE_URL,
  supabaseKey: process.env.SUPABASE_SERVICE_ROLE_KEY,
};

const openai = new OpenAI({
  apiKey: CONFIG.apiKey,
  baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

const supabase = createClient(CONFIG.supabaseUrl, CONFIG.supabaseKey);

// Categorize failed items
const ITEMS_TO_RETRY = {
  // Items with only HTML entities - should work after cleaning
  simple_html: [106766, 114164, 114165, 116175],
  
  // Items with religious content but no other issues
  religious: [104421, 114427, 116655],
  
  // Items with mild political/historical references
  historical: [107111, 111797],
  
  // Very long description
  long: [113598],
  
  // Skip - highly sensitive political content
  skip: [103360]
};

const SYSTEM_PROMPT = `You are a professional travel content generator and cultural translator specializing in Chinese tourism.

Your task is to process a Chinese-language description of a famous tourist attraction in China and produce a structured JSON output with the following fields:

1. name (original Chinese name)
2. name_vi (Vietnamese translation of the name)
3. name_en (English translation of the name)
4. description_vi (a detailed, eloquent, and culturally rich Vietnamese description, 400–800 words, mirroring depth, tone, and structure of professional travel content)
5. short_description_zh (a concise 1–2 sentence summary in Chinese, capturing the essence)
6. short_description_vi (a natural, engaging 2–3 sentence summary in Vietnamese)

The Vietnamese description must be factually accurate, culturally rich, and engaging. Focus on geography, architecture, history, and visitor experience.

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

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function generateContent(attraction, retries = 0) {
  const prompt = `根据以下中文景点描述，生成完整的JSON输出：

景点名称：${attraction.name}
景点描述：${attraction.description}

请生成包含 name, name_vi, name_en, description_vi, short_description_zh, short_description_vi 的JSON。`;

  try {
    const completion = await openai.chat.completions.create({
      model: CONFIG.model,
      messages: [
        { role: 'system', content: SYSTEM_PROMPT },
        { role: 'user', content: prompt }
      ],
      temperature: CONFIG.temperature
    });

    const content = completion.choices[0]?.message?.content?.trim();
    if (!content) throw new Error('Empty response from API');

    let jsonStr = content;
    if (jsonStr.startsWith('```')) {
      jsonStr = jsonStr.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
    }

    return JSON.parse(jsonStr);

  } catch (error) {
    if (retries < CONFIG.maxRetries && !error.message.includes('inappropriate content')) {
      console.log(`   ⚠️  Retrying... (${error.message})`);
      await sleep(CONFIG.retryDelay * (retries + 1));
      return generateContent(attraction, retries + 1);
    }
    throw error;
  }
}

async function updateSupabase(attractionCode, generatedData) {
  const { data, error } = await supabase
    .from('attractions')
    .update({
      name_vi: generatedData.name_vi,
      name_en: generatedData.name_en,
      description_vi: generatedData.description_vi,
      short_description_zh: generatedData.short_description_zh,
      short_description_vi: generatedData.short_description_vi,
      updated_at: new Date().toISOString()
    })
    .eq('attraction_code', attractionCode)
    .select();

  if (error) throw error;
  return data;
}

async function processItem(attraction, category) {
  console.log(`\n📍 Processing: ${attraction.name} (Code: ${attraction.attraction_code}) [${category}]`);
  console.log('='.repeat(100));

  try {
    // Clean HTML entities
    let cleanedDescription = cleanHtmlEntities(attraction.description);
    const originalLen = attraction.description.length;
    const cleanedLen = cleanedDescription.length;
    
    if (originalLen !== cleanedLen) {
      console.log(`   🧹 Cleaned HTML entities (${originalLen} → ${cleanedLen} chars)`);
    }

    // For very long descriptions, truncate intelligently
    if (category === 'long' && cleanedDescription.length > 2500) {
      // Keep first 2500 characters at sentence boundary
      cleanedDescription = cleanedDescription.substring(0, 2500);
      const lastPeriod = Math.max(
        cleanedDescription.lastIndexOf('。'),
        cleanedDescription.lastIndexOf('\n')
      );
      if (lastPeriod > 1500) {
        cleanedDescription = cleanedDescription.substring(0, lastPeriod + 1);
      }
      console.log(`   ✂️  Truncated to ${cleanedDescription.length} chars`);
    }

    const processedAttraction = {
      ...attraction,
      description: cleanedDescription
    };

    const generated = await generateContent(processedAttraction);
    const wordCount = generated.description_vi.split(/\s+/).length;
    
    console.log(`   ✅ Generated content (${wordCount} words)`);
    console.log(`   Vietnamese: ${generated.name_vi}`);
    console.log(`   English: ${generated.name_en}`);

    if (wordCount < 200) {
      console.log(`   ⚠️  Warning: Short description (${wordCount} words)`);
    }

    console.log(`   💾 Updating database...`);
    await updateSupabase(attraction.attraction_code, generated);
    console.log(`   ✅ Success!`);

    return { success: true, wordCount };

  } catch (error) {
    console.error(`   ❌ Failed: ${error.message}`);
    return { success: false, error: error.message };
  }
}

async function retryByCategory() {
  console.log('🔄 Smart Retry with Category-based Processing\n');
  console.log('='.repeat(100));

  const results = {
    success: [],
    failed: [],
    skipped: [],
    timestamp: new Date().toISOString()
  };

  // Process skipped items
  for (const code of ITEMS_TO_RETRY.skip) {
    console.log(`\n⏭️  Skipping Code ${code} - Highly sensitive political content`);
    results.skipped.push({ code, reason: 'Political/violent content' });
  }

  // Process all other categories
  const categoriesToProcess = ['simple_html', 'religious', 'historical', 'long'];
  
  for (const category of categoriesToProcess) {
    const codes = ITEMS_TO_RETRY[category];
    if (!codes || codes.length === 0) continue;

    console.log(`\n\n${'='.repeat(100)}`);
    console.log(`📂 Processing Category: ${category.toUpperCase()} (${codes.length} items)`);
    console.log('='.repeat(100));

    const { data: attractions, error } = await supabase
      .from('attractions')
      .select('id, attraction_code, name, description')
      .in('attraction_code', codes)
      .order('attraction_code');

    if (error) {
      console.error(`❌ Error fetching ${category}:`, error);
      continue;
    }

    for (const attraction of attractions) {
      const result = await processItem(attraction, category);
      
      if (result.success) {
        results.success.push({
          code: attraction.attraction_code,
          name: attraction.name,
          category,
          wordCount: result.wordCount
        });
      } else {
        results.failed.push({
          code: attraction.attraction_code,
          name: attraction.name,
          category,
          error: result.error
        });
      }

      await sleep(2000); // Rate limiting
    }
  }

  // Save report
  const reportPath = path.join(__dirname, 'smart-retry-results.json');
  await fs.writeFile(reportPath, JSON.stringify(results, null, 2), 'utf-8');

  // Summary
  console.log('\n\n' + '='.repeat(100));
  console.log('📊 FINAL SUMMARY');
  console.log('='.repeat(100));
  console.log(`✅ Successful: ${results.success.length}`);
  console.log(`❌ Failed: ${results.failed.length}`);
  console.log(`⏭️  Skipped: ${results.skipped.length}`);
  console.log(`\n📁 Report: ${reportPath}\n`);

  if (results.success.length > 0) {
    console.log('✅ SUCCESSFULLY PROCESSED:');
    results.success.forEach(item => {
      console.log(`   ${item.code}: ${item.name} [${item.category}] (${item.wordCount} words)`);
    });
  }

  if (results.failed.length > 0) {
    console.log('\n❌ STILL FAILED:');
    results.failed.forEach(item => {
      console.log(`   ${item.code}: ${item.name} [${item.category}]`);
      console.log(`      Error: ${item.error}`);
    });
  }

  if (results.skipped.length > 0) {
    console.log('\n⏭️  SKIPPED (Manual Review Required):');
    results.skipped.forEach(item => {
      console.log(`   ${item.code}: ${item.reason}`);
    });
  }

  const totalOriginalFailed = 11;
  const remaining = totalOriginalFailed - results.success.length - results.skipped.length;
  console.log(`\n📈 Progress: ${results.success.length}/${totalOriginalFailed} resolved, ${remaining} remaining`);

  return results;
}

retryByCategory().catch(console.error);

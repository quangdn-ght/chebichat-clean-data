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
  retryDelay: 2000,
  maxRetries: 5,
  supabaseUrl: process.env.SUPABASE_URL,
  supabaseKey: process.env.SUPABASE_SERVICE_ROLE_KEY,
};

// Initialize clients
const openai = new OpenAI({
  apiKey: CONFIG.apiKey,
  baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

const supabase = createClient(CONFIG.supabaseUrl, CONFIG.supabaseKey);

// Items to retry (with HTML entities cleaned)
const retryCodes = [104421, 106766, 111797, 113598, 114164, 114165, 114427, 116175, 116655];

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
    if (!content) {
      throw new Error('Empty response from API');
    }

    // Clean markdown code blocks if present
    let jsonStr = content;
    if (jsonStr.startsWith('```')) {
      jsonStr = jsonStr.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
    }

    const result = JSON.parse(jsonStr);
    return result;

  } catch (error) {
    if (retries < CONFIG.maxRetries) {
      console.log(`   ⚠️  Error occurred, retrying... (${error.message})`);
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

async function retryFailedItems() {
  console.log('🔄 Retrying failed items with cleaned HTML entities...\n');
  console.log('='.repeat(100));

  // Fetch items
  const { data: attractions, error: fetchError } = await supabase
    .from('attractions')
    .select('id, attraction_code, name, description')
    .in('attraction_code', retryCodes)
    .order('attraction_code');

  if (fetchError) {
    console.error('❌ Error fetching attractions:', fetchError);
    return;
  }

  console.log(`📋 Found ${attractions.length} items to retry\n`);

  const results = {
    success: [],
    failed: [],
    timestamp: new Date().toISOString()
  };

  for (const attraction of attractions) {
    console.log(`\n📍 Processing: ${attraction.name} (Code: ${attraction.attraction_code})`);
    console.log('='.repeat(100));

    try {
      // Clean HTML entities from description
      const cleanedDescription = cleanHtmlEntities(attraction.description);
      console.log(`   🧹 Cleaned description (${attraction.description.length} → ${cleanedDescription.length} chars)`);

      // Process with cleaned description
      const cleanedAttraction = {
        ...attraction,
        description: cleanedDescription
      };

      const generated = await generateContent(cleanedAttraction);

      // Validate
      const wordCount = generated.description_vi.split(/\s+/).length;
      console.log(`   ✅ Generated content (${wordCount} words)`);
      console.log(`   Vietnamese name: ${generated.name_vi}`);
      console.log(`   English name: ${generated.name_en}`);

      if (wordCount < 200) {
        console.log(`   ⚠️  Warning: description_vi is short (${wordCount} words)`);
      }

      // Update database
      console.log(`   💾 Updating Supabase...`);
      await updateSupabase(attraction.attraction_code, generated);
      console.log(`   ✅ Database updated successfully`);

      results.success.push({
        code: attraction.attraction_code,
        name: attraction.name,
        word_count: wordCount
      });

      console.log(`   ✅ Success: ${attraction.name}`);

    } catch (error) {
      console.error(`   ❌ Failed: ${error.message}`);
      results.failed.push({
        code: attraction.attraction_code,
        name: attraction.name,
        error: error.message
      });
    }

    // Rate limiting
    await sleep(1000);
  }

  // Save results
  const reportPath = path.join(__dirname, 'retry-results.json');
  await fs.writeFile(reportPath, JSON.stringify(results, null, 2), 'utf-8');

  // Summary
  console.log('\n\n' + '='.repeat(100));
  console.log('📊 RETRY SUMMARY');
  console.log('='.repeat(100));
  console.log(`Total items: ${attractions.length}`);
  console.log(`✅ Successful: ${results.success.length}`);
  console.log(`❌ Failed: ${results.failed.length}`);
  console.log(`\n📁 Report saved to: ${reportPath}`);

  if (results.success.length > 0) {
    console.log('\n✅ Successfully processed:');
    results.success.forEach(item => {
      console.log(`   - ${item.code}: ${item.name} (${item.word_count} words)`);
    });
  }

  if (results.failed.length > 0) {
    console.log('\n❌ Still failed:');
    results.failed.forEach(item => {
      console.log(`   - ${item.code}: ${item.name} - ${item.error}`);
    });
  }

  return results;
}

retryFailedItems().catch(console.error);

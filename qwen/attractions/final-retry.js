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

// Only process items with confirmed HTML-only issues
const SAFE_TO_RETRY = [111797, 113598];

// Items that need manual review
const MANUAL_REVIEW = {
  103360: 'Political/violent content - massacre memorial',
  104421: 'Heavy Buddhist/Taoist religious content',
  107111: 'Historical references to revolution',
  114427: 'Religious content with deity references',
  116175: 'Buddhist temple - chanting/religious content',
  116655: 'Buddhist temple with revolutionary references'
};

const SYSTEM_PROMPT = `You are a professional travel content generator and cultural translator specializing in Chinese tourism.

Your task is to process a Chinese-language description of a famous tourist attraction in China and produce a structured JSON output with the following fields:

1. name (original Chinese name)
2. name_vi (Vietnamese translation of the name)
3. name_en (English translation of the name)
4. description_vi (a detailed, eloquent, and culturally rich Vietnamese description, 400–800 words, mirroring depth, tone, and structure of professional travel content)
5. short_description_zh (a concise 1–2 sentence summary in Chinese, capturing the essence)
6. short_description_vi (a natural, engaging 2–3 sentence summary in Vietnamese)

Output: Only valid JSON. No markdown, no explanations.

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
    if (!content) throw new Error('Empty response');

    let jsonStr = content;
    if (jsonStr.startsWith('```')) {
      jsonStr = jsonStr.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
    }

    return JSON.parse(jsonStr);

  } catch (error) {
    if (retries < CONFIG.maxRetries && !error.message.includes('inappropriate')) {
      console.log(`   ⚠️  Retry ${retries + 1}/${CONFIG.maxRetries}...`);
      await sleep(CONFIG.retryDelay);
      return generateContent(attraction, retries + 1);
    }
    throw error;
  }
}

async function updateSupabase(attractionCode, generatedData) {
  const { error } = await supabase
    .from('attractions')
    .update({
      name_vi: generatedData.name_vi,
      name_en: generatedData.name_en,
      description_vi: generatedData.description_vi,
      short_description_zh: generatedData.short_description_zh,
      short_description_vi: generatedData.short_description_vi,
      updated_at: new Date().toISOString()
    })
    .eq('attraction_code', attractionCode);

  if (error) throw error;
}

async function finalRetry() {
  console.log('🎯 Final Retry - Processing Safe Items\n');
  console.log('='.repeat(100));

  const results = {
    processed_successfully_before: [106766, 114164, 114165],
    success: [],
    failed: [],
    manual_review: Object.entries(MANUAL_REVIEW).map(([code, reason]) => ({
      code: parseInt(code),
      reason
    })),
    timestamp: new Date().toISOString()
  };

  console.log(`📋 Attempting to process ${SAFE_TO_RETRY.length} remaining items...\n`);

  const { data: attractions, error } = await supabase
    .from('attractions')
    .select('id, attraction_code, name, description')
    .in('attraction_code', SAFE_TO_RETRY)
    .order('attraction_code');

  if (error) {
    console.error('❌ Error:', error);
    return;
  }

  for (const attraction of attractions) {
    console.log(`\n📍 ${attraction.name} (${attraction.attraction_code})`);
    console.log('-'.repeat(100));

    try {
      let desc = cleanHtmlEntities(attraction.description);
      
      // Truncate if very long
      if (desc.length > 2000) {
        desc = desc.substring(0, 2000);
        const lastPeriod = desc.lastIndexOf('。');
        if (lastPeriod > 1200) desc = desc.substring(0, lastPeriod + 1);
        console.log(`   ✂️  Truncated to ${desc.length} chars`);
      }

      const generated = await generateContent({ ...attraction, description: desc });
      const wordCount = generated.description_vi.split(/\s+/).length;
      
      console.log(`   ✅ Generated ${wordCount} words`);
      console.log(`   📝 ${generated.name_vi} / ${generated.name_en}`);
      
      await updateSupabase(attraction.attraction_code, generated);
      console.log(`   💾 Database updated`);

      results.success.push({
        code: attraction.attraction_code,
        name: attraction.name,
        wordCount
      });

    } catch (error) {
      console.error(`   ❌ ${error.message}`);
      results.failed.push({
        code: attraction.attraction_code,
        name: attraction.name,
        error: error.message
      });
    }

    await sleep(2000);
  }

  // Save report
  const reportPath = path.join(__dirname, 'final-retry-results.json');
  await fs.writeFile(reportPath, JSON.stringify(results, null, 2), 'utf-8');

  // Create summary document
  const summary = `# Final Processing Results

## Successfully Processed (Total: ${results.processed_successfully_before.length + results.success.length}/11)

### Previously Successful (3 items)
- 106766: 武汉外语外事职业学院
- 114164: 哲蚌寺  
- 114165: 罗布林卡

### Just Processed (${results.success.length} items)
${results.success.map(item => `- ${item.code}: ${item.name} (${item.wordCount} words)`).join('\n')}

### Still Failed (${results.failed.length} items)
${results.failed.map(item => `- ${item.code}: ${item.name} - ${item.error}`).join('\n')}

## Requires Manual Processing (${results.manual_review.length} items)

${results.manual_review.map(item => `### ${item.code}
**Reason:** ${item.reason}
**Action:** Manual content creation or skip
`).join('\n')}

## Statistics

| Status | Count | Percentage |
|--------|-------|------------|
| Total Failed | 11 | 100% |
| Auto-Resolved | ${results.processed_successfully_before.length + results.success.length} | ${((results.processed_successfully_before.length + results.success.length) / 11 * 100).toFixed(1)}% |
| Manual Review | ${results.manual_review.length} | ${(results.manual_review.length / 11 * 100).toFixed(1)}% |

**Overall Success Rate: 99.94%** (17,118 + ${results.processed_successfully_before.length + results.success.length}) / 17,129
`;

  const summaryPath = path.join(__dirname, 'FINAL_PROCESSING_SUMMARY.md');
  await fs.writeFile(summaryPath, summary, 'utf-8');

  console.log('\n\n' + '='.repeat(100));
  console.log('📊 FINAL SUMMARY');
  console.log('='.repeat(100));
  console.log(`\n✅ Successfully processed: ${results.processed_successfully_before.length + results.success.length}/11`);
  console.log(`   - Before this run: 3`);
  console.log(`   - This run: ${results.success.length}`);
  console.log(`\n❌ Still failed: ${results.failed.length}`);
  console.log(`\n⚠️  Manual review required: ${results.manual_review.length}`);
  console.log(`\n📁 Files created:`);
  console.log(`   - ${reportPath}`);
  console.log(`   - ${summaryPath}`);
  
  return results;
}

finalRetry().catch(console.error);

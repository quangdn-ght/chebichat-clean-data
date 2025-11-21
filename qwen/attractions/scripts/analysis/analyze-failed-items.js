import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs/promises';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.join(__dirname, '../../.env') });

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

// List of failed attraction codes from the logs
const failedCodes = [111797, 103360, 113598, 104421, 114164, 106766, 114165, 107111, 114427, 116175, 116655];

async function analyzeFailedAttractions() {
  console.log('🔍 Analyzing failed attractions...\n');
  
  const { data, error } = await supabase
    .from('attractions')
    .select('id, attraction_code, name, description, province_id, region_id, category_id')
    .in('attraction_code', failedCodes)
    .order('attraction_code');

  if (error) {
    console.error('❌ Error fetching data:', error);
    return;
  }

  console.log(`📋 Found ${data.length} failed attractions\n`);
  console.log('='.repeat(100));

  const results = [];
  
  for (const item of data) {
    const analysis = {
      code: item.attraction_code,
      name: item.name,
      description_length: item.description?.length || 0,
      description: item.description,
      issues: []
    };

    // Analyze potential issues
    const desc = item.description || '';
    
    // Check for potentially sensitive content
    const sensitiveKeywords = [
      '惨案', '屠杀', '军队', '开枪', '死', '帝国主义',
      '政治', '战争', '革命', '暴力', '血', '杀',
      '镇压', '运动', '罢工', '示威', '抗议'
    ];
    
    const foundKeywords = sensitiveKeywords.filter(keyword => desc.includes(keyword));
    if (foundKeywords.length > 0) {
      analysis.issues.push(`Sensitive keywords: ${foundKeywords.join(', ')}`);
    }

    // Check for HTML entities
    if (desc.includes('&ldquo;') || desc.includes('&rdquo;') || desc.includes('&') || desc.includes('&#')) {
      analysis.issues.push('Contains HTML entities');
    }

    // Check description length
    if (desc.length > 3000) {
      analysis.issues.push('Very long description (>3000 chars)');
    }

    // Check for special characters
    const specialChars = desc.match(/[^\u4e00-\u9fa5\u3000-\u303f\uff00-\uffef\w\s\.,;:!?()（）、，。；：！？]/g);
    if (specialChars && specialChars.length > 10) {
      analysis.issues.push(`Contains many special characters: ${[...new Set(specialChars)].join('')}`);
    }

    results.push(analysis);

    console.log(`\n${data.indexOf(item) + 1}. Code: ${item.attraction_code}`);
    console.log(`   Name: ${item.name}`);
    console.log(`   Length: ${analysis.description_length} chars`);
    console.log(`   Issues: ${analysis.issues.length > 0 ? analysis.issues.join('; ') : 'None detected'}`);
    console.log(`   Preview: ${desc.substring(0, 150)}...`);
    console.log('-'.repeat(100));
  }

  // Save full report to file
  const report = {
    timestamp: new Date().toISOString(),
    total_failed: data.length,
    items: results
  };

  const reportPath = path.join(__dirname, 'failed-attractions-report.json');
  await fs.writeFile(reportPath, JSON.stringify(report, null, 2), 'utf-8');
  console.log(`\n✅ Full report saved to: ${reportPath}`);

  // Create a CSV for easy review
  const csvLines = ['Code,Name,Length,Issues'];
  for (const item of results) {
    const issues = item.issues.join(' | ').replace(/,/g, ';');
    csvLines.push(`${item.code},"${item.name}",${item.description_length},"${issues}"`);
  }
  
  const csvPath = path.join(__dirname, 'failed-attractions-report.csv');
  await fs.writeFile(csvPath, csvLines.join('\n'), 'utf-8');
  console.log(`✅ CSV report saved to: ${csvPath}`);

  // Summary
  console.log('\n📊 SUMMARY');
  console.log('='.repeat(100));
  console.log(`Total failed items: ${data.length}`);
  
  const withSensitiveContent = results.filter(r => r.issues.some(i => i.includes('Sensitive keywords'))).length;
  const withHtmlEntities = results.filter(r => r.issues.some(i => i.includes('HTML entities'))).length;
  const veryLong = results.filter(r => r.issues.some(i => i.includes('Very long'))).length;
  
  console.log(`Items with sensitive keywords: ${withSensitiveContent}`);
  console.log(`Items with HTML entities: ${withHtmlEntities}`);
  console.log(`Items with very long descriptions: ${veryLong}`);
  
  console.log('\n💡 RECOMMENDATION:');
  console.log('The main issue appears to be:');
  if (withSensitiveContent > 0) {
    console.log('  1. Political/violent content that triggers Qwen content filters');
    console.log('     → These attractions may need manual processing or content sanitization');
  }
  if (withHtmlEntities > 0) {
    console.log('  2. HTML entities in descriptions');
    console.log('     → Clean HTML entities before sending to Qwen API');
  }
}

analyzeFailedAttractions().catch(console.error);

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs/promises';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.join(__dirname, '../../.env') });

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

// Items with HTML entity issues (excluding highly sensitive ones)
const htmlEntityCodes = [104421, 106766, 111797, 113598, 114164, 114165, 114427, 116175, 116655];

/**
 * Clean HTML entities from text
 */
function cleanHtmlEntities(text) {
  if (!text) return text;
  
  const entityMap = {
    '&ldquo;': '"',
    '&rdquo;': '"',
    '&lsquo;': "'",
    '&rsquo;': "'",
    '&quot;': '"',
    '&apos;': "'",
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&nbsp;': ' ',
    '&#8220;': '"',
    '&#8221;': '"',
    '&#8216;': "'",
    '&#8217;': "'",
    '&#39;': "'",
    '&#34;': '"',
  };
  
  let cleaned = text;
  for (const [entity, char] of Object.entries(entityMap)) {
    cleaned = cleaned.split(entity).join(char);
  }
  
  return cleaned;
}

async function fetchAndCleanItems() {
  console.log('🔍 Fetching items with HTML entity issues...\n');
  
  const { data, error } = await supabase
    .from('attractions')
    .select('id, attraction_code, name, description, province_id, region_id, category_id')
    .in('attraction_code', htmlEntityCodes)
    .order('attraction_code');

  if (error) {
    console.error('❌ Error fetching data:', error);
    return;
  }

  console.log(`📋 Found ${data.length} items to clean\n`);
  console.log('='.repeat(100));

  const results = [];
  
  for (const item of data) {
    const originalDesc = item.description || '';
    const cleanedDesc = cleanHtmlEntities(originalDesc);
    const hasChanges = originalDesc !== cleanedDesc;
    
    // Detect what entities were found
    const foundEntities = [];
    if (originalDesc.includes('&ldquo;') || originalDesc.includes('&rdquo;')) foundEntities.push('quotes');
    if (originalDesc.includes('&amp;')) foundEntities.push('ampersand');
    if (originalDesc.includes('&nbsp;')) foundEntities.push('nbsp');
    if (originalDesc.includes('&#')) foundEntities.push('numeric');
    
    const result = {
      code: item.attraction_code,
      name: item.name,
      id: item.id,
      original_length: originalDesc.length,
      cleaned_length: cleanedDesc.length,
      has_changes: hasChanges,
      found_entities: foundEntities,
      original_preview: originalDesc.substring(0, 150),
      cleaned_preview: cleanedDesc.substring(0, 150),
      original_description: originalDesc,
      cleaned_description: cleanedDesc
    };
    
    results.push(result);
    
    console.log(`\n${results.length}. Code: ${item.attraction_code} - ${item.name}`);
    console.log(`   Original length: ${originalDesc.length} → Cleaned: ${cleanedDesc.length}`);
    console.log(`   Changed: ${hasChanges ? '✅ YES' : '❌ NO'}`);
    console.log(`   Entities found: ${foundEntities.join(', ') || 'none'}`);
    console.log(`   Preview: ${cleanedDesc.substring(0, 100)}...`);
    console.log('-'.repeat(100));
  }

  // Save results
  const reportPath = path.join(__dirname, 'html-entity-cleaned-items.json');
  await fs.writeFile(reportPath, JSON.stringify({
    timestamp: new Date().toISOString(),
    total_items: results.length,
    items: results
  }, null, 2), 'utf-8');
  
  console.log(`\n✅ Report saved to: ${reportPath}`);
  
  // Summary
  console.log('\n📊 SUMMARY');
  console.log('='.repeat(100));
  console.log(`Total items fetched: ${results.length}`);
  console.log(`Items with HTML entities: ${results.filter(r => r.has_changes).length}`);
  console.log(`Items already clean: ${results.filter(r => !r.has_changes).length}`);
  
  return results;
}

// Run if executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  fetchAndCleanItems().catch(console.error);
}

export { fetchAndCleanItems, cleanHtmlEntities };

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, '../../.env') });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function queryRegions() {
  try {
    console.log('🔍 Querying regions without name_vi...\n');
    
    // Query regions where name_vi IS NULL
    const { data, error, count } = await supabase
      .from('regions')
      .select('*', { count: 'exact' })
      .is('name_vi', null);
    
    if (error) {
      console.error('❌ Error querying regions:', error);
      return;
    }
    
    console.log(`📊 Found ${count} regions without name_vi\n`);
    
    if (data && data.length > 0) {
      console.log('Sample records:');
      console.log('─'.repeat(80));
      
      // Show first 5 records
      data.slice(0, 5).forEach((region, index) => {
        console.log(`\n${index + 1}. Region ID: ${region.id}`);
        console.log(`   Name (Chinese): ${region.name || 'N/A'}`);
        console.log(`   Name (Vietnamese): ${region.name_vi || 'NULL'}`);
        console.log(`   Name (English): ${region.name_en || 'N/A'}`);
        
        // Check if short_description fields exist
        if ('short_description' in region) {
          console.log(`   Short Desc (ZH): ${region.short_description || 'NULL'}`);
        } else {
          console.log(`   Short Desc (ZH): [FIELD NOT EXISTS]`);
        }
        
        if ('short_description_vi' in region) {
          console.log(`   Short Desc (VI): ${region.short_description_vi || 'NULL'}`);
        } else {
          console.log(`   Short Desc (VI): [FIELD NOT EXISTS]`);
        }
      });
      
      console.log('\n' + '─'.repeat(80));
      
      // Check schema
      console.log('\n📋 Schema check (first record):');
      console.log('Available fields:', Object.keys(data[0]).join(', '));
      
      // Check if short_description fields exist
      const hasShortDesc = 'short_description' in data[0];
      const hasShortDescVi = 'short_description_vi' in data[0];
      
      console.log(`\n✓ Has short_description field: ${hasShortDesc}`);
      console.log(`✓ Has short_description_vi field: ${hasShortDescVi}`);
      
      if (!hasShortDesc || !hasShortDescVi) {
        console.log('\n⚠️  Need to add missing short_description columns!');
      }
    } else {
      console.log('✅ All regions already have name_vi populated!');
    }
    
  } catch (error) {
    console.error('❌ Unexpected error:', error);
  }
}

// Run the query
queryRegions();

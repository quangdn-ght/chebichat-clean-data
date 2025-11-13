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

async function queryProvinces() {
  try {
    console.log('🔍 Querying provinces table...\n');
    
    // Query all provinces
    const { data, error, count } = await supabase
      .from('provinces')
      .select('*', { count: 'exact' })
      .limit(5);
    
    if (error) {
      console.error('❌ Error querying provinces:', error);
      return;
    }
    
    console.log(`📊 Total provinces: ${count}\n`);
    
    if (data && data.length > 0) {
      console.log('Sample records:');
      console.log('─'.repeat(80));
      
      // Show first 5 records
      data.forEach((province, index) => {
        console.log(`\n${index + 1}. Province ID: ${province.id}`);
        console.log(`   Name (Chinese): ${province.name || 'N/A'}`);
        console.log(`   Name (Vietnamese): ${province.name_vi || 'NULL'}`);
        console.log(`   Name (English): ${province.name_en || 'N/A'}`);
        
        // Check if short_description fields exist
        if ('short_description' in province) {
          console.log(`   Short Desc (ZH): ${province.short_description || 'NULL'}`);
        } else {
          console.log(`   Short Desc (ZH): [FIELD NOT EXISTS]`);
        }
        
        if ('short_description_vi' in province) {
          console.log(`   Short Desc (VI): ${province.short_description_vi || 'NULL'}`);
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
      
      // Count provinces needing processing
      const needsProcessing = data.filter(p => 
        !p.short_description || !p.short_description_vi
      ).length;
      
      console.log(`\n📊 Provinces needing processing: ${needsProcessing}/${count}`);
    }
    
  } catch (error) {
    console.error('❌ Unexpected error:', error);
  }
}

// Run the query
queryProvinces();

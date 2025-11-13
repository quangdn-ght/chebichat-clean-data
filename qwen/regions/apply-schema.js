import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs/promises';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, '../../.env') });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function applySchemaChanges() {
  try {
    console.log('📋 Reading SQL file...\n');
    
    const sqlContent = await fs.readFile(
      path.join(__dirname, 'add-short-description-columns.sql'),
      'utf-8'
    );
    
    console.log('🔧 Applying schema changes to regions table...\n');
    console.log('SQL to execute:');
    console.log('─'.repeat(80));
    console.log(sqlContent);
    console.log('─'.repeat(80));
    
    // Execute the SQL
    const { data, error } = await supabase.rpc('exec_sql', { sql: sqlContent });
    
    if (error) {
      console.error('\n❌ Error applying schema changes:', error);
      console.log('\n⚠️  Please run the SQL manually in Supabase SQL Editor:');
      console.log('   Dashboard > SQL Editor > New Query');
      return;
    }
    
    console.log('\n✅ Schema changes applied successfully!');
    
    // Verify changes
    console.log('\n🔍 Verifying schema...\n');
    const { data: regions, error: verifyError } = await supabase
      .from('regions')
      .select('*')
      .limit(1);
    
    if (verifyError) {
      console.error('❌ Error verifying:', verifyError);
      return;
    }
    
    if (regions && regions.length > 0) {
      const fields = Object.keys(regions[0]);
      console.log('Available fields:', fields.join(', '));
      console.log('\n✓ Has short_description:', fields.includes('short_description'));
      console.log('✓ Has short_description_vi:', fields.includes('short_description_vi'));
    }
    
  } catch (error) {
    console.error('❌ Unexpected error:', error);
  }
}

applySchemaChanges();

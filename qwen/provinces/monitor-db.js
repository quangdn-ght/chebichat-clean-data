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

/**
 * Monitor database progress
 */
async function monitorDatabase() {
  console.log('🔍 Monitoring provinces database...\n');
  
  try {
    // Total provinces
    const { count: totalCount } = await supabase
      .from('provinces')
      .select('*', { count: 'exact', head: true });
    
    // Provinces without name_vi
    const { count: missingNameVi } = await supabase
      .from('provinces')
      .select('*', { count: 'exact', head: true })
      .is('name_vi', null);
    
    // Provinces with name_vi
    const withNameVi = totalCount - missingNameVi;
    
    // Provinces with short_description
    const { count: withShortDesc } = await supabase
      .from('provinces')
      .select('*', { count: 'exact', head: true })
      .not('short_description', 'is', null);
    
    // Provinces with short_description_vi
    const { count: withShortDescVi } = await supabase
      .from('provinces')
      .select('*', { count: 'exact', head: true })
      .not('short_description_vi', 'is', null);
    
    // Calculate progress
    const nameViProgress = totalCount > 0 ? ((withNameVi / totalCount) * 100).toFixed(1) : 0;
    const shortDescProgress = totalCount > 0 ? ((withShortDesc / totalCount) * 100).toFixed(1) : 0;
    const shortDescViProgress = totalCount > 0 ? ((withShortDescVi / totalCount) * 100).toFixed(1) : 0;
    
    // Display results
    console.log('='.repeat(80));
    console.log('📊 PROVINCES DATABASE STATUS');
    console.log('='.repeat(80));
    console.log(`Total Provinces: ${totalCount}`);
    console.log('');
    console.log(`Name (Vietnamese):`);
    console.log(`  ✅ Completed: ${withNameVi} (${nameViProgress}%)`);
    console.log(`  ⏳ Pending:   ${missingNameVi}`);
    console.log('');
    console.log(`Short Description (Chinese):`);
    console.log(`  ✅ Completed: ${withShortDesc || 0} (${shortDescProgress}%)`);
    console.log(`  ⏳ Pending:   ${totalCount - (withShortDesc || 0)}`);
    console.log('');
    console.log(`Short Description (Vietnamese):`);
    console.log(`  ✅ Completed: ${withShortDescVi || 0} (${shortDescViProgress}%)`);
    console.log(`  ⏳ Pending:   ${totalCount - (withShortDescVi || 0)}`);
    console.log('='.repeat(80));
    
    // Show recent updates
    const { data: recentUpdates } = await supabase
      .from('provinces')
      .select('id, name, name_vi, updated_at')
      .not('name_vi', 'is', null)
      .order('updated_at', { ascending: false })
      .limit(5);
    
    if (recentUpdates && recentUpdates.length > 0) {
      console.log('\n📝 Recent Updates:');
      console.log('-'.repeat(80));
      recentUpdates.forEach((province, index) => {
        const updateTime = new Date(province.updated_at).toLocaleString();
        console.log(`${index + 1}. [${province.id}] ${province.name} → ${province.name_vi}`);
        console.log(`   Updated: ${updateTime}`);
      });
      console.log('-'.repeat(80));
    }
    
  } catch (error) {
    console.error('❌ Error monitoring database:', error);
  }
}

// Auto-refresh mode
const args = process.argv.slice(2);
const watchMode = args.includes('--watch');
const interval = parseInt(args.find(arg => arg.startsWith('--interval='))?.split('=')[1] || '5');

if (watchMode) {
  console.log(`🔄 Watch mode enabled (refreshing every ${interval} seconds)\n`);
  console.log('Press Ctrl+C to stop\n');
  
  // Initial run
  monitorDatabase();
  
  // Periodic refresh
  setInterval(() => {
    console.clear();
    monitorDatabase();
  }, interval * 1000);
} else {
  monitorDatabase();
}

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import { processProvince } from './province-generator.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, '../../.env') });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Worker configuration from environment
const WORKER_ID = parseInt(process.env.NODE_APP_INSTANCE !== undefined 
  ? process.env.NODE_APP_INSTANCE 
  : (process.env.pm_id || process.pid));
const TOTAL_WORKERS = parseInt(process.env.TOTAL_WORKERS || '4');
const BATCH_SIZE = parseInt(process.env.BATCH_SIZE || '50');
const UPDATE_DB = process.env.UPDATE_DB === 'true';

console.log(`🚀 Worker ${WORKER_ID} started`);
console.log(`   Total workers: ${TOTAL_WORKERS}`);
console.log(`   Batch size: ${BATCH_SIZE}`);
console.log(`   Update DB: ${UPDATE_DB}`);

/**
 * Get work assignments for this worker
 */
async function getWorkAssignment() {
  // Get total count of provinces missing any field (name_vi, short_description, or short_description_vi)
  const { count, error: countError } = await supabase
    .from('provinces')
    .select('*', { count: 'exact', head: true })
    .or('name_vi.is.null,short_description.is.null,short_description_vi.is.null')
    .not('name', 'is', null);

  if (countError) {
    throw new Error(`Failed to count provinces: ${countError.message}`);
  }

  console.log(`📊 Worker ${WORKER_ID}: Found ${count} unprocessed provinces`);

  // Calculate this worker's range
  const itemsPerWorker = Math.ceil(count / TOTAL_WORKERS);
  const startIndex = WORKER_ID * itemsPerWorker;
  const endIndex = Math.min(startIndex + itemsPerWorker - 1, count - 1);

  console.log(`📋 Worker ${WORKER_ID}: Assigned range ${startIndex} to ${endIndex} (${endIndex - startIndex + 1} items)`);

  return { startIndex, endIndex, total: count };
}

/**
 * Fetch provinces for this worker
 */
async function fetchWorkerProvinces(startIndex, endIndex) {
  const limit = endIndex - startIndex + 1;
  
  const { data, error } = await supabase
    .from('provinces')
    .select('id, province_code, name, name_vi, name_en')
    .or('name_vi.is.null,short_description.is.null,short_description_vi.is.null')
    .not('name', 'is', null)
    .order('province_code', { ascending: true })
    .range(startIndex, endIndex);

  if (error) {
    throw new Error(`Failed to fetch provinces: ${error.message}`);
  }

  console.log(`✅ Worker ${WORKER_ID}: Fetched ${data.length} provinces`);
  return data;
}

/**
 * Process provinces in batches
 */
async function processBatch(provinces) {
  const results = [];
  let successCount = 0;
  let failedCount = 0;

  for (let i = 0; i < provinces.length; i++) {
    const province = provinces[i];
    
    try {
      console.log(`\n[Worker ${WORKER_ID}] [${i + 1}/${provinces.length}] Processing "${province.name}"...`);
      
      const result = await processProvince(province, UPDATE_DB);
      results.push(result);
      
      if (result.status === 'success') {
        successCount++;
      } else {
        failedCount++;
      }
      
      // Rate limiting: wait 1 second between requests
      if (i < provinces.length - 1) {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
      
    } catch (error) {
      console.error(`❌ Worker ${WORKER_ID}: Error processing province ${province.id}:`, error);
      failedCount++;
      results.push({
        id: province.id,
        province_code: province.province_code,
        original_name: province.name,
        error: error.message,
        status: 'failed'
      });
    }
  }

  return { results, successCount, failedCount };
}

/**
 * Save worker results
 */
async function saveWorkerResults(results, successCount, failedCount) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `worker-${WORKER_ID}-results-${timestamp}.json`;
  const outputDir = path.join(__dirname, 'output', 'workers');
  
  await import('fs/promises').then(fs => fs.mkdir(outputDir, { recursive: true }));
  
  const filepath = path.join(outputDir, filename);
  await import('fs/promises').then(fs => 
    fs.writeFile(filepath, JSON.stringify({
      worker_id: WORKER_ID,
      timestamp: new Date().toISOString(),
      total_processed: results.length,
      success: successCount,
      failed: failedCount,
      results
    }, null, 2))
  );
  
  console.log(`\n💾 Worker ${WORKER_ID}: Results saved to ${filename}`);
}

/**
 * Main worker function
 */
async function runWorker() {
  try {
    // Get work assignment
    const { startIndex, endIndex, total } = await getWorkAssignment();
    
    if (startIndex >= total) {
      console.log(`✅ Worker ${WORKER_ID}: No work to do`);
      return;
    }
    
    // Fetch provinces for this worker
    const provinces = await fetchWorkerProvinces(startIndex, endIndex);
    
    if (provinces.length === 0) {
      console.log(`✅ Worker ${WORKER_ID}: No provinces to process`);
      return;
    }
    
    console.log(`\n🔄 Worker ${WORKER_ID}: Starting to process ${provinces.length} provinces\n`);
    
    // Process provinces
    const { results, successCount, failedCount } = await processBatch(provinces);
    
    // Save results
    await saveWorkerResults(results, successCount, failedCount);
    
    // Print summary
    console.log('\n' + '='.repeat(80));
    console.log(`📊 WORKER ${WORKER_ID} SUMMARY`);
    console.log('='.repeat(80));
    console.log(`Total Processed: ${results.length}`);
    console.log(`✅ Success: ${successCount}`);
    console.log(`❌ Failed: ${failedCount}`);
    console.log('='.repeat(80) + '\n');
    
    console.log(`✅ Worker ${WORKER_ID}: Completed successfully`);
    
  } catch (error) {
    console.error(`❌ Worker ${WORKER_ID}: Fatal error:`, error);
    process.exit(1);
  }
}

// Run the worker
runWorker();

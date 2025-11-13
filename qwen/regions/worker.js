import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import { processRegion } from './region-generator.js';

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
  // Get total count of regions missing any field (name_vi, short_description, or short_description_vi)
  const { count, error: countError } = await supabase
    .from('regions')
    .select('*', { count: 'exact', head: true })
    .or('name_vi.is.null,short_description.is.null,short_description_vi.is.null')
    .not('name', 'is', null);

  if (countError) {
    throw new Error(`Failed to count regions: ${countError.message}`);
  }

  console.log(`📊 Worker ${WORKER_ID}: Found ${count} unprocessed regions`);

  // Calculate this worker's range
  const itemsPerWorker = Math.ceil(count / TOTAL_WORKERS);
  const startIndex = WORKER_ID * itemsPerWorker;
  const endIndex = Math.min(startIndex + itemsPerWorker - 1, count - 1);

  console.log(`📋 Worker ${WORKER_ID}: Assigned range ${startIndex} to ${endIndex} (${endIndex - startIndex + 1} items)`);

  return { startIndex, endIndex, total: count };
}

/**
 * Fetch regions for this worker
 */
async function fetchWorkerRegions(startIndex, endIndex) {
  const limit = endIndex - startIndex + 1;
  
  const { data, error } = await supabase
    .from('regions')
    .select('id, region_code, name, name_vi, name_en, province_id')
    .or('name_vi.is.null,short_description.is.null,short_description_vi.is.null')
    .not('name', 'is', null)
    .order('region_code', { ascending: true })
    .range(startIndex, endIndex);

  if (error) {
    throw new Error(`Failed to fetch regions: ${error.message}`);
  }

  console.log(`✅ Worker ${WORKER_ID}: Fetched ${data.length} regions`);
  return data;
}

/**
 * Process regions in batches
 */
async function processBatch(regions) {
  const results = [];
  let successCount = 0;
  let failedCount = 0;

  for (let i = 0; i < regions.length; i++) {
    const region = regions[i];
    
    try {
      console.log(`\n[Worker ${WORKER_ID}] [${i + 1}/${regions.length}] Processing "${region.name}"...`);
      
      const result = await processRegion(region, UPDATE_DB);
      results.push(result);
      
      if (result.status === 'success') {
        successCount++;
      } else {
        failedCount++;
      }
      
      // Rate limiting: wait 1 second between requests
      if (i < regions.length - 1) {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
      
    } catch (error) {
      console.error(`❌ Worker ${WORKER_ID}: Error processing region ${region.id}:`, error);
      failedCount++;
      results.push({
        id: region.id,
        region_code: region.region_code,
        original_name: region.name,
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
    
    // Fetch regions for this worker
    const regions = await fetchWorkerRegions(startIndex, endIndex);
    
    if (regions.length === 0) {
      console.log(`✅ Worker ${WORKER_ID}: No regions to process`);
      return;
    }
    
    console.log(`\n🔄 Worker ${WORKER_ID}: Starting to process ${regions.length} regions\n`);
    
    // Process regions
    const { results, successCount, failedCount } = await processBatch(regions);
    
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

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
 * Worker process for parallel processing
 */
import { processAttraction } from './supabase-attraction-processor.js';

// Use NODE_APP_INSTANCE for cluster mode (0-based index)
// Fallback to pm_id or process.pid for other modes
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
  // Get total count
  const { count, error: countError } = await supabase
    .from('attractions')
    .select('*', { count: 'exact', head: true })
    .not('description', 'is', null)
    .is('description_vi', null); // Only unprocessed items

  if (countError) {
    throw new Error(`Failed to count attractions: ${countError.message}`);
  }

  console.log(`📊 Worker ${WORKER_ID}: Found ${count} unprocessed attractions`);

  // Calculate this worker's range
  const itemsPerWorker = Math.ceil(count / TOTAL_WORKERS);
  const workerId = parseInt(WORKER_ID);
  const startIndex = workerId * itemsPerWorker;
  const endIndex = Math.min(startIndex + itemsPerWorker, count);

  console.log(`📌 Worker ${WORKER_ID}: Processing items ${startIndex}-${endIndex}`);

  return { startIndex, endIndex, total: count };
}

/**
 * Process assigned work
 */
async function processWork() {
  try {
    const { startIndex, endIndex, total } = await getWorkAssignment();

    if (startIndex >= total) {
      console.log(`✅ Worker ${WORKER_ID}: No work assigned`);
      process.exit(0);
    }

    // Fetch this worker's batch
    const { data: attractions, error } = await supabase
      .from('attractions')
      .select('id, attraction_code, name, description, province_id, region_id, category_id')
      .not('description', 'is', null)
      .is('description_vi', null)
      .order('attraction_code', { ascending: true })
      .range(startIndex, endIndex - 1);

    if (error) {
      throw new Error(`Failed to fetch attractions: ${error.message}`);
    }

    console.log(`📦 Worker ${WORKER_ID}: Processing ${attractions.length} attractions`);

    const results = {
      workerId: WORKER_ID,
      total: attractions.length,
      processed: 0,
      successful: 0,
      failed: 0,
      items: []
    };

    // Process each attraction
    for (let i = 0; i < attractions.length; i++) {
      const attraction = attractions[i];
      
      console.log(`\n[Worker ${WORKER_ID}] Progress: ${i + 1}/${attractions.length} - ${attraction.name}`);
      
      try {
        const result = await processAttraction(attraction, UPDATE_DB);
        results.items.push(result);
        results.processed++;
        
        if (result.success) {
          results.successful++;
          console.log(`✅ [Worker ${WORKER_ID}] Success: ${attraction.name}`);
        } else {
          results.failed++;
          console.log(`❌ [Worker ${WORKER_ID}] Failed: ${attraction.name}`);
        }

        // Save progress periodically
        if ((i + 1) % 10 === 0) {
          await saveProgress(results);
        }

      } catch (error) {
        console.error(`❌ [Worker ${WORKER_ID}] Error processing ${attraction.name}:`, error.message);
        results.items.push({
          success: false,
          attraction_code: attraction.attraction_code,
          original: { id: attraction.id, name: attraction.name },
          error: error.message
        });
        results.processed++;
        results.failed++;
      }

      // Small delay to avoid rate limiting
      await sleep(1000);
    }

    // Save final results
    await saveProgress(results);

    console.log(`\n${'='.repeat(60)}`);
    console.log(`✅ Worker ${WORKER_ID} COMPLETE`);
    console.log(`${'='.repeat(60)}`);
    console.log(`Total: ${results.total}`);
    console.log(`Successful: ${results.successful}`);
    console.log(`Failed: ${results.failed}`);
    console.log(`Success rate: ${((results.successful / results.total) * 100).toFixed(1)}%`);
    console.log(`${'='.repeat(60)}`);

    process.exit(0);

  } catch (error) {
    console.error(`❌ Worker ${WORKER_ID} fatal error:`, error.message);
    process.exit(1);
  }
}

/**
 * Save worker progress
 */
async function saveProgress(results) {
  const fs = await import('fs/promises');
  const outputPath = path.join(__dirname, 'output', `worker-${WORKER_ID}-results.json`);
  await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf-8');
  console.log(`💾 [Worker ${WORKER_ID}] Progress saved: ${results.successful}/${results.total}`);
}

/**
 * Sleep utility
 */
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Handle graceful shutdown
process.on('SIGINT', async () => {
  console.log(`\n⚠️  Worker ${WORKER_ID} received SIGINT, shutting down gracefully...`);
  process.exit(0);
});

process.on('SIGTERM', async () => {
  console.log(`\n⚠️  Worker ${WORKER_ID} received SIGTERM, shutting down gracefully...`);
  process.exit(0);
});

// Start processing
console.log(`\n${'='.repeat(60)}`);
console.log(`🚀 Starting Worker ${WORKER_ID}`);
console.log(`${'='.repeat(60)}\n`);

processWork();

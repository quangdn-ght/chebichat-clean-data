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

let lastProcessed = 0;
let lastTimestamp = Date.now();

/**
 * Get processing statistics from Supabase
 */
async function getStats() {
  try {
    // Total attractions with descriptions
    const { count: total, error: totalError } = await supabase
      .from('attractions')
      .select('*', { count: 'exact', head: true })
      .not('description', 'is', null);

    if (totalError) throw totalError;

    // Processed attractions (have description_vi)
    const { count: processed, error: processedError } = await supabase
      .from('attractions')
      .select('*', { count: 'exact', head: true })
      .not('description_vi', 'is', null);

    if (processedError) throw processedError;

    // Remaining
    const remaining = total - processed;
    const percentage = ((processed / total) * 100).toFixed(2);

    // Calculate processing rate
    const now = Date.now();
    const timeDiff = (now - lastTimestamp) / 1000; // seconds
    const itemsDiff = processed - lastProcessed;
    const rate = timeDiff > 0 ? (itemsDiff / timeDiff * 3600).toFixed(1) : 0; // items per hour

    lastProcessed = processed;
    lastTimestamp = now;

    // Estimate time remaining
    let eta = 'calculating...';
    if (itemsDiff > 0 && remaining > 0) {
      const secondsRemaining = (remaining / itemsDiff) * timeDiff;
      const hours = Math.floor(secondsRemaining / 3600);
      const minutes = Math.floor((secondsRemaining % 3600) / 60);
      eta = hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`;
    }

    return {
      total,
      processed,
      remaining,
      percentage,
      rate,
      eta
    };
  } catch (error) {
    console.error('Error fetching stats:', error.message);
    return null;
  }
}

/**
 * Clear console and move cursor to top
 */
function clearScreen() {
  process.stdout.write('\x1Bc');
}

/**
 * Display progress bar
 */
function progressBar(percentage, width = 50) {
  const filled = Math.round((percentage / 100) * width);
  const empty = width - filled;
  const bar = '█'.repeat(filled) + '░'.repeat(empty);
  return bar;
}

/**
 * Format number with thousands separator
 */
function formatNumber(num) {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

/**
 * Display real-time monitoring dashboard
 */
async function displayDashboard() {
  const stats = await getStats();
  
  if (!stats) {
    console.log('❌ Unable to fetch statistics');
    return;
  }

  clearScreen();
  
  const { total, processed, remaining, percentage, rate, eta } = stats;
  
  console.log('╔════════════════════════════════════════════════════════════════╗');
  console.log('║        ATTRACTION PROCESSING - REAL-TIME MONITOR              ║');
  console.log('╚════════════════════════════════════════════════════════════════╝');
  console.log('');
  console.log(`📊 Progress: ${percentage}%`);
  console.log('');
  console.log(`[${progressBar(parseFloat(percentage))}] ${percentage}%`);
  console.log('');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('');
  console.log(`📈 Statistics:`);
  console.log(`   Total:      ${formatNumber(total)} attractions`);
  console.log(`   Processed:  ${formatNumber(processed)} ✅`);
  console.log(`   Remaining:  ${formatNumber(remaining)} ⏳`);
  console.log('');
  console.log(`⚡ Performance:`);
  console.log(`   Rate:       ${rate} items/hour`);
  console.log(`   ETA:        ${eta}`);
  console.log('');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('');
  console.log(`🕐 Last update: ${new Date().toLocaleTimeString()}`);
  console.log('');
  console.log('Press Ctrl+C to exit');
  console.log('');
}

/**
 * Start monitoring
 */
async function startMonitoring() {
  console.log('🚀 Starting real-time monitoring...\n');
  console.log('Connecting to Supabase...');
  
  // Initial fetch to set baseline
  await getStats();
  
  // Display dashboard immediately
  await displayDashboard();
  
  // Update every 5 seconds
  setInterval(async () => {
    await displayDashboard();
  }, 5000);
}

// Handle graceful shutdown
process.on('SIGINT', () => {
  console.log('\n\n👋 Monitoring stopped');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n\n👋 Monitoring stopped');
  process.exit(0);
});

// Start monitoring
startMonitoring().catch(error => {
  console.error('❌ Fatal error:', error.message);
  process.exit(1);
});

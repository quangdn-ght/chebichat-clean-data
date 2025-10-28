// Node.js script to apply the user creation fix using Supabase client
require('dotenv').config();
const fs = require('fs');
const path = require('path');

// Check for required dependencies
try {
  require('@supabase/supabase-js');
} catch (e) {
  console.error('Error: @supabase/supabase-js is not installed');
  console.log('Please run: npm install @supabase/supabase-js');
  process.exit(1);
}

const { createClient } = require('@supabase/supabase-js');

// Validate environment variables
if (!process.env.SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
  console.error('Error: Missing required environment variables');
  console.error('Please ensure SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are set in .env');
  process.exit(1);
}

// Create Supabase client with service role key (has admin privileges)
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);

async function applyFix() {
  console.log('==========================================');
  console.log('Supabase User Creation Fix - Deployment');
  console.log('==========================================');
  console.log('');

  try {
    // Read the SQL file
    const sqlFilePath = path.join(__dirname, 'fix-user-creation.sql');
    const sqlContent = fs.readFileSync(sqlFilePath, 'utf8');
    
    console.log('✓ Loaded SQL file: fix-user-creation.sql');
    console.log('');

    // Split SQL into individual statements
    // Note: This is a simple split and may not work for all SQL
    const statements = sqlContent
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0 && !s.startsWith('--'));

    console.log(`Found ${statements.length} SQL statements to execute`);
    console.log('');
    console.log('Executing SQL statements...');
    console.log('');

    let successCount = 0;
    let errorCount = 0;

    // Execute each statement
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i] + ';';
      
      // Skip comments
      if (statement.trim().startsWith('--')) {
        continue;
      }

      // Get a short description of the statement
      let description = statement.substring(0, 60).replace(/\n/g, ' ');
      if (description.length < statement.length) {
        description += '...';
      }

      process.stdout.write(`[${i + 1}/${statements.length}] Executing: ${description} `);

      try {
        const { data, error } = await supabase.rpc('exec_sql', { sql: statement });
        
        if (error) {
          // Try direct execution via Supabase admin API
          throw error;
        }
        
        console.log('✓');
        successCount++;
      } catch (error) {
        console.log('✗');
        console.error(`   Error: ${error.message}`);
        errorCount++;
        
        // Continue with other statements
      }
    }

    console.log('');
    console.log('==========================================');
    console.log('Execution Summary');
    console.log('==========================================');
    console.log(`Total statements: ${statements.length}`);
    console.log(`Successful: ${successCount}`);
    console.log(`Failed: ${errorCount}`);
    console.log('');

    if (errorCount > 0) {
      console.log('⚠ Some statements failed to execute.');
      console.log('This is expected if they already exist (e.g., triggers, policies).');
      console.log('');
      console.log('Please verify the fix manually:');
      console.log('1. Go to Supabase SQL Editor: https://app.supabase.com/project/' + 
                  process.env.SUPABASE_URL.match(/https:\/\/(.*?)\.supabase/)[1] + '/sql/new');
      console.log('2. Copy the contents of database/fix-user-creation.sql');
      console.log('3. Run it in the SQL Editor');
      console.log('');
    } else {
      console.log('✓ All statements executed successfully!');
      console.log('');
    }

    // Run verification queries
    console.log('Running verification queries...');
    console.log('');

    await runVerification();

  } catch (error) {
    console.error('');
    console.error('==========================================');
    console.error('✗ Error applying fix');
    console.error('==========================================');
    console.error('');
    console.error('Error details:', error.message);
    console.error('');
    console.error('Please apply the fix manually:');
    console.error('1. Go to Supabase SQL Editor');
    console.error('2. Copy the contents of database/fix-user-creation.sql');
    console.error('3. Run it in the SQL Editor');
    console.error('');
    process.exit(1);
  }
}

async function runVerification() {
  console.log('1. Checking for trigger...');
  
  const { data: triggers, error: triggerError } = await supabase
    .rpc('exec_sql', { 
      sql: `SELECT trigger_name FROM information_schema.triggers 
            WHERE trigger_name = 'on_auth_user_created'` 
    });

  if (!triggerError && triggers) {
    console.log('   ✓ Trigger exists');
  } else {
    console.log('   ⚠ Could not verify trigger - check manually');
  }

  console.log('');
  console.log('2. Checking for free plan...');
  
  const { data: plans, error: planError } = await supabase
    .from('subscription_plans')
    .select('*')
    .eq('type', 'free')
    .single();

  if (!planError && plans) {
    console.log('   ✓ Free plan exists:', plans.name);
  } else {
    console.log('   ⚠ Could not verify free plan - check manually');
  }

  console.log('');
  console.log('3. Checking users have subscriptions...');
  
  const { count: totalUsers } = await supabase
    .from('auth.users')
    .select('*', { count: 'exact', head: true });

  const { count: usersWithSubs } = await supabase
    .from('user_subscriptions')
    .select('*', { count: 'exact', head: true });

  console.log(`   Total users: ${totalUsers || 'unknown'}`);
  console.log(`   Users with subscriptions: ${usersWithSubs || 'unknown'}`);

  console.log('');
  console.log('==========================================');
  console.log('Next Steps:');
  console.log('==========================================');
  console.log('1. Test user creation through your application');
  console.log('2. Monitor Supabase logs for any errors');
  console.log('3. Review FIX_USER_CREATION_GUIDE.md for more details');
  console.log('');
}

// Run the fix
applyFix().catch(console.error);

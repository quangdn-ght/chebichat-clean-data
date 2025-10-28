# Fix User Creation Error - Implementation Guide

## Problem Description
The error occurs when Supabase tries to create a new user:
```
ERROR: column "plan_type" does not exist (SQLSTATE 42703)
500: Database error creating new user
```

This happens because the system is trying to insert a `plan_type` column into the `auth.users` table, but this column doesn't exist there. The `plan_type` should be managed in the `user_subscriptions` table instead.

## Root Cause
- The `auth.users` table (Supabase's authentication table) doesn't have a `plan_type` column
- The application expects user plan information during user creation
- The `plan_type` should be stored in the `user_subscriptions` table

## Solution Overview
The fix implements an automatic trigger system that:
1. Creates a user profile when a new user signs up
2. Automatically assigns a free subscription plan to new users
3. Ensures all existing users have profiles and subscriptions
4. Implements proper Row Level Security (RLS) policies

## Implementation Steps

### Step 1: Access Supabase SQL Editor
1. Go to your Supabase dashboard: https://app.supabase.com
2. Select your project: `zzgkylsbdgwoohcbompi`
3. Navigate to **SQL Editor** in the left sidebar
4. Click **New Query**

### Step 2: Run the Fix Script
1. Copy the entire contents of `fix-user-creation.sql`
2. Paste it into the SQL Editor
3. Click **Run** or press `Ctrl+Enter`
4. Wait for all statements to execute successfully

### Step 3: Verify the Fix

#### 3.1 Check that the trigger was created:
```sql
SELECT 
  trigger_name, 
  event_manipulation, 
  event_object_table,
  action_statement
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';
```

#### 3.2 Check that the free plan exists:
```sql
SELECT * FROM public.subscription_plans WHERE type = 'free';
```

#### 3.3 Check existing users have subscriptions:
```sql
SELECT 
  u.email,
  u.created_at,
  us.plan_type,
  us.status
FROM auth.users u
LEFT JOIN public.user_subscriptions us ON u.id = us.user_id
ORDER BY u.created_at DESC
LIMIT 10;
```

#### 3.4 Check existing users have profiles:
```sql
SELECT 
  u.email,
  p.display_name,
  p.created_at
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.user_id
ORDER BY u.created_at DESC
LIMIT 10;
```

### Step 4: Test User Creation

#### Option A: Test via Supabase Dashboard
1. Go to **Authentication** > **Users**
2. Click **Add User**
3. Enter test email and password
4. Click **Create User**
5. Verify no errors occur
6. Check that the user has a profile and subscription:
```sql
SELECT 
  u.email,
  p.display_name,
  us.plan_type,
  us.status
FROM auth.users u
JOIN public.profiles p ON u.id = p.user_id
JOIN public.user_subscriptions us ON u.id = us.user_id
WHERE u.email = 'your-test-email@example.com';
```

#### Option B: Test via API
Create a test script to sign up a new user:

```javascript
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://zzgkylsbdgwoohcbompi.supabase.co';
const supabaseKey = 'YOUR_ANON_KEY_HERE';
const supabase = createClient(supabaseUrl, supabaseKey);

async function testUserCreation() {
  const { data, error } = await supabase.auth.signUp({
    email: 'test@example.com',
    password: 'SecurePassword123!',
    options: {
      data: {
        full_name: 'Test User'
      }
    }
  });

  if (error) {
    console.error('Error:', error);
  } else {
    console.log('User created successfully:', data);
  }
}

testUserCreation();
```

### Step 5: Monitor Logs
After implementation, monitor Supabase logs for any errors:
1. Go to **Logs** > **Postgres Logs** in Supabase dashboard
2. Look for any errors related to user creation
3. Verify that no "plan_type does not exist" errors appear

## What the Fix Does

### 1. Creates Automatic Trigger
- **Function**: `handle_new_user()`
- **Trigger**: `on_auth_user_created`
- Automatically runs after a new user is inserted into `auth.users`
- Creates a profile entry in `public.profiles`
- Creates a subscription entry in `public.user_subscriptions` with a free plan

### 2. Ensures Free Plan Exists
- Creates or updates a "Free Plan" in `subscription_plans`
- Sets appropriate default values (0 cost, unlimited lifetime)

### 3. Backfills Existing Data
- Adds subscriptions for any existing users without one
- Adds profiles for any existing users without one

### 4. Implements Security
- Enables Row Level Security (RLS) on relevant tables
- Creates policies so users can only view/update their own data
- Grants appropriate permissions to different roles

### 5. Helper Functions
- `get_user_plan_type(user_id)`: Returns the current active plan for a user

## Rollback Instructions
If you need to rollback this change:

```sql
-- Remove the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Remove the function
DROP FUNCTION IF EXISTS public.handle_new_user();

-- Remove the helper function
DROP FUNCTION IF EXISTS public.get_user_plan_type(UUID);

-- Note: This won't remove the data that was created (profiles, subscriptions)
-- Those should remain as they don't cause issues
```

## Common Issues and Solutions

### Issue 1: "Permission denied for schema public"
**Solution**: Run the grant statements again:
```sql
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, service_role;
```

### Issue 2: "Function already exists"
**Solution**: The script uses `CREATE OR REPLACE` so this shouldn't happen. If it does:
```sql
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
-- Then run the fix script again
```

### Issue 3: Users still getting errors
**Solution**: Check the Postgres logs for the specific error and verify:
1. The trigger exists and is enabled
2. The free plan exists in subscription_plans
3. The user has proper permissions

## Additional Recommendations

### 1. Update Application Code
Ensure your application code retrieves the user's plan from `user_subscriptions`:

```javascript
async function getUserPlan(userId) {
  const { data, error } = await supabase
    .from('user_subscriptions')
    .select('plan_type, status, current_period_end')
    .eq('user_id', userId)
    .eq('status', 'active')
    .single();
  
  return data?.plan_type || 'free';
}
```

### 2. Add More Plan Types
You can add additional plans by inserting into `subscription_plans`:

```sql
INSERT INTO public.subscription_plans (name, type, price_usd, price_vnd, billing_cycle, is_active, features)
VALUES (
  'Premium Monthly',
  'premium_monthly',
  9.99,
  249000,
  'monthly',
  true,
  jsonb_build_object(
    'dictionary_lookups', 'unlimited',
    'ai_tutor', true,
    'bookmark_limit', 'unlimited',
    'advanced_features', true
  )
);
```

### 3. Monitor User Creation
Set up monitoring to track user creation success rate:

```sql
-- Query to check recent user creation with subscription status
SELECT 
  DATE(u.created_at) as signup_date,
  COUNT(u.id) as total_signups,
  COUNT(us.id) as with_subscription,
  COUNT(p.user_id) as with_profile
FROM auth.users u
LEFT JOIN public.user_subscriptions us ON u.id = us.user_id
LEFT JOIN public.profiles p ON u.id = p.user_id
WHERE u.created_at >= NOW() - INTERVAL '7 days'
GROUP BY DATE(u.created_at)
ORDER BY signup_date DESC;
```

## Support
If you continue to experience issues after applying this fix:
1. Check Supabase Postgres logs for detailed error messages
2. Verify all steps were completed successfully
3. Ensure no custom code is interfering with the user creation process
4. Check that the service role key has proper permissions

## Related Files
- `database/database-schema.sql` - Full database schema
- `database/fix-user-creation.sql` - This fix script
- `.env` - Contains Supabase credentials (keep secure!)

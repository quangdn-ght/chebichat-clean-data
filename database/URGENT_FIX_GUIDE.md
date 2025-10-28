# URGENT: Plan Type Error Still Occurring - Investigation Guide

## Current Error
```
ERROR: column "plan_type" does not exist (SQLSTATE 42703)
Path: /admin/users (Supabase Admin API)
Method: POST
```

## Why the Error Persists

The error is happening at the **Supabase Admin API level** (`/admin/users`), which means:

1. **NOT a database trigger issue** (that would show different error path)
2. **Possibly a Database Webhook** calling a function
3. **Possibly an Edge Function** being triggered
4. **Possibly custom Auth configuration** in Supabase dashboard
5. **Transaction issue** - something is trying to reference plan_type before the trigger creates the subscription

## Immediate Actions Required

### Action 1: Check for Database Webhooks

1. Go to Supabase Dashboard
2. Navigate to: **Database** → **Webhooks**
3. Look for any webhooks on `auth.users` table
4. **Disable or delete** any webhooks that might be inserting plan_type
5. Screenshot or note what you find

### Action 2: Check for Edge Functions

1. Go to Supabase Dashboard
2. Navigate to: **Edge Functions**
3. Look for functions with names like:
   - `on-user-created`
   - `handle-new-user`
   - `auth-hook`
   - Any function related to user creation
4. Check the code for references to `plan_type`
5. **Disable** any suspicious functions temporarily

### Action 3: Check Auth Hooks Configuration

1. Go to Supabase Dashboard
2. Navigate to: **Authentication** → **Hooks** (or **Auth Hooks**)
3. Look for any configured hooks:
   - Custom Access Token Hook
   - Send SMS Hook
   - Send Email Hook
   - **Password Verification Hook**
4. Check if any are enabled and might be causing issues

### Action 4: Run Diagnostic SQL

Copy and run this in SQL Editor:

```sql
-- Find ALL triggers on auth.users
SELECT 
    t.trigger_name,
    t.event_manipulation,
    t.action_timing,
    t.action_statement,
    p.proname as function_name
FROM information_schema.triggers t
LEFT JOIN pg_proc p ON t.action_statement ILIKE '%' || p.proname || '%'
WHERE t.event_object_table = 'users'
    AND t.event_object_schema = 'auth';

-- Find all functions that reference plan_type
SELECT 
    n.nspname || '.' || p.proname as function_full_name,
    pg_get_functiondef(p.oid) as definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE pg_get_functiondef(p.oid) ILIKE '%plan_type%';
```

### Action 5: Apply the Clean Fix

Run the new fix file in Supabase SQL Editor:

**File: `database/fix-plan-type-error.sql`**

This will:
1. Remove ALL triggers on auth.users
2. Recreate a clean, simple trigger
3. Ensure no plan_type column exists in auth.users
4. Test the fix

## Root Cause Analysis

The error message shows:
```
failed to close prepared statement: ERROR: current transaction is aborted
```

This suggests:
1. A transaction started
2. Something tried to use `plan_type` on `auth.users`
3. That failed (because the column doesn't exist)
4. The transaction was aborted
5. Now nothing works until transaction ends

### Possible Culprits

#### 1. Application Code Calling Admin API
Your application might be calling:
```javascript
supabase.auth.admin.createUser({
  email: 'user@example.com',
  password: 'password',
  user_metadata: { plan_type: 'free' } // ❌ Wrong place
})
```

**Should be:**
```javascript
// Create user first
const { data: user } = await supabase.auth.admin.createUser({
  email: 'user@example.com',
  password: 'password',
  user_metadata: { full_name: 'User Name' }
});

// Then let the trigger handle subscription, OR manually create it
// The trigger should handle this automatically
```

#### 2. Database Webhook
Check: Database → Webhooks for any webhook on `auth.users`

#### 3. Edge Function
Check: Edge Functions for any function triggered on user creation

#### 4. Old/Cached Trigger
Even after dropping, prepared statements might be cached

## Step-by-Step Fix Process

### Step 1: Clean Database (SQL Editor)
```sql
-- Run in Supabase SQL Editor
\i database/fix-plan-type-error.sql
```

OR copy/paste the entire contents of `fix-plan-type-error.sql`

### Step 2: Clear Connection Pool
In Supabase Dashboard:
1. Go to **Settings** → **Database**
2. Scroll to **Connection pooling**
3. Click **Reset connection pool** (if available)

OR just wait 5-10 minutes for connections to cycle

### Step 3: Check Application Code
Search your application code for:
```bash
grep -r "plan_type" /path/to/your/app
grep -r "createUser" /path/to/your/app
grep -r "admin.users" /path/to/your/app
```

Look for any code that:
- Tries to insert plan_type into auth.users
- Calls admin API with plan_type
- Has custom user creation logic

### Step 4: Test User Creation

Try creating a user via Supabase Dashboard:
1. **Authentication** → **Users**
2. Click **Add User**
3. Enter email: `test-$(date +%s)@example.com`
4. Enter password
5. Click **Create User**

Watch the Logs:
- **Logs** → **Postgres Logs**
- Look for errors

### Step 5: If Still Failing - Nuclear Option

If the error persists, we need to:

1. **Temporarily disable the trigger:**
```sql
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users CASCADE;
```

2. **Test user creation** - should work now

3. **If it works**, the problem is in the trigger logic

4. **If it still fails**, the problem is:
   - In your application code
   - In a webhook
   - In an edge function
   - In Auth hooks configuration

## Quick Test Command

Run this to test user creation via API:

```bash
curl -X POST \
  'https://zzgkylsbdgwoohcbompi.supabase.co/auth/v1/admin/users' \
  -H "apikey: $SUPABASE_SERVICE_ROLE_KEY" \
  -H "Authorization: Bearer $SUPABASE_SERVICE_ROLE_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test-'$(date +%s)'@example.com",
    "password": "SecurePassword123!",
    "email_confirm": true
  }'
```

## What to Report Back

Please check and report:

1. ✅ or ❌ Any webhooks found in Database → Webhooks?
2. ✅ or ❌ Any edge functions found related to auth?
3. ✅ or ❌ Any auth hooks enabled?
4. ✅ or ❌ Did fix-plan-type-error.sql run successfully?
5. ✅ or ❌ Can you create a user via Dashboard after fix?
6. 📋 Full error from Postgres Logs (if still failing)

## Emergency Contact

If this is blocking production:

1. **Temporarily disable the problematic feature**
2. **Remove the trigger** (see Nuclear Option above)
3. **Manually create subscriptions** for new users
4. **Investigate thoroughly** what's calling plan_type

## Files to Use

1. **`database/diagnose-error.sql`** - Run first to diagnose
2. **`database/fix-plan-type-error.sql`** - Run to fix
3. This guide - Follow step by step

## Next Steps

After you run the diagnostic and fix:
1. Report findings
2. Test user creation
3. Share any remaining errors with full context

# IMMEDIATE ACTION REQUIRED

## Current Situation
✅ All existing users have profiles and subscriptions  
❌ NEW users cannot sign up - getting plan_type error

## The Fix - 3 Simple Steps

### Step 1: Apply SQL Fix (5 minutes)

1. Open Supabase SQL Editor:
   ```
   https://app.supabase.com/project/zzgkylsbdgwoohcbompi/sql/new
   ```

2. Copy **ALL content** from: `database/final-fix.sql`

3. Paste into SQL Editor and click **RUN**

4. You should see messages ending with:
   ```
   ✓ Trigger on_auth_user_created_v3 exists
   ✓ Function handle_new_user_v3 exists
   ✓ Free plan exists and is active
   Setup complete! Try creating a new user now.
   ```

### Step 2: Test User Creation (2 minutes)

**Option A: Via Supabase Dashboard**
1. Go to: Authentication → Users
2. Click "Add User"
3. Email: `test-$(date +%s)@example.com`
4. Password: `TestPassword123!`
5. Click "Create User"

**Option B: Via curl**
```bash
curl -X POST \
  'https://zzgkylsbdgwoohcbompi.supabase.co/auth/v1/admin/users' \
  -H "apikey: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6Z2t5bHNiZGd3b29oY2JvbXBpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MDA0OTg3NSwiZXhwIjoyMDY1NjI1ODc1fQ.QuCJFh8iwA6gsYRsmUutiizNq2TR3T1xECVvAXFWxLw" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6Z2t5bHNiZGd3b29oY2JvbXBpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MDA0OTg3NSwiZXhwIjoyMDY1NjI1ODc1fQ.QuCJFh8iwA6gsYRsmUutiizNq2TR3T1xECVvAXFWxLw" \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"test-$RANDOM@example.com\", \"password\": \"TestPassword123!\", \"email_confirm\": true}"
```

### Step 3: Verify Fix (1 minute)

Check if the new user has profile and subscription:

```sql
-- Run in SQL Editor
SELECT 
    u.email,
    u.created_at,
    p.user_id IS NOT NULL as has_profile,
    s.user_id IS NOT NULL as has_subscription,
    s.plan_type
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.user_id
LEFT JOIN public.user_subscriptions s ON u.id = s.user_id
WHERE u.email LIKE 'test-%@example.com'
ORDER BY u.created_at DESC
LIMIT 5;
```

Should show: `has_profile: true`, `has_subscription: true`, `plan_type: free`

## What Changed?

### Before (Broken)
- Old trigger trying to reference plan_type incorrectly
- Cached prepared statements causing issues
- Error blocking user creation

### After (Fixed)
- ✅ Clean trigger function (v3)
- ✅ Proper error handling (won't block user creation)
- ✅ Clears cached statements
- ✅ Better logging for debugging

## If Still Getting Errors

### Check These:

1. **Database Webhooks**
   - Dashboard → Database → Webhooks
   - Disable any webhook on `auth.users` table

2. **Edge Functions**
   - Dashboard → Edge Functions
   - Look for auth-related functions
   - Temporarily disable them

3. **Application Code**
   - Check if your app is calling:
     ```javascript
     supabase.auth.admin.createUser({
       email: '...',
       user_metadata: { plan_type: 'free' } // ❌ REMOVE THIS
     })
     ```
   - It should just be:
     ```javascript
     supabase.auth.admin.createUser({
       email: '...',
       password: '...'
     })
     ```

4. **Check Postgres Logs**
   - Dashboard → Logs → Postgres Logs
   - Look for errors after trying to create user
   - Share the full error message

## Emergency Fallback

If trigger is causing issues, temporarily disable it:

```sql
-- Run in SQL Editor to disable trigger
DROP TRIGGER IF EXISTS on_auth_user_created_v3 ON auth.users;

-- Now try creating user - should work
-- Then manually create their subscription:
INSERT INTO public.user_subscriptions (
    user_id, email, plan_id, plan_type, status, 
    billing_cycle, started_at, price_usd, price_vnd
)
SELECT 
    u.id, u.email, sp.id, 'free', 'active',
    'lifetime', NOW(), 0, 0
FROM auth.users u
CROSS JOIN subscription_plans sp
WHERE sp.type = 'free'
AND u.email = 'THE_NEW_USER_EMAIL'
AND NOT EXISTS (
    SELECT 1 FROM user_subscriptions WHERE user_id = u.id
);
```

## Files Created

1. ✅ `database/final-fix.sql` - **USE THIS ONE**
2. `database/diagnose-simple.sql` - For diagnostics
3. `database/TAKE_ACTION.md` - This file

## Need Help?

Report:
1. Result of Step 1 (SQL output)
2. Result of Step 2 (error or success)
3. Any error from Postgres Logs
4. Email: chebichat.ai@gmail.com

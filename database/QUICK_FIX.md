# Quick Fix Summary - User Creation Error

## Error
```
ERROR: column "plan_type" does not exist (SQLSTATE 42703)
500: Database error creating new user
```

## Root Cause
Supabase is trying to insert `plan_type` into `auth.users` table, but this column doesn't exist there. It should be in `user_subscriptions` table instead.

## Solution
Apply the `fix-user-creation.sql` script which creates automatic triggers to:
1. Create user profile when user signs up
2. Assign free subscription plan automatically
3. Backfill existing users

## How to Apply (Choose One Method)

### Method 1: Supabase Dashboard (EASIEST - RECOMMENDED)

1. Go to: https://app.supabase.com/project/zzgkylsbdgwoohcbompi/sql/new

2. Open `database/fix-user-creation.sql` and copy ALL content

3. Paste into SQL Editor and click "Run"

4. Done! ✓

### Method 2: Using Node.js Script

```bash
cd /home/ght/chebichat-project/chebichat-clean-data
npm install @supabase/supabase-js
node database/apply-fix.js
```

### Method 3: Using Bash Script

```bash
cd /home/ght/chebichat-project/chebichat-clean-data
chmod +x database/apply-fix.sh
./database/apply-fix.sh
```

## Verify the Fix

After applying, run this in Supabase SQL Editor:

```sql
-- Check trigger exists
SELECT trigger_name FROM information_schema.triggers 
WHERE trigger_name = 'on_auth_user_created';

-- Check free plan exists
SELECT * FROM public.subscription_plans WHERE type = 'free';

-- Check users have profiles and subscriptions
SELECT 
  u.email,
  p.display_name,
  us.plan_type,
  us.status
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.user_id
LEFT JOIN public.user_subscriptions us ON u.id = us.user_id
ORDER BY u.created_at DESC
LIMIT 5;
```

All users should have a profile and subscription. If any are NULL, the trigger will handle new users going forward.

## Test User Creation

Try creating a test user:

```bash
curl -X POST 'https://zzgkylsbdgwoohcbompi.supabase.co/auth/v1/signup' \
  -H 'apikey: YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "test@example.com",
    "password": "SecurePassword123!"
  }'
```

Should return success with no "plan_type" error.

## Files Created

1. `database/fix-user-creation.sql` - The SQL fix script
2. `database/FIX_USER_CREATION_GUIDE.md` - Detailed documentation
3. `database/apply-fix.sh` - Bash deployment script
4. `database/apply-fix.js` - Node.js deployment script
5. `database/README.md` - Database folder documentation
6. `database/QUICK_FIX.md` - This file

## Need Help?

See detailed guide: `database/FIX_USER_CREATION_GUIDE.md`

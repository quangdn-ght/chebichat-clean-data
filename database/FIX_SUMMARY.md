# Summary: User Creation Fix for plan_type Error

## Problem
```
ERROR: column "plan_type" does not exist (SQLSTATE 42703)
500: Database error creating new user
Path: /admin/users
```

## Diagnosis Results
✅ All existing users (10+) have profiles and subscriptions correctly  
✅ Database structure is correct - `plan_type` exists in `user_subscriptions` table  
❌ New user creation fails with plan_type error  

## Root Cause
The error occurs because something is trying to reference or insert `plan_type` into the `auth.users` table during user creation, but that column doesn't exist there (and shouldn't exist there).

Possible causes:
1. Stale/cached database trigger or function
2. Cached prepared statements in PostgreSQL
3. Application code incorrectly setting plan_type during user creation
4. Database webhook or edge function

## Solution

**File to apply: `database/final-fix.sql`**

This script:
1. ✅ Removes ALL old triggers on auth.users
2. ✅ Clears cached prepared statements (`DISCARD PLANS`)
3. ✅ Creates new clean trigger function (v3) with proper error handling
4. ✅ Automatically creates profile + free subscription for new users
5. ✅ Includes verification checks

## How to Apply

### Method 1: Supabase Dashboard (Recommended)
1. Go to: https://app.supabase.com/project/zzgkylsbdgwoohcbompi/sql/new
2. Open `database/final-fix.sql`
3. Copy ALL content
4. Paste into SQL Editor
5. Click "RUN"
6. Check for success messages

### Method 2: Command Line
```bash
cd /home/ght/chebichat-project/chebichat-clean-data
# Then manually run the SQL in Supabase dashboard
```

## Test the Fix

After applying, test user creation:

**Via Dashboard:**
- Authentication → Users → Add User
- Email: test-<timestamp>@example.com
- Click Create User

**Via API:**
```bash
curl -X POST 'https://zzgkylsbdgwoohcbompi.supabase.co/auth/v1/signup' \
  -H 'apikey: YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{"email": "test@example.com", "password": "SecurePass123!"}'
```

## Verify

Run in SQL Editor:
```sql
SELECT u.email, u.created_at, 
       p.user_id IS NOT NULL as has_profile,
       s.plan_type
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.user_id
LEFT JOIN public.user_subscriptions s ON u.id = s.user_id
ORDER BY u.created_at DESC LIMIT 1;
```

Should show: `has_profile: true`, `plan_type: free`

## All Files Created

| File | Purpose |
|------|---------|
| **`final-fix.sql`** | **Main fix - Use this** |
| `TAKE_ACTION.md` | Quick action guide |
| `diagnose-simple.sql` | Diagnostic queries |
| `fix-plan-type-error.sql` | Alternative fix |
| `fix-user-creation.sql` | Initial fix attempt |
| `FIX_USER_CREATION_GUIDE.md` | Detailed documentation |
| `URGENT_FIX_GUIDE.md` | Investigation guide |

## Key Changes

**New Trigger Function: `handle_new_user_v3()`**
- Uses `SECURITY DEFINER` for proper permissions
- Has error handling (won't block user creation if fails)
- Uses `ON CONFLICT DO NOTHING` to avoid duplicate errors
- Includes logging for debugging
- Clears cached statements

**Old vs New:**
- ❌ Old: Could fail and block user creation
- ✅ New: Gracefully handles errors, logs warnings
- ❌ Old: No prepared statement cleanup
- ✅ New: Includes `DISCARD PLANS` to clear cache
- ❌ Old: Simple error messages
- ✅ New: Detailed logging with user email

## If Still Failing

Check these in order:

1. **Postgres Logs** (Dashboard → Logs → Postgres Logs)
   - Look for warnings from `handle_new_user_v3`
   - Share full error message

2. **Database Webhooks** (Dashboard → Database → Webhooks)
   - Check for webhooks on `auth.users` table
   - Temporarily disable them

3. **Edge Functions** (Dashboard → Edge Functions)
   - Look for auth-related functions
   - Check code for `plan_type` references

4. **Application Code**
   - Search for `plan_type` in your application
   - Check user creation endpoints
   - Ensure not setting plan_type during signup

## Success Criteria

After fix is applied:
- ✅ New users can sign up without errors
- ✅ New users automatically get a profile
- ✅ New users automatically get free subscription
- ✅ No "plan_type does not exist" errors in logs
- ✅ Existing users unaffected

## Contact

If issues persist:
- Email: chebichat.ai@gmail.com
- Provide: Postgres logs, error messages, test results

---

**Last Updated:** 2025-10-19  
**Status:** Ready to apply  
**Priority:** HIGH - Blocking new user signups

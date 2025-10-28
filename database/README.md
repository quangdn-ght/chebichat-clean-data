# Database Management

This folder contains database schemas, migrations, and management scripts for the ChebChat project.

## Files Overview

### Schema Files
- **`database-schema.sql`** - Complete database schema (for reference only)
- **`add-image-field.sql`** - Migration to add image_url field to dictionary table

### Fix Scripts
- **`fix-user-creation.sql`** - Fix for "plan_type does not exist" error during user creation
- **`FIX_USER_CREATION_GUIDE.md`** - Detailed guide for applying the user creation fix
- **`apply-fix.sh`** - Bash script to deploy the fix (requires psql)
- **`apply-fix.js`** - Node.js script to deploy the fix (recommended)

## Quick Fix for User Creation Error

If you're experiencing this error:
```
ERROR: column "plan_type" does not exist (SQLSTATE 42703)
500: Database error creating new user
```

### Option 1: Manual Application (Recommended)

1. **Go to Supabase SQL Editor**
   - URL: `https://app.supabase.com/project/YOUR_PROJECT_ID/sql/new`
   - Or navigate: Dashboard → SQL Editor → New Query

2. **Copy and paste** the entire contents of `fix-user-creation.sql`

3. **Click Run** (or press Ctrl+Enter)

4. **Verify** using the queries in `FIX_USER_CREATION_GUIDE.md`

### Option 2: Using Node.js Script

```bash
# Make sure you have the dependencies
npm install @supabase/supabase-js

# Run the fix script
node database/apply-fix.js
```

### Option 3: Using Bash Script (requires psql)

```bash
# Make executable (if not already)
chmod +x database/apply-fix.sh

# Run the script
./database/apply-fix.sh
```

## What the Fix Does

The fix creates an automatic system that:

1. **Creates a trigger** that runs whenever a new user signs up
2. **Automatically creates** a user profile in `public.profiles`
3. **Automatically assigns** a free subscription in `public.user_subscriptions`
4. **Backfills** existing users who don't have profiles or subscriptions
5. **Implements** Row Level Security (RLS) policies
6. **Grants** appropriate permissions to different roles

## Database Structure

### Main Tables

#### Authentication & Users
- `auth.users` - Supabase authentication table (managed by Supabase)
- `public.profiles` - User profile information
- `public.user_subscriptions` - User subscription and plan information
- `public.subscription_plans` - Available subscription plans

#### Learning Content
- `public.dictionary` - Chinese-Vietnamese-English dictionary
- `public.greetings` - Chinese greetings with translations
- `public.quotations` - Chinese quotes and sayings
- `public.radicals_poem` - Chinese radicals with memory poems
- `public.letters` - Chinese text with analysis

#### User Data
- `public.character_bookmarks` - User's bookmarked characters
- `public.hanzi_quiz_results` - Quiz results and scores
- `public.user_usage` - Usage tracking and analytics

#### Subscriptions & Payments
- `public.orders` - Order information from Haravan
- `public.payment_history` - Payment transaction history
- `public.subscription_changes` - Subscription change log

### Key Relationships

```
auth.users (Supabase)
    ├── public.profiles (1:1)
    ├── public.user_subscriptions (1:many)
    ├── public.character_bookmarks (1:many)
    ├── public.hanzi_quiz_results (1:many)
    └── public.user_usage (1:many)

public.subscription_plans
    ├── public.user_subscriptions (1:many)
    └── public.orders (1:many)

public.orders
    └── public.user_subscriptions (1:many)
```

## Environment Variables

Ensure these are set in your `.env` file:

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## Verification Queries

### Check user creation system is working

```sql
-- Check if trigger exists
SELECT trigger_name, event_manipulation, event_object_table
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';

-- Check free plan exists
SELECT * FROM public.subscription_plans WHERE type = 'free';

-- Check all users have profiles
SELECT 
  u.email,
  p.display_name IS NOT NULL as has_profile,
  us.plan_type IS NOT NULL as has_subscription
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.user_id
LEFT JOIN public.user_subscriptions us ON u.id = us.user_id
ORDER BY u.created_at DESC
LIMIT 10;

-- Get subscription statistics
SELECT 
  us.plan_type,
  us.status,
  COUNT(*) as user_count
FROM public.user_subscriptions us
GROUP BY us.plan_type, us.status
ORDER BY user_count DESC;
```

## Troubleshooting

### Problem: Script fails to connect
**Solution**: 
- Verify environment variables are set correctly
- Check Supabase project is active
- Ensure network connectivity

### Problem: Permission denied errors
**Solution**: Run these grants in SQL Editor:
```sql
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, service_role;
```

### Problem: Users still getting errors after fix
**Solution**:
1. Check Supabase logs: Dashboard → Logs → Postgres Logs
2. Verify trigger is active: Run verification queries above
3. Check if free plan exists in subscription_plans table
4. Review FIX_USER_CREATION_GUIDE.md for detailed troubleshooting

## Migrations Best Practices

When creating new migrations:

1. **Always test locally first** (if possible)
2. **Back up data** before major changes
3. **Use transactions** for multi-statement migrations
4. **Add rollback instructions** in comments
5. **Document changes** in commit messages
6. **Version your migrations** with timestamps or sequential numbers

Example migration template:
```sql
-- Migration: Add new feature
-- Created: 2025-10-19
-- Author: Your Name
-- Description: What this migration does

BEGIN;

-- Your changes here
ALTER TABLE ... ;

-- Rollback instructions:
-- ALTER TABLE ... ;

COMMIT;
```

## Security Notes

- The service role key has admin access - keep it secure!
- Never commit `.env` file to version control
- Use Row Level Security (RLS) for all user-facing tables
- Audit database permissions regularly

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

## Support

For issues related to:
- **Database schema**: Check `database-schema.sql`
- **User creation**: See `FIX_USER_CREATION_GUIDE.md`
- **Supabase configuration**: Check Supabase dashboard and logs
- **Connection issues**: Verify `.env` configuration

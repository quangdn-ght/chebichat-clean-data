-- Diagnostic script to find the source of the plan_type error
-- Run this in Supabase SQL Editor to identify the problem

-- 1. Check all triggers on auth.users
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'users'
    AND event_object_schema = 'auth'
ORDER BY trigger_name;

-- 2. Check all functions that might be called during user creation
SELECT 
    n.nspname as schema_name,
    p.proname as function_name,
    CASE 
        WHEN p.prokind = 'a' THEN 'AGGREGATE FUNCTION - skipped'
        ELSE pg_get_functiondef(p.oid)
    END as function_definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname IN ('public', 'auth')
    AND p.prokind != 'a'  -- Exclude aggregate functions
    AND p.proname ILIKE '%user%'
ORDER BY n.nspname, p.proname;

-- 3. Check if there's a view or rule on auth.users
SELECT 
    schemaname,
    tablename,
    definition
FROM pg_views
WHERE tablename = 'users'
    AND schemaname = 'auth';

-- 4. Check for any rules on auth.users
SELECT 
    schemaname,
    tablename,
    rulename,
    definition
FROM pg_rules
WHERE tablename = 'users'
    AND schemaname = 'auth';

-- 5. List all columns in auth.users to confirm plan_type is not there
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'auth'
    AND table_name = 'users'
ORDER BY ordinal_position;

-- 6. Check for any prepared statements that might be cached
SELECT 
    name,
    statement,
    parameter_types
FROM pg_prepared_statements
WHERE statement ILIKE '%plan_type%';

-- 7. Check webhooks configuration (this might not show in SQL)
-- You'll need to check in Supabase Dashboard: Database > Webhooks

-- 8. Check for policies that might reference plan_type
SELECT 
    schemaname,
    tablename,
    policyname,
    qual,
    with_check
FROM pg_policies
WHERE qual::text ILIKE '%plan_type%'
    OR with_check::text ILIKE '%plan_type%';

-- Simple Diagnostic Script - Run each section separately
-- This avoids aggregate function errors

-- ============================================
-- SECTION 1: Check Triggers on auth.users
-- ============================================
SELECT 
    trigger_name,
    event_manipulation as "event",
    action_timing as "timing",
    action_statement as "action"
FROM information_schema.triggers
WHERE event_object_table = 'users'
    AND event_object_schema = 'auth'
ORDER BY trigger_name;

-- ============================================
-- SECTION 2: List All User-Related Functions
-- ============================================
SELECT 
    n.nspname as schema,
    p.proname as function_name,
    pg_get_function_identity_arguments(p.oid) as arguments
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname IN ('public', 'auth')
    AND p.prokind IN ('f', 'p')  -- Only regular functions and procedures
    AND p.proname ILIKE '%user%'
ORDER BY n.nspname, p.proname;

-- ============================================
-- SECTION 3: Get Definition of Specific Function
-- Run this for each function found above
-- ============================================
SELECT pg_get_functiondef('public.handle_new_user'::regproc);
-- If error "function does not exist", try:
-- SELECT pg_get_functiondef('public.handle_new_user_simple'::regproc);

-- ============================================
-- SECTION 4: Check auth.users Columns
-- ============================================
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'auth'
    AND table_name = 'users'
ORDER BY ordinal_position;

-- ============================================
-- SECTION 5: Check for plan_type References
-- ============================================
-- This searches for any database objects referencing plan_type
SELECT 
    'TABLE COLUMN' as object_type,
    table_schema || '.' || table_name as object_name,
    column_name as detail
FROM information_schema.columns
WHERE column_name = 'plan_type'

UNION ALL

SELECT 
    'POLICY' as object_type,
    schemaname || '.' || tablename as object_name,
    policyname as detail
FROM pg_policies
WHERE qual::text ILIKE '%plan_type%'
    OR with_check::text ILIKE '%plan_type%'

UNION ALL

SELECT 
    'VIEW' as object_type,
    schemaname || '.' || viewname as object_name,
    'contains plan_type' as detail
FROM pg_views
WHERE definition ILIKE '%plan_type%'

ORDER BY object_type, object_name;

-- ============================================
-- SECTION 6: Check Subscription Tables Status
-- ============================================
-- Verify the plan_type column exists in the RIGHT place
SELECT 
    'user_subscriptions' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT plan_type) as distinct_plan_types,
    string_agg(DISTINCT plan_type, ', ') as plan_types
FROM public.user_subscriptions;

SELECT 
    'subscription_plans' as table_name,
    COUNT(*) as total_plans,
    string_agg(type, ', ') as available_types
FROM public.subscription_plans;

-- ============================================
-- SECTION 7: Check User Profile Coverage
-- ============================================
-- See how many users have profiles and subscriptions
SELECT 
    'Total Users' as metric,
    COUNT(*) as count
FROM auth.users

UNION ALL

SELECT 
    'Users with Profile' as metric,
    COUNT(*) as count
FROM auth.users u
INNER JOIN public.profiles p ON u.id = p.user_id

UNION ALL

SELECT 
    'Users with Subscription' as metric,
    COUNT(*) as count
FROM auth.users u
INNER JOIN public.user_subscriptions s ON u.id = s.user_id

UNION ALL

SELECT 
    'Users Missing Profile' as metric,
    COUNT(*) as count
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.user_id
WHERE p.user_id IS NULL

UNION ALL

SELECT 
    'Users Missing Subscription' as metric,
    COUNT(*) as count
FROM auth.users u
LEFT JOIN public.user_subscriptions s ON u.id = s.user_id
WHERE s.user_id IS NULL;

-- ============================================
-- SECTION 8: Recent User Creation Activity
-- ============================================
SELECT 
    u.email,
    u.created_at,
    p.user_id IS NOT NULL as has_profile,
    s.user_id IS NOT NULL as has_subscription,
    s.plan_type
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.user_id
LEFT JOIN public.user_subscriptions s ON u.id = s.user_id
ORDER BY u.created_at DESC
LIMIT 10;

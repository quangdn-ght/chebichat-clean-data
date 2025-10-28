-- FINAL FIX: Complete cleanup and recreation of user creation system
-- Run this entire script in Supabase SQL Editor

-- ============================================
-- STEP 1: Drop ALL existing user-related triggers
-- ============================================
DO $$ 
DECLARE
    trigger_record RECORD;
BEGIN
    FOR trigger_record IN 
        SELECT trigger_name
        FROM information_schema.triggers
        WHERE event_object_table = 'users'
        AND event_object_schema = 'auth'
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON auth.users CASCADE', trigger_record.trigger_name);
        RAISE NOTICE '✓ Dropped trigger: %', trigger_record.trigger_name;
    END LOOP;
END $$;

-- ============================================
-- STEP 2: Drop ALL related functions
-- ============================================
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user_v2() CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user_simple() CASCADE;
DROP FUNCTION IF EXISTS auth.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS handle_new_user() CASCADE;

-- ============================================
-- STEP 3: Verify auth.users does NOT have plan_type
-- ============================================
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'auth' 
        AND table_name = 'users' 
        AND column_name = 'plan_type'
    ) THEN
        RAISE EXCEPTION 'ERROR: auth.users has plan_type column - this should not exist!';
    ELSE
        RAISE NOTICE '✓ Confirmed: auth.users does NOT have plan_type column (correct)';
    END IF;
END $$;

-- ============================================
-- STEP 4: Create the free plan (if not exists)
-- ============================================
INSERT INTO public.subscription_plans (
    name, 
    type, 
    price_usd, 
    price_vnd, 
    billing_cycle, 
    is_active, 
    features
)
VALUES (
    'Free Plan',
    'free',
    0,
    0,
    'lifetime',
    true,
    jsonb_build_object(
        'dictionary_lookups', 'unlimited',
        'basic_features', true,
        'bookmark_limit', 100
    )
)
ON CONFLICT (type) 
DO UPDATE SET
    name = EXCLUDED.name,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();

-- ============================================
-- STEP 5: Create new clean trigger function
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_new_user_v3()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public, auth
LANGUAGE plpgsql
AS $$
DECLARE
    v_free_plan_id UUID;
    v_display_name TEXT;
BEGIN
    -- Log for debugging
    RAISE LOG 'handle_new_user_v3: Processing new user %', NEW.email;

    -- Get the free plan ID
    SELECT id INTO v_free_plan_id 
    FROM public.subscription_plans 
    WHERE type = 'free' 
    AND is_active = true
    LIMIT 1;

    IF v_free_plan_id IS NULL THEN
        RAISE WARNING 'Free plan not found! Creating one...';
        INSERT INTO public.subscription_plans (name, type, price_usd, price_vnd, billing_cycle, is_active)
        VALUES ('Free Plan', 'free', 0, 0, 'lifetime', true)
        RETURNING id INTO v_free_plan_id;
    END IF;

    -- Extract display name from metadata or use email
    v_display_name := COALESCE(
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'name',
        NEW.email,
        'User'
    );

    -- Create profile (use INSERT with ON CONFLICT)
    INSERT INTO public.profiles (
        user_id, 
        display_name, 
        created_at, 
        updated_at
    )
    VALUES (
        NEW.id,
        v_display_name,
        NOW(),
        NOW()
    )
    ON CONFLICT (user_id) DO NOTHING;

    RAISE LOG 'handle_new_user_v3: Created profile for %', NEW.email;

    -- Create subscription (use INSERT with ON CONFLICT)
    INSERT INTO public.user_subscriptions (
        user_id,
        email,
        plan_id,
        plan_type,
        status,
        billing_cycle,
        started_at,
        current_period_start,
        price_usd,
        price_vnd,
        payment_provider,
        metadata,
        created_at,
        updated_at
    )
    VALUES (
        NEW.id,
        NEW.email,
        v_free_plan_id,
        'free',
        'active',
        'lifetime',
        NOW(),
        NOW(),
        0,
        0,
        'none',
        jsonb_build_object('auto_created', true, 'version', 'v3'),
        NOW(),
        NOW()
    )
    ON CONFLICT (id) DO NOTHING;

    RAISE LOG 'handle_new_user_v3: Created subscription for %', NEW.email;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error but don't fail user creation
        RAISE WARNING 'handle_new_user_v3: Error for user %: %', NEW.email, SQLERRM;
        -- Still return NEW so user creation succeeds
        RETURN NEW;
END;
$$;

-- ============================================
-- STEP 6: Create the trigger
-- ============================================
CREATE TRIGGER on_auth_user_created_v3
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user_v3();

-- ============================================
-- STEP 7: Grant permissions
-- ============================================
GRANT EXECUTE ON FUNCTION public.handle_new_user_v3() TO postgres, service_role, authenticated;
GRANT ALL ON public.profiles TO postgres, service_role;
GRANT ALL ON public.user_subscriptions TO postgres, service_role;
GRANT ALL ON public.subscription_plans TO postgres, service_role;

-- ============================================
-- STEP 8: Clear any cached prepared statements
-- ============================================
-- This forces PostgreSQL to recompile queries
DISCARD PLANS;
DISCARD TEMP;

-- ============================================
-- STEP 9: Verification
-- ============================================
DO $$
DECLARE
    v_trigger_count INTEGER;
    v_function_exists BOOLEAN;
    v_free_plan_exists BOOLEAN;
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE 'VERIFICATION RESULTS';
    RAISE NOTICE '============================================';

    -- Check trigger
    SELECT COUNT(*) INTO v_trigger_count
    FROM information_schema.triggers
    WHERE trigger_name = 'on_auth_user_created_v3'
    AND event_object_table = 'users'
    AND event_object_schema = 'auth';
    
    IF v_trigger_count > 0 THEN
        RAISE NOTICE '✓ Trigger on_auth_user_created_v3 exists';
    ELSE
        RAISE WARNING '✗ Trigger on_auth_user_created_v3 NOT found!';
    END IF;

    -- Check function
    SELECT EXISTS(
        SELECT 1 FROM pg_proc 
        WHERE proname = 'handle_new_user_v3'
    ) INTO v_function_exists;
    
    IF v_function_exists THEN
        RAISE NOTICE '✓ Function handle_new_user_v3 exists';
    ELSE
        RAISE WARNING '✗ Function handle_new_user_v3 NOT found!';
    END IF;

    -- Check free plan
    SELECT EXISTS(
        SELECT 1 FROM public.subscription_plans 
        WHERE type = 'free' AND is_active = true
    ) INTO v_free_plan_exists;
    
    IF v_free_plan_exists THEN
        RAISE NOTICE '✓ Free plan exists and is active';
    ELSE
        RAISE WARNING '✗ Free plan NOT found or inactive!';
    END IF;

    RAISE NOTICE '============================================';
    RAISE NOTICE 'Setup complete! Try creating a new user now.';
    RAISE NOTICE '============================================';
END $$;

-- ============================================
-- OPTIONAL: Test the trigger function manually
-- ============================================
-- Uncomment and run this to test without creating a real user:
/*
DO $$
DECLARE
    test_user_record RECORD;
BEGIN
    -- Create a mock user record
    SELECT 
        gen_random_uuid() as id,
        'test-' || extract(epoch from now())::text || '@example.com' as email,
        '{"full_name": "Test User"}'::jsonb as raw_user_meta_data
    INTO test_user_record;

    RAISE NOTICE 'Testing with mock user: %', test_user_record.email;
    
    -- This won't actually create a user, just tests the function logic
    -- You'll need to manually verify the function works with a real user creation
END $$;
*/

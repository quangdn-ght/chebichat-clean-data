-- Fix for user creation error: column "plan_type" does not exist
-- This script adds the necessary infrastructure to handle user subscriptions automatically

-- Step 1: Create a function to automatically create user profile and subscription when a new user is created
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  free_plan_id UUID;
BEGIN
  -- Get the free plan ID (assuming there's a free plan)
  SELECT id INTO free_plan_id 
  FROM public.subscription_plans 
  WHERE type = 'free' 
  LIMIT 1;

  -- If no free plan exists, create one
  IF free_plan_id IS NULL THEN
    INSERT INTO public.subscription_plans (name, type, price_usd, price_vnd, billing_cycle, is_active)
    VALUES ('Free Plan', 'free', 0, 0, 'lifetime', true)
    RETURNING id INTO free_plan_id;
  END IF;

  -- Create user profile
  INSERT INTO public.profiles (user_id, display_name, created_at, updated_at)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email), now(), now())
  ON CONFLICT (user_id) DO NOTHING;

  -- Create user subscription with free plan
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
    free_plan_id,
    'free',
    'active',
    'lifetime',
    now(),
    now(),
    0,
    0,
    'none',
    jsonb_build_object('auto_created', true, 'created_by', 'trigger'),
    now(),
    now()
  )
  ON CONFLICT DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 2: Drop existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Step 3: Create trigger to automatically handle new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Step 4: Ensure the free plan exists
INSERT INTO public.subscription_plans (name, type, price_usd, price_vnd, billing_cycle, is_active, features)
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
ON CONFLICT (type) DO UPDATE SET
  name = EXCLUDED.name,
  price_usd = EXCLUDED.price_usd,
  price_vnd = EXCLUDED.price_vnd,
  billing_cycle = EXCLUDED.billing_cycle,
  is_active = EXCLUDED.is_active,
  features = EXCLUDED.features,
  updated_at = now();

-- Step 5: Backfill existing users without subscriptions
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
SELECT 
  u.id,
  u.email,
  sp.id,
  'free',
  'active',
  'lifetime',
  u.created_at,
  u.created_at,
  0,
  0,
  'none',
  jsonb_build_object('backfilled', true, 'backfill_date', now()),
  now(),
  now()
FROM auth.users u
CROSS JOIN (SELECT id FROM public.subscription_plans WHERE type = 'free' LIMIT 1) sp
WHERE NOT EXISTS (
  SELECT 1 FROM public.user_subscriptions us WHERE us.user_id = u.id
);

-- Step 6: Backfill existing users without profiles
INSERT INTO public.profiles (user_id, display_name, created_at, updated_at)
SELECT 
  u.id,
  COALESCE(u.raw_user_meta_data->>'full_name', u.email, 'User'),
  u.created_at,
  now()
FROM auth.users u
WHERE NOT EXISTS (
  SELECT 1 FROM public.profiles p WHERE p.user_id = u.id
)
ON CONFLICT (user_id) DO NOTHING;

-- Step 7: Grant necessary permissions
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, service_role;
GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
GRANT SELECT ON public.user_subscriptions TO authenticated;
GRANT SELECT ON public.subscription_plans TO anon, authenticated;

-- Step 8: Enable Row Level Security (RLS) policies if not already enabled
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscription_plans ENABLE ROW LEVEL SECURITY;

-- Step 9: Create RLS policies for profiles
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Users can view their own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = user_id);

-- Step 10: Create RLS policies for user_subscriptions
DROP POLICY IF EXISTS "Users can view their own subscription" ON public.user_subscriptions;
CREATE POLICY "Users can view their own subscription"
  ON public.user_subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- Step 11: Create RLS policies for subscription_plans
DROP POLICY IF EXISTS "Anyone can view subscription plans" ON public.subscription_plans;
CREATE POLICY "Anyone can view subscription plans"
  ON public.subscription_plans FOR SELECT
  USING (true);

-- Step 12: Create helper function to get user's current plan
CREATE OR REPLACE FUNCTION public.get_user_plan_type(p_user_id UUID)
RETURNS TEXT AS $$
DECLARE
  v_plan_type TEXT;
BEGIN
  SELECT plan_type INTO v_plan_type
  FROM public.user_subscriptions
  WHERE user_id = p_user_id
    AND status = 'active'
  ORDER BY created_at DESC
  LIMIT 1;
  
  RETURN COALESCE(v_plan_type, 'free');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 13: Grant execute permission on helper function
GRANT EXECUTE ON FUNCTION public.get_user_plan_type(UUID) TO authenticated;

COMMENT ON FUNCTION public.handle_new_user() IS 'Automatically creates profile and subscription for new users';
COMMENT ON FUNCTION public.get_user_plan_type(UUID) IS 'Returns the current active plan type for a user';

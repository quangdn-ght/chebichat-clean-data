-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.categories (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  name character varying NOT NULL UNIQUE,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT categories_pkey PRIMARY KEY (id)
);
CREATE TABLE public.character_bookmarks (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  characters text NOT NULL,
  pinyin text,
  meanings ARRAY,
  raw_data text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT character_bookmarks_pkey PRIMARY KEY (id),
  CONSTRAINT character_bookmarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.dictionary (
  chinese character varying NOT NULL,
  pinyin character varying NOT NULL,
  type USER-DEFINED NOT NULL,
  meaning_vi text NOT NULL,
  meaning_en text NOT NULL,
  example_cn text NOT NULL,
  example_vi text NOT NULL,
  example_en text NOT NULL,
  grammar text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  hsk_level text,
  hanviet character varying,
  meaning_cn text,
  search_vector tsvector DEFAULT to_tsvector('simple'::regconfig, (((((((((((chinese)::text || ' '::text) || (pinyin)::text) || ' '::text) || (COALESCE(hanviet, ''::character varying))::text) || ' '::text) || meaning_vi) || ' '::text) || meaning_en) || ' '::text) || COALESCE(meaning_cn, ''::text))),
  image_url text,
  CONSTRAINT dictionary_pkey PRIMARY KEY (chinese, pinyin)
);
CREATE TABLE public.greetings (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  category USER-DEFINED NOT NULL,
  content text NOT NULL,
  content_vietnamese text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  search_vector tsvector,
  CONSTRAINT greetings_pkey PRIMARY KEY (id)
);
CREATE TABLE public.hanzi_quiz_results (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  character_set text NOT NULL,
  total_strokes integer NOT NULL,
  mistake_strokes integer NOT NULL,
  accuracy_percentage numeric NOT NULL,
  score integer NOT NULL,
  passed boolean NOT NULL,
  completion_time interval,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT hanzi_quiz_results_pkey PRIMARY KEY (id),
  CONSTRAINT hanzi_quiz_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.letter_words (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  letter_id uuid NOT NULL,
  word text NOT NULL,
  hsk_level USER-DEFINED NOT NULL,
  frequency integer DEFAULT 1,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT letter_words_pkey PRIMARY KEY (id),
  CONSTRAINT letter_words_letter_id_fkey FOREIGN KEY (letter_id) REFERENCES public.letters(id)
);
CREATE TABLE public.letters (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  batch_id uuid,
  original text NOT NULL,
  pinyin text,
  vietnamese text,
  category_id uuid,
  source_id uuid,
  processed boolean DEFAULT false,
  processing_status USER-DEFINED DEFAULT 'pending'::processing_status,
  character_count integer,
  word_count integer,
  unique_word_count integer,
  average_word_length numeric,
  hsk1_count integer DEFAULT 0,
  hsk2_count integer DEFAULT 0,
  hsk3_count integer DEFAULT 0,
  hsk4_count integer DEFAULT 0,
  hsk5_count integer DEFAULT 0,
  hsk6_count integer DEFAULT 0,
  hsk7_count integer DEFAULT 0,
  other_count integer DEFAULT 0,
  total_hsk_words integer DEFAULT 0,
  hsk1_percentage numeric DEFAULT 0,
  hsk2_percentage numeric DEFAULT 0,
  hsk3_percentage numeric DEFAULT 0,
  hsk4_percentage numeric DEFAULT 0,
  hsk5_percentage numeric DEFAULT 0,
  hsk6_percentage numeric DEFAULT 0,
  hsk7_percentage numeric DEFAULT 0,
  other_percentage numeric DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT letters_pkey PRIMARY KEY (id),
  CONSTRAINT letters_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.processing_batches(id),
  CONSTRAINT letters_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id),
  CONSTRAINT letters_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.sources(id)
);
CREATE TABLE public.orders (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  haravan_order_id character varying NOT NULL UNIQUE,
  order_number character varying,
  email character varying NOT NULL,
  customer_name character varying,
  plan_id uuid,
  financial_status character varying NOT NULL,
  fulfillment_status character varying,
  total_price numeric NOT NULL,
  calculated_price numeric NOT NULL DEFAULT 0,
  currency character varying DEFAULT 'VND'::character varying,
  gateway character varying,
  quantity integer NOT NULL DEFAULT 1,
  plan_type character varying NOT NULL,
  haravan_customer_id character varying,
  line_items jsonb DEFAULT '[]'::jsonb,
  transactions jsonb DEFAULT '[]'::jsonb,
  verified_transactions jsonb DEFAULT '[]'::jsonb,
  raw_data jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id)
);
CREATE TABLE public.payment_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  subscription_id uuid NOT NULL,
  user_id uuid NOT NULL,
  amount_usd numeric NOT NULL,
  amount_vnd numeric NOT NULL,
  currency_rate numeric,
  payment_provider character varying NOT NULL,
  external_payment_id character varying,
  external_transaction_id character varying,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::payment_status,
  billing_cycle USER-DEFINED NOT NULL,
  payment_date timestamp with time zone,
  due_date timestamp with time zone NOT NULL,
  period_start timestamp with time zone NOT NULL,
  period_end timestamp with time zone NOT NULL,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT payment_history_pkey PRIMARY KEY (id),
  CONSTRAINT payment_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.processing_batches (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  processed_at timestamp with time zone DEFAULT now(),
  total_items integer NOT NULL DEFAULT 0,
  successful_items integer NOT NULL DEFAULT 0,
  failed_items integer NOT NULL DEFAULT 0,
  status USER-DEFINED DEFAULT 'pending'::processing_status,
  summary jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT processing_batches_pkey PRIMARY KEY (id)
);
CREATE TABLE public.profiles (
  user_id uuid NOT NULL,
  display_name text NOT NULL DEFAULT ''::text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT profiles_pkey PRIMARY KEY (user_id),
  CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.quotations (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  title character varying NOT NULL,
  category USER-DEFINED NOT NULL,
  content text NOT NULL,
  title_vietnamese character varying NOT NULL,
  content_vietnamese text NOT NULL,
  images text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  search_vector tsvector,
  CONSTRAINT quotations_pkey PRIMARY KEY (id)
);
CREATE TABLE public.radicals_poem (
  chinese character varying NOT NULL,
  poem_description text NOT NULL CHECK (length(TRIM(BOTH FROM poem_description)) > 0),
  category USER-DEFINED DEFAULT 'other'::radical_category,
  stroke_count smallint CHECK (stroke_count > 0 AND stroke_count <= 50),
  radical_number smallint CHECK (radical_number > 0 AND radical_number <= 300),
  notes text,
  normalized_description text,
  search_vector tsvector,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT radicals_poem_pkey PRIMARY KEY (chinese)
);
CREATE TABLE public.sources (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  name character varying NOT NULL UNIQUE,
  description text,
  total_items integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT sources_pkey PRIMARY KEY (id)
);
CREATE TABLE public.subscription_changes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  subscription_id uuid,
  change_type character varying NOT NULL,
  to_plan_type character varying NOT NULL,
  reason text,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT subscription_changes_pkey PRIMARY KEY (id),
  CONSTRAINT subscription_changes_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.user_subscriptions(id)
);
CREATE TABLE public.subscription_plans (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  type character varying NOT NULL UNIQUE,
  price_usd numeric NOT NULL DEFAULT 0,
  price_vnd numeric NOT NULL DEFAULT 0,
  billing_cycle character varying NOT NULL DEFAULT 'monthly'::character varying,
  features jsonb DEFAULT '{}'::jsonb,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT subscription_plans_pkey PRIMARY KEY (id)
);
CREATE TABLE public.user_subscriptions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  email character varying NOT NULL,
  plan_id uuid,
  order_id uuid,
  status character varying NOT NULL DEFAULT 'pending'::character varying,
  billing_cycle character varying NOT NULL DEFAULT 'monthly'::character varying,
  started_at timestamp with time zone,
  current_period_start timestamp with time zone,
  current_period_end timestamp with time zone,
  expires_at timestamp with time zone,
  price_usd numeric NOT NULL DEFAULT 0,
  price_vnd numeric NOT NULL DEFAULT 0,
  payment_provider character varying DEFAULT 'haravan'::character varying,
  external_subscription_id character varying,
  external_customer_id character varying,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  plan_type character varying DEFAULT 'free'::character varying,
  CONSTRAINT user_subscriptions_pkey PRIMARY KEY (id),
  CONSTRAINT user_subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id),
  CONSTRAINT user_subscriptions_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id)
);
CREATE TABLE public.user_usage (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  subscription_id uuid,
  usage_date date NOT NULL DEFAULT CURRENT_DATE,
  bookmarks_created integer DEFAULT 0,
  dictionary_lookups integer DEFAULT 0,
  quiz_attempts integer DEFAULT 0,
  hanzi_practice_sessions integer DEFAULT 0,
  ai_tutor_interactions integer DEFAULT 0,
  total_study_time_minutes integer DEFAULT 0,
  features_used jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_usage_pkey PRIMARY KEY (id),
  CONSTRAINT user_usage_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.vocabulary_frequency (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  letter_id uuid NOT NULL,
  word text NOT NULL,
  frequency integer NOT NULL DEFAULT 1,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT vocabulary_frequency_pkey PRIMARY KEY (id),
  CONSTRAINT vocabulary_frequency_letter_id_fkey FOREIGN KEY (letter_id) REFERENCES public.letters(id)
);
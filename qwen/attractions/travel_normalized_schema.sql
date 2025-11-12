create table public.attractions (
  id uuid not null default gen_random_uuid(),
  attraction_code bigint not null,
  name text null,
  province_id integer not null,
  region_id integer not null,
  category_id integer not null,
  description text null,
  opening_hours text null,
  ticket_price text null,
  best_time text null,
  contact_info text null,
  complaint_phone text null,
  transport_guide text null,
  image text null,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),
  constraint attractions_pkey primary key (id),
  constraint attractions_attraction_code_key unique (attraction_code),
  constraint fk_attraction_category foreign KEY (category_id) references categories (id) on update CASCADE on delete RESTRICT,
  constraint fk_attraction_province foreign KEY (province_id) references provinces (id) on update CASCADE on delete RESTRICT,
  constraint fk_attraction_region foreign KEY (region_id) references regions (id) on update CASCADE on delete RESTRICT
) TABLESPACE pg_default;

create index IF not exists idx_attractions_code on public.attractions using btree (attraction_code) TABLESPACE pg_default;

create index IF not exists idx_attractions_province on public.attractions using btree (province_id) TABLESPACE pg_default;

create index IF not exists idx_attractions_region on public.attractions using btree (region_id) TABLESPACE pg_default;

create index IF not exists idx_attractions_category on public.attractions using btree (category_id) TABLESPACE pg_default;

create index IF not exists idx_attractions_created on public.attractions using btree (created_at) TABLESPACE pg_default;

create index IF not exists idx_attractions_name on public.attractions using btree (name) TABLESPACE pg_default;

create index IF not exists idx_attractions_search on public.attractions using gin (
  to_tsvector(
    'simple'::regconfig,
    (
      (
        COALESCE(name, (''::character varying)::text) || ' '::text
      ) || COALESCE(description, ''::text)
    )
  )
) TABLESPACE pg_default;

create trigger update_attractions_updated_at BEFORE
update on attractions for EACH row
execute FUNCTION update_updated_at_column ();
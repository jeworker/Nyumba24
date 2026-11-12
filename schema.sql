-- NYUMBA24 schema migration. Run in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.properties (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  region text not null default 'Dar es Salaam',
  area text not null,
  property_type text not null,
  monthly_rent numeric(12,2) not null check (monthly_rent > 0),
  bedrooms integer not null default 0,
  bathrooms integer not null default 0,
  phone text not null,
  contact_phone text,
  description text,
  photo_url text,
  photo_urls text[] not null default '{}',
  image_urls text[] not null default '{}',
  owner_id uuid references auth.users(id) on delete set null,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);

-- Add columns missing from the existing NYUMBA24 table, without deleting old data.
alter table public.properties add column if not exists bathrooms integer not null default 0;
alter table public.properties add column if not exists contact_phone text;
alter table public.properties add column if not exists photo_url text;
alter table public.properties add column if not exists photo_urls text[] not null default '{}';
alter table public.properties add column if not exists owner_id uuid references auth.users(id) on delete set null;
alter table public.properties add column if not exists image_urls text[] not null default '{}';
update public.properties set contact_phone = phone where contact_phone is null and phone is not null;
update public.properties set photo_urls = image_urls where cardinality(photo_urls)=0 and cardinality(image_urls)>0;
update public.properties set photo_url = photo_urls[1] where photo_url is null and cardinality(photo_urls)>0;

create index if not exists properties_status_created_idx on public.properties(status, created_at desc);
create index if not exists properties_area_idx on public.properties(area);
alter table public.properties enable row level security;
grant select, insert on public.properties to anon, authenticated;

drop policy if exists "Public view approved houses" on public.properties;
drop policy if exists "Public can read approved properties" on public.properties;
create policy "Public can read approved properties" on public.properties for select to anon, authenticated using (status = 'approved');

drop policy if exists "Authenticated owners submit houses" on public.properties;
drop policy if exists "Public can submit pending properties" on public.properties;
drop policy if exists "Owners can publish own houses" on public.properties;
create policy "Owners can publish own houses" on public.properties for insert to authenticated with check (owner_id = auth.uid() and status = 'approved' and region = 'Dar es Salaam');

-- Use the exact bucket already created in your project.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('nyumba24-photos','nyumba24-photos',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=true,file_size_limit=5242880,allowed_mime_types=array['image/jpeg','image/png','image/webp'];

drop policy if exists "Authenticated upload house photos" on storage.objects;
drop policy if exists "Signed-in users can upload NYUMBA24 photos" on storage.objects;
drop policy if exists "Owners upload NYUMBA24 listing photos" on storage.objects;
create policy "Owners upload NYUMBA24 listing photos" on storage.objects for insert to authenticated with check (bucket_id='nyumba24-photos' and (storage.foldername(name))[1] = auth.uid()::text);

-- Public buckets can serve public object URLs without a broad SELECT/list policy.
drop policy if exists "Public view house photos" on storage.objects;
drop policy if exists "Anyone can view NYUMBA24 photos" on storage.objects;

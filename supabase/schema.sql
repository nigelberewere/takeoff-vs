create type public.application_status as enum ('draft', 'pending_review', 'approved', 'rejected');
create type public.document_type as enum ('national_id_front', 'national_id_back', 'selfie', 'license_front', 'license_back', 'vehicle_registration', 'insurance');

create table public.drivers (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null unique references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  phone text not null,
  dob date,
  national_id text,
  address text,
  city text,
  emergency_contact_name text,
  emergency_contact_phone text,
  application_status public.application_status not null default 'draft',
  created_at timestamptz not null default now()
);

create table public.vehicles (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null unique references public.drivers(id) on delete cascade,
  type text not null check (type in ('bike', 'car', 'van', 'truck')),
  make text,
  model text,
  year integer,
  plate_number text,
  color text
);

create table public.documents (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.drivers(id) on delete cascade,
  document_type public.document_type not null,
  file_url text not null,
  uploaded_at timestamptz not null default now(),
  unique(driver_id, document_type)
);

alter table public.drivers enable row level security;
alter table public.vehicles enable row level security;
alter table public.documents enable row level security;

create policy "drivers own profile" on public.drivers for all using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id);
create policy "drivers own vehicle" on public.vehicles for all using (driver_id in (select id from public.drivers where auth_user_id = auth.uid())) with check (driver_id in (select id from public.drivers where auth_user_id = auth.uid()));
create policy "drivers own documents" on public.documents for all using (driver_id in (select id from public.drivers where auth_user_id = auth.uid())) with check (driver_id in (select id from public.drivers where auth_user_id = auth.uid()));

insert into storage.buckets (id, name, public) values ('driver-documents', 'driver-documents', false) on conflict (id) do nothing;
create policy "drivers upload own documents" on storage.objects for insert to authenticated with check (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "drivers read own documents" on storage.objects for select to authenticated using (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "drivers update own documents" on storage.objects for update to authenticated using (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "drivers delete own documents" on storage.objects for delete to authenticated using (bucket_id = 'driver-documents' and (storage.foldername(name))[1] = auth.uid()::text);

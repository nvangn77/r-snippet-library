-- ============================================================
-- R Snippet Library — Supabase schema, moderation rules, backups
-- Run this once in the Supabase SQL editor (it is idempotent).
-- ============================================================

-- 1. Snippets table (mirrors the app's object shape) -----------
create table if not exists public.snippets (
  id           uuid primary key default gen_random_uuid(),
  category     text not null,
  title        text not null,
  description  text default '',
  code         text not null,
  tags         text[] default '{}',
  preview_type text,
  status       text not null default 'pending'
                 check (status in ('pending','approved','rejected')),
  submitted_by text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index if not exists snippets_status_idx   on public.snippets(status);
create index if not exists snippets_category_idx on public.snippets(category);

-- 2. Moderator allow-list -------------------------------------
-- Only these emails can approve / edit / delete. RLS is on with
-- no policies, so the table is NOT directly readable by clients;
-- the security-definer function below is the only way in.
create table if not exists public.moderators (
  email text primary key
);
alter table public.moderators enable row level security;

create or replace function public.is_moderator()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.moderators
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
grant execute on function public.is_moderator() to anon, authenticated;

-- 3. Force every public submission into the 'pending' queue ----
-- Moderators may insert directly as approved; everyone else is
-- forced to 'pending' regardless of what the client sends.
create or replace function public.force_status()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_moderator() then
    new.status := 'pending';
  elsif new.status is null then
    new.status := 'approved';
  end if;
  new.created_at := coalesce(new.created_at, now());
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_force_status on public.snippets;
create trigger trg_force_status
  before insert on public.snippets
  for each row execute function public.force_status();

create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end;
$$;
drop trigger if exists trg_touch_updated on public.snippets;
create trigger trg_touch_updated
  before update on public.snippets
  for each row execute function public.touch_updated_at();

-- 4. Row-Level Security: the moderation rules -----------------
alter table public.snippets enable row level security;

drop policy if exists "read approved or moderator" on public.snippets;
create policy "read approved or moderator" on public.snippets
  for select to anon, authenticated
  using (status = 'approved' or public.is_moderator());

drop policy if exists "anyone can submit" on public.snippets;
create policy "anyone can submit" on public.snippets
  for insert to anon, authenticated
  with check (true);                 -- trigger forces status='pending'

drop policy if exists "moderators update" on public.snippets;
create policy "moderators update" on public.snippets
  for update to authenticated
  using (public.is_moderator()) with check (public.is_moderator());

drop policy if exists "moderators delete" on public.snippets;
create policy "moderators delete" on public.snippets
  for delete to authenticated
  using (public.is_moderator());

-- 5. Make yourself a moderator --------------------------------
-- Replace with the email you will sign in with, then re-run:
--   insert into public.moderators (email) values ('you@example.com')
--   on conflict do nothing;

-- 6. Seeding the 72 default snippets --------------------------
-- Easiest path: open the deployed site, sign in as a moderator,
-- and click "Publish the 72 default snippets" on the empty state.

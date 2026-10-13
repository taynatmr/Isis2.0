-- ISIS 2.0 — configuração do Supabase
-- Cole TUDO no SQL Editor do Supabase e clique em "Run". Pode rodar mais de uma vez sem problema.

-- 1) Tabela: uma linha por usuário, com todos os dados do app
create table if not exists public.user_data (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 2) Segurança (RLS): cada pessoa só enxerga e altera a PRÓPRIA linha
alter table public.user_data enable row level security;

drop policy if exists "user_data_select_own" on public.user_data;
drop policy if exists "user_data_insert_own" on public.user_data;
drop policy if exists "user_data_update_own" on public.user_data;
drop policy if exists "user_data_delete_own" on public.user_data;

create policy "user_data_select_own" on public.user_data for select to authenticated using (auth.uid() = user_id);
create policy "user_data_insert_own" on public.user_data for insert to authenticated with check (auth.uid() = user_id);
create policy "user_data_update_own" on public.user_data for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "user_data_delete_own" on public.user_data for delete to authenticated using (auth.uid() = user_id);

-- 3) Bucket privado para anexos (exames, documentos, comprovantes...)
insert into storage.buckets (id, name, public)
values ('anexos', 'anexos', false)
on conflict (id) do nothing;

-- 4) Cada pessoa só acessa a própria pasta (<id do usuário>/<arquivo>) dentro do bucket
drop policy if exists "anexos_select_own" on storage.objects;
drop policy if exists "anexos_insert_own" on storage.objects;
drop policy if exists "anexos_update_own" on storage.objects;
drop policy if exists "anexos_delete_own" on storage.objects;

create policy "anexos_select_own" on storage.objects for select to authenticated
  using (bucket_id = 'anexos' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "anexos_insert_own" on storage.objects for insert to authenticated
  with check (bucket_id = 'anexos' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "anexos_update_own" on storage.objects for update to authenticated
  using (bucket_id = 'anexos' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "anexos_delete_own" on storage.objects for delete to authenticated
  using (bucket_id = 'anexos' and (storage.foldername(name))[1] = auth.uid()::text);

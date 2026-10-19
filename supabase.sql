-- =====================================================================
--  Meu dinheiro — instalação no Supabase
--
--  Rode este arquivo UMA vez, no SQL Editor do seu projeto
--  (menu lateral -> SQL Editor -> New query -> colar -> Run).
--
--  Ele cria uma tabela só para este app. Nada do que você já tem
--  no projeto é tocado.
-- =====================================================================

create table if not exists public.meu_dinheiro_estado (
  usuario_id    uuid        primary key references auth.users (id) on delete cascade,
  dados         jsonb       not null default '{}'::jsonb,
  versao        bigint      not null default 1,
  dispositivo   text,
  atualizado_em timestamptz not null default now()
);

comment on table  public.meu_dinheiro_estado is
  'Um registro por pessoa: o estado completo do app em JSON.';
comment on column public.meu_dinheiro_estado.versao is
  'Sobe de 1 em 1 a cada gravação. É o que impede um aparelho de apagar o que o outro acabou de salvar.';


-- ---------------------------------------------------------------------
--  Trancar o acesso: cada pessoa só enxerga a própria linha
-- ---------------------------------------------------------------------
alter table public.meu_dinheiro_estado enable row level security;

drop policy if exists "dono le"     on public.meu_dinheiro_estado;
drop policy if exists "dono insere" on public.meu_dinheiro_estado;
drop policy if exists "dono altera" on public.meu_dinheiro_estado;
drop policy if exists "dono apaga"  on public.meu_dinheiro_estado;

create policy "dono le" on public.meu_dinheiro_estado
  for select using (auth.uid() = usuario_id);

create policy "dono insere" on public.meu_dinheiro_estado
  for insert with check (auth.uid() = usuario_id);

create policy "dono altera" on public.meu_dinheiro_estado
  for update using (auth.uid() = usuario_id)
          with check (auth.uid() = usuario_id);

create policy "dono apaga" on public.meu_dinheiro_estado
  for delete using (auth.uid() = usuario_id);


-- ---------------------------------------------------------------------
--  Rede de segurança: a versão nunca anda para trás, e a data de
--  atualização é sempre a do servidor (não a do relógio do celular).
-- ---------------------------------------------------------------------
create or replace function public.meu_dinheiro_guarda()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'UPDATE' and new.versao <= old.versao then
    raise exception 'A versao precisa aumentar (gravada %, enviada %).', old.versao, new.versao;
  end if;
  new.atualizado_em := now();
  return new;
end;
$$;

drop trigger if exists meu_dinheiro_guarda_trg on public.meu_dinheiro_estado;
create trigger meu_dinheiro_guarda_trg
  before insert or update on public.meu_dinheiro_estado
  for each row execute function public.meu_dinheiro_guarda();


-- =====================================================================
--  Pronto. Depois disso:
--
--  1. Authentication -> Sign In / Providers -> Email
--     Se quiser criar a conta e já entrar na hora, desligue
--     "Confirm email". Deixando ligado, o Supabase manda um e-mail
--     de confirmação antes do primeiro acesso.
--
--  2. Project Settings -> API
--     Copie "Project URL" e a chave "anon public" para o config.js.
-- =====================================================================

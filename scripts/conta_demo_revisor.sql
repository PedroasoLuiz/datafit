-- ============================================================================
-- Conta de demonstracao para o revisor da Apple / Google
--
--   Personal : app.datafit@gmail.com
--   Aluno    : ryaaancruzz@icloud.com   (vinculado ao personal acima)
--
-- PRE-REQUISITO: os dois usuarios ja devem existir em Authentication > Users
-- do Supabase (criados pelo Dashboard, com "Auto Confirm User" marcado).
-- Nao da para cria-los por SQL: a senha precisa do hash do GoTrue.
--
-- Este script e IDEMPOTENTE: pode rodar mais de uma vez sem duplicar nada.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- ETAPA 1 — VERIFICACAO (rodar SOZINHA primeiro e conferir a saida)
--
-- O DATABASE.md esta desatualizado em alguns pontos (ex.: afirma que Perfis tem
-- "TelefonesId", coluna que NAO existe). Confira o que aparece aqui antes de
-- rodar a Etapa 2.
-- ----------------------------------------------------------------------------

-- 1a. Os dois usuarios existem na auth?
select id, email, email_confirmed_at
from auth.users
where email in ('app.datafit@gmail.com', 'ryaaancruzz@icloud.com');
-- Esperado: 2 linhas, ambas com email_confirmed_at preenchido.
-- Se vier menos de 2, PARE: crie os usuarios no Dashboard primeiro.

-- 1b. Colunas reais de Perfis
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'public' and table_name = 'Perfis'
order by ordinal_position;

-- 1c. Colunas reais de PersonalAlunos
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'public' and table_name = 'PersonalAlunos'
order by ordinal_position;

-- 1d. Confirmar os IDs de TiposPerfil (esperado: Aluno=1, Personal=2, Admin=3)
select * from "TiposPerfil" order by "Id";

-- 1e. Ja existe algum Perfil para esses emails? (evita duplicar)
select p."idUser", p."Nome", p."TiposPerfilId", u.email
from "Perfis" p
join auth.users u on u.id = p."idUser"
where u.email in ('app.datafit@gmail.com', 'ryaaancruzz@icloud.com');


-- ----------------------------------------------------------------------------
-- ETAPA 2 — CRIACAO (rodar so depois de conferir a Etapa 1)
-- ----------------------------------------------------------------------------

do $$
declare
  v_personal_id uuid;
  v_aluno_id    uuid;
begin
  -- Resolve os UUIDs a partir dos emails
  select id into v_personal_id from auth.users where email = 'app.datafit@gmail.com';
  select id into v_aluno_id    from auth.users where email = 'ryaaancruzz@icloud.com';

  if v_personal_id is null then
    raise exception 'Usuario PERSONAL (app.datafit@gmail.com) nao existe em auth.users. Crie no Dashboard primeiro.';
  end if;
  if v_aluno_id is null then
    raise exception 'Usuario ALUNO (ryaaancruzz@icloud.com) nao existe em auth.users. Crie no Dashboard primeiro.';
  end if;

  -- ---- Perfil do PERSONAL ----
  -- ATENCAO: no banco real Personal = 1 e Aluno = 2 (o DATABASE.md dizia o
  -- inverso). Resolvido por Descricao para nao depender do id.
  insert into "Perfis" ("idUser", "Nome", "NickName", "TiposPerfilId", "Ativo", "IsDeleted")
  values (v_personal_id, 'Datafit Demo', 'datafitdemo',
          (select "Id" from "TiposPerfil" where "Descricao" = 'Personal' limit 1),
          true, false)
  on conflict ("idUser") do update
    set "Nome"          = excluded."Nome",
        "TiposPerfilId" = excluded."TiposPerfilId",
        "Ativo"         = true,
        "IsDeleted"     = false;

  -- ---- Perfil do ALUNO ----
  insert into "Perfis" ("idUser", "Nome", "NickName", "TiposPerfilId", "Ativo", "IsDeleted")
  values (v_aluno_id, 'Ryan Cruz', 'ryancruz',
          (select "Id" from "TiposPerfil" where "Descricao" = 'Aluno' limit 1),
          true, false)
  on conflict ("idUser") do update
    set "Nome"          = excluded."Nome",
        "TiposPerfilId" = excluded."TiposPerfilId",
        "Ativo"         = true,
        "IsDeleted"     = false;

  -- ---- Vinculo Personal <-> Aluno ----
  -- Regra do CLAUDE.md: o vinculo ATIVO e o que tem
  -- StatusConvite = 'aceito' AND Ativo = true.
  -- Ja criamos direto como 'aceito' para o revisor nao precisar aceitar convite.

  -- Desativa qualquer vinculo anterior deste aluno com OUTRO personal
  update "PersonalAlunos"
     set "Ativo"          = false,
         "StatusConvite"  = 'substituido',
         "DataDesvinculo" = (now() at time zone 'America/Sao_Paulo')::date
   where "AlunoPerfisId" = v_aluno_id
     and "PersonalPerfisId" <> v_personal_id
     and "Ativo" = true;

  -- Cria o vinculo, ou reativa se ja existir
  if exists (
    select 1 from "PersonalAlunos"
     where "AlunoPerfisId" = v_aluno_id
       and "PersonalPerfisId" = v_personal_id
  ) then
    update "PersonalAlunos"
       set "Ativo"          = true,
           "StatusConvite"  = 'aceito',
           "DataDesvinculo" = null,
           "DataVinculo"    = coalesce("DataVinculo", (now() at time zone 'America/Sao_Paulo')::date)
     where "AlunoPerfisId" = v_aluno_id
       and "PersonalPerfisId" = v_personal_id;
    raise notice 'Vinculo ja existia -- reativado como aceito.';
  else
    insert into "PersonalAlunos"
      ("PersonalPerfisId", "AlunoPerfisId", "Ativo", "DataVinculo", "StatusConvite")
    values
      (v_personal_id, v_aluno_id, true, (now() at time zone 'America/Sao_Paulo')::date, 'aceito');
    raise notice 'Vinculo criado.';
  end if;

  raise notice 'OK. Personal=% / Aluno=%', v_personal_id, v_aluno_id;
end $$;


-- ----------------------------------------------------------------------------
-- ETAPA 3 — CONFERENCIA FINAL
-- ----------------------------------------------------------------------------

select
  up.email               as personal_email,
  pp."Nome"              as personal_nome,
  pp."TiposPerfilId"     as personal_tipo,
  ua.email               as aluno_email,
  pa_perfil."Nome"       as aluno_nome,
  pa_perfil."TiposPerfilId" as aluno_tipo,
  pa."StatusConvite",
  pa."Ativo",
  pa."DataVinculo"
from "PersonalAlunos" pa
join "Perfis" pp        on pp."idUser" = pa."PersonalPerfisId"
join "Perfis" pa_perfil on pa_perfil."idUser" = pa."AlunoPerfisId"
join auth.users up      on up.id = pa."PersonalPerfisId"
join auth.users ua      on ua.id = pa."AlunoPerfisId"
where up.email = 'app.datafit@gmail.com'
  and ua.email = 'ryaaancruzz@icloud.com';
-- Esperado: 1 linha, StatusConvite = 'aceito', Ativo = true,
-- personal_tipo = 2, aluno_tipo = 1.

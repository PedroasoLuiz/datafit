-- =====================================================================
-- Datafit — Exclusao de conta iniciada pelo usuario
-- Apple App Store Guideline 5.1.1(v): apps que permitem criar conta
-- precisam permitir excluir a conta de dentro do proprio app.
--
-- Estrategia escolhida: ANONIMIZAR + SOFT DELETE
--   - o registro em Perfis permanece (nao quebra FKs nem historico do
--     personal), mas os dados pessoais sao substituidos
--   - vinculos em PersonalAlunos sao encerrados
--   - o login e revogado (auth.users recebe email/senha inutilizaveis)
--
-- !!! ATENCAO !!!
-- Este arquivo foi escrito a partir do DATABASE.md, SEM acesso de leitura
-- ao banco (o MCP do Supabase estava sem permissao na sessao em que foi
-- gerado). ANTES DE APLICAR, confira:
--   1. Perfis realmente NAO tem coluna "IsDeleted" (o doc indica que nao;
--      se tiver, use-a em vez de depender so de "Ativo")
--   2. os nomes das colunas de PersonalAlunos e Telefones
--   3. rode primeiro o bloco de VERIFICACAO no fim do arquivo
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Coluna de marcacao (idempotente)
-- ---------------------------------------------------------------------
ALTER TABLE public."Perfis"
  ADD COLUMN IF NOT EXISTS "ExcluidoEm" timestamptz;

COMMENT ON COLUMN public."Perfis"."ExcluidoEm" IS
  'Preenchido quando o usuario exclui a propria conta pelo app. NULL = conta ativa.';

-- ---------------------------------------------------------------------
-- 2. RPC de exclusao
-- ---------------------------------------------------------------------
-- SECURITY DEFINER porque precisa escrever em auth.users.
-- VOLATILE (default) — funcao STABLE nao consegue gravar (ver RULES.md).
CREATE OR REPLACE FUNCTION public.excluir_minha_conta()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  v_uid          uuid := auth.uid();
  v_tipo_perfil  bigint;
  v_alunos_ativos int := 0;
  v_sufixo       text;
BEGIN
  IF v_uid IS NULL THEN
    RETURN jsonb_build_object('sucesso', false, 'erro', 'NAO_AUTENTICADO');
  END IF;

  SELECT "TiposPerfilId" INTO v_tipo_perfil
  FROM public."Perfis"
  WHERE "idUser" = v_uid;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('sucesso', false, 'erro', 'PERFIL_NAO_ENCONTRADO');
  END IF;

  -- Personal com alunos ativos: bloqueia e explica, para nao deixar alunos orfaos.
  IF v_tipo_perfil = 2 THEN
    SELECT count(*) INTO v_alunos_ativos
    FROM public."PersonalAlunos"
    WHERE "PersonalPerfisId" = v_uid
      AND "StatusConvite" = 'aceito'
      AND "Ativo" = true;

    IF v_alunos_ativos > 0 THEN
      RETURN jsonb_build_object(
        'sucesso', false,
        'erro', 'POSSUI_ALUNOS_ATIVOS',
        'alunosAtivos', v_alunos_ativos
      );
    END IF;
  END IF;

  v_sufixo := replace(v_uid::text, '-', '');

  -- 2.1 Encerra vinculos (dos dois lados: o usuario pode ser aluno ou personal)
  UPDATE public."PersonalAlunos"
     SET "Ativo" = false,
         "DataDesvinculo" = (now() AT TIME ZONE 'America/Sao_Paulo')::date
   WHERE ("AlunoPerfisId" = v_uid OR "PersonalPerfisId" = v_uid)
     AND "Ativo" = true;

  -- 2.2 Anonimiza o perfil
  UPDATE public."Perfis"
     SET "Nome"          = 'Usuario removido',
         "NickName"      = 'removido_' || left(v_sufixo, 12),
         "UrlImgPerfil"  = NULL,
         "Ativo"         = false,
         "ExcluidoEm"    = now() AT TIME ZONE 'America/Sao_Paulo'
   WHERE "idUser" = v_uid;

  -- 2.3 Anonimiza telefone (se houver vinculo)
  UPDATE public."Telefones" t
     SET "Numero"     = NULL,
         "IsWhatsApp" = false,
         "Ativo"      = false
   FROM public."Perfis" p
  WHERE p."idUser" = v_uid
    AND t."Id" = p."TelefonesId";

  -- 2.4 Revoga o login. Nao apagamos a linha de auth.users para nao
  --     cascatear em FKs; tornamos as credenciais inutilizaveis.
  UPDATE auth.users
     SET email             = 'removido+' || v_sufixo || '@datafit.invalid',
         phone             = NULL,
         encrypted_password = '',
         email_confirmed_at = NULL,
         raw_user_meta_data = '{}'::jsonb,
         banned_until      = 'infinity'
   WHERE id = v_uid;

  -- 2.5 Encerra sessoes ativas
  DELETE FROM auth.sessions  WHERE user_id = v_uid;
  DELETE FROM auth.refresh_tokens WHERE user_id = v_uid::text;

  RETURN jsonb_build_object('sucesso', true, 'excluidoEm', now());
END;
$$;

REVOKE ALL ON FUNCTION public.excluir_minha_conta() FROM public, anon;
GRANT EXECUTE ON FUNCTION public.excluir_minha_conta() TO authenticated;

COMMENT ON FUNCTION public.excluir_minha_conta() IS
  'Exclusao de conta iniciada pelo proprio usuario (App Store 5.1.1(v)). '
  'Anonimiza Perfis/Telefones, encerra vinculos e revoga o login. '
  'Retorna {sucesso:bool, erro?:text, alunosAtivos?:int}.';

-- =====================================================================
-- BLOCO DE VERIFICACAO — rode ANTES de aplicar o resto
-- =====================================================================
-- Confirma nomes de coluna usados acima:
--
-- SELECT table_name, column_name
--   FROM information_schema.columns
--  WHERE table_schema='public'
--    AND table_name IN ('Perfis','PersonalAlunos','Telefones')
--  ORDER BY table_name, ordinal_position;
--
-- Confirma que nao ha overload conflitante (ver RULES.md):
--
-- SELECT pg_get_function_arguments(oid)
--   FROM pg_proc WHERE proname = 'excluir_minha_conta';
--
-- Teste com a aluna de teste (NAO rodar em conta real):
--   Maria Miranda ad2b23a6-c484-48ab-b3e9-d60b7665add4
-- =====================================================================

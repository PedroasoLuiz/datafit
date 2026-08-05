-- ====================================================================
-- PASSO 2 de 2 — APLICAR (este MUDA o banco)
--
-- Cole no SQL Editor do Supabase e clique em RUN.
-- Depois me mande o que apareceu.
--
-- Corrigido em 04/08/2026 com base no resultado da verificação:
--   * Telefones é ligado por Telefones.PerfisId (a versão antiga usava
--     um Perfis.TelefonesId que NÃO existe — quebraria em produção)
--   * Perfis TEM coluna IsDeleted — agora é marcada
--   * Cpf / ChavePix / TipoPix / Bio / DataNascimento também são apagados
-- ====================================================================

-- 1. Coluna de marcação (pode rodar quantas vezes quiser)
ALTER TABLE public."Perfis"
  ADD COLUMN IF NOT EXISTS "ExcluidoEm" timestamptz;

COMMENT ON COLUMN public."Perfis"."ExcluidoEm" IS
  'Preenchido quando o usuario exclui a propria conta pelo app. NULL = conta ativa.';

-- 2. A função de exclusão
CREATE OR REPLACE FUNCTION public.excluir_minha_conta()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  v_uid           uuid := auth.uid();
  v_tipo_perfil   bigint;
  v_alunos_ativos int := 0;
  v_sufixo        text;
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

  -- Personal com alunos ativos: bloqueia, para nao deixar alunos orfaos.
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

  -- 2.1 Encerra vinculos dos dois lados (usuario pode ser aluno ou personal)
  UPDATE public."PersonalAlunos"
     SET "Ativo" = false,
         "DataDesvinculo" = (now() AT TIME ZONE 'America/Sao_Paulo')::date
   WHERE ("AlunoPerfisId" = v_uid OR "PersonalPerfisId" = v_uid)
     AND "Ativo" = true;

  -- 2.2 Anonimiza o perfil.
  -- Cpf e ChavePix sao dado pessoal sensivel — LGPD exige remover.
  UPDATE public."Perfis"
     SET "Nome"           = 'Usuario removido',
         "NickName"       = 'removido_' || left(v_sufixo, 12),
         "UrlImgPerfil"   = NULL,
         "Cpf"            = NULL,
         "Bio"            = NULL,
         "Cref"           = NULL,
         "Unidade"        = NULL,
         "ChavePix"       = NULL,
         "TipoPix"        = NULL,
         "DataNascimento" = NULL,
         "Ativo"          = false,
         "IsDeleted"      = true,
         "ExcluidoEm"     = now() AT TIME ZONE 'America/Sao_Paulo'
   WHERE "idUser" = v_uid;

  -- 2.3 Anonimiza telefone(s).
  -- CORRIGIDO: o vinculo e Telefones.PerfisId -> Perfis.idUser.
  UPDATE public."Telefones"
     SET "Numero"     = NULL,
         "IsWhatsApp" = false,
         "Ativo"      = false
   WHERE "PerfisId" = v_uid;

  -- 2.4 Revoga o login. Nao apagamos a linha de auth.users para nao
  --     cascatear em FKs; tornamos as credenciais inutilizaveis.
  UPDATE auth.users
     SET email              = 'removido+' || v_sufixo || '@datafit.invalid',
         phone              = NULL,
         encrypted_password = '',
         email_confirmed_at = NULL,
         raw_user_meta_data = '{}'::jsonb,
         banned_until       = 'infinity'
   WHERE id = v_uid;

  -- 2.5 Encerra sessoes ativas
  DELETE FROM auth.sessions       WHERE user_id = v_uid;
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

-- 3. Confirma que criou (tem que aparecer 1 linha)
SELECT proname AS funcao_criada,
       pg_get_function_arguments(oid) AS argumentos
  FROM pg_proc
 WHERE proname = 'excluir_minha_conta';

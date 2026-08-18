-- Feedback do app (aplicado em 18/08/2026)
--
-- O que a pessoa acha do Datafit em si. Nao confundir com "AvaliacoesPersonal",
-- que e a nota do aluno ao seu personal e e publica no perfil dele. O que chega
-- aqui e privado: so volta para quem escreveu e para a triagem por SQL.
--
-- Leitura de rotina: SELECT * FROM public.vw_feedbacks_app WHERE status = 'novo';

CREATE TABLE IF NOT EXISTS public."FeedbacksApp" (
  "Id"          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "PerfisId"    uuid NOT NULL REFERENCES public."Perfis"("idUser") ON DELETE CASCADE,
  "Tipo"        varchar NOT NULL,
  "Nota"        smallint,
  "Mensagem"    text NOT NULL,
  "Contato"     varchar,
  "Plataforma"  varchar,
  "VersaoApp"   varchar,
  "Status"      varchar NOT NULL DEFAULT 'novo',
  "NotaInterna" text,
  "IsDeleted"   boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT feedback_tipo_valido CHECK ("Tipo" IN ('sugestao','problema','elogio','outro')),
  CONSTRAINT feedback_nota_valida CHECK ("Nota" IS NULL OR ("Nota" BETWEEN 1 AND 5)),
  CONSTRAINT feedback_status_valido CHECK ("Status" IN ('novo','lido','respondido','arquivado')),
  CONSTRAINT feedback_mensagem_nao_vazia CHECK (btrim("Mensagem") <> '')
);

CREATE INDEX IF NOT EXISTS idx_feedbacks_app_triagem
  ON public."FeedbacksApp" ("Status", created_at DESC)
  WHERE "IsDeleted" = false;

CREATE INDEX IF NOT EXISTS idx_feedbacks_app_pessoa
  ON public."FeedbacksApp" ("PerfisId", created_at DESC)
  WHERE "IsDeleted" = false;

ALTER TABLE public."FeedbacksApp" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS feedbacks_app_leitura_propria ON public."FeedbacksApp";
CREATE POLICY feedbacks_app_leitura_propria ON public."FeedbacksApp"
  FOR SELECT USING ("PerfisId" = auth.uid());

DROP POLICY IF EXISTS feedbacks_app_escrita_propria ON public."FeedbacksApp";
CREATE POLICY feedbacks_app_escrita_propria ON public."FeedbacksApp"
  FOR INSERT WITH CHECK ("PerfisId" = auth.uid());

-- Envio. Teto de 5 por dia por pessoa: sem ele, um toque repetido no visto
-- enche a caixa de triagem e o sinal se perde no volume.
CREATE OR REPLACE FUNCTION public.enviar_feedback_app(
  p_tipo       varchar,
  p_mensagem   text,
  p_nota       smallint DEFAULT NULL,
  p_contato    varchar  DEFAULT NULL,
  p_plataforma varchar  DEFAULT NULL,
  p_versao     varchar  DEFAULT NULL
) RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_pessoa uuid := auth.uid();
  v_hoje   int;
  v_id     bigint;
BEGIN
  IF v_pessoa IS NULL THEN
    RETURN json_build_object('sucesso', false, 'erro', 'SEM_SESSAO');
  END IF;

  IF p_tipo IS NULL OR p_tipo NOT IN ('sugestao','problema','elogio','outro') THEN
    RETURN json_build_object('sucesso', false, 'erro', 'TIPO_INVALIDO');
  END IF;

  IF p_mensagem IS NULL OR btrim(p_mensagem) = '' THEN
    RETURN json_build_object('sucesso', false, 'erro', 'MENSAGEM_VAZIA');
  END IF;

  IF p_nota IS NOT NULL AND (p_nota < 1 OR p_nota > 5) THEN
    RETURN json_build_object('sucesso', false, 'erro', 'NOTA_INVALIDA');
  END IF;

  SELECT count(*) INTO v_hoje
  FROM public."FeedbacksApp"
  WHERE "PerfisId" = v_pessoa
    AND COALESCE("IsDeleted", false) = false
    AND DATE(created_at AT TIME ZONE 'America/Sao_Paulo')
      = DATE(NOW() AT TIME ZONE 'America/Sao_Paulo');

  IF v_hoje >= 5 THEN
    RETURN json_build_object('sucesso', false, 'erro', 'LIMITE_DIARIO');
  END IF;

  INSERT INTO public."FeedbacksApp"
    ("PerfisId", "Tipo", "Nota", "Mensagem", "Contato", "Plataforma", "VersaoApp")
  VALUES
    (v_pessoa,
     p_tipo,
     p_nota,
     btrim(p_mensagem),
     NULLIF(btrim(p_contato), ''),
     NULLIF(btrim(p_plataforma), ''),
     NULLIF(btrim(p_versao), ''))
  RETURNING "Id" INTO v_id;

  RETURN json_build_object('sucesso', true, 'id', v_id);
END;
$$;

-- Os envios da propria pessoa, do mais novo para o mais antigo. O status e o
-- que evita a pergunta "sera que chegou?" e o reenvio do mesmo texto.
CREATE OR REPLACE FUNCTION public.meus_feedbacks_app()
RETURNS json
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    json_agg(
      json_build_object(
        'id',        f."Id",
        'tipo',      f."Tipo",
        'nota',      f."Nota",
        'mensagem',  f."Mensagem",
        'status',    f."Status",
        'criadoEm',  to_char(f.created_at AT TIME ZONE 'America/Sao_Paulo', 'DD/MM/YYYY')
      )
      ORDER BY f.created_at DESC
    ),
    '[]'::json
  )
  FROM public."FeedbacksApp" f
  WHERE f."PerfisId" = auth.uid()
    AND COALESCE(f."IsDeleted", false) = false;
$$;

GRANT EXECUTE ON FUNCTION public.enviar_feedback_app(varchar, text, smallint, varchar, varchar, varchar) TO authenticated;
GRANT EXECUTE ON FUNCTION public.meus_feedbacks_app() TO authenticated;

-- Triagem, para o SQL editor. Sem GRANT para anon/authenticated: a view roda
-- com os direitos do dono e passaria por cima do RLS da tabela.
CREATE OR REPLACE VIEW public.vw_feedbacks_app AS
SELECT
  f."Id"                                                    AS id,
  to_char(f.created_at AT TIME ZONE 'America/Sao_Paulo',
          'DD/MM/YYYY HH24:MI')                             AS quando,
  f."Status"                                                AS status,
  f."Tipo"                                                  AS tipo,
  f."Nota"                                                  AS nota,
  f."Mensagem"                                              AS mensagem,
  f."Contato"                                               AS contato,
  f."Plataforma"                                            AS plataforma,
  f."VersaoApp"                                             AS versao,
  p."Nome"                                                  AS pessoa,
  CASE t."Descricao" WHEN 'Personal' THEN 'Personal'
                     WHEN 'Aluno'    THEN 'Aluno'
                     ELSE t."Descricao" END                 AS papel,
  f."PerfisId"                                              AS perfil_uuid,
  f."NotaInterna"                                           AS nota_interna
FROM public."FeedbacksApp" f
LEFT JOIN public."Perfis" p      ON p."idUser" = f."PerfisId"
LEFT JOIN public."TiposPerfil" t ON t."Id"     = p."TiposPerfilId"
WHERE COALESCE(f."IsDeleted", false) = false
ORDER BY f.created_at DESC;

REVOKE ALL ON public.vw_feedbacks_app FROM anon, authenticated;

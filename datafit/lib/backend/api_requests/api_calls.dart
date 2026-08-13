import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_commons/api_requests/api_manager.dart';

import 'package:ff_commons/api_requests/api_paging_params.dart';

export 'package:ff_commons/api_requests/api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Perfil Group Code

class PerfilGroup {
  static String getBaseUrl({
    String? apikey,
    String? project,
  }) {
    apikey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    return 'https://${project}.supabase.co/rest/v1/rpc';
  }

  static Map<String, String> headers = {
    'apikey': '[apikey]',
    'Authorization': 'Bearer [apikey]',
  };
  static PerfilCall perfilCall = PerfilCall();
  static GetNotificacoesCall getNotificacoesCall = GetNotificacoesCall();
  static MarcarNotiComoLidaCall marcarNotiComoLidaCall =
      MarcarNotiComoLidaCall();
  static CriarNotificacaoCall criarNotificacaoCall = CriarNotificacaoCall();
  static GetCamposPersonalizadosCall getCamposPersonalizadosCall =
      GetCamposPersonalizadosCall();
  static UpsertCampoPersonalizadoCall upsertCampoPersonalizadoCall =
      UpsertCampoPersonalizadoCall();
  static DeleteCampoPersonalizadoCall deleteCampoPersonalizadoCall =
      DeleteCampoPersonalizadoCall();
}

class PerfilCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? apikey,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PerfilGroup.getBaseUrl(
      apikey: apikey,
      project: project,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'perfil',
      apiUrl: '${baseUrl}/get_perfil_by_id',
      callType: ApiCallType.GET,
      headers: {
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {
        'p_user_uuid': pUserId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? usuarioid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].usuario_id''',
      ));
  String? createdat(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].created_at''',
      ));
  String? nomecompleto(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].nome_completo''',
      ));
  String? email(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].email''',
      ));
  bool? inativo(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].inativo''',
      ));
  String? foto(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].foto_url''',
      ));
  int? tipouser(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].tipouser''',
      ));
  String? nikname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].nikname''',
      ));
  int? perfilid(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].perfil_id''',
      ));
  String? nome(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].nome''',
      ));
  String? nascimento(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].nascimento''',
      ));
  String? tel(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].telefone''',
      ));
  bool? what(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].whatsapp''',
      ));
  String? bio(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].bio''',
      ));
  String? cpf(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].cpf''',
      ));
  String? tipoperfil(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].perfil_tipo''',
      ));
  String? cref(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].cref''',
      ));
  int? pesoatual(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].pesoatual''',
      ));
  String? altura(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].altura''',
      ));
}

class GetNotificacoesCall {
  Future<ApiCallResponse> call({
    String? user = '',
    String? apikey,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PerfilGroup.getBaseUrl(
      apikey: apikey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_user_uuid": "${escapeStringForJson(user)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get notificacoes',
      apiUrl: '${baseUrl}/get_notificacoes',
      callType: ApiCallType.POST,
      headers: {
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarcarNotiComoLidaCall {
  Future<ApiCallResponse> call({
    int? notificacaoId,
    String? user = '',
    String? apikey,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PerfilGroup.getBaseUrl(
      apikey: apikey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_notificacao_id": ${notificacaoId},
  "p_user_uuid": "${escapeStringForJson(user)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'marcar noti como lida',
      apiUrl: '${baseUrl}/marcar_notificacao_lida',
      callType: ApiCallType.POST,
      headers: {
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CriarNotificacaoCall {
  Future<ApiCallResponse> call({
    String? destinatario = '',
    String? remetente = '',
    String? titulo = '',
    String? descricao = '',
    String? tag = '',
    String? apikey,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PerfilGroup.getBaseUrl(
      apikey: apikey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_destinatario_uuid": "${escapeStringForJson(destinatario)}",
  "p_remetente_uuid": "${escapeStringForJson(remetente)}",
  "p_titulo": "${escapeStringForJson(titulo)}",
  "p_descricao": "${escapeStringForJson(descricao)}",
  "p_tag": "${escapeStringForJson(tag)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'criar notificacao',
      apiUrl: '${baseUrl}/criar_notificacao',
      callType: ApiCallType.POST,
      headers: {
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Perfil Group Code

/// Start CRUD usuario Group Code

class CRUDUsuarioGroup {
  static String getBaseUrl({
    String? apikey,
    String? project,
  }) {
    apikey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    return 'https://${project}.supabase.co';
  }

  static Map<String, String> headers = {
    'apikey': '[apikey]',
    'Authorization': 'Bearer [apikey]',
  };
  static CriarusuarioCall criarusuarioCall = CriarusuarioCall();
}

class CriarusuarioCall {
  Future<ApiCallResponse> call({
    String? email = '',
    String? senha = '',
    String? apikey,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = CRUDUsuarioGroup.getBaseUrl(
      apikey: apikey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "email": "${escapeStringForJson(email)}",
  "password": "${escapeStringForJson(senha)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'criarusuario',
      apiUrl: '${baseUrl}/auth/v1/signup',
      callType: ApiCallType.POST,
      headers: {
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? id(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.id''',
      ));
}

/// End CRUD usuario Group Code

/// Start Personal Group Code

class PersonalGroup {
  static String getBaseUrl({
    String? apiKey,
    String? project,
  }) {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    return 'https://${project}.supabase.co/rest/v1/rpc/';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'apikey': '[apiKey]',
    'Authorization': 'Bearer [apiKey]',
  };
  static AlunosCall alunosCall = AlunosCall();
  static PagamentosCall pagamentosCall = PagamentosCall();
  static VerificarCadastroAlunoCall verificarCadastroAlunoCall =
      VerificarCadastroAlunoCall();
  static GetPerfilAlunoCall getPerfilAlunoCall = GetPerfilAlunoCall();
  static StatusAlunoCall statusAlunoCall = StatusAlunoCall();
  static InsertPgtoAlunoCall insertPgtoAlunoCall = InsertPgtoAlunoCall();
  static UpdatePgtoAlunoCall updatePgtoAlunoCall = UpdatePgtoAlunoCall();
  static DeletePgtoCall deletePgtoCall = DeletePgtoCall();
  static GetTreinosPersonalCall getTreinosPersonalCall =
      GetTreinosPersonalCall();
  static UpsertTreinoCall upsertTreinoCall = UpsertTreinoCall();
  static ToggleAlunoAtivoCall toggleAlunoAtivoCall = ToggleAlunoAtivoCall();
  static EnviarConvitePersonalCall enviarConvitePersonalCall =
      EnviarConvitePersonalCall();
  static ConfirmarPagamentoCall confirmarPagamentoCall =
      ConfirmarPagamentoCall();
}

class AlunosCall {
  Future<ApiCallResponse> call({
    String? pPersonalId = '',
    String? busca = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(pPersonalId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'alunos',
      apiUrl: '${baseUrl}get_alunos_do_personal',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PagamentosCall {
  Future<ApiCallResponse> call({
    String? uuidpersonal = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(uuidpersonal)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'pagamentos',
      apiUrl: '${baseUrl}/get_pagamentos_do_personal',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class VerificarCadastroAlunoCall {
  Future<ApiCallResponse> call({
    String? email = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_email": "${escapeStringForJson(email)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'verificarCadastroAluno',
      apiUrl: '${baseUrl}/verificar_usuario_por_email',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPerfilAlunoCall {
  Future<ApiCallResponse> call({
    String? personalId = '',
    String? alunoid = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(personalId)}",
  "p_aluno_uuid": "${escapeStringForJson(alunoid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getPerfilAluno',
      apiUrl: '${baseUrl}get_perfil_aluno_pelo_personal',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class StatusAlunoCall {
  Future<ApiCallResponse> call({
    String? uuidPersonal = '',
    String? uuidAluno = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(uuidPersonal)}",
  "p_aluno_uuid": "${escapeStringForJson(uuidAluno)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'status aluno',
      apiUrl: '${baseUrl}/toggle_status_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertPgtoAlunoCall {
  Future<ApiCallResponse> call({
    String? pPersonalUuid = '',
    String? pAlunoUuid = '',
    String? pDescricao = '',
    double? pValor,
    String? pTipoPagamento = '',
    String? pDataVencimento = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(pPersonalUuid)}",
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_descricao": "${escapeStringForJson(pDescricao)}",
  "p_valor": ${pValor},
  "p_tipo_pagamento": "${escapeStringForJson(pTipoPagamento)}",
  "p_data_vencimento": "${escapeStringForJson(pDataVencimento)}"

}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insert pgto aluno',
      apiUrl: '${baseUrl}/upsert_pagamento_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdatePgtoAlunoCall {
  Future<ApiCallResponse> call({
    String? pPersonalUuid = '',
    String? pAlunoUuid = '',
    String? pDescricao = '',
    double? pValor,
    String? pTipoPagamento = '',
    String? pDataVencimento = '',
    String? pDataPagamento = '',
    int? pId,
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(pPersonalUuid)}",
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_descricao": "${escapeStringForJson(pDescricao)}",
  "p_valor": ${pValor},
  "p_tipo_pagamento": "${escapeStringForJson(pTipoPagamento)}",
  "p_data_vencimento": "${escapeStringForJson(pDataVencimento)}",
  "p_data_pagamento": "${escapeStringForJson(pDataPagamento)}",
  "p_id": ${pId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'update  pgto aluno',
      apiUrl: '${baseUrl}/upsert_pagamento_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletePgtoCall {
  Future<ApiCallResponse> call({
    String? pPersonalUuid = '',
    int? pPagamentoId,
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(pPersonalUuid)}",
  "p_pagamento_id":${pPagamentoId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'delete pgto',
      apiUrl: '${baseUrl}/deletar_pagamento_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetTreinosPersonalCall {
  Future<ApiCallResponse> call({
    String? pPersonalUuid = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(pPersonalUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get treinos personal',
      apiUrl: '${baseUrl}get_treinos_personal',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpsertTreinoCall {
  Future<ApiCallResponse> call({
    String? pPersonalUuid = '',
    String? pNome = '',
    int? pGrupoTreinoId,
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );

    final body = pGrupoTreinoId != null
        ? '{"p_personal_uuid":"${escapeStringForJson(pPersonalUuid)}","p_nome":"${escapeStringForJson(pNome)}","p_grupo_treino_id":$pGrupoTreinoId}'
        : '{"p_personal_uuid":"${escapeStringForJson(pPersonalUuid)}","p_nome":"${escapeStringForJson(pNome)}"}';

    return ApiManager.instance.makeApiCall(
      callName: 'upsert treino',
      apiUrl: '${baseUrl}upsert_treino',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ToggleAlunoAtivoCall {
  Future<ApiCallResponse> call({
    String? personalUuid = '',
    String? alunoUuid = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );
    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(personalUuid)}",
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'toggle aluno ativo',
      apiUrl: '${baseUrl}toggle_aluno_ativo',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EnviarConvitePersonalCall {
  Future<ApiCallResponse> call({
    String? personalUuid = '',
    String? alunoUuid = '',
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );
    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(personalUuid)}",
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'enviar convite personal',
      apiUrl: '${baseUrl}enviar_convite_personal',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ConfirmarPagamentoCall {
  Future<ApiCallResponse> call({
    int? pPagamentoId,
    String? pPersonalUuid = '',
    String? pTipoPagamento,
    String? apiKey,
    String? project,
  }) async {
    apiKey ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = PersonalGroup.getBaseUrl(
      apiKey: apiKey,
      project: project,
    );
    // Sem forma escolhida vai null, e o banco preserva a que o aluno
    // declarou — mandar string vazia apagaria essa informacao.
    final tipo = (pTipoPagamento != null && pTipoPagamento.isNotEmpty)
        ? '"${escapeStringForJson(pTipoPagamento)}"'
        : 'null';
    final ffApiRequestBody = '''
{
  "p_pagamento_id": ${pPagamentoId ?? 0},
  "p_personal_uuid": "${escapeStringForJson(pPersonalUuid)}",
  "p_tipo_pagamento": ${tipo}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'confirmar pagamento',
      apiUrl: '${baseUrl}confirmar_pagamento_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apiKey}',
        'Authorization': 'Bearer ${apiKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Personal Group Code

/// Start Treino Group Code

class TreinoGroup {
  static String getBaseUrl({
    String? apikey,
    String? bearer,
    String? project,
  }) {
    apikey ??= FFAppConstants.apiKey;
    bearer ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    return 'https://${project}.supabase.co/rest/v1/rpc/';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'apikey': '[apikey]',
    'Authorization': 'Bearer[bearer]',
  };
  static ExerciciosCall exerciciosCall = ExerciciosCall();
  static MusculosCall musculosCall = MusculosCall();
  static BuscatreinoalunoCall buscatreinoalunoCall = BuscatreinoalunoCall();
  static GetExerciciosCall getExerciciosCall = GetExerciciosCall();
}

class ExerciciosCall {
  Future<ApiCallResponse> call({
    String? pMusculoId = '',
    String? pNome = '',
    String? pPersonalId = '',
    String? apikey,
    String? bearer,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    bearer ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = TreinoGroup.getBaseUrl(
      apikey: apikey,
      bearer: bearer,
      project: project,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'exercicios',
      apiUrl: '${baseUrl}exercicios',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer${bearer}',
      },
      params: {
        'p_musculo_id': pMusculoId,
        'p_nome': pNome,
        'p_personal_id': pPersonalId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<int>? id(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<String>? nome(dynamic response) => (getJsonField(
        response,
        r'''$[:].nome''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class MusculosCall {
  Future<ApiCallResponse> call({
    String? apikey,
    String? bearer,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    bearer ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = TreinoGroup.getBaseUrl(
      apikey: apikey,
      bearer: bearer,
      project: project,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'musculos',
      apiUrl: '${baseUrl}get_grupos_musculares',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer${bearer}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? nome(dynamic response) => (getJsonField(
        response,
        r'''$[:].nome''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class BuscatreinoalunoCall {
  Future<ApiCallResponse> call({
    String? pDataTreino = '',
    int? pIdAluno,
    String? apikey,
    String? bearer,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    bearer ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = TreinoGroup.getBaseUrl(
      apikey: apikey,
      bearer: bearer,
      project: project,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'buscatreinoaluno',
      apiUrl: '${baseUrl}buscartreinosaluno',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer${bearer}',
      },
      params: {
        'p_data_treino': pDataTreino,
        'p_id_aluno': pIdAluno,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  int? treino(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.treino.id''',
      ));
}

class GetExerciciosCall {
  Future<ApiCallResponse> call({
    String? personalUuid = '',
    int? grupoMuscular,
    int? treinoExecucaoId,
    String? apikey,
    String? bearer,
    String? project,
  }) async {
    apikey ??= FFAppConstants.apiKey;
    bearer ??= FFAppConstants.apiKey;
    project ??= FFAppConstants.project;
    final baseUrl = TreinoGroup.getBaseUrl(
      apikey: apikey,
      bearer: bearer,
      project: project,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(personalUuid)}",
  "p_grupo_muscular_id": ${grupoMuscular},
  "p_treino_execucao_id": ${treinoExecucaoId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getExercicios',
      apiUrl: '${baseUrl}/get_exercicios',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer${bearer}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Treino Group Code

/// Start Perfis Group Code

class PerfisGroup {
  static String getBaseUrl() =>
      'https://idsopfkwmquvndwmwlbr.supabase.co/rest/v1';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
  };
  static GetPerfisUsuarioCall getPerfisUsuarioCall = GetPerfisUsuarioCall();
  static GetPerfilUsuarioByIdCall getPerfilUsuarioByIdCall =
      GetPerfilUsuarioByIdCall();
  static TesteGetInfosFromViewCall testeGetInfosFromViewCall =
      TesteGetInfosFromViewCall();
}

class GetPerfisUsuarioCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = PerfisGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'GetPerfisUsuario',
      apiUrl: '${baseUrl}/usuarios',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPerfilUsuarioByIdCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = PerfisGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'GetPerfilUsuarioById',
      apiUrl:
          '${baseUrl}/usuarios?user_uuid=eq.ca7b52b9-92bd-4e07-97d1-f4c687599141',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TesteGetInfosFromViewCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = PerfisGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'TesteGetInfosFromView',
      apiUrl: '${baseUrl}/vw_usuarios_com_perfil',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkc29wZmt3bXF1dm5kd213bGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDM1OTYsImV4cCI6MjA4NjQxOTU5Nn0.Ji4Si0KvX-R0ZMqqDNjCz9e5pR6esKwt5XWo3ig8IDs',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Perfis Group Code

/// Start Aluno Group Code

class AlunoGroup {
  static String getBaseUrl({
    String? project,
    String? apikey,
  }) {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    return 'https://${project}.supabase.co/rest/v1/rpc/';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'apikey': '[apikey]',
    'Authorization': 'Bearer[apikey]',
  };
  static GetMetasCall getMetasCall = GetMetasCall();
  static GetMetricasCall getMetricasCall = GetMetricasCall();
  static GetTreinosCall getTreinosCall = GetTreinosCall();
  static GetCalendarioCall getCalendarioCall = GetCalendarioCall();
  static IniciarTreinoCall iniciarTreinoCall = IniciarTreinoCall();
  static IniciarExercicioCall iniciarExercicioCall = IniciarExercicioCall();
  static FinalizarTreinoCall finalizarTreinoCall = FinalizarTreinoCall();
  static RegistrarSerieCall registrarSerieCall = RegistrarSerieCall();
  static RegistrarDescansoCall registrarDescansoCall = RegistrarDescansoCall();
  static SalvarFeedbackCall salvarFeedbackCall = SalvarFeedbackCall();
  static RegistrarCardioCall registrarCardioCall = RegistrarCardioCall();
  static PularExercicioCall pularExercicioCall = PularExercicioCall();
  static UpsertInfoCorporaisCall upsertInfoCorporaisCall =
      UpsertInfoCorporaisCall();
  static UpsertRegMensalCall upsertRegMensalCall = UpsertRegMensalCall();
  static GetPerfilPersonalCall getPerfilPersonalCall = GetPerfilPersonalCall();
  static GetConvitesPendentesCall getConvitesPendentesCall =
      GetConvitesPendentesCall();
  static ResponderConvitePersonalCall responderConvitePersonalCall =
      ResponderConvitePersonalCall();
  static CompletarPerfilAlunoCall completarPerfilAlunoCall =
      CompletarPerfilAlunoCall();
  static VerificarAcessoAlunoCall verificarAcessoAlunoCall =
      VerificarAcessoAlunoCall();
  static GetSubstitutosExercicioCall getSubstitutosExercicioCall =
      GetSubstitutosExercicioCall();
  static InformarPagamentoCall informarPagamentoCall = InformarPagamentoCall();
}

class GetConvitesPendentesCall {
  Future<ApiCallResponse> call({
    String? alunoUuid = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get convites pendentes',
      apiUrl: '${baseUrl}get_convites_pendentes',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ResponderConvitePersonalCall {
  Future<ApiCallResponse> call({
    String? alunoUuid = '',
    String? personalUuid = '',
    bool? aceitar = false,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}",
  "p_personal_uuid": "${escapeStringForJson(personalUuid)}",
  "p_aceitar": ${aceitar}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'responder convite personal',
      apiUrl: '${baseUrl}responder_convite_personal',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CompletarPerfilAlunoCall {
  Future<ApiCallResponse> call({
    String? alunoUuid = '',
    String? nascimento = '',
    String? telefone = '',
    bool? isWhatsapp = false,
    double? peso,
    double? altura,
    String? nickname = '',
    String? cpf = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}",
  "p_nascimento": "${escapeStringForJson(nascimento)}",
  "p_telefone": "${escapeStringForJson(telefone)}",
  "p_is_whatsapp": ${isWhatsapp},
  "p_peso": ${peso},
  "p_altura": ${altura},
  "p_nickname": "${escapeStringForJson(nickname)}",
  "p_cpf": "${escapeStringForJson(cpf)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'completar perfil aluno',
      apiUrl: '${baseUrl}completar_perfil_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetMetasCall {
  Future<ApiCallResponse> call({
    String? alunoUuid = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get Metas',
      apiUrl: '${baseUrl}/get_metas_by_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetMetricasCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    String? pPeriodo = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_periodo": "${escapeStringForJson(pPeriodo)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get Metricas',
      apiUrl: '${baseUrl}/get_metricas_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetTreinosCall {
  Future<ApiCallResponse> call({
    String? alunoUuid = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get Treinos',
      apiUrl: '${baseUrl}/get_treino_ativo_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  GruposStruct? grupoTreino(dynamic response) =>
      GruposStruct.maybeFromMap(getJsonField(
        response,
        r'''$.grupoTreino''',
      ));
}

/// Dias treinados de um mes, com o detalhe de cada treino.
///
/// Um mes por chamada: o calendario mostra um mes de cada vez e a pessoa
/// folheia. Trazer o historico inteiro cresceria sem limite com o uso.
class GetCalendarioCall {
  Future<ApiCallResponse> call({
    String? alunoUuid = '',
    int? ano,
    int? mes,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}",
  "p_ano": ${ano ?? 0},
  "p_mes": ${mes ?? 0}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get Calendario',
      apiUrl: '${baseUrl}/get_calendario_treinos_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class IniciarTreinoCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucao,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_treino_execucao_id": ${pTreinoExecucao}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'iniciarTreino',
      apiUrl: '${baseUrl}/iniciar_treino_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class IniciarExercicioCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucaoId,
    int? pExercicioExecucaoId,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_treino_execucao_id": ${pTreinoExecucaoId},
  "p_exercicio_execucao_id": ${pExercicioExecucaoId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'iniciarExercicio',
      apiUrl: '${baseUrl}/iniciar_exercicio',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class FinalizarTreinoCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucaoId,
    bool? pPulado,
    String? pFeedback = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_treino_execucao_id": ${pTreinoExecucaoId},
  "p_pulado": ${pPulado}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'FinalizarTreino',
      apiUrl: '${baseUrl}/finalizar_treino_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RegistrarSerieCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucaoId,
    int? pExercicioExecucaoId,
    int? pSeriesTotal,
    int? pSerieNumero,
    int? pRepeticoes,
    double? pPeso,
    int? pMedidaId = 1,
    bool? pPulado,
    bool? pSerieAquecimento,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_treino_execucao_id": ${pTreinoExecucaoId},
  "p_exercicio_execucao_id": ${pExercicioExecucaoId},
  "p_series_total": ${pSeriesTotal},
  "p_serie_numero": ${pSerieNumero},
  "p_repeticoes": ${pRepeticoes},
  "p_peso": ${pPeso},
  "p_medida_id": ${pMedidaId},
  "p_pulado": ${pPulado},
  "p_serie_aquecimento":${pSerieAquecimento}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Registrar Serie',
      apiUrl: '${baseUrl}registrar_serie',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RegistrarDescansoCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucaoId,
    int? pExercicioExecucaoId,
    int? pDuracaoSegundos,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_treino_execucao_id": ${pTreinoExecucaoId},
  "p_exercicio_execucao_id": ${pExercicioExecucaoId},
  "p_duracao_segundos": ${pDuracaoSegundos}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Registrar Descanso',
      apiUrl: '${baseUrl}/registrar_descanso',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SalvarFeedbackCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucaoId,
    String? pFeedback = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_treino_execucao_id": ${pTreinoExecucaoId},
  "p_feedback": "${escapeStringForJson(pFeedback)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Salvar Feedback',
      apiUrl: '${baseUrl}/salvar_feedback_treino',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RegistrarCardioCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucaoId,
    String? pDescricao = '',
    int? pDuracaoMinutos,
    double? pDistanciaKm,
    String? pObservacao = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "PerfisId": "${escapeStringForJson(pAlunoUuid)}",
  "TreinosExecucaoId": ${pTreinoExecucaoId},
  "Descricao": "${escapeStringForJson(pDescricao)}",
  "DuracaoMinutos": ${pDuracaoMinutos},
  "DistanciaKm": ${pDistanciaKm},
  "Observacao": "${escapeStringForJson(pObservacao)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Registrar Cardio',
      apiUrl: '${baseUrl}/registrar_cardio',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PularExercicioCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    int? pTreinoExecucaoId,
    int? pExercicioExecucaoId,
    bool? pPulado = true,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_treino_execucao_id": ${pTreinoExecucaoId},
  "p_exercicio_execucao_id": ${pExercicioExecucaoId},
  "p_pulado": ${pPulado}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Pular Exercicio',
      apiUrl: '${baseUrl}/pular_exercicio',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpsertInfoCorporaisCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    double? pPeso,
    double? pAltura,
    double? pPorcentagemGordura,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_peso": ${pPeso},
  "p_altura": ${pAltura},
  "p_porcentagem_gordura": ${pPorcentagemGordura}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Upsert Info Corporais',
      apiUrl: '${baseUrl}/upsert_informacoes_corporais',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpsertRegMensalCall {
  Future<ApiCallResponse> call({
    String? pAlunoUuid = '',
    String? pUrlImg = '',
    String? pMesAno = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_url_img": "${escapeStringForJson(pUrlImg)}",
  "p_mes_ano": "${escapeStringForJson(pMesAno)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Upsert Reg Mensal',
      apiUrl: '${baseUrl}upsert_registro_mensal',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPerfilPersonalCall {
  Future<ApiCallResponse> call({
    String? pPersonalUuid = '',
    String? pAlunoUuid = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_personal_uuid": "${escapeStringForJson(pPersonalUuid)}",
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get Perfil Personal',
      apiUrl: '${baseUrl}get_perfil_personal_publico',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class VerificarAcessoAlunoCall {
  Future<ApiCallResponse> call({
    String? alunoUuid = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );
    final ffApiRequestBody = '''
{
  "p_aluno_uuid": "${escapeStringForJson(alunoUuid)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'verificar acesso aluno',
      apiUrl: '${baseUrl}verificar_acesso_aluno',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Aluno Group Code

class UsercreateCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? senha = '',
    String? projectKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdic3ZqdGhjanJ3ZWl6anR6aXZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYwNjYwMTQsImV4cCI6MjA4MTY0MjAxNH0.w51cN6rbDT1KTCmSGn9nKXZsD0EslDqo1buFMtFuqcQ',
    String? projectId = 'gbsvjthcjrweizjtzivh',
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${escapeStringForJson(email)}",
  "password": "${escapeStringForJson(senha)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'usercreate',
      apiUrl: 'https://${projectId}.supabase.co/auth/v1/signup',
      callType: ApiCallType.POST,
      headers: {
        'apikey': '${projectKey}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetSubstitutosExercicioCall {
  Future<ApiCallResponse> call({
    int? pExecucaoId,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_execucao_id": ${pExecucaoId ?? 0}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'get substitutos exercicio',
      apiUrl: '${baseUrl}/get_substitutos_exercicio',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InformarPagamentoCall {
  Future<ApiCallResponse> call({
    int? pPagamentoId,
    String? pAlunoUuid = '',
    String? pDataPagamento = '',
    String? pTipoPagamento,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = AlunoGroup.getBaseUrl(
      project: project,
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "p_pagamento_id": ${pPagamentoId ?? 0},
  "p_aluno_uuid": "${escapeStringForJson(pAlunoUuid)}",
  "p_data_pagamento": "${escapeStringForJson(pDataPagamento)}",
  "p_tipo_pagamento": ${pTipoPagamento == null ? 'null' : '"\${escapeStringForJson(pTipoPagamento)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'informar pagamento',
      apiUrl: '${baseUrl}aluno_informar_pagamento',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetCamposPersonalizadosCall {
  Future<ApiCallResponse> call({
    String? pPerfisId = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = PerfilGroup.getBaseUrl(project: project, apikey: apikey);
    return ApiManager.instance.makeApiCall(
      callName: 'get campos personalizados',
      apiUrl: '${baseUrl}/get_campos_personalizados',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: '{"p_perfis_id": "${escapeStringForJson(pPerfisId)}"}',
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpsertCampoPersonalizadoCall {
  Future<ApiCallResponse> call({
    String? pPerfisId = '',
    String? pNome = '',
    String? pUnidade = '',
    String? pValor = '',
    int? pId,
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = PerfilGroup.getBaseUrl(project: project, apikey: apikey);
    final body = pId != null
        ? '{"p_perfis_id":"${escapeStringForJson(pPerfisId)}","p_nome":"${escapeStringForJson(pNome)}","p_unidade":"${escapeStringForJson(pUnidade)}","p_valor":"${escapeStringForJson(pValor)}","p_id":$pId}'
        : '{"p_perfis_id":"${escapeStringForJson(pPerfisId)}","p_nome":"${escapeStringForJson(pNome)}","p_unidade":"${escapeStringForJson(pUnidade)}","p_valor":"${escapeStringForJson(pValor)}"}';
    return ApiManager.instance.makeApiCall(
      callName: 'upsert campo personalizado',
      apiUrl: '${baseUrl}/upsert_campo_personalizado',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteCampoPersonalizadoCall {
  Future<ApiCallResponse> call({
    int? pId,
    String? pPerfisId = '',
    String? project,
    String? apikey,
  }) async {
    project ??= FFAppConstants.project;
    apikey ??= FFAppConstants.apiKey;
    final baseUrl = PerfilGroup.getBaseUrl(project: project, apikey: apikey);
    return ApiManager.instance.makeApiCall(
      callName: 'delete campo personalizado',
      apiUrl: '${baseUrl}/delete_campo_personalizado',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body:
          '{"p_id":${pId ?? 0},"p_perfis_id":"${escapeStringForJson(pPerfisId)}"}',
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}

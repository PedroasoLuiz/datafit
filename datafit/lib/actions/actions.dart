import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:convert';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_commons/api_requests/api_manager.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

Future perfil(BuildContext context) async {
  ApiCallResponse? apiResult4yl;

  apiResult4yl = await PerfilGroup.perfilCall.call(
    pUserId: currentUserUid,
  );

  if ((apiResult4yl?.succeeded ?? true)) {
    FFAppState().perfil =
        PerfilStruct.maybeFromMap((apiResult4yl?.jsonBody ?? '')) ??
            PerfilStruct();
    FFAppState().update(() {});
  }
}

Future alunosdopersonal(
  BuildContext context, {
  required String? uuidpersonal,
}) async {
  ApiCallResponse? apiResultvz1;

  apiResultvz1 = await PersonalGroup.alunosCall.call(
    pPersonalId: uuidpersonal,
  );

  if ((apiResultvz1?.succeeded ?? true)) {
    FFAppState().alunosdopersonal = ((apiResultvz1?.jsonBody ?? '')
            .toList()
            .map<PersonalalunosStruct?>(PersonalalunosStruct.maybeFromMap)
            .toList() as Iterable<PersonalalunosStruct?>)
        .withoutNulls
        .toList()
        .cast<PersonalalunosStruct>();
    FFAppState().update(() {});
  }
}

Future exercicios(
  BuildContext context, {
  int? idmusculo,
  String? nome,
  int? idpersonal,
}) async {}

Future musculos(BuildContext context) async {
  ApiCallResponse? apiResult1sz;

  apiResult1sz = await TreinoGroup.musculosCall.call();

  if ((apiResult1sz?.succeeded ?? true)) {
    FFAppState().musculos = ((apiResult1sz?.jsonBody ?? '')
            .toList()
            .map<MusculosStruct?>(MusculosStruct.maybeFromMap)
            .toList() as Iterable<MusculosStruct?>)
        .withoutNulls
        .toList()
        .cast<MusculosStruct>();
    FFAppState().update(() {});
  }
}

Future treinoalunos(
  BuildContext context, {
  String? data,
  int? idaluno,
}) async {
  ApiCallResponse? apiResultcct;

  apiResultcct = await TreinoGroup.buscatreinoalunoCall.call(
    pDataTreino: data,
    pIdAluno: idaluno,
  );

  if ((apiResultcct?.succeeded ?? true)) {
    await showDialog(
      useRootNavigator: true,
      context: context,
      builder: (alertDialogContext) {
        return WebViewAware(
          child: AlertDialog(
            title: Text(TreinoGroup.buscatreinoalunoCall
                .treino(
                  (apiResultcct?.jsonBody ?? ''),
                )!
                .toString()),
            content: Text('aaaaa'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      },
    );
    FFAppState().addToTreinoalunos(((apiResultcct?.jsonBody ?? '')
            .toList()
            .map<TreinoalunoStruct?>(TreinoalunoStruct.maybeFromMap)
            .toList() as Iterable<TreinoalunoStruct?>)
        .withoutNulls
        .firstOrNull!);
    FFAppState().update(() {});
  }
}

Future pagamentos(
  BuildContext context, {
  required String? uuidpersonal,
}) async {
  ApiCallResponse? apiResult4p7;

  apiResult4p7 = await PersonalGroup.pagamentosCall.call(
    uuidpersonal: uuidpersonal,
  );

  if ((apiResult4p7?.succeeded ?? true)) {
    FFAppState().pagamentos = ((apiResult4p7?.jsonBody ?? '')
            .toList()
            .map<PersonalpagamentosStruct?>(
                PersonalpagamentosStruct.maybeFromMap)
            .toList() as Iterable<PersonalpagamentosStruct?>)
        .withoutNulls
        .toList()
        .cast<PersonalpagamentosStruct>();
    FFAppState().update(() {});
  }
}

Future verificaCadastroEmail(
  BuildContext context, {
  required String? email,
}) async {
  ApiCallResponse? apiResultc6c;

  apiResultc6c = await PersonalGroup.verificarCadastroAlunoCall.call(
    email: email,
  );

  if ((apiResultc6c?.succeeded ?? true)) {
    FFAppState().existeCadastro = (apiResultc6c?.jsonBody ?? '');
    FFAppState().update(() {});
  }
}

Future getPerfilAluno(
  BuildContext context, {
  required String? alunoId,
}) async {
  ApiCallResponse? apiResult3bf;

  apiResult3bf = await PersonalGroup.getPerfilAlunoCall.call(
    personalId: currentUserUid,
    alunoid: alunoId,
  );

  if ((apiResult3bf?.succeeded ?? true)) {
    final parsed =
        PerfilAlunoStruct.maybeFromMap((apiResult3bf?.jsonBody ?? ''));
    if (parsed != null) {
      FFAppState().alunotemp = parsed;
      FFAppState().update(() {});
    }
  }
}

Future getConvitesPendentes(BuildContext context) async {
  ApiCallResponse? apiResultcvp;

  apiResultcvp = await AlunoGroup.getConvitesPendentesCall.call(
    alunoUuid: currentUserUid,
  );

  if ((apiResultcvp?.succeeded ?? true)) {
    FFAppState().convitesPendentes = ((apiResultcvp?.jsonBody ?? '')
            .toList()
            .map<ConviteStruct?>(ConviteStruct.maybeFromMap)
            .toList() as Iterable<ConviteStruct?>)
        .withoutNulls
        .toList()
        .cast<ConviteStruct>();
    FFAppState().update(() {});
  }
}

Future responderConvite(
  BuildContext context, {
  required String? personalUuid,
  required bool? aceitar,
}) async {
  ApiCallResponse? apiResultrcv;

  apiResultrcv = await AlunoGroup.responderConvitePersonalCall.call(
    alunoUuid: currentUserUid,
    personalUuid: personalUuid,
    aceitar: aceitar,
  );

  if ((apiResultrcv?.succeeded ?? true)) {
    FFAppState().convitesPendentes = FFAppState()
        .convitesPendentes
        .where((e) => e.personalUuid != personalUuid)
        .toList();
    FFAppState().update(() {});
  }
}

Future completarPerfilAluno(
  BuildContext context, {
  String? nascimento,
  String? telefone,
  bool? isWhatsapp,
  double? peso,
  double? altura,
  String? nickname,
  String? cpf,
}) async {
  ApiCallResponse? apiResultcpa;

  apiResultcpa = await AlunoGroup.completarPerfilAlunoCall.call(
    alunoUuid: currentUserUid,
    nascimento: nascimento,
    telefone: telefone,
    isWhatsapp: isWhatsapp,
    peso: peso,
    altura: altura,
    nickname: nickname,
    cpf: cpf,
  );
}

Future<Map<String, dynamic>?> verificarAcessoAluno(
  BuildContext context, {
  required String? alunoUuid,
}) async {
  final result = await AlunoGroup.verificarAcessoAlunoCall.call(
    alunoUuid: alunoUuid,
  );
  if ((result.succeeded ?? false) && result.jsonBody is Map) {
    return (result.jsonBody as Map).cast<String, dynamic>();
  }
  return null;
}

Future<bool?> toggleAlunoAtivo(
  BuildContext context, {
  required String? personalUuid,
  required String? alunoUuid,
}) async {
  final result = await PersonalGroup.toggleAlunoAtivoCall.call(
    personalUuid: personalUuid,
    alunoUuid: alunoUuid,
  );
  if ((result.succeeded ?? false) && result.jsonBody is Map) {
    return (result.jsonBody as Map)['ativo'] as bool?;
  }
  return null;
}

Future<bool> enviarConvitePersonal(
  BuildContext context, {
  required String? alunoUuid,
}) async {
  final result = await PersonalGroup.enviarConvitePersonalCall.call(
    personalUuid: currentUserUid,
    alunoUuid: alunoUuid,
  );
  return (result.succeeded ?? false) &&
      ((result.jsonBody as Map?))?['sucesso'] == true;
}

Future metasAluno(BuildContext context) async {
  ApiCallResponse? apiResult3q1;

  apiResult3q1 = await AlunoGroup.getMetasCall.call(
    alunoUuid: currentUserUid,
  );

  if ((apiResult3q1?.succeeded ?? true)) {
    FFAppState().metasTemp =
        MetasAlunoStruct.maybeFromMap((apiResult3q1?.jsonBody ?? '')) ??
            MetasAlunoStruct();
    FFAppState().update(() {});
  }
}

/// Carrega as metricas em FFAppState().metricasTemp.
///
/// [alunoUuid] existe para o personal abrir as metricas de um aluno. Quando
/// vem nulo assume o proprio usuario, que e o caso do aluno vendo as dele.
Future getMetricasAluno(
  BuildContext context, {
  required int? meses,
  required String? periodo,
  String? alunoUuid,
}) async {
  ApiCallResponse? apiResult5af;

  apiResult5af = await AlunoGroup.getMetricasCall.call(
    pAlunoUuid:
        (alunoUuid == null || alunoUuid.isEmpty) ? currentUserUid : alunoUuid,
    pPeriodo: periodo,
  );

  if ((apiResult5af?.succeeded ?? true)) {
    FFAppState().metricasTemp =
        DashMetricasStruct.maybeFromMap((apiResult5af?.jsonBody ?? '')) ??
            DashMetricasStruct();
    FFAppState().update(() {});
  }
}

/// Recarrega os treinos do aluno em FFAppState().treinosTemp.
///
/// [silencioso] serve para a atualizacao de fundo ao abrir "Meus treinos":
/// ali a tela ja mostra o que estava em cache, entao uma falha de rede nao
/// deve virar um alerta no meio do caminho — so mantem o que ja havia.
Future getTreinosAluno(
  BuildContext context, {
  bool silencioso = false,
}) async {
  ApiCallResponse? apiResulthbj1;

  apiResulthbj1 = await AlunoGroup.getTreinosCall.call(
    alunoUuid: currentUserUid,
  );

  if ((apiResulthbj1?.succeeded ?? true)) {
    FFAppState().treinosTemp = GrupostreinosStruct.maybeFromMap(getJsonField(
          (apiResulthbj1?.jsonBody ?? ''),
          r'''$.grupoTreino''',
        )) ??
        GrupostreinosStruct();
    FFAppState().update(() {});
  } else if (silencioso) {
    return;
  } else {
    await showDialog(
      useRootNavigator: true,
      context: context,
      builder: (alertDialogContext) {
        return WebViewAware(
          child: AlertDialog(
            title: Text('Erro ao carregar treinos'),
            content: Text(
                'Não foi possível carregar seus treinos. Verifique sua conexão e tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future perfilPersonal(
  BuildContext context, {
  required String? personal,
}) async {}

Future loadingNotifica(BuildContext context) async {
  ApiCallResponse? apiResult4lk;

  apiResult4lk = await PerfilGroup.getNotificacoesCall.call(
    user: currentUserUid,
  );

  if ((apiResult4lk?.succeeded ?? true)) {
    FFAppState().notificacoes = ((apiResult4lk?.jsonBody ?? '')
            .toList()
            .map<NotificacoesStruct?>(NotificacoesStruct.maybeFromMap)
            .toList() as Iterable<NotificacoesStruct?>)
        .withoutNulls
        .toList()
        .cast<NotificacoesStruct>();
    FFAppState().update(() {});
  }
}

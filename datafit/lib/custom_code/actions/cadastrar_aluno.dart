// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

import '/link_email_auth.dart';

// Quem cria o usuario no Auth e a Edge Function `criar-usuario-auth`.
//
// A RPC ja fez isso com um INSERT cru em auth.users, e o resultado era um
// usuario fantasma: sem linha em auth.identities, que e a tabela onde o GoTrue
// guarda "como esta pessoa entra". Sem ela nao havia login por senha, nem
// vinculo com Apple ou Google, e o resetPasswordForEmail respondia sucesso sem
// enviar nada. O aluno existia para a checagem de e-mail e nao existia para o
// Auth. A Edge Function usa `auth.admin.createUser`, que monta a identidade.
//
// Parâmetros:
//   personalUuid → UUID do personal logado
//   alunoUuid    → userId retornado pela verificar_usuario_por_email;
//                  vindo vazio, a Edge Function cria a conta e devolve o id
//   ...demais dados do formulário

Future<String> cadastrarAluno(
  String personalUuid,
  String nome,
  String email,
  String? cpf,
  String? fotoUrl,
  String? nickname,
  String? nascimento,
  String? telefone,
  bool isWhatsapp,
  double? peso,
  double? altura,
  bool forcarVinculo,
  String? alunoUuid,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Normaliza data DD/MM/YYYY → YYYY-MM-DD se necessário
    String? nascimentoNormalizado = nascimento;
    if (nascimento != null &&
        RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(nascimento)) {
      final p = nascimento.split('/');
      nascimentoNormalizado = '${p[2]}-${p[1]}-${p[0]}';
    }

    // Garante o usuario no Auth antes de vincular.
    //
    // A funcao devolve o id de quem ja existe, entao reenviar convite para o
    // mesmo e-mail nao cria uma segunda conta.
    var uuidDoAluno = alunoUuid;
    if (uuidDoAluno == null || uuidDoAluno.isEmpty || uuidDoAluno == 'null') {
      try {
        final criacao = await supabase.functions.invoke(
          'criar-usuario-auth',
          body: {'email': email},
        );
        final dados = criacao.data;
        final mapa = dados is Map
            ? dados
            : (dados is String ? jsonDecode(dados) as Map : const {});
        uuidDoAluno = mapa['userId']?.toString();
        if (uuidDoAluno == null || uuidDoAluno.isEmpty) {
          return jsonEncode({
            'sucesso': false,
            'codigo': 'SEM_USUARIO_AUTH',
            'mensagem': mapa['error']?.toString() ??
                'Nao consegui criar o acesso deste aluno. Tente de novo.',
          });
        }
      } catch (e) {
        return jsonEncode({
          'sucesso': false,
          'codigo': 'SEM_USUARIO_AUTH',
          'mensagem': 'Nao consegui criar o acesso deste aluno: $e',
        });
      }
    }

    final resultado = await supabase.rpc(
      'criar_ou_vincular_aluno',
      params: {
        'p_personal_uuid': personalUuid,
        'p_aluno_uuid': uuidDoAluno,
        'p_nome': nome,
        'p_email': email,
        'p_forcar_vinculo': forcarVinculo,
        if (cpf != null && cpf.isNotEmpty) 'p_cpf': cpf,
        if (fotoUrl != null && fotoUrl.isNotEmpty) 'p_foto_url': fotoUrl,
        if (nickname != null && nickname.isNotEmpty) 'p_nickname': nickname,
        if (nascimentoNormalizado != null && nascimentoNormalizado.isNotEmpty)
          'p_nascimento': nascimentoNormalizado,
        if (telefone != null && telefone.isNotEmpty) 'p_telefone': telefone,
        'p_is_whatsapp': isWhatsapp,
        if (peso != null) 'p_peso': peso,
        if (altura != null) 'p_altura': altura,
      },
    );

    // O convite: um e-mail de definir senha.
    //
    // A Edge Function cria a conta sem senha e sem mandar nada, entao e este
    // `resetPasswordForEmail` que leva o aluno ao app. So funciona porque a
    // conta agora tem identidade `email`: sem ela o GoTrue respondia sucesso e
    // nao enviava (e o comportamento anti-enumeracao dele).
    final resultMap = resultado is Map ? resultado : null;
    // Envia email sempre que o convite foi criado/reenviado com sucesso
    final deveEnviarEmail = resultMap != null && resultMap['sucesso'] == true;
    String? emailErro;
    if (deveEnviarEmail) {
      try {
        await supabase.auth.resetPasswordForEmail(
          email,
          redirectTo: destinoDefinirSenha(),
        );
      } catch (e) {
        emailErro = e.toString();
      }
    }

    if (emailErro != null && resultMap != null) {
      return jsonEncode({...resultMap, 'emailErro': emailErro});
    }
    return jsonEncode(resultado);
  } catch (e) {
    return '{"sucesso": false, "codigo": "ERRO_CLIENT", "mensagem": "$e"}';
  }
}

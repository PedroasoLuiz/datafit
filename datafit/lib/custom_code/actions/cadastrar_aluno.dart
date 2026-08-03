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

// A RPC criar_ou_vincular_aluno agora cria o usuário na auth internamente
// se alunoUuid vier vazio — não precisa mais de edge function.
//
// Parâmetros:
//   personalUuid → UUID do personal logado
//   alunoUuid    → userId retornado pela verificar_usuario_por_email
//                  (pode ser null/vazio se usuário não existe — a RPC cria)
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

    final resultado = await supabase.rpc(
      'criar_ou_vincular_aluno',
      params: {
        'p_personal_uuid': personalUuid,
        'p_aluno_uuid': alunoUuid ?? '',
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

    // Se o cadastro foi bem-sucedido e o aluno era novo (não tinha conta),
    // envia e-mail de redefinição de senha para que ele possa definir sua senha e entrar.
    // A RPC cria o usuário no auth.users diretamente (sem acionar o sistema de e-mail do Supabase),
    // então precisamos chamar resetPasswordForEmail aqui para que o aluno receba o e-mail.
    final resultMap = resultado is Map ? resultado : null;
    // Envia email sempre que o convite foi criado/reenviado com sucesso
    final deveEnviarEmail = resultMap != null && resultMap['sucesso'] == true;
    String? emailErro;
    if (deveEnviarEmail) {
      try {
        await supabase.auth.resetPasswordForEmail(
          email,
          redirectTo: 'com.virtus.datafit://reset-password',
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

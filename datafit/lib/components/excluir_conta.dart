/// Exclusao de conta iniciada pelo proprio usuario.
///
/// Exigencia da Apple App Store — Guideline 5.1.1(v): todo app que permite
/// criar conta precisa permitir excluir a conta de dentro do app, sem
/// depender de e-mail ou suporte.
///
/// Chama a RPC `excluir_minha_conta` (ver migrations/excluir_conta_usuario.sql),
/// que anonimiza o perfil, encerra os vinculos e revoga o login.
///
/// IMPORTANTE: a chamada vai por `SupaFlow.client.rpc` e NAO pelo
/// ApiManager/api_calls.dart. As calls geradas pelo FlutterFlow mandam
/// `Authorization: Bearer <anon key>`, entao `auth.uid()` chegaria NULL no
/// banco. O client do Supabase manda o JWT do usuario logado.

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Abre o fluxo de confirmacao e, se confirmado, exclui a conta.
Future<void> confirmarExclusaoConta(BuildContext context) async {
  final confirmou = await _dialogoConfirmacao(context);
  if (confirmou != true || !context.mounted) return;

  _mostrarCarregando(context);

  Map<String, dynamic>? resultado;
  Object? falha;
  try {
    final r = await SupaFlow.client.rpc('excluir_minha_conta');
    resultado = (r as Map).cast<String, dynamic>();
  } catch (e) {
    falha = e;
  }

  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop(); // fecha o carregando

  if (falha != null) {
    await _dialogoAviso(
      context,
      'Nao foi possivel excluir',
      'Houve uma falha de comunicacao com o servidor. Verifique sua conexao e tente novamente.',
    );
    return;
  }

  if (resultado?['sucesso'] == true) {
    if (!context.mounted) return;
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    GoRouter.of(context).clearRedirectLocation();
    if (!context.mounted) return;
    context.goNamedAuth(StartWidget.routeName, context.mounted);
    return;
  }

  final erro = resultado?['erro'] as String?;
  if (erro == 'POSSUI_ALUNOS_ATIVOS') {
    final n = resultado?['alunosAtivos'] ?? 0;
    await _dialogoAviso(
      context,
      'Voce ainda tem alunos ativos',
      'Sua conta esta vinculada a $n aluno(s). Desative ou transfira esses alunos antes de excluir sua conta, '
          'para que eles nao percam o acesso aos treinos.',
    );
  } else {
    await _dialogoAviso(
      context,
      'Nao foi possivel excluir',
      'Tente novamente em alguns instantes. Se o problema continuar, fale com o suporte.',
    );
  }
}

Future<bool?> _dialogoConfirmacao(BuildContext context) {
  final theme = FlutterFlowTheme.of(context);
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: theme.primaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      title: Text(
        'Excluir minha conta',
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
          color: theme.error,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Esta acao e permanente e nao pode ser desfeita.\n\n'
        'Seus dados pessoais (nome, e-mail, telefone e foto) serao removidos, '
        'seus vinculos com personal trainer serao encerrados e voce perdera o '
        'acesso ao aplicativo imediatamente.',
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(),
          fontSize: 13.0,
          color: theme.secondaryText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            'Cancelar',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: theme.secondaryText,
              fontSize: 13.0,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            'Excluir conta',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: theme.error,
              fontSize: 13.0,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _dialogoAviso(
    BuildContext context, String titulo, String mensagem) {
  final theme = FlutterFlowTheme.of(context);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: theme.primaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      title: Text(
        titulo,
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        mensagem,
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(),
          fontSize: 13.0,
          color: theme.secondaryText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            'Entendi',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: theme.primary,
              fontSize: 13.0,
            ),
          ),
        ),
      ],
    ),
  );
}

void _mostrarCarregando(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            FlutterFlowTheme.of(context).primary,
          ),
        ),
      ),
    ),
  );
}

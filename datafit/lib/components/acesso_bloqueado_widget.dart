import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TipoBloqueio { semPersonal, assinaturaVencida, alunoInativo }

class AcessoBloqueadoWidget extends StatelessWidget {
  const AcessoBloqueadoWidget({super.key, required this.tipo});

  final TipoBloqueio tipo;

  String get _titulo {
    switch (tipo) {
      case TipoBloqueio.semPersonal:
        return 'Aguardando convite';
      case TipoBloqueio.assinaturaVencida:
        return 'Acesso indisponível';
      case TipoBloqueio.alunoInativo:
        return 'Acesso bloqueado';
    }
  }

  String get _mensagem {
    switch (tipo) {
      case TipoBloqueio.semPersonal:
        return 'Você ainda não foi vinculado a um personal trainer. Aguarde o convite do seu personal para começar.';
      case TipoBloqueio.assinaturaVencida:
        return 'A assinatura do seu personal trainer está vencida. Entre em contato com ele para regularizar o acesso.';
      case TipoBloqueio.alunoInativo:
        return 'Seu acesso foi temporariamente bloqueado. Entre em contato com seu personal trainer para mais informações.';
    }
  }

  IconData get _icone {
    switch (tipo) {
      case TipoBloqueio.semPersonal:
        return Icons.person_add_outlined;
      case TipoBloqueio.assinaturaVencida:
        return Icons.lock_clock_outlined;
      case TipoBloqueio.alunoInativo:
        return Icons.block_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.accent1,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _icone,
                      color: theme.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _titulo,
                    textAlign: TextAlign.center,
                    style: theme.headlineSmall.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _mensagem,
                    textAlign: TextAlign.center,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: theme.secondaryText,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () async {
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();
                      context.goNamedAuth(StartWidget.routeName, context.mounted);
                    },
                    child: Text(
                      'Sair da conta',
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: theme.secondaryText,
                        letterSpacing: 0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

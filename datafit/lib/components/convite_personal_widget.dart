import '/backend/schema/structs/index.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConvitePersonalWidget extends StatefulWidget {
  const ConvitePersonalWidget({super.key, required this.convite});

  final ConviteStruct convite;

  @override
  State<ConvitePersonalWidget> createState() => _ConvitePersonalWidgetState();
}

class _ConvitePersonalWidgetState extends State<ConvitePersonalWidget> {
  /// Trava enquanto a resposta corre: aceitar e recusar em sequência
  /// mandariam duas decisões opostas para o mesmo convite.
  bool _respondendo = false;

  Future<Object?> _responder(bool aceitar) async {
    if (_respondendo) return null;
    safeSetState(() => _respondendo = true);

    await action_blocks.responderConvite(
      context,
      personalUuid: widget.convite.personalUuid,
      aceitar: aceitar,
    );

    if (!mounted) return null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return FolhaPadrao(
      // O visto aceita. Recusar sai pelo X, que é o que ele já faz em toda
      // folha: fechar sem levar nada adiante.
      aoConfirmar: () => _responder(true),
      filhos: [
        CabecaFolha(
          titulo: 'Convite de personal',
          apoio: 'Aceitando, ele passa a montar e acompanhar seus treinos.',
          icone: Icons.person_add_outlined,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              MedidasFolha.lado, 0.0, MedidasFolha.lado, 0.0),
          child: Text(
            '${widget.convite.personalNome} convidou você para ser aluno dele.',
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.primaryText,
              fontSize: 15.0,
              letterSpacing: -0.1,
              fontWeight: FontWeight.w500,
              lineHeight: 1.4,
            ),
          ),
        ),
        // Recusar em vermelho e separado: é a única das duas respostas que
        // não se desfaz por dentro do app.
        AcaoDestrutivaFolha(
          texto: 'Recusar convite',
          icone: Icons.close_rounded,
          aoTocar: () async {
            final ok = await _responder(false);
            if (ok == null || !mounted) return;
            await FolhaPadrao.fechar(context, true);
          },
        ),
      ],
    );
  }
}

import '/components/folha_kit.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// O que o aluno escreve ao encerrar um treino.
class FolhaFeedbackTreino extends StatefulWidget {
  const FolhaFeedbackTreino({
    super.key,
    required this.controlador,
    required this.aoSalvar,
  });

  final TextEditingController controlador;

  /// Devolve `true` se o banco aceitou. Falhando, a folha continua aberta com
  /// o texto: fechar levaria embora o que a pessoa acabou de escrever.
  final Future<bool> Function(String texto) aoSalvar;

  @override
  State<FolhaFeedbackTreino> createState() => _FolhaFeedbackTreinoState();
}

class _FolhaFeedbackTreinoState extends State<FolhaFeedbackTreino> {
  bool _falhou = false;

  Future<Object?> _salvar() async {
    if (_falhou) setState(() => _falhou = false);

    final ok = await widget.aoSalvar(widget.controlador.text.trim());
    if (!mounted) return null;
    if (ok) return true;

    setState(() => _falhou = true);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return FolhaPadrao(
      aoConfirmar: _salvar,
      filhos: [
        const CabecaFolha(
          titulo: 'Como foi este treino?',
          apoio: 'O que você escrever aqui vai para o seu personal.',
          icone: Icons.chat_bubble_outline_rounded,
        ),
        CampoFolha(
          primeiro: true,
          rotulo: 'Seu relato',
          dica: 'Pesos, dores, o que rendeu, o que travou...',
          controlador: widget.controlador,
          linhas: 4,
          autofoco: true,
        ),
        if (_falhou)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                MedidasFolha.lado, 14.0, MedidasFolha.lado, 0.0),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
              decoration: BoxDecoration(
                color: tema.error.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Não consegui salvar agora. Tente de novo.',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  color: tema.error,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

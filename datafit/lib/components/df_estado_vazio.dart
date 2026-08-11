/// Estado vazio padrão do app.
///
/// Existiam dois desenhos diferentes convivendo — o card ilustrado de alunos e
/// o ícone solto dos treinos — e nenhum para pagamentos e vídeos. Este componente
/// unifica os quatro casos.
///
/// A linguagem visual vem do próprio kit: o badge do ícone repete o botão de
/// notificações (fundo `accent1`, ícone `primary`, canto 12), só que maior.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DfEstadoVazio extends StatelessWidget {
  const DfEstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    this.textoBotao,
    this.onBotao,
    this.compacto = false,
  });

  final IconData icone;
  final String titulo;

  /// Uma frase dizendo o que fazer. Evite texto de erro aqui.
  final String descricao;

  /// Ação opcional. Só aparece quando os dois são informados.
  final String? textoBotao;
  final VoidCallback? onBotao;

  /// Reduz a folga vertical, para quando o vazio aparece dentro de um card
  /// ou de uma aba, e não ocupando a tela inteira.
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final temAcao = textoBotao != null && onBotao != null;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          32.0, compacto ? 28.0 : 56.0, 32.0, compacto ? 28.0 : 56.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68.0,
            height: 68.0,
            decoration: BoxDecoration(
              color: tema.accent1,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Icon(icone, color: tema.primary, size: 28.0),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: tema.primaryText,
              fontSize: 15.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
              lineHeight: 1.4,
            ),
          ),
          if (temAcao) ...[
            SizedBox(height: 20.0),
            SizedBox(
              height: 40.0,
              child: ElevatedButton(
                onPressed: onBotao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tema.primary,
                  foregroundColor: Colors.white,
                  elevation: 0.0,
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  textoBotao!,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

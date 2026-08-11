/// Chip de filtro de lista, no estilo dos filtros por tag do WhatsApp.
///
/// Antes cada filtro era um par de `FFButtonWidget` escritos à mão — um bloco
/// para o estado selecionado e outro para o não selecionado — repetidos em
/// cada tela que tinha filtro. Além de longo, o visual tinha saído do rumo:
/// o selecionado usava cinza `alternate` e o não selecionado um cinza mais
/// claro, o que dava quase nenhum contraste entre "estou aqui" e "posso ir".
///
/// Aqui o selecionado é a cor primária com texto branco e o não selecionado é
/// só o contorno, sem preenchimento.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChipFiltro extends StatelessWidget {
  const ChipFiltro({
    super.key,
    required this.texto,
    required this.selecionado,
    required this.onTap,
  });

  final String texto;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 32.0,
          padding: EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 0.0),
          decoration: BoxDecoration(
            color: selecionado ? tema.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(999.0),
            border: Border.all(
              color: selecionado ? tema.primary : tema.alternate,
              width: 1.0,
            ),
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            texto,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: selecionado ? FontWeight.w600 : FontWeight.w500,
              ),
              color: selecionado ? Colors.white : tema.secondaryText,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: selecionado ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Linha de chips: encostada à esquerda e rolável na horizontal, para nenhum
/// chip ser cortado quando a fonte do sistema está grande.
class LinhaChipsFiltro extends StatelessWidget {
  const LinhaChipsFiltro({
    super.key,
    required this.chips,
    this.paddingHorizontal = 16.0,
  });

  final List<Widget> chips;
  final double paddingHorizontal;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.fromSTEB(
          paddingHorizontal, 0.0, paddingHorizontal, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) SizedBox(width: 8.0),
            chips[i],
          ],
        ],
      ),
    );
  }
}

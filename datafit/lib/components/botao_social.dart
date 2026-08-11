/// Botão de login social, um por linha.
///
/// Antes Google e Facebook dividiam uma linha e o da Apple era um bloco preto
/// de largura cheia logo abaixo — o preto sólido puxava toda a atenção da tela
/// e a lista ficava desalinhada. Aqui os três têm exatamente a mesma forma,
/// altura e peso; o que distingue cada um é só o ícone.
///
/// A Apple aceita a variante clara com contorno para o "Sign in with Apple",
/// então dá para uniformizar sem violar as diretrizes dela.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoSocial extends StatelessWidget {
  const BotaoSocial({
    super.key,
    required this.icone,
    required this.texto,
    this.onPressed,
  });

  /// Ícone do provedor. Vem pronto para preservar as cores de marca
  /// (o G do Google é colorido).
  final Widget icone;
  final String texto;

  /// `null` deixa o botão cinza e inativo — é o caso do Facebook.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final ativo = onPressed != null;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Material(
        color: ativo ? tema.primaryBackground : tema.alternate,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: double.infinity,
            height: 46.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: tema.alternate),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(opacity: ativo ? 1.0 : 0.45, child: icone),
                SizedBox(width: 10.0),
                Text(
                  texto,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: ativo ? tema.primaryText : tema.secondaryText,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Uma linha da lista de atalhos: quadrado colorido, titulo e apoio.
///
/// Vive no kit porque o mesmo desenho serve a tela do aluno e a ficha que o
/// personal abre: sao os mesmos tres assuntos: o treino, quem o escreveu e
/// ate quando ele vale: vistos dos dois lados do vinculo.
class AtalhoCartao extends StatelessWidget {
  const AtalhoCartao({
    super.key,
    required this.icone,
    required this.cor,
    required this.titulo,
    this.apoio,
    this.selo,
    this.aoTocar,
    this.carregando = false,
  });

  final IconData icone;
  final Color cor;
  final String titulo;
  final String? apoio;
  final String? selo;
  final VoidCallback? aoTocar;
  final bool carregando;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: aoTocar,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            // Branco com sombra, como todo cartao do app. A cor fica so no
            // quadrado do icone: tingir o cartao inteiro dava a cada linha o
            // peso de um alerta, e sao tres atalhos comuns.
            color: tema.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [tema.designToken.shadow.lg],
          ),
          child: Row(
            children: [
              Container(
                width: 42.0,
                height: 42.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13.0),
                ),
                child: carregando
                    ? SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(cor),
                        ),
                      )
                    : Icon(icone, color: cor, size: 21.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            titulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: tema.primaryText,
                              fontSize: 14.0,
                              letterSpacing: -0.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (selo != null) ...[
                          const SizedBox(width: 7.0),
                          Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                7.0, 1.0, 7.0, 2.0),
                            decoration: BoxDecoration(
                              color: cor.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                            child: Text(
                              selo!,
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700),
                                color: cor,
                                fontSize: 10.5,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if ((apoio ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 2.0, 0.0, 0.0),
                        child: Text(
                          apoio!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tema.bodyMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w400),
                            color: tema.secondaryText,
                            fontSize: 11.5,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (aoTocar != null) ...[
                const SizedBox(width: 6.0),
                Icon(Icons.chevron_right_rounded,
                    color: tema.secondaryText, size: 20.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

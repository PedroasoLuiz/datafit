/// Visualizador de foto em tela cheia, no estilo do WhatsApp.
///
/// Fundo preto, a foto no centro, e o gesto de arrastar para baixo fecha —
/// que é como todo mundo já espera sair de uma foto aberta. Pinça para
/// aproximar usa `InteractiveViewer`, que já vem no Flutter; não há pacote
/// novo envolvido.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Abre [url] em tela cheia. [titulo] aparece no topo quando informado.
Future<void> mostrarFotoEmTelaCheia(
  BuildContext context, {
  required String url,
  String? titulo,
}) async {
  await Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black,
      // A foto cresce a partir do nada em vez de deslizar da direita: a
      // transição lateral leria como "outra tela", e isto é a mesma tela
      // vista de perto.
      transitionsBuilder: (_, animacao, __, filho) => FadeTransition(
        opacity: animacao,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: animacao, curve: Curves.easeOutCubic),
          ),
          child: filho,
        ),
      ),
      pageBuilder: (_, __, ___) => _FotoTelaCheia(url: url, titulo: titulo),
    ),
  );
}

class _FotoTelaCheia extends StatefulWidget {
  const _FotoTelaCheia({required this.url, this.titulo});

  final String url;
  final String? titulo;

  @override
  State<_FotoTelaCheia> createState() => _FotoTelaCheiaState();
}

class _FotoTelaCheiaState extends State<_FotoTelaCheia> {
  /// Deslocamento vertical do arraste em andamento.
  double _arraste = 0.0;

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.sizeOf(context).height;

    // Quanto mais longe do centro, mais transparente o fundo: dá a sensação
    // de estar puxando a foto para fora, e não de arrastar a tela inteira.
    final opacidade = (1.0 - (_arraste.abs() / (altura / 2))).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: opacidade),
      body: GestureDetector(
        onVerticalDragUpdate: (d) =>
            setState(() => _arraste += d.delta.dy),
        onVerticalDragEnd: (d) {
          if (_arraste.abs() > 120.0 ||
              d.velocity.pixelsPerSecond.dy.abs() > 700) {
            Navigator.of(context).pop();
          } else {
            setState(() => _arraste = 0.0);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0.0, _arraste),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => const SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white54,
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 16.0, 0.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white),
                    ),
                    if (widget.titulo != null)
                      Expanded(
                        child: Text(
                          widget.titulo!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

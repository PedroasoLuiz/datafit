/// Visualizador de foto em tela cheia, no estilo do WhatsApp.
///
/// Fundo preto, a foto no centro, pinça para aproximar e um toque para sair.
/// Usa `InteractiveViewer`, que já vem no Flutter; não há pacote novo
/// envolvido.
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

class _FotoTelaCheia extends StatelessWidget {
  const _FotoTelaCheia({required this.url, this.titulo});

  final String url;
  final String? titulo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Tocar fora fecha. Nao existe arrastar-para-fechar de proposito:
          // o InteractiveViewer ja reivindica o gesto de arrastar para mover a
          // foto ampliada, e os dois reconhecedores disputando faziam a imagem
          // sair da tela e nao voltar mais.
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              // Sem InteractiveViewer: mesmo com tamanho imposto ele
              // continuava posicionando a imagem no topo e em escala errada.
              // Um Image simples ocupando a tela e `contain` faz o obvio —
              // a foto inteira, centralizada, no maior tamanho que couber.
              // Perde-se a pinca para aproximar; ver a foto vale mais.
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  imageUrl: url,
                  fit: BoxFit.contain,
                  // Decodifica no tamanho da tela, nao no do arquivo. Uma foto
                  // de celular tem 2268x4032 — 9 megapixels, uns 36 MB de
                  // bitmap — e mandar isso inteiro para a memoria e o que fazia
                  // a imagem falhar sem dar erro nenhum. `memCacheWidth` corta
                  // o custo na decodificacao, antes de virar textura.
                  memCacheWidth: (MediaQuery.sizeOf(context).width *
                          MediaQuery.devicePixelRatioOf(context))
                      .round()
                      .clamp(360, 2000),
                  placeholder: (_, __) => const Center(
                    child: SizedBox(
                      width: 28.0,
                      height: 28.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => const Center(
                    child: Icon(
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
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  if (titulo != null)
                    Expanded(
                      child: Text(
                        titulo!,
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
    );
  }
}

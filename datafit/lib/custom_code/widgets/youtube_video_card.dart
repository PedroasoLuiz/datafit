// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

/// YoutubeVideoCard — visualização padrão estilo YouTube
/// Props:
///   - videoUrl   : URL do vídeo (youtube.com/watch, shorts ou youtu.be)
///   - titulo     : Nome do exercício
///   - subcategoria: Ex: "Peitoral", "Braços"
///   - onTap      : Action ao clicar (abre o link externamente)

class YoutubeVideoCard extends StatefulWidget {
  const YoutubeVideoCard({
    super.key,
    this.width,
    this.height,
    required this.videoUrl,
    this.titulo = '',
    this.subcategoria = '',
    this.onTap,
  });

  final double? width;
  final double? height;
  final String videoUrl;
  final String titulo;
  final String subcategoria;
  final Future Function()? onTap;

  @override
  State<YoutubeVideoCard> createState() => _YoutubeVideoCardState();
}

class _YoutubeVideoCardState extends State<YoutubeVideoCard> {
  bool _hovered = false;

  /// Extrai o ID do vídeo de qualquer formato de URL do YouTube
  String? _extractVideoId(String url) {
    try {
      final uri = Uri.parse(url);

      // youtube.com/shorts/ID
      if (uri.pathSegments.contains('shorts')) {
        final idx = uri.pathSegments.indexOf('shorts');
        if (idx + 1 < uri.pathSegments.length) {
          return uri.pathSegments[idx + 1];
        }
      }

      // youtu.be/ID
      if (uri.host == 'youtu.be') {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }

      // youtube.com/watch?v=ID
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }
    } catch (_) {}
    return null;
  }

  String _thumbnailUrl(String videoId) =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  bool _isShorts(String url) => url.contains('/shorts/');

  @override
  Widget build(BuildContext context) {
    final videoId = _extractVideoId(widget.videoUrl);
    final thumbUrl = videoId != null ? _thumbnailUrl(videoId) : null;
    final isShorts = _isShorts(widget.videoUrl);

    return GestureDetector(
      onTap: widget.onTap != null ? () => widget.onTap!() : null,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovered ? 0.12 : 0.06),
                blurRadius: _hovered ? 16 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Thumbnail ───────────────────────────────────────────────
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: isShorts ? 9 / 16 : 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagem de thumbnail
                      thumbUrl != null
                          ? Image(
                              image: CachedNetworkImageProvider(thumbUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _PlaceholderThumb(),
                            )
                          : _PlaceholderThumb(),

                      // Overlay escuro sutil
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),

                      // Badge Shorts
                      if (isShorts)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF0000),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Shorts',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),

                      // Botão Play centralizado
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: _hovered ? 52 : 46,
                          height: _hovered ? 52 : 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color(0xFFFF0000),
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Info abaixo da thumbnail ────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ícone canal
                    Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(right: 10, top: 1),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF0000),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 18),
                    ),
                    // Título e subcategoria
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.titulo.isNotEmpty
                                ? widget.titulo
                                : 'Exercício',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F0F0F),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.subcategoria.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              widget.subcategoria,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF606060),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Menu
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.more_vert,
                          color: Color(0xFF606060), size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderThumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: const Center(
        child: Icon(Icons.play_circle_outline_rounded,
            color: Color(0xFFD0D0D0), size: 48),
      ),
    );
  }
}

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
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

import 'package:url_launcher/url_launcher.dart';
import '/components/video_exercicio.dart';

class ReelsVideoGrid extends StatelessWidget {
  const ReelsVideoGrid({
    super.key,
    this.width,
    this.height,
    required this.exercicios,
  });

  final double? width;
  final double? height;
  final List<ExerciciosStruct> exercicios;

  String? _extractVideoId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.contains('shorts')) {
        final idx = uri.pathSegments.indexOf('shorts');
        if (idx + 1 < uri.pathSegments.length) {
          return uri.pathSegments[idx + 1];
        }
      }
      if (uri.host == 'youtu.be') {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }
    } catch (_) {}
    return null;
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final urls = exercicios
        .map((e) => e.linkInstrucao)
        .where((l) => l != null && l.isNotEmpty)
        .cast<String>()
        .toList();

    if (urls.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 9 / 16,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        final url = urls[index];
        // Video da plataforma nao tem thumbnail publica como a do YouTube.
        // Em vez de gerar quadro (que exigiria pacote nativo de thumbnail ou
        // um player por celula do grid), a celula mostra a marca de video.
        final daPlataforma = ehVideoDaPlataforma(url);
        final videoId = daPlataforma ? null : _extractVideoId(url);
        final thumbUrl = videoId != null
            ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
            : null;

        return GestureDetector(
          onTap: () => _openUrl(url),
          child: Stack(
            fit: StackFit.expand,
            children: [
              thumbUrl != null
                  ? Image.network(
                      thumbUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _Placeholder(),
                    )
                  : const _Placeholder(),
              const Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  color: Colors.white70,
                  size: 36,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: const Center(
        child: Icon(
          Icons.play_circle_outline_rounded,
          color: Color(0xFF444444),
          size: 32,
        ),
      ),
    );
  }
}

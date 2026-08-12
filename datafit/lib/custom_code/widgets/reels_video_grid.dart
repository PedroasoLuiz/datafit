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

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  /// YouTube sai para o app/navegador; video nosso abre em tela cheia.
  ///
  /// Mandar o video da plataforma para o `launchUrl` abria o arquivo cru no
  /// navegador — sem controle, sem voltar.
  Future<void> _abrir(BuildContext context, String url) async {
    if (ehVideoDaPlataforma(url)) {
      await mostrarVideoEmTelaCheia(context, url: url);
      return;
    }

    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // Mais recente primeiro. A RPC devolve agrupado por categoria e em ordem
    // alfabetica dentro dela, entao um exercicio recem-criado caia no meio da
    // grade — nao e onde a pessoa procura o que acabou de cadastrar.
    // `execucaoId` aqui e o Id do exercicio, entao o maior e o mais novo.
    final comVideo = exercicios
        .where((e) => e.linkInstrucao.isNotEmpty)
        .toList()
      ..sort((a, b) => b.execucaoId.compareTo(a.execucaoId));


    if (comVideo.isEmpty) return const SizedBox.shrink();

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
      itemCount: comVideo.length,
      itemBuilder: (context, index) {
        final exercicio = comVideo[index];
        final url = exercicio.linkInstrucao;
        // Video da plataforma nao tem thumbnail publica como a do YouTube.
        // Em vez de gerar quadro (que exigiria pacote nativo de thumbnail ou
        // um player por celula do grid), a celula mostra a marca de video.
        final daPlataforma = ehVideoDaPlataforma(url);
        final videoId = daPlataforma ? null : _extractVideoId(url);
        final thumbUrl = videoId != null
            ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
            : null;

        return GestureDetector(
          onTap: () => _abrir(context, url),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // YouTube tem miniatura publica; o video enviado pelo
              // personal nao tem, entao a capa vem do primeiro quadro dele.
              if (thumbUrl != null)
                Image(
                  image: CachedNetworkImageProvider(thumbUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _Placeholder(),
                )
              else if (daPlataforma)
                CapaVideoPlataforma(
                  url: url,
                  segundo: exercicio.hasThumbSegundo()
                      ? exercicio.thumbSegundo
                      : null,
                )
              else
                const _Placeholder(),
              // Antes era um play grande no meio da celula: tapava a
              // imagem justo onde ela e mais legivel. No canto ele marca
              // "isto e video" sem competir com a miniatura.
              //
              // O degrade existe porque a miniatura pode ser clara: sem ele
              // o icone branco sumia em video de fundo branco.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 6,
                bottom: 6,
                // Um icone so por celula: o play e para video nosso, a
                // marca do YouTube para os de la. Mostrar os dois juntos
                // fazia parecer que havia duas acoes.
                //
                // FaIcon, nao Icon: o glifo do FontAwesome e um `FaIconData`,
                // que o `Icon` do Material nao aceita.
                child: daPlataforma
                    ? const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.youtube,
                        color: Colors.white,
                        size: 16,
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

/// Vídeo de demonstração do exercício.
///
/// O app nasceu só com link do YouTube (`Exercicios.LinkInstrucao`), e 22 dos
/// 67 exercícios cadastrados ainda apontam para lá. Agora o caminho principal
/// é o vídeo enviado pelo próprio personal, guardado no bucket `Videos`.
///
/// Os dois convivem no mesmo campo: a origem é deduzida da URL, então nada
/// precisou ser migrado e os links antigos continuam tocando.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Vídeo enviado para o storage do próprio projeto.
bool ehVideoDaPlataforma(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains('/storage/v1/object/public/Videos/');
}

/// Link do YouTube — o formato antigo.
bool ehVideoDoYoutube(String? url) {
  if (url == null || url.isEmpty) return false;
  final u = url.toLowerCase();
  return u.contains('youtube.com') || u.contains('youtu.be');
}

/// Player dos vídeos hospedados na plataforma.
///
/// Sem controles do sistema: um toque alterna play/pause e a barra de
/// progresso fica no rodapé. É vídeo curto de demonstração, não filme — a
/// barra de controle cheia do Material tomaria metade da altura útil.
class PlayerVideoPlataforma extends StatefulWidget {
  const PlayerVideoPlataforma({
    super.key,
    required this.url,
    this.autoPlay = false,
    this.alturaMaxima,
  });

  final String url;
  final bool autoPlay;

  /// Teto de altura para a previa.
  ///
  /// O player se dimensiona pela proporcao do proprio video. Video gravado
  /// de pe (9:16) num Column de largura cheia fica quase duas telas de
  /// altura — foi o que empurrou o botao de concluir para fora em
  /// "novo exercicio". Com o teto, o video encolhe mantendo a proporcao.
  final double? alturaMaxima;

  @override
  State<PlayerVideoPlataforma> createState() => _PlayerVideoPlataformaState();
}

class _PlayerVideoPlataformaState extends State<PlayerVideoPlataforma> {
  VideoPlayerController? _controle;
  bool _pronto = false;
  bool _falhou = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controle = c;
    try {
      await c.initialize();
      await c.setLooping(true);
      if (widget.autoPlay) {
        await c.play();
      }
      if (!mounted) return;
      setState(() => _pronto = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _falhou = true);
    }
  }

  @override
  void dispose() {
    _controle?.dispose();
    super.dispose();
  }

  void _alternar() {
    final c = _controle;
    if (c == null || !_pronto) return;
    setState(() {
      c.value.isPlaying ? c.pause() : c.play();
    });
  }

  @override
  Widget build(BuildContext context) => widget.alturaMaxima == null
      ? _conteudo(context)
      : Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.alturaMaxima!),
            child: _conteudo(context),
          ),
        );

  Widget _conteudo(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    if (_falhou) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: tema.secondaryBackground,
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            'Não consegui carregar este vídeo.',
            style: tema.bodyMedium.override(
              color: tema.secondaryText,
              fontSize: 13.0,
              letterSpacing: 0.0,
            ),
          ),
        ),
      );
    }

    final c = _controle;
    if (!_pronto || c == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: tema.secondaryBackground,
          alignment: AlignmentDirectional(0.0, 0.0),
          child: SizedBox(
            width: 28.0,
            height: 28.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(tema.primary),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _alternar,
      child: AspectRatio(
        aspectRatio: c.value.aspectRatio,
        child: Stack(
          alignment: AlignmentDirectional(0.0, 0.0),
          children: [
            VideoPlayer(c),
            // Só aparece quando está parado: com o vídeo rodando, o ícone
            // sobreposto atrapalha justamente o que a pessoa foi ver.
            if (!c.value.isPlaying)
              Container(
                width: 54.0,
                height: 54.0,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: VideoProgressIndicator(
                c,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: tema.primary,
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.white10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

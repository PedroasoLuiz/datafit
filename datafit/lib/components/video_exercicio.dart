/// Vídeo de demonstração do exercício.
///
/// O app nasceu só com link do YouTube (`Exercicios.LinkInstrucao`), e 22 dos
/// 67 exercícios cadastrados ainda apontam para lá. Agora o caminho principal
/// é o vídeo enviado pelo próprio personal, guardado no bucket `Videos`.
///
/// Os dois convivem no mesmo campo: a origem é deduzida da URL, então nada
/// precisou ser migrado e os links antigos continuam tocando.
library;

import 'dart:io';

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

/// Capa do vídeo da plataforma: o primeiro quadro, parado.
///
/// Vídeo do YouTube tem miniatura pública (`img.youtube.com`); o que o
/// personal envia não tem nada equivalente — o storage guarda o arquivo, não
/// um pôster. Extrair um quadro exigiria um pacote nativo de thumbnail, então
/// aqui o próprio `video_player` carrega o vídeo e mostra o primeiro quadro
/// sem tocar. É o mesmo pacote que o app já usa, sem dependência nova.
///
/// O custo é real: cada capa mantém um controlador de vídeo vivo. Serve para
/// a grade de vídeos de um personal, que tem dezenas — não para uma lista
/// infinita.
class CapaVideoPlataforma extends StatefulWidget {
  const CapaVideoPlataforma({super.key, required this.url, this.segundo});

  final String url;

  /// Segundo escolhido pelo personal em `SeletorCapaVideo`.
  ///
  /// Nulo cai no primeiro quadro — que costuma ser a pessoa ainda se
  /// posicionando, e foi por isso que a escolha passou a existir.
  final double? segundo;

  @override
  State<CapaVideoPlataforma> createState() => _CapaVideoPlataformaState();
}

class _CapaVideoPlataformaState extends State<CapaVideoPlataforma> {
  VideoPlayerController? _controle;
  bool _pronto = false;

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
      // Sem play: `initialize` já deixa um quadro pronto para pintar; o
      // `seekTo` só troca qual é.
      final s = widget.segundo;
      if (s != null && s > 0) {
        await c.seekTo(Duration(milliseconds: (s * 1000).round()));
      }
      if (!mounted) return;
      setState(() => _pronto = true);
    } catch (_) {
      // Sem capa a célula fica no fundo escuro, que é o estado anterior.
    }
  }

  @override
  void dispose() {
    _controle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controle;
    if (!_pronto || c == null) {
      return Container(color: const Color(0xFF1A1A1A));
    }

    // `cover` recortando pelo centro: a célula é 9/16 e o vídeo pode ser
    // deitado. Deixar `contain` encheria a célula de tarja preta.
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: c.value.size.width,
        height: c.value.size.height,
        child: VideoPlayer(c),
      ),
    );
  }
}

/// Abre os vídeos em tela cheia, no formato de reels.
///
/// [urls] é a lista inteira e [inicial] diz por qual começar: rolar para cima
/// e para baixo passa pelos outros, como no Instagram. Mostrar só o vídeo
/// tocado obrigaria a voltar para a grade a cada troca.
/// [autoPlay] falso abre parado no primeiro quadro, com o play grande no
/// meio esperando o toque. É o certo quando o vídeo foi aberto no meio de um
/// treino: a pessoa pode ter tocado sem querer, e som e movimento começando
/// sozinhos assustam mais do que ajudam. Na grade do personal, que existe
/// para folhear vídeo, o padrão continua sendo tocar na hora.
Future<void> mostrarVideoEmTelaCheia(
  BuildContext context, {
  required String url,
  List<String>? urls,
  int inicial = 0,
  bool autoPlay = true,
}) async {
  final lista = (urls == null || urls.isEmpty) ? <String>[url] : urls;
  await Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _ReelsTelaCheia(
        urls: lista,
        inicial: inicial,
        autoPlay: autoPlay,
      ),
    ),
  );
}

class _ReelsTelaCheia extends StatefulWidget {
  const _ReelsTelaCheia({
    required this.urls,
    required this.inicial,
    this.autoPlay = true,
  });

  final List<String> urls;
  final int inicial;
  final bool autoPlay;

  @override
  State<_ReelsTelaCheia> createState() => _ReelsTelaCheiaState();
}

class _ReelsTelaCheiaState extends State<_ReelsTelaCheia> {
  late final PageController _paginas =
      PageController(initialPage: widget.inicial);

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _paginas,
            scrollDirection: Axis.vertical,
            itemCount: widget.urls.length,
            itemBuilder: (context, i) => _PaginaReels(
              url: widget.urls[i],
              // Só a página de entrada respeita o `autoPlay`: quem rolou até
              // a seguinte foi atrás dela, e parar cada uma exigiria um toque
              // a mais por vídeo.
              autoPlay: widget.autoPlay || i != widget.inicial,
              // A chave amarra o player à URL: sem ela, o PageView reaproveita
              // o State ao rolar e o vídeo novo abriria mostrando o anterior.
              key: ValueKey(widget.urls[i]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 0.0, 0.0),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginaReels extends StatefulWidget {
  const _PaginaReels({super.key, required this.url, this.autoPlay = true});

  final String url;
  final bool autoPlay;

  @override
  State<_PaginaReels> createState() => _PaginaReelsState();
}

class _PaginaReelsState extends State<_PaginaReels> {
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
      if (widget.autoPlay) await c.play();
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
    setState(() => c.value.isPlaying ? c.pause() : c.play());
  }

  @override
  Widget build(BuildContext context) {
    final c = _controle;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _alternar,
            child: _falhou
                ? const Center(
                    child: Text(
                      'Não consegui carregar este vídeo.',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  )
                : (!_pronto || c == null)
                    ? const Center(
                        child: SizedBox(
                          width: 28.0,
                          height: 28.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    // `contain`, e nao `cover`: com `cover` o video era
                    // recortado nas laterais para encher a tela, e sumia
                    // justamente a parte que mostra a execucao do exercicio.
                    // Video gravado de pe (9:16) enche a tela do mesmo jeito;
                    // o deitado ganha tarja, que e o certo — melhor tarja do
                    // que metade do movimento cortada.
                    : SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: c.value.size.width,
                            height: c.value.size.height,
                            child: VideoPlayer(c),
                          ),
                        ),
                      ),
          ),
        ),
        if (_pronto && c != null && !c.value.isPlaying)
          IgnorePointer(
            child: Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white.withValues(alpha: 0.85),
                size: 72.0,
              ),
            ),
          ),
        if (_pronto && c != null)
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            // SafeArea: encostada em `bottom: 0` a barra ficava atras do
            // indicador de home do iPhone, fora do alcance do dedo e quase
            // invisivel.
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999.0),
                  child: VideoProgressIndicator(
                    c,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white24,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Escolha do quadro de capa, no estilo do Instagram.
///
/// O vídeo aparece inteiro e uma régua embaixo percorre a duração: arrastar
/// move o player até aquele ponto, então o que se vê é exatamente o que vai
/// virar capa.
///
/// Guarda o SEGUNDO, não uma imagem. Extrair e subir um arquivo novo a cada
/// troca exigiria um pacote nativo de thumbnail e uma ida ao storage; com o
/// segundo, quem desenha a capa só manda o player até lá.
class SeletorCapaVideo extends StatefulWidget {
  const SeletorCapaVideo({
    super.key,
    required this.aoEscolher,
    this.url,
    this.caminhoLocal,
    this.segundoInicial,
    this.altura = 260.0,
  });

  /// URL do video ja no storage. Usada quando nao ha [caminhoLocal].
  final String? url;

  /// Arquivo ainda no aparelho, escolhido nesta sessao.
  ///
  /// Tem prioridade sobre [url]: o video so sobe ao salvar o exercicio, entao
  /// enquanto se escolhe a capa o arquivo de verdade e este.
  final String? caminhoLocal;
  final ValueChanged<double> aoEscolher;
  final double? segundoInicial;
  final double altura;

  @override
  State<SeletorCapaVideo> createState() => _SeletorCapaVideoState();
}

class _SeletorCapaVideoState extends State<SeletorCapaVideo> {
  VideoPlayerController? _controle;
  bool _pronto = false;
  bool _falhou = false;
  double _segundo = 0.0;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final local = widget.caminhoLocal;
    final c = local != null
        ? VideoPlayerController.file(File(local))
        : VideoPlayerController.networkUrl(Uri.parse(widget.url ?? ''));
    _controle = c;
    try {
      await c.initialize();
      _segundo = widget.segundoInicial ?? 0.0;
      await c.seekTo(Duration(milliseconds: (_segundo * 1000).round()));
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

  Future<void> _irPara(double segundo) async {
    final c = _controle;
    if (c == null) return;
    setState(() => _segundo = segundo);
    await c.seekTo(Duration(milliseconds: (segundo * 1000).round()));
    widget.aoEscolher(segundo);
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final c = _controle;

    if (_falhou) {
      return SizedBox(
        height: widget.altura,
        child: Center(
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

    if (!_pronto || c == null) {
      return SizedBox(
        height: widget.altura,
        child: Center(
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

    final duracao = c.value.duration.inMilliseconds / 1000.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Container(
            height: widget.altura,
            width: double.infinity,
            color: Colors.black,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: c.value.size.width,
                height: c.value.size.height,
                child: VideoPlayer(c),
              ),
            ),
          ),
        ),
        // Um vídeo de duração zero (ou não lida) não tem o que percorrer.
        if (duracao > 0.2)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arraste para escolher a capa',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 14.0),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                  ),
                  child: Slider(
                    value: _segundo.clamp(0.0, duracao),
                    min: 0.0,
                    max: duracao,
                    activeColor: tema.primary,
                    inactiveColor: tema.alternate,
                    onChanged: _irPara,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

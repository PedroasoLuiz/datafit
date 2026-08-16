import 'package:flutter/material.dart';

/// Baralho de cartas: uma pilha que se arrasta para os lados.
///
/// A versao anterior era um leque: os vizinhos ficavam ao lado, inclinados.
/// Aqui eles ficam ATRAS do card da frente, com as pontas assomando dos dois
/// lados, como uma pilha de cartas.
///
/// Arrastar para qualquer um dos lados manda a carta da frente para o fim da
/// pilha. Nao existe descartar: e uma fila circular, entao a mesma carta
/// sempre volta depois de dar a volta.
class BaralhoCartas extends StatefulWidget {
  const BaralhoCartas({
    super.key,
    required this.quantidade,
    required this.construir,
    this.altura = 250.0,
  });

  final int quantidade;
  final Widget Function(BuildContext, int) construir;

  /// Altura da pilha. As cartas nao se medem sozinhas: a pilha existe dentro
  /// de uma rolagem, e uma altura que muda com o conteudo faria o baralho
  /// saltar a cada troca de carta.
  final double altura;

  @override
  State<BaralhoCartas> createState() => _BaralhoCartasState();
}

class _BaralhoCartasState extends State<BaralhoCartas>
    with TickerProviderStateMixin {
  /// Quanto cada carta de tras assoma para o lado, e quanto ela encolhe.
  static const double _passoLateral = 26.0;
  static const double _passoEscala = 0.06;

  /// Giro das cartas de tras, em radianos (~8 graus). A da esquerda gira para
  /// um lado e a da direita para o outro, abrindo o leque.
  ///
  /// Comecou em 30 graus e ficou deitado demais: a carta de tras virava um
  /// losango e competia com a da frente em vez de so sugerir profundidade.
  static const double _giroFundo = 0.14;

  /// A carta da frente nao ocupa a largura toda: e a sobra que deixa as
  /// pontas das de tras aparecerem sem precisar empurra-las para fora.
  static const double _larguraFrente = 0.86;

  /// Cartas de tras visiveis. Acima disso a pilha vira sujeira visual.
  static const int _visiveis = 2;

  /// Onde cada assento da pilha fica: 0 = frente, 1 = segunda, 2 = terceira.
  ///
  /// Existe como lista, e nao como conta em cima da camada, porque a posicao
  /// nao e uma progressao — a segunda vai para a direita e a terceira para a
  /// esquerda, e a terceira ainda leva 2px a mais.
  static const List<double> _deslocDoAssento = [
    0.0,
    _passoLateral,
    -(_passoLateral + 2.0),
  ];

  static const List<double> _giroDoAssento = [0.0, _giroFundo, -_giroFundo];

  /// Le a lista num ponto continuo entre dois assentos.
  ///
  /// E o que transforma a troca de lugar em movimento: com `p = 1.4` a carta
  /// esta 40% do caminho entre o segundo assento e o primeiro, em vez de estar
  /// num ou noutro.
  static double _entreAssentos(List<double> assentos, double p) {
    if (p <= 0) return assentos.first;
    if (p >= assentos.length - 1) return assentos.last;
    final anterior = p.floor();
    final fracao = p - anterior;
    return assentos[anterior] +
        (assentos[anterior + 1] - assentos[anterior]) * fracao;
  }

  /// Indice da carta que esta na frente.
  int _topo = 0;

  /// Deslocamento horizontal do arraste em andamento.
  double _arraste = 0.0;

  late final AnimationController _controle;

  /// Entrada da carta que volta para o fundo da pilha.
  ///
  /// Quando a da frente sai, ela reaparece no ultimo assento — e aparecia
  /// pronta, do nada. Comeca em 1 para a pilha parada ja nascer visivel; so
  /// as trocas rodam a animacao.
  late final AnimationController _controleEntrada;

  @override
  void initState() {
    super.initState();
    _controle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(() => setState(() {}));
    _controleEntrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controle.dispose();
    _controleEntrada.dispose();
    super.dispose();
  }

  void _aoArrastar(DragUpdateDetails d) {
    if (widget.quantidade < 2) return;
    setState(() => _arraste += d.delta.dx);
  }

  void _aoSoltar(DragEndDetails d, double largura) {
    if (widget.quantidade < 2) {
      _animarAte(0.0);
      return;
    }

    // Passou de um terco da largura, ou saiu com velocidade: vai para o fim.
    final velocidade = d.velocity.pixelsPerSecond.dx;
    final passou = _arraste.abs() > largura / 3 || velocidade.abs() > 700;

    if (!passou) {
      _animarAte(0.0, curva: Curves.easeOutBack);
      return;
    }

    final destino = _arraste.isNegative ? -largura * 1.3 : largura * 1.3;
    _animarAte(destino, aoTerminar: () {
      setState(() {
        _topo = (_topo + 1) % widget.quantidade;
        _arraste = 0.0;
      });
      // A carta que acabou de sair reentra no fundo: sem isto ela pisca de
      // volta ja pronta, no mesmo quadro em que a pilha se reorganiza.
      _controleEntrada.forward(from: 0.0);
    });
  }

  void _animarAte(
    double destino, {
    Curve curva = Curves.easeOut,
    VoidCallback? aoTerminar,
  }) {
    final anim = Tween<double>(begin: _arraste, end: destino).animate(
      CurvedAnimation(parent: _controle, curve: curva),
    );
    void ouvir() => _arraste = anim.value;

    _controle.reset();
    _controle.addListener(ouvir);
    _controle.forward().whenComplete(() {
      _controle.removeListener(ouvir);
      if (aoTerminar != null) {
        aoTerminar();
      } else {
        _arraste = destino;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quantidade == 0) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, restricoes) {
        final largura = restricoes.maxWidth;

        // A da frente mais as de tras visiveis, nunca mais do que existem.
        final qtd = widget.quantidade < _visiveis + 1
            ? widget.quantidade
            : _visiveis + 1;

        final cartas = <Widget>[];
        // De tras para frente, para a da frente terminar por cima na Stack.
        for (var camada = qtd - 1; camada >= 0; camada--) {
          final indice = (_topo + camada) % widget.quantidade;
          cartas.add(_carta(context, camada, indice, largura,
              ultima: camada == qtd - 1));
        }

        return SizedBox(
          height: widget.altura,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: cartas,
          ),
        );
      },
    );
  }

  Widget _carta(
    BuildContext context,
    int camada,
    int indice,
    double largura, {
    required bool ultima,
  }) {
    final daFrente = camada == 0;

    // Enquanto a da frente e arrastada, as de tras se adiantam. Sem isso so a
    // de cima se mexeria e a pilha pareceria congelada.
    final progresso =
        largura == 0 ? 0.0 : (_arraste.abs() / largura).clamp(0.0, 1.0);
    final camadaEfetiva = daFrente ? 0.0 : camada - progresso;

    final escala = 1.0 - (_passoEscala * camadaEfetiva);

    // As de tras caminham para o assento da frente conforme o arraste avanca,
    // em vez de ficarem paradas e trocarem de lugar de uma vez no fim. Era
    // esse salto — de +26 para 0, desendireitando junto — que fazia a troca
    // parecer um corte em vez de um movimento.
    final desloc =
        daFrente ? _arraste : _entreAssentos(_deslocDoAssento, camadaEfetiva);

    // Frente: gira conforme o arraste. Fundo: acompanha o assento.
    final giro = daFrente
        ? (largura > 0 ? (_arraste / largura) * 0.22 : 0.0)
        : _entreAssentos(_giroDoAssento, camadaEfetiva);

    final carta = Transform.translate(
      offset: Offset(desloc, 0.0),
      child: Transform.rotate(
        angle: giro,
        child: Transform.scale(
          scale: escala,
          child: Opacity(
            // A ultima da pilha entra clareando: e o assento que recebe a
            // carta recem-descartada, o unico que troca de conteudo de um
            // quadro para o outro.
            opacity: daFrente
                ? 1.0
                : (1.0 - 0.2 * camadaEfetiva) *
                    (ultima ? _controleEntrada.value : 1.0),
            child: FractionallySizedBox(
              widthFactor: _larguraFrente,
              child: widget.construir(context, indice),
            ),
          ),
        ),
      ),
    );

    // So a da frente responde ao gesto.
    if (!daFrente) {
      return IgnorePointer(child: carta);
    }

    return GestureDetector(
      onHorizontalDragUpdate: _aoArrastar,
      onHorizontalDragEnd: (d) => _aoSoltar(d, largura),
      child: carta,
    );
  }
}

/// Comemoração de tela cheia ao concluir algo.
///
/// O aviso de "exercício concluído" era uma folha subindo do rodapé, igual à
/// de erro e à de convite — o mesmo desenho para dar parabéns e para dizer
/// que algo deu errado. Terminar uma série de exercícios é o momento em que
/// o app tem mais motivo para responder, e respondia com o mesmo retângulo
/// de sempre.
///
/// Aqui a tela inteira vira a resposta: um círculo da cor de sucesso cresce
/// do centro, o visto assenta dentro dele e o texto sobe por baixo. Passado
/// pouco mais de um segundo, ela se fecha sozinha e devolve quem chamou à
/// tela anterior.
///
/// Sem Lottie nem pacote de animação: são três intervalos de um único
/// `AnimationController`. Um JSON de animação pesaria mais que a tela toda e
/// traria uma dependência para desenhar um círculo e um visto.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mostra a comemoração e só retorna quando ela terminar.
///
/// Quem chama normalmente quer navegar em seguida — por isso o `await`
/// importa: navegar antes do fim deixaria a animação tocando por cima de uma
/// tela que já não é a dela.
/// [origem] é o ponto da tela de onde o círculo nasce, em coordenadas
/// globais — normalmente o centro do botão que disparou a ação. É o que faz a
/// animação parecer o próprio botão se abrindo, em vez de um aviso que veio
/// de outro lugar. Nulo cai no centro da tela.
Future<void> mostrarComemoracao(
  BuildContext context, {
  required String titulo,
  String? subtitulo,
  Offset? origem,
}) async {
  await Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      // Opaca no fim das contas — o círculo cobre tudo —, mas declarada
      // transparente para que o primeiro quadro mostre a tela de baixo e o
      // círculo pareça nascer dela.
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => _Comemoracao(
        titulo: titulo,
        subtitulo: subtitulo,
        origem: origem,
      ),
      transitionsBuilder: (_, animacao, __, filho) =>
          FadeTransition(opacity: animacao, child: filho),
    ),
  );
}

class _Comemoracao extends StatefulWidget {
  const _Comemoracao({
    required this.titulo,
    this.subtitulo,
    this.origem,
    this.usarPrimary = false,
    this.corFundo,
    this.icone = Icons.check_rounded,
    this.rodape,
    this.fecharSozinho = true,
    this.itens = const <ItemResumo>[],
  });

  final String titulo;
  final String? subtitulo;
  final Offset? origem;

  /// Azul da marca em vez do verde de sucesso.
  final bool usarPrimary;

  /// Cor de fundo explicita, quando nem sucesso nem marca servem — e o caso
  /// do vermelho de falha.
  final Color? corFundo;

  /// Simbolo do circulo. O visto e o padrao porque quase tudo aqui e
  /// conclusao; a falha troca por um X.
  final IconData icone;

  /// Linha pequena no rodape. Guarda o codigo do erro: quem vai reportar
  /// precisa dele, e quem nao vai nem repara.
  final String? rodape;

  /// Some sozinha ao fim da animação. Falso deixa o X no comando.
  final bool fecharSozinho;

  /// Números do treino. Vazio some — a comemoração de exercício não tem o que
  /// contabilizar.
  final List<ItemResumo> itens;

  @override
  State<_Comemoracao> createState() => _ComemoracaoState();
}

class _ComemoracaoState extends State<_Comemoracao>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  /// O círculo tomando a tela.
  late final Animation<double> _circulo = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
  );

  /// O visto, entrando depois que já há fundo onde pousar.
  late final Animation<double> _visto = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.18, 0.48, curve: Curves.easeOutBack),
  );

  /// A onda que sai de trás do visto e se dissolve.
  late final Animation<double> _onda = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.26, 0.62, curve: Curves.easeOut),
  );

  /// O texto, por último: primeiro se entende o símbolo, depois se lê.
  late final Animation<double> _texto = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.34, 0.60, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    final animacao = _controle.forward();
    if (widget.fecharSozinho) {
      animacao.whenComplete(() {
        // `canPop` e não `mounted` apenas: entre o fim da animação e este
        // quadro alguém pode ter fechado a tela por outro caminho, e um pop a
        // mais levaria embora a tela de baixo.
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final medida = MediaQuery.sizeOf(context);
    final centro = Offset(medida.width / 2, medida.height / 2);
    final origem = widget.origem ?? centro;

    // Raio até o canto mais distante da origem, e não meia diagonal da tela:
    // nascendo num botão junto ao rodapé, o canto de cima fica muito mais
    // longe, e um raio calculado pelo centro deixaria a faixa superior sem
    // pintar bem no fim do crescimento.
    double distancia(Offset canto) => (canto - origem).distance;
    final raio = [
      distancia(Offset.zero),
      distancia(Offset(medida.width, 0.0)),
      distancia(Offset(0.0, medida.height)),
      distancia(Offset(medida.width, medida.height)),
    ].reduce((a, b) => a > b ? a : b);
    final diametro = raio * 2.0;

    return AnimatedBuilder(
      animation: _controle,
      builder: (context, _) => Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            // Ancorado na origem: o círculo se abre a partir do botão, como
            // se ele próprio tivesse virado a tela.
            Positioned(
              left: origem.dx - raio,
              top: origem.dy - raio,
              child: Transform.scale(
                scale: _circulo.value,
                child: Container(
                  width: diametro,
                  height: diametro,
                  decoration: BoxDecoration(
                    color: widget.corFundo ??
                        (widget.usarPrimary ? tema.primary : tema.success),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // A onda passa por baixo do visto: nasce do mesmo ponto, cresce
            // além dele e some. É o que dá a impressão de impacto — sem ela
            // o visto só aparece.
            if (_onda.value > 0 && _onda.value < 1)
              Opacity(
                opacity: (1.0 - _onda.value).clamp(0.0, 1.0) * 0.5,
                child: Container(
                  width: 120.0 + 140.0 * _onda.value,
                  height: 120.0 + 140.0 * _onda.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: _visto.value.clamp(0.0, 1.4),
                  child: Container(
                    width: 108.0,
                    height: 108.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    alignment: AlignmentDirectional.center,
                    child: Icon(
                      widget.icone,
                      color: Colors.white,
                      size: 64.0,
                    ),
                  ),
                ),
                const SizedBox(height: 28.0),
                // Sobe 16 pixels enquanto aparece: o deslocamento é o que
                // liga o texto ao visto, em vez de ele piscar do nada.
                Opacity(
                  opacity: _texto.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0.0, 16.0 * (1.0 - _texto.value)),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          32.0, 0.0, 32.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.titulo,
                            textAlign: TextAlign.center,
                            style: tema.bodyMedium.override(
                              font:
                                  GoogleFonts.inter(fontWeight: FontWeight.w700),
                              color: Colors.white,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.subtitulo != null) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              widget.subtitulo!,
                              textAlign: TextAlign.center,
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500),
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          // Os numeros do treino, com o mesmo atraso do
                          // texto: entram depois que o simbolo ja foi
                          // entendido, senao a tela apresenta conta antes de
                          // dizer o que aconteceu.
                          if (widget.itens.isNotEmpty) ...[
                            const SizedBox(height: 32.0),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12.0,
                              runSpacing: 12.0,
                              children: [
                                for (final item in widget.itens)
                                  Container(
                                    width: 104.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.14),
                                      borderRadius: BorderRadius.circular(14.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(item.icone,
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                            size: 20.0),
                                        const SizedBox(height: 6.0),
                                        Text(
                                          item.valor,
                                          style: tema.bodyMedium.override(
                                            font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            letterSpacing: -0.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        Text(
                                          item.rotulo,
                                          textAlign: TextAlign.center,
                                          style: tema.bodyMedium.override(
                                            font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500),
                                            color: Colors.white
                                                .withValues(alpha: 0.8),
                                            fontSize: 11.5,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // O X so existe quando a tela nao se fecha sozinha. Aparece
            // junto com o texto, e nao com o circulo: oferecer a saida antes
            // de mostrar o que aconteceu convida a sair sem ler.
            // O codigo do erro no rodape, pequeno e discreto: quem vai
            // reportar o problema precisa dele, e quem nao vai nem repara.
            if (widget.rodape != null)
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: SafeArea(
                  top: false,
                  child: Opacity(
                    opacity: _texto.value.clamp(0.0, 1.0) * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        widget.rodape!,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.robotoMono(fontWeight: FontWeight.w400),
                          color: Colors.white,
                          fontSize: 11.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (!widget.fecharSozinho)
              Positioned(
                top: 0.0,
                right: 0.0,
                child: SafeArea(
                  child: Opacity(
                    opacity: _texto.value.clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 4.0, 4.0, 0.0),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 26.0),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Um número com rótulo no resumo do treino.
class ItemResumo {
  const ItemResumo({
    required this.icone,
    required this.valor,
    required this.rotulo,
  });

  final IconData icone;
  final String valor;
  final String rotulo;
}

/// Resumo de tela cheia ao concluir o treino inteiro.
///
/// Mesma abertura da comemoração de exercício, com três diferenças que vêm de
/// o momento ser outro: azul da marca em vez do verde de sucesso — porque
/// aqui não se trata de mais um item feito, e sim do dia inteiro fechado —,
/// não se fecha sozinha, e traz os números do treino. Terminar o treino é o
/// fim de uma sessão; é a hora de ver o que rendeu, e isso não cabe em um
/// segundo e meio de animação.
Future<void> mostrarResumoTreino(
  BuildContext context, {
  required String titulo,
  String? subtitulo,
  required List<ItemResumo> itens,
  Offset? origem,
}) async {
  await Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => _Comemoracao(
        titulo: titulo,
        subtitulo: subtitulo,
        origem: origem,
        usarPrimary: true,
        fecharSozinho: false,
        itens: itens,
      ),
      transitionsBuilder: (_, animacao, __, filho) =>
          FadeTransition(opacity: animacao, child: filho),
    ),
  );
}

/// Tela cheia de falha, no mesmo desenho das de sucesso.
///
/// A recusa do banco era anunciada numa folha cinza com o corpo da resposta
/// HTTP no meio do texto: ilegível para quem usa e inútil para quem vai
/// reportar. Aqui a tela diz o que houve em uma linha, e o código fica no
/// rodapé, pequeno — perto de quem precisa dele, longe de quem não precisa.
///
/// Não se fecha sozinha: erro é para ser lido, não para passar.
Future<void> mostrarFalha(
  BuildContext context, {
  String titulo = 'Algo deu errado',
  String? subtitulo,
  String? codigo,
  Offset? origem,
}) async {
  await Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, __, ___) => _Comemoracao(
        titulo: titulo,
        subtitulo: subtitulo,
        origem: origem,
        corFundo: FlutterFlowTheme.of(ctx).error,
        icone: Icons.priority_high_rounded,
        rodape: codigo,
        fecharSozinho: false,
      ),
      transitionsBuilder: (_, animacao, __, filho) =>
          FadeTransition(opacity: animacao, child: filho),
    ),
  );
}

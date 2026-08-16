/// Blocos de carregamento — o desenho da tela antes dos dados chegarem.
///
/// A alternativa que havia era tela parada: o app abria e ficava em branco
/// enquanto a chamada não voltava, e quem esperava não tinha como saber se
/// estava carregando ou se tinha travado. Um rodinha no meio resolveria isso,
/// mas diz só "espere"; o esqueleto diz também **o quê** vem — quantos
/// cartões, onde fica o número, que a lista tem três itens.
///
/// Sem pacote de shimmer: é uma opacidade que vai e volta num
/// `AnimatedBuilder`. O gradiente varrendo é bonito e custa uma camada de
/// shader por bloco; a pulsação usa o mesmo controlador para a tela inteira.
library;

import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// Um retângulo cinza pulsando, no lugar de um pedaço de conteúdo.
///
/// [largura] nula ocupa o que houver — serve para linha de texto dentro de
/// coluna. Para peça de tamanho conhecido (um avatar, um cartão), vale passar
/// as duas medidas: o esqueleto só ajuda se ele tiver a forma do que
/// substitui.
class BlocoEsqueleto extends StatefulWidget {
  const BlocoEsqueleto({
    super.key,
    this.largura,
    required this.altura,
    this.raio = 8.0,
  });

  final double? largura;
  final double altura;
  final double raio;

  @override
  State<BlocoEsqueleto> createState() => _BlocoEsqueletoState();
}

class _BlocoEsqueletoState extends State<BlocoEsqueleto>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return AnimatedBuilder(
      animation: _controle,
      builder: (context, _) => Container(
        width: widget.largura,
        height: widget.altura,
        decoration: BoxDecoration(
          // Entre 6% e 14%: acima disso o esqueleto compete com o conteúdo
          // real que já apareceu ao lado dele.
          color:
              tema.primaryText.withValues(alpha: 0.06 + 0.08 * _controle.value),
          borderRadius: BorderRadius.circular(widget.raio),
        ),
      ),
    );
  }
}

/// O esqueleto da tela de treinos: cabeçalho, faixa do personal e o baralho.
///
/// As medidas acompanham as do `treinos_widget` — se o cartão de lá mudar de
/// altura, este precisa mudar junto, senão a tela dá um pulo quando os dados
/// chegam, que é justamente o que o esqueleto existe para evitar.
class EsqueletoTreinos extends StatelessWidget {
  const EsqueletoTreinos({super.key});

  @override
  Widget build(BuildContext context) {
    // Mesmo limiar do `treinos_widget`: 16 até 767, 32 acima. Se divergir, a
    // tela dá um passo lateral no instante em que os dados chegam.
    final lateral =
        MediaQuery.sizeOf(context).width < kBreakpointMedium ? 16.0 : 32.0;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(lateral, 8.0, lateral, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho: a pilha de progresso à esquerda e, ao lado, o nome do
          // treino sobre a linha da validade.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BlocoEsqueleto(largura: 6.0, altura: 44.0, raio: 3.0),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    BlocoEsqueleto(largura: 170.0, altura: 16.0),
                    SizedBox(height: 8.0),
                    BlocoEsqueleto(largura: 120.0, altura: 12.0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const BlocoEsqueleto(altura: 56.0, raio: 14.0),
          const SizedBox(height: 16.0),
          // A carta da frente do baralho.
          const BlocoEsqueleto(altura: 210.0, raio: 20.0),
        ],
      ),
    );
  }
}

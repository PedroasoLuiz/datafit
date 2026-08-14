/// A chama da sequência de dias treinados.
///
/// Vive num arquivo próprio porque aparece em dois lugares — o cartão de
/// sequência no painel de métricas e o da home do aluno — e uma cópia em cada
/// tela significaria que ajustar o tremor em uma deixaria a outra para trás.
///
/// Fogo não pulsa em compasso: ele treme. Uma escala indo e voltando no mesmo
/// ritmo lê como ícone piscando, daí a animação ser a soma de três ondas de
/// velocidades diferentes. As três dão voltas inteiras dentro do ciclo (2, 3 e
/// 5 voltas), e isso não é detalhe: com frequências quebradas, o fim do ciclo
/// pega cada onda num ponto diferente de onde ela começou e o loop salta a
/// cada volta. Sendo inteiras, o último quadro encosta no primeiro. Escolhidas
/// 2, 3 e 5 — primos entre si — o padrão só se repete a cada ciclo completo.
///
/// Apagada, fica cinza e imóvel: manter fogo aceso numa sequência já quebrada
/// seria comemorar o que não está acontecendo.
library;

import 'dart:math' as math;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// Em que degrau a sequência está, de 0 a 3.
///
/// Os degraus não são lineares de propósito: os primeiros dias são fáceis e
/// não merecem festa, e é lá pelas duas semanas que manter a sequência começa
/// a exigir organizar a vida em volta. Daí 10, 15 e 30 — e não 5, 10, 15.
int nivelDaSequencia(int dias) {
  if (dias >= 30) return 3;
  if (dias >= 15) return 2;
  if (dias >= 10) return 1;
  return 0;
}

class ChamaSequencia extends StatefulWidget {
  const ChamaSequencia({
    super.key,
    required this.dias,
    this.tamanhoBase = 22.0,
  });

  /// Dias seguidos da sequência **viva**. Zero apaga a chama.
  final int dias;

  /// Tamanho no degrau 0. Os degraus seguintes crescem a partir dele.
  final double tamanhoBase;

  @override
  State<ChamaSequencia> createState() => _ChamaSequenciaState();
}

class _ChamaSequenciaState extends State<ChamaSequencia>
    with SingleTickerProviderStateMixin {
  int get _nivel => nivelDaSequencia(widget.dias);

  /// A chama cresce com a sequência, a partir do tamanho que a tela pediu.
  double get _tamanho =>
      widget.tamanhoBase * const [1.0, 1.18, 1.27, 1.4][_nivel];

  /// E acelera. O ciclo continua fechando — as ondas seguem dando voltas
  /// inteiras —, só que mais rápido: é o mesmo desenho com mais pressa.
  int get _ciclo => const [6000, 4200, 3200, 2400][_nivel];

  /// Quanto o tremor abre. Perto do teto ele fica visivelmente mais nervoso.
  double get _amplitude => const [1.0, 1.25, 1.5, 1.8][_nivel];

  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _ciclo),
  );

  @override
  void initState() {
    super.initState();
    if (widget.dias > 0) _controle.repeat();
  }

  @override
  void didUpdateWidget(ChamaSequencia old) {
    super.didUpdateWidget(old);
    if (old.dias != widget.dias) {
      _controle.duration = Duration(milliseconds: _ciclo);
    }
    if (widget.dias > 0 && !_controle.isAnimating) {
      _controle.repeat();
    } else if (widget.dias <= 0 && _controle.isAnimating) {
      _controle.stop();
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

    if (widget.dias <= 0) {
      return Icon(Icons.local_fire_department_rounded,
          color: tema.secondaryText.withValues(alpha: 0.45),
          size: widget.tamanhoBase);
    }

    return SizedBox(
      // Só o espaço para esticar e balançar sem ser cortada.
      width: _tamanho + 4.0,
      height: _tamanho + 6.0,
      child: AnimatedBuilder(
        animation: _controle,
        builder: (context, _) {
          final t = _controle.value * 2 * math.pi;

          final lenta = math.sin(t * 2);
          final media = math.sin(t * 3 + 1.1);
          final rapida = math.sin(t * 5 + 2.3);

          // A rápida entra com pouco peso: no talo ela vira vibração, e
          // vibração parece defeito.
          final tremor =
              (lenta * 0.5 + media * 0.35 + rapida * 0.15) * _amplitude;

          return Transform.translate(
            offset: Offset(0.0, -1.2 * media),
            child: Transform.rotate(
              // Cinco graus: mais que isso o ícone parece tombando em vez de
              // tremulando.
              angle: 0.09 * tremor,
              child: Transform(
                alignment: Alignment.bottomCenter,
                // Estica mais na vertical que na horizontal — fogo sobe.
                transform: Matrix4.diagonal3Values(
                  1.0 + 0.05 * tremor,
                  1.0 + 0.14 * tremor,
                  1.0,
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: Color.lerp(
                    tema.secondary,
                    tema.error,
                    // Mais perto do vermelho conforme a sequência cresce.
                    (0.5 + rapida * 0.5) * (0.45 + 0.15 * _nivel),
                  ),
                  size: _tamanho,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

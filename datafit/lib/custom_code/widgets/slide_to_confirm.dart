// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'dart:ui';

import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class SlideToConfirm extends StatefulWidget {
  const SlideToConfirm({
    Key? key,
    this.width,
    this.height,
    required this.onConfirm,
    this.backgroundColor,
    this.thumbColor,
    this.text,
    this.textColor,
    this.vidro = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future Function() onConfirm;
  final Color? backgroundColor;
  final Color? thumbColor; // cor do thumb (bolinha)
  final Color? textColor;
  final String? text;

  /// Trilha de vidro, no lugar da faixa colorida.
  ///
  /// E o desenho do "deslize para desligar" do iPhone: a trilha nao tem cor
  /// propria, ela desfoca e clareia o que esta atras. Fica para o gesto de
  /// INICIAR, que acontece sobre o conteudo do treino; o de concluir segue
  /// solido, porque ali o botao e o assunto da tela.
  final bool vidro;

  @override
  _SlideToConfirmState createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm>
    with SingleTickerProviderStateMixin {
  double _drag = 0;
  bool _completed = false;
  bool _loading = false;

  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _anim = const AlwaysStoppedAnimation(0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _anim = Tween<double>(begin: _drag, end: target)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut))
      ..addListener(() => setState(() => _drag = _anim.value));
    _ctrl.forward(from: 0);
  }

  void _onUpdate(DragUpdateDetails d, double maxDrag) {
    if (_completed || _loading) return;
    setState(() => _drag = (_drag + d.delta.dx).clamp(0, maxDrag));
  }

  Future<void> _onEnd(DragEndDetails d, double maxDrag) async {
    if (_completed || _loading) return;
    if (_drag > maxDrag * 0.82) {
      _animateTo(maxDrag);
      setState(() {
        _completed = true;
        _loading = true;
      });
      await widget.onConfirm();
      // reseta após execução
      if (mounted) {
        setState(() {
          _completed = false;
          _loading = false;
        });
        _animateTo(0);
      }
    } else {
      _animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Usa o tamanho do pai; os parâmetros do FF são fallback
      final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
          ? constraints.maxWidth
          : (widget.width ?? 300.0);
      final h = constraints.maxHeight.isFinite &&
              constraints.maxHeight > 0 &&
              constraints.maxHeight < 200
          ? constraints.maxHeight
          : (widget.height ?? 60.0);

      // Thumb é um círculo perfeito com diâmetro = h - padding interno
      const double kPad = 4.0;
      final double thumbD = h - kPad * 2; // diâmetro
      final double maxDrag = w - thumbD - kPad * 2;

      final bgColor = widget.backgroundColor ?? const Color(0xFFE5E7EB);
      final thumbColor = widget.thumbColor ?? const Color(0xFF1B98E0);
      final txtColor = widget.textColor ?? Colors.grey.shade500;

      // Progresso 0..1 para fade do texto e efeito no thumb
      final progress = maxDrag > 0 ? (_drag / maxDrag).clamp(0.0, 1.0) : 0.0;

      return SizedBox(
        width: w,
        height: h,
        child: Stack(
          children: [
            // ── Trilha ────────────────────────────────────────────────────
            //
            // Comeca onde o thumb esta, e nao na borda: o trecho ja percorrido
            // some conforme o dedo avanca e volta a aparecer se o dedo recuar,
            // como no "deslize para desligar" do iPhone. A trilha deixa de ser
            // um fundo parado e passa a ser o quanto falta — o gesto vira uma
            // medida em vez de um enfeite.
            Positioned(
              left: _drag,
              top: 0,
              bottom: 0,
              right: 0,
              child: widget.vidro
                  ? ClipRRect(
                      // O ClipRRect nao e decorativo: sem ele o BackdropFilter
                      // desfoca a tela inteira, nao so o retangulo da trilha.
                      borderRadius: BorderRadius.circular(h / 2),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(h / 2),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.45),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(h / 2),
                      ),
                    ),
            ),

            // O realce que ficava atrás do thumb saiu junto: ele pintava
            // justamente o trecho que agora tem de sumir.

            // ── Texto central ─────────────────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: (1.0 - progress * 2.5).clamp(0.0, 1.0),
                    child: Text(
                      widget.text ?? 'Deslize para confirmar',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: txtColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Thumb ─────────────────────────────────────────────────────
            Positioned(
              left: kPad + _drag,
              top: kPad,
              child: GestureDetector(
                onHorizontalDragUpdate: (d) => _onUpdate(d, maxDrag),
                onHorizontalDragEnd: (d) => _onEnd(d, maxDrag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: thumbD,
                  height: thumbD,
                  decoration: BoxDecoration(
                    // No vidro o thumb e a unica peca opaca: e ele que da o
                    // ponto de apoio visual para o dedo.
                    color: widget.vidro ? Colors.white : thumbColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: thumbColor.withOpacity(0.35),
                        blurRadius: 8 + progress * 6,
                        spreadRadius: progress * 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _loading
                      ? Padding(
                          padding: const EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        )
                      : _SlideArrow(
                          progress: progress,
                          cor: widget.vidro ? thumbColor : Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Seta dentro do thumb.
///
/// Ela desbotava conforme o dedo avançava e chegava ao fim invisível: o
/// thumb terminava o gesto como um disco vazio, e o botão parecia ter se
/// apagado justo no instante em que a ação acontece. Agora ela só perde um
/// pouco de força — o suficiente para não competir com o movimento — e
/// continua legível do começo ao fim.
class _SlideArrow extends StatelessWidget {
  const _SlideArrow({required this.progress, this.cor = Colors.white});
  final double progress;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: 1.0 - 0.25 * progress.clamp(0.0, 1.0),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: cor,
          size: 22,
        ),
      ),
    );
  }
}

/// Transição entre as abas da navbar.
///
/// O conteúdo não desliza como um carrossel — ele **assenta**. São três coisas
/// acontecendo juntas, curtas:
///
///  * um deslocamento de apenas 7% da largura, no sentido da aba escolhida —
///    ir para a direita na navbar traz o conteúdo da direita;
///  * uma escala saindo de 0.985, que dá o "respiro" de algo pousando;
///  * um fade que começa levemente atrasado, para a tela não piscar.
///
/// A curva é `easeOutCubic`: sai rápido e desacelera forte no fim. É o mesmo
/// gesto de uma repetição terminada sob controle — combina com o contexto do
/// app e evita a sensação de deslize solto.
///
/// A tela que **sai** também se move, metade da distância e no sentido oposto.
/// É a parte que costuma faltar: sem isso a transição parece um corte.
library;

import 'package:flutter/widgets.dart';

import 'nav/nav.dart';

/// Curta de propósito. Acima de ~300ms a troca de aba começa a parecer lenta
/// em uso repetido.
const Duration _kDuracao = Duration(milliseconds: 280);

/// Fração da largura percorrida pela tela que entra.
const double _kDeslocamento = 0.07;

/// Monta a transição para uma troca de aba.
///
/// [paraDireita] indica que o destino está à direita na navbar, então o
/// conteúdo entra pela direita.
TransitionInfo transicaoAba({required bool paraDireita}) {
  final double dx = paraDireita ? _kDeslocamento : -_kDeslocamento;

  return TransitionInfo(
    hasTransition: true,
    duration: _kDuracao,
    builder: (context, animation, secondaryAnimation, child) {
      final entrada = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      // A saída usa uma curva mais suave: quem sai não deve chamar atenção.
      final saida = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOut,
      );

      // Na saída a tela apenas se apaga, sem deslizar. Como a navbar usa
      // `goNamed` (aba substitui aba), quem sai não recebe `secondaryAnimation`
      // — toca a própria entrada ao contrário. Sem esta guarda ela voltaria
      // para o lado de onde entrou, que nem sempre é o oposto da nova aba.
      final saindo = animation.status == AnimationStatus.reverse;

      final desliza = Tween<Offset>(
        begin: saindo ? Offset.zero : Offset(dx, 0.0),
        end: Offset.zero,
      ).animate(entrada);

      final recua = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-dx * 0.5, 0.0),
      ).animate(saida);

      final cresce = Tween<double>(
        begin: 0.985,
        end: 1.0,
      ).animate(entrada);

      // O fade entra depois dos primeiros 12% para não piscar no começo.
      final aparece = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.12, 1.0, curve: Curves.easeOut),
      );

      return SlideTransition(
        position: recua,
        child: SlideTransition(
          position: desliza,
          child: FadeTransition(
            opacity: aparece,
            child: ScaleTransition(
              scale: cresce,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

/// Empacota a transição no formato que o `context.pushNamed` espera.
Map<String, dynamic> extraDaAba({required bool paraDireita}) => {
      '__transition_info__': transicaoAba(paraDireita: paraDireita),
    };

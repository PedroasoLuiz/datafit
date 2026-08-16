/// Quem mandou e quando: as duas peças que faltavam nas notificações.
///
/// Uma lista de avisos sem data faz tudo parecer recente — "pagamento
/// pendente" de maio lê igual ao de hoje, e é a data que decide se aquilo
/// ainda importa. E sem rosto, a notificação parece vir do app mesmo quando
/// quem falou foi o personal da pessoa.
///
/// As duas moram no mesmo arquivo porque respondem à mesma pergunta e
/// aparecem sempre juntas, na listagem e na tela de novidades.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// "agora", "há 2 h", "há 3 sem".
///
/// Curto de propósito: isto divide a linha com o título, e "há aproximadamente
/// 3 semanas" empurraria o título para a segunda linha em todo cartão.
///
/// A conta é feita no fuso do aparelho, com a data convertida para local antes
/// — o banco devolve UTC, e comparar UTC com o relógio de São Paulo daria três
/// horas de erro, o bastante para "agora" virar "há 3 h".
String tempoRelativo(String iso) {
  final quando = DateTime.tryParse(iso)?.toLocal();
  if (quando == null) return '';

  final diferenca = DateTime.now().difference(quando);

  // Data no futuro (relógio do aparelho atrasado, por exemplo) vira "agora":
  // "há -2 h" seria pior que impreciso.
  if (diferenca.isNegative || diferenca.inMinutes < 1) return 'agora';
  if (diferenca.inMinutes < 60) return 'há ${diferenca.inMinutes} min';
  if (diferenca.inHours < 24) return 'há ${diferenca.inHours} h';
  if (diferenca.inDays < 7) {
    return 'há ${diferenca.inDays} ${diferenca.inDays == 1 ? 'dia' : 'dias'}';
  }
  if (diferenca.inDays < 30) return 'há ${diferenca.inDays ~/ 7} sem';
  if (diferenca.inDays < 365) return 'há ${diferenca.inDays ~/ 30} mes';
  return 'há ${diferenca.inDays ~/ 365} a';
}

/// O rosto de quem mandou a notificação.
///
/// Com foto, mostra a foto. Sem foto mas com remetente, as iniciais do nome —
/// um contorno vazio diria menos que duas letras. Sem remetente nenhum, o
/// símbolo do app, porque aí quem falou foi o sistema mesmo.
class AvatarNotificacao extends StatelessWidget {
  const AvatarNotificacao({
    super.key,
    required this.foto,
    required this.nome,
    this.tamanho = 38.0,
    this.sobreEscuro = false,
  });

  final String foto;
  final String nome;
  final double tamanho;

  /// Na tela de novidades o fundo é o azul da marca, e os tons claros do tema
  /// desapareceriam nele.
  final bool sobreEscuro;

  /// Até duas letras: "Pedro Luiz" vira "PL", "Ana" vira "A".
  String get _iniciais {
    final partes =
        nome.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final fundo =
        sobreEscuro ? Colors.white.withValues(alpha: 0.2) : tema.accent1;
    final tinta = sobreEscuro ? Colors.white : tema.primary;

    Widget dentro;
    if (foto.isNotEmpty) {
      dentro = CachedNetworkImage(
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        imageUrl: foto,
        width: tamanho,
        height: tamanho,
        fit: BoxFit.cover,
        // Enquanto carrega e se falhar, o mesmo desenho de quem não tem foto:
        // um quadrado cinza piscando no lugar do rosto chama mais atenção que
        // a própria notificação.
        placeholder: (_, __) => _semFoto(tema, fundo, tinta),
        errorWidget: (_, __, ___) => _semFoto(tema, fundo, tinta),
      );
    } else {
      dentro = _semFoto(tema, fundo, tinta);
    }

    return ClipOval(
      child: SizedBox(width: tamanho, height: tamanho, child: dentro),
    );
  }

  Widget _semFoto(FlutterFlowTheme tema, Color fundo, Color tinta) {
    final iniciais = _iniciais;

    return Container(
      width: tamanho,
      height: tamanho,
      color: fundo,
      alignment: Alignment.center,
      child: iniciais.isEmpty
          // Sem remetente: o aviso veio do próprio app.
          ? Padding(
              padding: EdgeInsets.all(tamanho * 0.22),
              child: Image.asset(
                'assets/images/logodatafitazul.png',
                fit: BoxFit.contain,
                color: sobreEscuro ? Colors.white : null,
              ),
            )
          : Text(
              iniciais,
              style: tema.bodyMedium.override(
                color: tinta,
                fontSize: tamanho * 0.36,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}

/// A sequência por dentro: quais dias foram treinados e o que se fez neles.
///
/// O cartão de sequência mostra um número. Tocar na chama tem que responder de
/// onde ele veio — senão o número é uma afirmação sem prova, e é justamente o
/// tipo de dado que uma pessoa quer conferir ("três dias? qual foi o
/// terceiro?").
///
/// Reaproveita a abertura das comemorações: o círculo cresce do ponto que foi
/// tocado, e a tela se monta por cima dele. Aqui em laranja, a cor da própria
/// chama.
library;

import 'dart:math' as math;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';

/// Abre a tela dos dias treinados.
Future<void> mostrarDiasTreinados(
  BuildContext context, {
  required int sequenciaAtual,
  required int sequenciaMaxima,
  Offset? origem,
}) async {
  await Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => _TelaDias(
        sequenciaAtual: sequenciaAtual,
        sequenciaMaxima: sequenciaMaxima,
        origem: origem,
      ),
      transitionsBuilder: (_, animacao, __, filho) =>
          FadeTransition(opacity: animacao, child: filho),
    ),
  );
}

class _TelaDias extends StatefulWidget {
  const _TelaDias({
    required this.sequenciaAtual,
    required this.sequenciaMaxima,
    this.origem,
  });

  final int sequenciaAtual;
  final int sequenciaMaxima;
  final Offset? origem;

  @override
  State<_TelaDias> createState() => _TelaDiasState();
}

class _TelaDiasState extends State<_TelaDias>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final Animation<double> _circulo = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _conteudo = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
  );

  List<Map<String, dynamic>>? _dias;
  bool _falhou = false;

  /// Quantos dias estão à mostra. A busca traz até sessenta de uma vez — são
  /// poucos bytes —, mas despejar tudo faria a lista abrir já rolando, e o
  /// que interessa de imediato são os últimos.
  int _visiveis = 10;

  @override
  void initState() {
    super.initState();
    _controle.forward();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final resposta = await SupaFlow.client.rpc(
        'get_dias_treinados',
        params: {'p_aluno_uuid': currentUserUid, 'p_limite': 60},
      );
      if (!mounted) return;
      setState(() => _dias = (resposta as List? ?? [])
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList());
    } catch (_) {
      if (!mounted) return;
      setState(() => _falhou = true);
    }
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  static const _meses = [
    'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez',
  ];
  static const _semana = [
    'segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo',
  ];

  /// "hoje", "ontem" ou "qua, 13 de ago".
  ///
  /// Nome do dia da semana junto: numa lista de datas soltas, "13 de ago" não
  /// diz nada, e é pelo dia da semana que a pessoa lembra da rotina dela.
  String _rotuloDoDia(DateTime d) {
    final hoje = DateTime.now();
    final so = DateTime(d.year, d.month, d.day);
    final h = DateTime(hoje.year, hoje.month, hoje.day);
    final diff = h.difference(so).inDays;
    if (diff == 0) return 'hoje';
    if (diff == 1) return 'ontem';
    final dia = _semana[so.weekday - 1].substring(0, 3);
    return '$dia, ${so.day} de ${_meses[so.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final medida = MediaQuery.sizeOf(context);
    final origem =
        widget.origem ?? Offset(medida.width / 2, medida.height / 2);

    double distancia(Offset canto) => (canto - origem).distance;
    final raio = [
      distancia(Offset.zero),
      distancia(Offset(medida.width, 0.0)),
      distancia(Offset(0.0, medida.height)),
      distancia(Offset(medida.width, medida.height)),
    ].reduce(math.max);

    return AnimatedBuilder(
      animation: _controle,
      builder: (context, _) => Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned(
              left: origem.dx - raio,
              top: origem.dy - raio,
              child: Transform.scale(
                scale: _circulo.value,
                child: Container(
                  width: raio * 2,
                  height: raio * 2,
                  decoration: BoxDecoration(
                    color: tema.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: _conteudo.value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0.0, 20.0 * (1 - _conteudo.value)),
                child: SafeArea(child: _corpo(tema)),
              ),
            ),
            // O X fora do corpo, preso ao canto: dentro da coluna ele
            // disputava a linha com o titulo e empurrava o texto para o meio.
            Positioned(
              top: 0.0,
              right: 0.0,
              child: SafeArea(
                child: Opacity(
                  opacity: _conteudo.value.clamp(0.0, 1.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 26.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corpo(FlutterFlowTheme tema) {
    final altura = MediaQuery.sizeOf(context).height;

    // Metade de baixo para a lista, metade de cima para o selo e o título.
    // Deixar a lista em `Expanded` fazia ela comer a tela inteira e empurrar
    // o cabeçalho para fora; presa em 50%, ela rola dentro do próprio espaço
    // e o que explica o número continua à vista.
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
        // O mesmo selo das comemorações: círculo translúcido com o símbolo do
        // assunto dentro. É ele que amarra esta tela às outras do app.
        Container(
          width: 88.0,
          height: 88.0,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.local_fire_department_rounded,
              color: Colors.white, size: 50.0),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            widget.sequenciaAtual > 0
                ? 'Você está em ${widget.sequenciaAtual} ${widget.sequenciaAtual == 1 ? 'dia' : 'dias'} seguidos'
                : 'Seu recorde: ${widget.sequenciaMaxima} ${widget.sequenciaMaxima == 1 ? 'dia' : 'dias'} seguidos',
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: -0.3,
              fontWeight: FontWeight.bold,
              lineHeight: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            widget.sequenciaAtual > 0 &&
                    widget.sequenciaAtual < widget.sequenciaMaxima
                ? 'Seu recorde é de ${widget.sequenciaMaxima} dias.'
                : 'Cada dia abaixo é um treino que você fechou.',
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
            ],
          ),
        ),
        SizedBox(height: altura * 0.5, child: _lista(tema)),
      ],
    );
  }

  Widget _lista(FlutterFlowTheme tema) {
    if (_falhou) {
      return _aviso(tema, 'Não consegui carregar seus dias agora.');
    }
    if (_dias == null) {
      return const Center(
        child: SizedBox(
          width: 26.0,
          height: 26.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }
    if (_dias!.isEmpty) {
      return _aviso(tema, 'Você ainda não fechou nenhum treino.');
    }

    final total = _dias!.length;
    final mostrando = _visiveis < total ? _visiveis : total;

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
      // Uma linha a mais quando ainda há o que mostrar: é o "ver mais".
      itemCount: mostrando + (mostrando < total ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 8.0),
      itemBuilder: (context, i) {
        if (i == mostrando) {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: TextButton(
              onPressed: () => setState(
                  () => _visiveis = (_visiveis + 10).clamp(0, total)),
              child: Text(
                'Ver mais ${(total - mostrando) < 10 ? (total - mostrando) : 10}',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: Colors.white,
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }
        final item = _dias![i];
        final data = DateTime.tryParse('${item['dia']}');
        final treinos = (item['treinos'] as List? ?? []).cast<String>();
        final naSequencia = item['emSequencia'] == true;

        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            // Os dias da sequência viva ficam mais opacos que os antigos: a
            // lista inteira é histórico, e é o bloco corrente que responde a
            // pergunta que trouxe a pessoa até aqui.
            color: Colors.white.withValues(alpha: naSequencia ? 0.18 : 0.08),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Row(
            children: [
              Icon(
                naSequencia
                    ? Icons.local_fire_department_rounded
                    : Icons.check_rounded,
                color: Colors.white.withValues(alpha: naSequencia ? 1.0 : 0.7),
                size: 18.0,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data == null ? '${item['dia']}' : _rotuloDoDia(data),
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: Colors.white,
                        fontSize: 13.5,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (treinos.isNotEmpty)
                      Text(
                        treinos.join(' · '),
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11.5,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              // Dois ou três treinos no mesmo dia é informação: sem o número,
              // a lista faz parecer que todo dia rendeu igual.
              if (treinos.length > 1)
                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      8.0, 3.0, 8.0, 3.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999.0),
                  ),
                  child: Text(
                    '${treinos.length}',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: Colors.white,
                      fontSize: 11.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _aviso(FlutterFlowTheme tema, String texto) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13.5,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}

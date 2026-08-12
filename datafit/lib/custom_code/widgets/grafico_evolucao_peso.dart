// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import '/flutter_flow/unidade_carga.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:ui' as ui;
import 'index.dart';

class GraficoEvolucaoPeso extends StatefulWidget {
  const GraficoEvolucaoPeso({
    super.key,
    this.width,
    this.height,
    this.periodoLabel = '4 meses',
    this.corPrimaria = const Color(0xFF1B98E0),
  });

  final double? width;
  final double? height;
  final String periodoLabel;
  final Color corPrimaria;

  @override
  State<GraficoEvolucaoPeso> createState() => _GraficoEvolucaoPesoState();
}

class _GraficoEvolucaoPesoState extends State<GraficoEvolucaoPeso>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  late ScrollController _scrollCtrl;
  int _ativa = -1;
  bool _mostrarGordura = false;

  static const double kPontoW = 36.0; // largura por ponto no modo scroll

  bool get _isScrollavel {
    final l = widget.periodoLabel.toLowerCase().trim();
    return l == '15 dias' || l == '30 dias';
  }

  static const _mesesAbrev = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  bool get _isDias {
    final l = widget.periodoLabel.toLowerCase().trim();
    return l == '7 dias' || l == '15 dias' || l == '30 dias';
  }

  int get _numeroDias {
    final l = widget.periodoLabel.toLowerCase().trim();
    if (l == '7 dias') return 7;
    if (l == '15 dias') return 15;
    if (l == '30 dias') return 30;
    return 7;
  }

  int get _numeroMeses {
    final l = widget.periodoLabel.toLowerCase().trim();
    switch (l) {
      case '30 dias':
        return 1;
      case '2 meses':
        return 2;
      case '3 meses':
        return 3;
      case '4 meses':
        return 4;
      case '6 meses':
        return 6;
      default:
        return 4;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) => _animar());
  }

  @override
  void didUpdateWidget(GraficoEvolucaoPeso old) {
    super.didUpdateWidget(old);
    if (old.periodoLabel != widget.periodoLabel) _animar();
  }

  void _animar() {
    if (!mounted) return;
    final slots = _buildSlots();
    // Mais recente é índice 0 — seleciona o primeiro com dado
    final primeiroComDado = slots.indexWhere((s) => s['temDado'] as bool);
    setState(() => _ativa = primeiroComDado >= 0 ? primeiroComDado : 0);
    _ctrl.reset();
    _ctrl.forward();
  }

  void _trocarTipo(bool gordura) {
    if (_mostrarGordura == gordura) return;
    setState(() => _mostrarGordura = gordura);
    _animar();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<dynamic> _buscarHistorico() {
    try {
      final metricas = FFAppState().metricasTemp;
      return metricas.dsHistoricoPeso as List? ?? [];
    } catch (_) {
      return [];
    }
  }

  double _getPeso(dynamic item) {
    try {
      final v = item.peso;
      if (v != null) return (v as num).toDouble();
    } catch (_) {}
    try {
      final v = (item as Map)['peso'];
      if (v != null) return (v as num).toDouble();
    } catch (_) {}
    return 0.0;
  }

  double _getGordura(dynamic item) {
    try {
      final v = item.gordura;
      if (v != null) return (v as num).toDouble();
    } catch (_) {}
    try {
      final v = (item as Map)['gordura'];
      if (v != null) return (v as num).toDouble();
    } catch (_) {}
    return 0.0;
  }

  DateTime? _getMesAno(dynamic item) {
    try {
      final v = item.mesAno;
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    } catch (_) {}
    try {
      final v = (item as Map)['mesAno'];
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    } catch (_) {}
    return null;
  }

  // ── SLOTS — ORDEM: mais recente primeiro (índice 0) ───────────────────────
  List<Map<String, dynamic>> _buildSlots() {
    final historico = _buscarHistorico();
    final now = DateTime.now();

    if (_isDias) {
      final dias = _numeroDias;
      return List.generate(dias, (i) {
        final dia = now.subtract(Duration(days: i));

        // Busca no histórico pelo dia EXATO (ano + mês + dia)
        dynamic dadoDia;
        for (final h in historico) {
          final dt = _getMesAno(h);
          if (dt != null &&
              dt.year == dia.year &&
              dt.month == dia.month &&
              dt.day == dia.day) {
            dadoDia = h;
            break;
          }
        }

        double peso = 0.0;
        double gordura = 0.0;
        bool temRegistro = false;

        if (dadoDia != null && _getPeso(dadoDia) > 0) {
          peso = _getPeso(dadoDia);
          gordura = _getGordura(dadoDia);
          temRegistro = true;
        } else {
          // Propaga o último valor anterior a este dia
          for (final h in historico) {
            final dt = _getMesAno(h);
            if (dt == null) continue;
            if (!dt.isAfter(dia)) {
              final p = _getPeso(h);
              if (p > 0) {
                peso = p;
                gordura = _getGordura(h);
              }
            }
          }
        }

        return <String, dynamic>{
          'label':
              '${_mesesAbrev[dia.month - 1]}/${dia.year.toString().substring(2)}',
          'diaN': dia.day,
          'mesN': dia.month,
          'mesAbrev': _mesesAbrev[dia.month - 1],
          'peso': peso,
          'gordura': gordura,
          'temDado': temRegistro,
        };
      });
    } else {
      final meses = _numeroMeses;

      // Gera do mais antigo ao mais recente para propagar valor
      final slotsAsc = List.generate(meses, (i) {
        final mesOffset = meses - 1 - i; // i=0 → mais antigo
        final mesRef = DateTime(now.year, now.month - mesOffset, 1);
        final label =
            '${_mesesAbrev[mesRef.month - 1]}/${mesRef.year.toString().substring(2)}';
        dynamic dadoMes;
        for (final h in historico) {
          final dt = _getMesAno(h);
          if (dt != null &&
              dt.year == mesRef.year &&
              dt.month == mesRef.month) {
            dadoMes = h;
            break;
          }
        }
        final peso = dadoMes != null ? _getPeso(dadoMes) : 0.0;
        final gordura = dadoMes != null ? _getGordura(dadoMes) : 0.0;
        return <String, dynamic>{
          'label': label,
          'peso': peso,
          'gordura': gordura,
          'temDado': dadoMes != null && peso > 0,
          'temRegistro': dadoMes != null && peso > 0,
        };
      });

      // Propagação para frente: do mais antigo ao mais recente
      double ultimoPeso = 0.0;
      double ultimaGordura = 0.0;
      for (final slot in slotsAsc) {
        if (slot['temRegistro'] as bool) {
          ultimoPeso = slot['peso'] as double;
          ultimaGordura = slot['gordura'] as double;
        } else if (ultimoPeso > 0) {
          slot['peso'] = ultimoPeso;
          slot['gordura'] = ultimaGordura;
        }
      }

      // Propagação para trás: do mais recente ao mais antigo
      // Cobre meses APÓS o último registro (ex: Fev, Mar, Abr, Mai se Jan foi o último)
      double primeiroPeso = 0.0;
      double primeiraGordura = 0.0;
      for (int i = slotsAsc.length - 1; i >= 0; i--) {
        final slot = slotsAsc[i];
        if (slot['temRegistro'] as bool) {
          primeiroPeso = slot['peso'] as double;
          primeiraGordura = slot['gordura'] as double;
        } else if ((slot['peso'] as double) == 0.0 && primeiroPeso > 0) {
          slot['peso'] = primeiroPeso;
          slot['gordura'] = primeiraGordura;
        }
      }

      // Inverte: índice 0 = mais recente
      return slotsAsc.reversed.toList();
    }
  }

  // ── Eixo X modo dias: número em cima, mês agrupado embaixo ───────────────

  List<Map<String, dynamic>> _buildMesGroupsDias(
      List<Map<String, dynamic>> slots) {
    final groups = <Map<String, dynamic>>[];
    if (slots.isEmpty) return groups;
    int startIndex = 0;
    int currentMes = slots[0]['mesN'] as int;
    for (int i = 1; i <= slots.length; i++) {
      final isLast = i == slots.length;
      final mesAtual = isLast ? -1 : slots[i]['mesN'] as int;
      if (isLast || mesAtual != currentMes) {
        groups.add({
          'mesLabel': slots[startIndex]['mesAbrev'] as String,
          'startIndex': startIndex,
          'count': i - startIndex,
          'temProximo': !isLast,
        });
        if (!isLast) {
          startIndex = i;
          currentMes = mesAtual;
        }
      }
    }
    return groups;
  }

  Widget _buildEixoXDias(List<Map<String, dynamic>> slots, Color cor,
      {double? colW}) {
    final mesGroups = _buildMesGroupsDias(slots);
    return LayoutBuilder(builder: (context, constraints) {
      final totalW = constraints.maxWidth;
      final barW = colW ?? (slots.isNotEmpty ? totalW / slots.length : totalW);

      return Column(
        children: [
          // Linha 1: número do dia
          SizedBox(
            height: 18,
            child: Row(
              children: List.generate(slots.length, (i) {
                final isAtiva = _ativa == i;
                final dia = slots[i]['diaN'] as int;
                final child = GestureDetector(
                  onTap: () => setState(() => _ativa = i),
                  child: Center(
                    child: Text('$dia',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight:
                              isAtiva ? FontWeight.w700 : FontWeight.w400,
                          color: isAtiva ? cor : Colors.grey.shade400,
                        )),
                  ),
                );
                return colW != null
                    ? SizedBox(width: colW, child: child)
                    : Expanded(child: child);
              }),
            ),
          ),

          // Linha 2: linha horizontal + labels de mês agrupados
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Linha horizontal
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.grey.shade200),
                ),
                // Labels dos meses
                ...mesGroups.map((g) {
                  final start = g['startIndex'] as int;
                  final count = g['count'] as int;
                  final label = g['mesLabel'] as String;
                  final temProximo = g['temProximo'] as bool;
                  final left = start * barW;
                  final width = count * barW;
                  return Stack(
                    children: [
                      Positioned(
                        left: left,
                        width: width,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(label,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                    letterSpacing: 0.3)),
                          ),
                        ),
                      ),
                      if (temProximo)
                        Positioned(
                          left: left + width - 5,
                          top: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: cor, width: 1.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final slots = _buildSlots();
    final totalW = widget.width ?? 300.0;
    final totalH = widget.height ?? 280.0;

    final corPeso = widget.corPrimaria;
    final corGordura = const Color(0xFFF59E0B);
    final corAtiva = _mostrarGordura ? corGordura : corPeso;
    // A unidade sai da preferencia do perfil, nao de um literal. O banco
    // guarda sempre em kg (ver unidade_carga.dart); aqui e so exibicao.
    // Gordura e percentual e nao se converte.
    final unidade = _mostrarGordura ? '%' : rotuloUnidade;

    final valores = slots
        .map((s) => _mostrarGordura
            ? (s['gordura'] as double)
            : kgParaExibicao(s['peso'] as double))
        .toList();
    final temDados = slots.map((s) => s['temDado'] as bool).toList();

    final valoresComDado = valores.where((v) => v > 0).toList();
    final maxVal = valoresComDado.isEmpty
        ? 1.0
        : valoresComDado.fold(0.0, (p, v) => v > p ? v : p);
    final minVal = valoresComDado.isEmpty
        ? 0.0
        : valoresComDado.fold(double.infinity, (p, v) => v < p ? v : p);
    // Margem de 5% do valor mínimo — linha nunca fica na base,
    // e diferenças pequenas (ex: 66→67.5) não são exageradas
    final margem = minVal > 0 ? minVal * 0.05 : 1.0;
    final yMin = (minVal - margem).clamp(0.0, double.infinity);
    final yMax = maxVal + margem;
    final yRange = (yMax - yMin).clamp(1.0, double.infinity);

    // Delta: índice 0 = mais recente, último = mais antigo
    final primeiro = valoresComDado.isNotEmpty ? valoresComDado.first : 0.0;
    final ultimo = valoresComDado.isNotEmpty ? valoresComDado.last : 0.0;
    final delta = ultimo > 0 ? ((primeiro - ultimo) / ultimo * 100) : 0.0;
    final isPositivo = delta <= 0; // queda de peso = positivo

    // Valor atual = primeiro valor não-zero da lista (propagado ou real)
    final valorAtual = valores.firstWhere((v) => v > 0, orElse: () => 0.0);

    const double kPadTop = 16;
    const double kHeaderH = 26;
    const double kToggleH = 32;
    const double kGapH = 12;
    final double kLabelsH = _isDias ? 44.0 : 22.0;
    const double kDividerH = 21;
    const double kFooterH = 38;
    const double kPadBot = 14;
    final double kFixed = kPadTop +
        kHeaderH +
        kToggleH +
        kGapH +
        kLabelsH +
        kDividerH +
        kFooterH +
        kPadBot;
    // chartH já é descontado de kLabelsH — o SizedBox engloba ambos
    final chartH = (totalH - kFixed).clamp(60.0, totalH);

    return SizedBox(
      width: totalW,
      height: totalH,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, kPadTop, 16, kPadBot),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header — sem repetir o período ──────────────────────────────
            SizedBox(
              height: kHeaderH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título com capitalização normal, sem all-caps
                  Text('Evolução física',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700)),
                  // Contagem de registros no lugar do período repetido
                  Text(
                    () {
                      final n = slots.where((s) => s['temDado'] as bool).length;
                      if (n == 0) return 'Sem registros';
                      return '$n ${n == 1 ? 'registro' : 'registros'}';
                    }(),
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),

            // Toggle
            SizedBox(
              height: kToggleH,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    _ToggleBtn(
                        label: 'Peso',
                        ativo: !_mostrarGordura,
                        cor: corPeso,
                        onTap: () => _trocarTipo(false)),
                    _ToggleBtn(
                        label: 'Gordura',
                        ativo: _mostrarGordura,
                        cor: corGordura,
                        onTap: () => _trocarTipo(true)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: kGapH),

            // Gráfico + eixo X (dias scrolláveis juntos, meses separados)
            if (_isDias && _isScrollavel)
              SizedBox(
                height: chartH + kLabelsH,
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: kPontoW * slots.length,
                    child: Column(
                      children: [
                        SizedBox(
                          height: chartH,
                          child: AnimatedBuilder(
                            animation: _anim,
                            builder: (context, _) => _LineChart(
                              slots: slots,
                              valores: valores,
                              temDados: temDados,
                              yMin: yMin,
                              yRange: yRange,
                              progress: _anim.value,
                              ativaIdx: _ativa,
                              cor: corAtiva,
                              unidade: unidade,
                              onTap: (i) => setState(() => _ativa = i),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kLabelsH,
                          child:
                              _buildEixoXDias(slots, corAtiva, colW: kPontoW),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_isDias && !_isScrollavel)
              Column(
                children: [
                  SizedBox(
                    height: chartH,
                    child: AnimatedBuilder(
                      animation: _anim,
                      builder: (context, _) => _LineChart(
                        slots: slots,
                        valores: valores,
                        temDados: temDados,
                        yMin: yMin,
                        yRange: yRange,
                        progress: _anim.value,
                        ativaIdx: _ativa,
                        cor: corAtiva,
                        unidade: unidade,
                        onTap: (i) => setState(() => _ativa = i),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kLabelsH,
                    child: _buildEixoXDias(slots, corAtiva),
                  ),
                ],
              ),
            if (!_isDias)
              SizedBox(
                height: chartH,
                child: AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) => _LineChart(
                    slots: slots,
                    valores: valores,
                    temDados: temDados,
                    yMin: yMin,
                    yRange: yRange,
                    progress: _anim.value,
                    ativaIdx: _ativa,
                    cor: corAtiva,
                    unidade: unidade,
                    onTap: (i) => setState(() => _ativa = i),
                  ),
                ),
              ),
            if (!_isDias)
              SizedBox(
                height: kLabelsH,
                child: Row(
                  children: List.generate(slots.length, (i) {
                    final isAtiva = _ativa == i;
                    final temDado = slots[i]['temDado'] as bool;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _ativa = i),
                        child: Center(
                          child: Text(
                            slots[i]['label'] as String,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight:
                                  isAtiva ? FontWeight.w700 : FontWeight.w500,
                              color: isAtiva
                                  ? corAtiva
                                  : (temDado
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, thickness: 1),
            ),

            // Footer
            SizedBox(
              height: kFooterH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: valoresComDado.isEmpty
                          ? Colors.grey.shade100
                          : (isPositivo
                              ? const Color(0xFF059669).withOpacity(0.1)
                              : const Color(0xFFDC2626).withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (valoresComDado.isNotEmpty)
                          Icon(
                            isPositivo
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            size: 13,
                            color: isPositivo
                                ? const Color(0xFF059669)
                                : const Color(0xFFDC2626),
                          ),
                        const SizedBox(width: 4),
                        Text(
                          valoresComDado.isEmpty
                              ? 'Sem registros'
                              : '${delta.abs().toStringAsFixed(1)}% no período',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: valoresComDado.isEmpty
                                ? Colors.grey.shade400
                                : (isPositivo
                                    ? const Color(0xFF059669)
                                    : const Color(0xFFDC2626)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(TextSpan(
                    text: 'Atual: ',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.grey.shade400),
                    children: [
                      TextSpan(
                        text: valorAtual > 0
                            ? '${valorAtual.toStringAsFixed(valorAtual.truncateToDouble() == valorAtual ? 0 : 1)} $unidade'
                            : '--',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Toggle ────────────────────────────────────────────────────────────────────
class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn(
      {required this.label,
      required this.ativo,
      required this.cor,
      required this.onTap});
  final String label;
  final bool ativo;
  final Color cor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: ativo ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: ativo
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1))
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ativo ? cor : Colors.grey.shade400)),
        ),
      ),
    );
  }
}

// ── LineChart ─────────────────────────────────────────────────────────────────
class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.slots,
    required this.valores,
    required this.temDados,
    required this.yMin,
    required this.yRange,
    required this.progress,
    required this.ativaIdx,
    required this.cor,
    required this.unidade,
    required this.onTap,
  });

  final List<Map<String, dynamic>> slots;
  final List<double> valores;
  final List<bool> temDados;
  final double yMin;
  final double yRange;
  final double progress;
  final int ativaIdx;
  final Color cor;
  final String unidade;
  final void Function(int) onTap;

  double _yRatio(double v) => 1.0 - ((v - yMin) / yRange).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final n = slots.length;
    if (n == 0) return const SizedBox.shrink();

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;
      if (w <= 0 || h <= 0) return const SizedBox.shrink();

      // x centralizado na coluna i: cada coluna tem largura w/n, centro em (i+0.5)*colW
      final colWChart = w / n;
      final points = List.generate(n, (i) {
        final x = (i + 0.5) * colWChart;
        final y =
            valores[i] > 0 ? _yRatio(valores[i]) * h * progress : h * 0.85;
        return Offset(x, y);
      });

      const double kR = 5.0;
      const double kRAlt = 7.0;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _LinePainter(
                points: points,
                temDados: temDados,
                cor: cor,
                progress: progress,
                chartW: w,
                chartH: h,
              ),
            ),
          ),

          // Toque por coluna
          ...List.generate(n, (i) {
            final colW = w / n;
            return Positioned(
              left: i * colW,
              top: 0,
              width: colW,
              height: h,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: const ColoredBox(color: Colors.transparent),
              ),
            );
          }),

          // Pontos
          ...List.generate(n, (i) {
            final pt = points[i];
            final isAtiva = ativaIdx == i;
            final temDado = temDados[i];
            final r = isAtiva ? kRAlt : kR;
            return Positioned(
              left: pt.dx - r,
              top: pt.dy - r,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Container(
                  width: r * 2,
                  height: r * 2,
                  decoration: BoxDecoration(
                    color: !temDado
                        ? Colors.grey.shade200
                        : (isAtiva ? cor : Colors.white),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: !temDado ? Colors.grey.shade300 : cor,
                      width: isAtiva ? 0 : 2,
                    ),
                    boxShadow: isAtiva && temDado
                        ? [
                            BoxShadow(
                                color: cor.withOpacity(0.35),
                                blurRadius: 8,
                                spreadRadius: 1)
                          ]
                        : null,
                  ),
                ),
              ),
            );
          }),

          // Tooltip
          if (ativaIdx >= 0 && ativaIdx < n && temDados[ativaIdx])
            _buildTooltip(points[ativaIdx], valores[ativaIdx], w),
        ],
      );
    });
  }

  Widget _buildTooltip(Offset pt, double valor, double chartW) {
    const kW = 80.0;
    const kH = 32.0;
    const kGap = 10.0;
    final left = (pt.dx - kW / 2).clamp(0.0, chartW - kW);
    final top = (pt.dy - kH - kGap).clamp(0.0, double.infinity);
    final str = valor.truncateToDouble() == valor
        ? valor.toInt().toString()
        : valor.toStringAsFixed(1);
    return Positioned(
      left: left,
      top: top,
      width: kW,
      height: kH,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(8)),
        child: Text('$str $unidade',
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ),
    );
  }
}

// ── Painter ───────────────────────────────────────────────────────────────────
class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.points,
    required this.temDados,
    required this.cor,
    required this.progress,
    required this.chartW,
    required this.chartH,
  });

  final List<Offset> points;
  final List<bool> temDados;
  final Color cor;
  final double progress;
  final double chartW;
  final double chartH;

  @override
  void paint(Canvas canvas, Size _) {
    if (points.length < 2) return;

    final segmentos = <List<int>>[];
    List<int>? atual;
    for (int i = 0; i < points.length; i++) {
      // Inclui na linha: pontos com registro real OU com valor propagado (peso != baseline)
      final temValor = temDados[i] || points[i].dy < chartH * 0.8;
      if (temValor) {
        atual ??= [];
        atual.add(i);
      } else {
        if (atual != null && atual.length >= 1) {
          segmentos.add(atual);
          atual = null;
        }
      }
    }
    if (atual != null && atual.length >= 1) segmentos.add(atual);

    final linePaint = Paint()
      ..color = cor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final seg in segmentos) {
      if (seg.length < 2) continue;
      final path = Path();
      path.moveTo(points[seg[0]].dx, points[seg[0]].dy);
      for (int k = 0; k < seg.length - 1; k++) {
        final curr = points[seg[k]];
        final next = points[seg[k + 1]];
        final cpX = (curr.dx + next.dx) / 2;
        path.cubicTo(cpX, curr.dy, cpX, next.dy, next.dx, next.dy);
      }
      canvas.drawPath(path, linePaint);

      final fillPath = Path()..addPath(path, Offset.zero);
      fillPath.lineTo(points[seg.last].dx, chartH);
      fillPath.lineTo(points[seg.first].dx, chartH);
      fillPath.close();
      canvas.drawPath(
          fillPath,
          Paint()
            ..shader = ui.Gradient.linear(
              Offset.zero,
              Offset(0, chartH),
              [cor.withOpacity(0.18 * progress), cor.withOpacity(0.0)],
            )
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.progress != progress || old.points != points || old.cor != cor;
}

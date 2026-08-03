// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart';

class GraficoEvolucaoCarga extends StatefulWidget {
  const GraficoEvolucaoCarga({
    super.key,
    this.width,
    this.height,
    required this.exercicioSelecionado,
    this.periodoLabel = '4 meses',
    this.corPrimaria = const Color(0xFF1B98E0),
  });

  final double? width;
  final double? height;
  final String exercicioSelecionado;
  final String periodoLabel;
  final Color corPrimaria;

  @override
  State<GraficoEvolucaoCarga> createState() => _GraficoEvolucaoCargaState();
}

class _GraficoEvolucaoCargaState extends State<GraficoEvolucaoCarga>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  late ScrollController _scrollCtrl;
  int _ativa = -1;

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

  bool get _isScrollavel {
    final l = widget.periodoLabel.toLowerCase().trim();
    return l == '15 dias' || l == '30 dias';
  }

  bool get _isDias {
    final l = widget.periodoLabel.toLowerCase().trim();
    return l == '7 dias' || l == '15 dias' || l == '30 dias';
  }

  int get _numeroDias {
    final l = widget.periodoLabel.toLowerCase().trim();
    if (l == '7 dias') return 7;
    if (l == '15 dias') return 15;
    if (l == '30 dias') return 30;
    return 0;
  }

  int get _numeroMeses {
    final l = widget.periodoLabel.toLowerCase().trim();
    switch (l) {
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

  static const double kBarWDias = 36.0;
  static const double kTooltipReserva = 46.0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animar();
      if (_isScrollavel && _scrollCtrl.hasClients) {
        _scrollCtrl.jumpTo(0);
      }
    });
  }

  @override
  void didUpdateWidget(GraficoEvolucaoCarga old) {
    super.didUpdateWidget(old);
    if (old.exercicioSelecionado != widget.exercicioSelecionado ||
        old.periodoLabel != widget.periodoLabel) {
      _animar();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isScrollavel && _scrollCtrl.hasClients) {
          _scrollCtrl.jumpTo(0);
        }
      });
    }
  }

  void _animar() {
    if (!mounted) return;
    final slots = _buildSlots();
    final primeiro = slots.indexWhere((s) => s['temDado'] as bool);
    setState(() => _ativa = primeiro >= 0 ? primeiro : 0);
    _ctrl.reset();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<dynamic> _buscarHistorico() {
    try {
      final metricas = FFAppState().metricasTemp;
      for (final categoria in metricas.dsExercicios) {
        final subcategorias = categoria.subcategorias as List;
        for (final sub in subcategorias) {
          final exercicios = sub.exercicios as List;
          for (final ex in exercicios) {
            if ((ex.nome as String?) == widget.exercicioSelecionado) {
              return ex.historicoCargas as List? ?? [];
            }
          }
        }
      }
    } catch (e) {
      debugPrint('_buscarHistorico: $e');
    }
    return [];
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

  int _getQtd(dynamic item) {
    try {
      final v = item.qtd;
      if (v != null) return (v as num).toInt();
    } catch (_) {}
    try {
      final v = (item as Map)['qtd'];
      if (v != null) return (v as num).toInt();
    } catch (_) {}
    return 0;
  }

  String _getMedida(dynamic item) {
    try {
      final v = item.medida;
      if (v != null) return v.toString();
    } catch (_) {}
    try {
      final v = (item as Map)['medida'];
      if (v != null) return v.toString();
    } catch (_) {}
    return 'Kg';
  }

  DateTime? _getData(dynamic item) {
    try {
      final v = item.data;
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    } catch (_) {}
    try {
      final v = (item as Map)['data'];
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    } catch (_) {}
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

  // ── Slots ─────────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _buildSlots() {
    final historico = _buscarHistorico();
    final now = DateTime.now();

    if (_isDias) {
      final dias = _numeroDias;
      return List.generate(dias, (i) {
        final dia = now.subtract(Duration(days: i));
        final separadorDireita = i < dias - 1 &&
            now.subtract(Duration(days: i + 1)).month != dia.month;

        dynamic dadoDia;
        for (final h in historico) {
          final dt = _getData(h);
          if (dt != null &&
              dt.year == dia.year &&
              dt.month == dia.month &&
              dt.day == dia.day) {
            dadoDia = h;
            break;
          }
        }

        return {
          'dia': dia.day,
          'mes': dia.month,
          'ano': dia.year,
          'peso': dadoDia != null ? _getPeso(dadoDia) : 0.0,
          'qtd': dadoDia != null ? _getQtd(dadoDia) : 0,
          'medida': dadoDia != null ? _getMedida(dadoDia) : 'Kg',
          'temDado': dadoDia != null && _getPeso(dadoDia) > 0,
          'separadorDireita': separadorDireita,
        };
      });
    } else {
      final meses = _numeroMeses;
      return List.generate(meses, (i) {
        final dt = DateTime(now.year, now.month - i, 1);
        final mesRef = DateTime(dt.year, dt.month, 1);

        dynamic dadoMes;
        for (final h in historico) {
          final dtH = _getData(h);
          if (dtH != null &&
              dtH.year == mesRef.year &&
              dtH.month == mesRef.month) {
            dadoMes = h;
            break;
          }
        }

        return {
          'dia': 1,
          'mes': mesRef.month,
          'ano': mesRef.year,
          'peso': dadoMes != null ? _getPeso(dadoMes) : 0.0,
          'qtd': dadoMes != null ? _getQtd(dadoMes) : 0,
          'medida': dadoMes != null ? _getMedida(dadoMes) : 'Kg',
          'temDado': dadoMes != null && _getPeso(dadoMes) > 0,
          'separadorDireita': false,
        };
      });
    }
  }

  List<Map<String, dynamic>> _buildMesGroups(List<Map<String, dynamic>> slots) {
    final groups = <Map<String, dynamic>>[];
    if (slots.isEmpty) return groups;
    int startIndex = 0;
    int currentMes = slots[0]['mes'] as int;
    int currentAno = slots[0]['ano'] as int;
    for (int i = 1; i <= slots.length; i++) {
      final isLast = i == slots.length;
      final mesAtual = isLast ? -1 : slots[i]['mes'] as int;
      final anoAtual = isLast ? -1 : slots[i]['ano'] as int;
      if (isLast || mesAtual != currentMes || anoAtual != currentAno) {
        groups.add({
          'mesLabel': _mesesAbrev[currentMes - 1],
          'startIndex': startIndex,
          'count': i - startIndex,
          'temProximo': !isLast,
        });
        if (!isLast) {
          startIndex = i;
          currentMes = mesAtual;
          currentAno = anoAtual;
        }
      }
    }
    return groups;
  }

  String _footerInfo(List<Map<String, dynamic>> slots) {
    final n = slots.where((s) => s['temDado'] as bool).length;
    if (n == 0) return 'Sem registros';
    return '$n ${n == 1 ? 'registro' : 'registros'}';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final slots = _buildSlots();
    final pesos = slots.map((s) => s['peso'] as double).toList();
    final maxPeso = pesos.fold(0.0, (prev, p) => p > prev ? p : prev);
    final maxPesoSafe = maxPeso > 0 ? maxPeso : 1.0;
    final ratios = pesos.map((p) => (p / maxPesoSafe).clamp(0.0, 1.0)).toList();

    final pesosComDado = pesos.where((p) => p > 0).toList();
    final delta = pesosComDado.length >= 2
        ? ((pesosComDado.first - pesosComDado.last) / pesosComDado.last * 100)
        : 0.0;
    final isUp = delta >= 0;
    final cor = widget.corPrimaria;
    final corInativa = cor.withOpacity(0.22);

    final totalW = widget.width ?? 300.0;
    final totalH = widget.height ?? 400.0;

    final double kEixoXH = _isDias ? 44.0 : 22.0;
    const double kHeaderH = 26.0;
    const double kGapH = 12.0;
    const double kDividerPadV = 10.0;
    const double kFooterH = 38.0;
    const double kPadTop = 16.0;
    const double kPadBottom = 16.0;

    // +22 na altura total quando for dias (eixo X de dias é 22px maior que meses)
    final double alturaTotal = totalH + (_isDias ? 26.0 : 0.0);

    // Bug corrigido: parêntese fechando ANTES do .clamp
    final double barAreaH = (alturaTotal -
            kPadTop -
            kHeaderH -
            kGapH -
            kTooltipReserva -
            kEixoXH -
            1.0 -
            kDividerPadV * 2 -
            kFooterH -
            kPadBottom)
        .clamp(60.0, alturaTotal);

    final mesGroups =
        _isDias ? _buildMesGroups(slots) : <Map<String, dynamic>>[];
    final footerInfo = _footerInfo(slots);

    return SizedBox(
      width: totalW,
      height: alturaTotal, // usa alturaTotal, não totalH
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, kPadTop, 16, 0),
            child: SizedBox(
              height: kHeaderH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Evolução de carga',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700)),
                  Text(footerInfo,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Colors.grey.shade400)),
                ],
              ),
            ),
          ),

          SizedBox(height: kGapH),

          // ── Barras + eixo X ──────────────────────────────────────────────
          SizedBox(
            height: kTooltipReserva + barAreaH + kEixoXH,
            child: _isScrollavel
                ? SingleChildScrollView(
                    controller: _scrollCtrl,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: kBarWDias * slots.length,
                      child: _buildConteudo(
                        slots: slots,
                        ratios: ratios,
                        barAreaH: barAreaH,
                        mesGroups: mesGroups,
                        cor: cor,
                        corInativa: corInativa,
                        barW: kBarWDias,
                        usarExpanded: false,
                        kEixoXH: kEixoXH,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildConteudo(
                      slots: slots,
                      ratios: ratios,
                      barAreaH: barAreaH,
                      mesGroups: mesGroups,
                      cor: cor,
                      corInativa: corInativa,
                      barW: 0,
                      usarExpanded: true,
                      kEixoXH: kEixoXH,
                    ),
                  ),
          ),

          // ── Divider borda a borda ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDividerPadV),
            child: Container(height: 1, color: Colors.grey.shade200),
          ),

          // ── Footer ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, kPadBottom),
            child: SizedBox(
              height: kFooterH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isUp
                          ? const Color(0xFF059669).withOpacity(0.1)
                          : const Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                        '${isUp ? '+' : '-'}${delta.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isUp
                                ? const Color(0xFF059669)
                                : const Color(0xFFDC2626))),
                  ),
                  if (maxPeso > 0)
                    Text.rich(TextSpan(
                      text: 'Máx: ',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Colors.grey.shade400),
                      children: [
                        TextSpan(
                          text: maxPeso == maxPeso.truncateToDouble()
                              ? '${maxPeso.toInt()} Kg'
                              : '${maxPeso.toStringAsFixed(1)} Kg',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ))
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Conteúdo: tooltip reserva + barras + eixo X ───────────────────────────

  Widget _buildConteudo({
    required List<Map<String, dynamic>> slots,
    required List<double> ratios,
    required double barAreaH,
    required List<Map<String, dynamic>> mesGroups,
    required Color cor,
    required Color corInativa,
    required double barW,
    required bool usarExpanded,
    required double kEixoXH,
  }) {
    return Column(
      children: [
        SizedBox(
          height: kTooltipReserva + barAreaH,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              final progress = _anim.value;
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: barAreaH,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(slots.length, (i) {
                        final slot = slots[i];
                        final isAtiva = _ativa == i;
                        final peso = slot['peso'] as double;
                        final temDado = slot['temDado'] as bool;
                        final qtd = slot['qtd'] as int;
                        final medida = slot['medida'] as String;
                        final separadorDireita =
                            slot['separadorDireita'] as bool;

                        final barH = temDado
                            ? (barAreaH * ratios[i] * progress)
                                .clamp(2.0, barAreaH)
                            : 3.0;

                        Widget child = GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap:
                              temDado ? () => setState(() => _ativa = i) : null,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Separador gradiente de mês
                              if (separadorDireita && _isDias)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.grey.shade400.withOpacity(0),
                                          Colors.grey.shade400,
                                          Colors.grey.shade400.withOpacity(0),
                                        ],
                                        stops: const [0.0, 0.5, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                              // Barra
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 3,
                                  right: separadorDireita && _isDias ? 5 : 3,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    height: barH,
                                    decoration: BoxDecoration(
                                      color: !temDado
                                          ? Colors.grey.shade200
                                          : (isAtiva ? cor : corInativa),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                              // Tooltip preso à coluna
                              if (isAtiva && temDado)
                                Positioned(
                                  bottom: barH + 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2)),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          peso == peso.truncateToDouble()
                                              ? '${peso.toInt()} $medida'
                                              : '${peso.toStringAsFixed(1)} $medida',
                                          style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            width: 1,
                                            height: 12,
                                            color: Colors.white24),
                                        Text('$qtd reps',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 11,
                                                color: Colors.white
                                                    .withOpacity(0.6))),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );

                        return usarExpanded
                            ? Expanded(child: child)
                            : SizedBox(width: barW, child: child);
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Eixo X
        SizedBox(
          height: kEixoXH,
          child: _isDias
              ? _eixoXDias(slots, mesGroups, cor, barW, usarExpanded)
              : _eixoXMeses(slots, cor),
        ),
      ],
    );
  }

  // ── Eixo X dias ───────────────────────────────────────────────────────────

  Widget _eixoXDias(
    List<Map<String, dynamic>> slots,
    List<Map<String, dynamic>> mesGroups,
    Color cor,
    double barW,
    bool usarExpanded,
  ) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalW = constraints.maxWidth;
      final effectiveBarW = usarExpanded
          ? (slots.isNotEmpty ? totalW / slots.length : totalW)
          : barW;

      return Column(
        children: [
          SizedBox(
            height: 18,
            child: Row(
              children: List.generate(slots.length, (i) {
                final isAtiva = _ativa == i;
                final temDado = slots[i]['temDado'] as bool;
                Widget child = GestureDetector(
                  onTap: temDado ? () => setState(() => _ativa = i) : null,
                  child: Center(
                    child: Text('${slots[i]['dia']}',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight:
                                isAtiva ? FontWeight.w700 : FontWeight.w400,
                            color: isAtiva ? cor : Colors.grey.shade400)),
                  ),
                );
                return usarExpanded
                    ? Expanded(child: child)
                    : SizedBox(width: effectiveBarW, child: child);
              }),
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.grey.shade200),
                ),
                ...mesGroups.map((g) {
                  final start = g['startIndex'] as int;
                  final count = g['count'] as int;
                  final label = g['mesLabel'] as String;
                  final temProximo = g['temProximo'] as bool;
                  final left = start * effectiveBarW;
                  final width = count * effectiveBarW;
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

  // ── Eixo X meses ─────────────────────────────────────────────────────────

  Widget _eixoXMeses(List<Map<String, dynamic>> slots, Color cor) {
    return Row(
      children: List.generate(slots.length, (i) {
        final isAtiva = _ativa == i;
        final temDado = slots[i]['temDado'] as bool;
        final mes = slots[i]['mes'] as int;
        final ano = slots[i]['ano'] as int;
        final label = '${_mesesAbrev[mes - 1]}/${ano.toString().substring(2)}';
        return Expanded(
          child: GestureDetector(
            onTap: temDado ? () => setState(() => _ativa = i) : null,
            child: Center(
              child: Text(label,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: isAtiva ? FontWeight.w700 : FontWeight.w500,
                      color: isAtiva ? cor : Colors.grey.shade400)),
            ),
          ),
        );
      }),
    );
  }
}

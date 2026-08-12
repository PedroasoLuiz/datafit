/// Indicadores de exercícios por grupo muscular.
///
/// O bloco antigo despejava, numa coluna só, cada categoria com todas as suas
/// subcategorias e todos os exercícios abertos ao mesmo tempo. Numa conta com
/// alguns meses de uso isso vira uma parede de texto onde nada se destaca —
/// e ainda repetia o mesmo exercício uma vez por ciclo de treino (isso era um
/// erro na RPC, corrigido separadamente).
///
/// Aqui cada categoria é uma linha fechada, com a barra mostrando o peso dela
/// no total. Tocar abre as subcategorias e os exercícios daquele grupo. O que
/// se quer saber de relance — "onde estou treinando mais?" — cabe na primeira
/// tela; o detalhe fica a um toque.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/schema/structs/index.dart';

class IndicadoresExercicios extends StatefulWidget {
  const IndicadoresExercicios({super.key, required this.categorias});

  final List<DsExerciciosStruct> categorias;

  @override
  State<IndicadoresExercicios> createState() => _IndicadoresExerciciosState();
}

class _IndicadoresExerciciosState extends State<IndicadoresExercicios> {
  /// Categoria aberta. Só uma por vez: abrir todas devolveria a parede de
  /// texto que este bloco veio resolver.
  int? _abertaId;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final comExercicios =
        widget.categorias.where((c) => c.total > 0).toList();

    if (comExercicios.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.fitness_center_rounded,
                color: tema.secondaryText, size: 32.0),
            const SizedBox(height: 12.0),
            Text(
              'Nenhum exercício no período',
              textAlign: TextAlign.center,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final total =
        comExercicios.fold<int>(0, (soma, c) => soma + c.total);

    /// Quantos exercicios daquele grupo ja apareceram no periodo.
    int feitosDe(DsExerciciosStruct c) => c.subcategorias
        .expand((s) => s.exercicios)
        .where((e) => e.totalConclusoes > 0)
        .length;

    final feitos =
        comExercicios.fold<int>(0, (soma, c) => soma + feitosDe(c));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumo em frase, e nao um numero solto: "44" sozinho nao dizia
        // se era muito, pouco, feito ou por fazer.
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$feitos',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: tema.primaryText,
                  fontSize: 26.0,
                  letterSpacing: -0.8,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6.0),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                child: Text(
                  'de $total exercícios você já fez',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 16.0, 14.0),
          child: Text(
            total - feitos == 0
                ? 'Você passou por todos no período.'
                : 'Faltam ${total - feitos} que ainda não apareceram.',
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w400),
              color: tema.secondaryText,
              fontSize: 12.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        for (final categoria in comExercicios)
          _CardCategoria(
            categoria: categoria,
            feitos: feitosDe(categoria),
            // A barra mede o que foi FEITO dentro do grupo, e nao o tamanho
            // dele. Cheia quer dizer "passei por todos deste grupo". Antes ela
            // media o tamanho e parecia progresso — era isso que confundia.
            proporcao:
                categoria.total == 0 ? 0.0 : feitosDe(categoria) / categoria.total,
            aberta: _abertaId == categoria.categoriaId,
            aoTocar: () => setState(() {
              _abertaId = _abertaId == categoria.categoriaId
                  ? null
                  : categoria.categoriaId;
            }),
          ),
      ],
    );
  }
}

class _CardCategoria extends StatelessWidget {
  const _CardCategoria({
    required this.categoria,
    required this.feitos,
    required this.proporcao,
    required this.aberta,
    required this.aoTocar,
  });

  final DsExerciciosStruct categoria;

  /// Quantos exercicios deste grupo ja apareceram no periodo.
  final int feitos;

  final double proporcao;
  final bool aberta;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final subcategorias =
        categoria.subcategorias.where((s) => s.exercicios.isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: tema.primaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [tema.designToken.shadow.sm],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: subcategorias.isEmpty ? null : aoTocar,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              categoria.categoria,
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                color: tema.primaryText,
                                fontSize: 14.5,
                                letterSpacing: -0.1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '$feitos de ${categoria.total}',
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: feitos > 0
                                  ? tema.primary
                                  : tema.secondaryText,
                              fontSize: 13.0,
                              letterSpacing: -0.1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (subcategorias.isNotEmpty)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: AnimatedRotation(
                                turns: aberta ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 180),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: tema.secondaryText,
                                  size: 20.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999.0),
                          child: LinearProgressIndicator(
                            value: proporcao,
                            minHeight: 6.0,
                            backgroundColor: tema.alternate,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(tema.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // O detalhe cresce e encolhe em vez de aparecer de repente: sem
              // a animação, tocar numa categoria fazia a página inteira dar um
              // salto e perder a referência de onde se estava.
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: aberta
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: tema.alternate,
                          ),
                          for (final sub in subcategorias)
                            _BlocoSubcategoria(sub: sub),
                          const SizedBox(height: 6.0),
                        ],
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlocoSubcategoria extends StatelessWidget {
  const _BlocoSubcategoria({required this.sub});

  final DsSubcategoriasStruct sub;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sub.subcategoria.toUpperCase(),
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: tema.secondaryText,
              fontSize: 10.5,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6.0),
          for (final ex in sub.exercicios)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
              child: Row(
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      // Cheio quando já foi feito no período, vazado quando
                      // não: é a diferença entre "está no plano" e "aconteceu".
                      color: ex.totalConclusoes > 0
                          ? tema.success
                          : tema.alternate,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      ex.nome,
                      overflow: TextOverflow.ellipsis,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                        color: tema.primaryText,
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (ex.totalConclusoes > 0)
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          7.0, 2.0, 7.0, 2.0),
                      decoration: BoxDecoration(
                        color: tema.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999.0),
                      ),
                      child: Text(
                        ex.totalConclusoes == 1
                            ? 'feito 1×'
                            : 'feito ${ex.totalConclusoes}×',
                        style: tema.bodyMedium.override(
                          font:
                              GoogleFonts.inter(fontWeight: FontWeight.w600),
                          color: tema.success,
                          fontSize: 11.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

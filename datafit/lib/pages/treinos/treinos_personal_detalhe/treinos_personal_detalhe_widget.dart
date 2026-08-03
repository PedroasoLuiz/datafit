import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/treinos_novo_exercicio_treino/treinos_novo_exercicio_treino_widget.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'treinos_personal_detalhe_model.dart';
export 'treinos_personal_detalhe_model.dart';

class TreinosPersonalDetalheWidget extends StatefulWidget {
  const TreinosPersonalDetalheWidget({
    super.key,
    required this.treinoId,
    this.treinoNome = '',
    this.grupoNome = '',
  });

  final int treinoId;
  final String treinoNome;
  final String grupoNome;

  static String routeName = 'treinosPersonalDetalhe';
  static String routePath = '/treinosPersonalDetalhe';

  @override
  State<TreinosPersonalDetalheWidget> createState() =>
      _TreinosPersonalDetalheWidgetState();
}

class _TreinosPersonalDetalheWidgetState
    extends State<TreinosPersonalDetalheWidget> {
  late TreinosPersonalDetalheModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosPersonalDetalheModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _carregarExercicios();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ── LOAD ─────────────────────────────────────────────────────────────────

  Future<void> _carregarExercicios() async {
    safeSetState(() => _model.isLoading = true);
    try {
      final rows = await SupaFlow.client
          .from('ExerciciosTreinos')
          .select(
              'Id, SerieExecucao, RepeticaoExecucao, SerieAquecimento, '
              'RepeticaoAquecimento, TempoDescansoSegundos, Observacao, Ordem, '
              'Exercicios(Id, Descricao, LinkInstrucao, IsDeleted, '
              'SubCategoriasTrabalhadas(Id, Descricao))')
          .eq('TreinosId', widget.treinoId)
          .order('Ordem', ascending: true);

      final Map<int, SubcatGrupoPersonal> groupMap = {};
      for (final row in rows) {
        final ex = row['Exercicios'] as Map<String, dynamic>?;
        if (ex == null) continue;
        if (ex['IsDeleted'] == true) continue;

        final subcat = ex['SubCategoriasTrabalhadas'] as Map<String, dynamic>?;
        final subcatId = (subcat?['Id'] as num?)?.toInt() ?? 0;
        final subcatNome = subcat?['Descricao'] as String? ?? 'Outros';

        if (!groupMap.containsKey(subcatId)) {
          groupMap[subcatId] = SubcatGrupoPersonal(subcatId, subcatNome, []);
        }
        groupMap[subcatId]!.exercicios.add(ExercicioDetalhePersonal(
              etId: (row['Id'] as num).toInt(),
              exercicioId: (ex['Id'] as num).toInt(),
              nome: ex['Descricao'] as String? ?? '',
              linkInstrucao: ex['LinkInstrucao'] as String?,
              series: (row['SerieExecucao'] as num?)?.toInt() ?? 0,
              repeticoes: (row['RepeticaoExecucao'] as num?)?.toInt() ?? 0,
              serieAquecimento: (row['SerieAquecimento'] as num?)?.toInt(),
              repeticaoAquecimento:
                  (row['RepeticaoAquecimento'] as num?)?.toInt(),
              observacao: row['Observacao'] as String?,
              tempoDescansoSeg:
                  (row['TempoDescansoSegundos'] as num?)?.toInt(),
              ordem: (row['Ordem'] as num?)?.toInt() ?? 0,
            ));
      }
      final sortedGroups = groupMap.values.toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));
      safeSetState(() => _model.grupos = sortedGroups);
    } catch (_) {
      safeSetState(() => _model.grupos = []);
    }
    safeSetState(() => _model.isLoading = false);
  }

  // ── CRUD ACTIONS ─────────────────────────────────────────────────────────

  Future<void> _abrirAdicionarExercicio() async {
    final nextOrdem =
        _model.grupos.fold<int>(0, (sum, g) => sum + g.exercicios.length) + 1;
    final criou = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: TreinosNovoExercicioTreinoWidget(
            treinoId: widget.treinoId,
            nextOrdem: nextOrdem,
          ),
        ),
      ),
    );
    if (criou == true && mounted) {
      await _carregarExercicios();
    }
  }

  Future<void> _abrirEditarExercicio(ExercicioDetalhePersonal ex) async {
    final editou = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: TreinosNovoExercicioTreinoWidget(
            treinoId: widget.treinoId,
            etId: ex.etId,
            exercicioNome: ex.nome,
            series: ex.series,
            reps: ex.repeticoes,
            seriesAque: ex.serieAquecimento,
            repsAque: ex.repeticaoAquecimento,
            descanso: ex.tempoDescansoSeg,
            obs: ex.observacao,
          ),
        ),
      ),
    );
    if (editou == true && mounted) {
      await _carregarExercicios();
    }
  }

  Future<void> _confirmarExcluirExercicio(int etId, String nome) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => WebViewAware(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: MensagemWidget(
              texto: 'Remover exercício do treino?',
              textoauxiliar: '"$nome"',
              tipo: '2',
              fechasozinho: false,
              mostrabotoes: true,
              action: () async {
                await SupaFlow.client
                    .from('ExerciciosTreinos')
                    .delete()
                    .eq('Id', etId);
              },
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) await _carregarExercicios();
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    context.watch<cupertino_time_picker_hiuzb7_app_state.FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // ── HEADER ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 16.0, 16.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.navigate_before_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            8.0, 0.0, 8.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.grupoNome.isNotEmpty)
                              Text(
                                widget.grupoNome,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 11.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            Text(
                              widget.treinoNome.isNotEmpty
                                  ? widget.treinoNome
                                  : 'Exercícios',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _abrirAdicionarExercicio,
                      child: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent1,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.add_sharp,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── BODY ───────────────────────────────────────────────
              Expanded(
                child: _model.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      )
                    : _model.grupos.isEmpty
                        ? _buildEstadoVazio(context)
                        : SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 40.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _model.grupos
                                    .map((g) =>
                                        _buildGrupoSection(context, g))
                                    .toList()
                                    .divide(const SizedBox(height: 16.0)),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── SECTION ───────────────────────────────────────────────────────────────

  Widget _buildGrupoSection(BuildContext context, SubcatGrupoPersonal grupo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 8.0),
          child: Text(
            grupo.nome,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primary,
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: grupo.exercicios
                .asMap()
                .entries
                .map((e) => _SwipeableExercicioRow(
                      key: ValueKey(e.value.etId),
                      ex: e.value,
                      isLast: e.key == grupo.exercicios.length - 1,
                      onEdit: () => _abrirEditarExercicio(e.value),
                      onDelete: () =>
                          _confirmarExcluirExercicio(e.value.etId, e.value.nome),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  // ── EMPTY STATE ──────────────────────────────────────────────────────────

  Widget _buildEstadoVazio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Icon(
              FFIcons.kproperty1FiRrGym,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 28.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Nenhum exercício cadastrado',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  fontSize: 15.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Toque em + para adicionar exercícios',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }
}

// ── SWIPEABLE EXERCÍCIO ROW ───────────────────────────────────────────────

class _SwipeableExercicioRow extends StatefulWidget {
  const _SwipeableExercicioRow({
    super.key,
    required this.ex,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });

  final ExercicioDetalhePersonal ex;
  final bool isLast;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_SwipeableExercicioRow> createState() =>
      _SwipeableExercicioRowState();
}

class _SwipeableExercicioRowState extends State<_SwipeableExercicioRow> {
  static const double _actionWidth = 130.0;
  double _offset = 0.0;

  void _onDragUpdate(DragUpdateDetails d) {
    setState(() {
      _offset = (_offset + d.delta.dx).clamp(-_actionWidth, 0.0);
    });
  }

  void _onDragEnd(DragEndDetails d) {
    setState(() {
      _offset = _offset < -_actionWidth / 2 ? -_actionWidth : 0.0;
    });
  }

  void _close() => setState(() => _offset = 0.0);

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final ex = widget.ex;

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          // ── ACTION BUTTONS (behind) ────────────────────────────────
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: _actionWidth,
              child: Row(
                children: [
                  // Edit
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _close();
                        widget.onEdit();
                      },
                      child: Container(
                        color: theme.accent1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              color: theme.primary,
                              size: 20.0,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Editar',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: theme.bodyMedium.fontStyle,
                                ),
                                color: theme.primary,
                                fontSize: 11.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Delete
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _close();
                        widget.onDelete();
                      },
                      child: Container(
                        color: theme.error,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Excluir',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: theme.bodyMedium.fontStyle,
                                ),
                                color: Colors.white,
                                fontSize: 11.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── MAIN CONTENT (foreground) ──────────────────────────────
          Transform.translate(
            offset: Offset(_offset, 0),
            child: Material(
              color: theme.primaryBackground,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _offset != 0.0 ? _close : null,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex.nome,
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: theme.bodyMedium.fontStyle,
                                    ),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (ex.series > 0 || ex.repeticoes > 0)
                                  Text(
                                    '${ex.series}x${ex.repeticoes} reps'
                                    '${ex.tempoDescansoSeg != null && ex.tempoDescansoSeg! > 0 ? '  •  ${ex.tempoDescansoSeg}s descanso' : ''}'
                                    '${ex.serieAquecimento != null && ex.serieAquecimento! > 0 ? '  •  +${ex.serieAquecimento} aq' : ''}',
                                    style: theme.bodyMedium.override(
                                      font: GoogleFonts.inter(
                                        fontWeight:
                                            theme.bodyMedium.fontWeight,
                                        fontStyle: theme.bodyMedium.fontStyle,
                                      ),
                                      color: theme.secondaryText,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                if (ex.observacao != null &&
                                    ex.observacao!.trim().isNotEmpty)
                                  Text(
                                    ex.observacao!,
                                    style: theme.bodyMedium.override(
                                      font: GoogleFonts.inter(
                                        fontWeight:
                                            theme.bodyMedium.fontWeight,
                                        fontStyle: theme.bodyMedium.fontStyle,
                                      ),
                                      color: theme.secondaryText,
                                      fontSize: 11.0,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                              ].divide(const SizedBox(height: 2.0)),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Icon(
                            Icons.swipe_left_outlined,
                            color: theme.secondaryText.withValues(alpha: 0.4),
                            size: 14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!widget.isLast)
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                      indent: 16.0,
                      endIndent: 16.0,
                      color: theme.alternate,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/novo_exercicio/novo_exercicio_widget.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'gestao_exercicios_model.dart';
export 'gestao_exercicios_model.dart';

class GestaoExerciciosWidget extends StatefulWidget {
  const GestaoExerciciosWidget({super.key});

  static String routeName = 'gestaoExercicios';
  static String routePath = '/gestaoExercicios';

  @override
  State<GestaoExerciciosWidget> createState() => _GestaoExerciciosWidgetState();
}

class _GestaoExerciciosWidgetState extends State<GestaoExerciciosWidget> {
  late GestaoExerciciosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GestaoExerciciosModel());
    _searchController.addListener(() {
      safeSetState(() => _searchQuery = _searchController.text.trim());
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _carregar();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _model.dispose();
    super.dispose();
  }

  // ── LOAD ─────────────────────────────────────────────────────────────────

  Future<void> _carregar() async {
    safeSetState(() => _model.isLoading = true);
    try {
      final rows = await SupaFlow.client
          .from('Exercicios')
          .select('Id, Descricao, SubCategoriasTrabalhadasId, LinkInstrucao, '
              'CriadorPerfisId, SubCategoriasTrabalhadas(Descricao)')
          .or('CriadorPerfisId.is.null,CriadorPerfisId.eq.$currentUserUid')
          .or('IsDeleted.is.null,IsDeleted.eq.false')
          .order('Descricao', ascending: true);

      final Map<int?, SubcatGestaoGroup> groupMap = {};

      for (final r in (rows as List)) {
        final criadorId = r['CriadorPerfisId'] as String?;
        final isGlobal = criadorId == null;
        final subcat = r['SubCategoriasTrabalhadas'] as Map<String, dynamic>?;
        final subcatId = (r['SubCategoriasTrabalhadasId'] as num?)?.toInt();
        final subcatNome = subcat?['Descricao'] as String? ?? 'Outros';

        if (!groupMap.containsKey(subcatId)) {
          groupMap[subcatId] = SubcatGestaoGroup(subcatId, subcatNome, []);
        }
        groupMap[subcatId]!.exercicios.add(ExercicioGestaoRow(
              id: (r['Id'] as num).toInt(),
              nome: r['Descricao'] as String? ?? '',
              subcatId: subcatId,
              subcatNome: subcatNome,
              link: r['LinkInstrucao'] as String?,
              isGlobal: isGlobal,
            ));
      }

      // Sort groups: named subcats alphabetically, "Outros" (null) last
      final grupos = groupMap.values.toList()
        ..sort((a, b) {
          if (a.id == null && b.id != null) return 1;
          if (a.id != null && b.id == null) return -1;
          return a.nome.compareTo(b.nome);
        });

      safeSetState(() => _model.grupos = grupos);
    } catch (_) {
      safeSetState(() => _model.grupos = []);
    }
    safeSetState(() => _model.isLoading = false);
  }

  // ── CRUD ─────────────────────────────────────────────────────────────────

  Future<void> _abrirModal({ExercicioGestaoRow? ex}) async {
    final salvou = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: NovoExercicioWidget(
            exercicioId: ex?.id,
            nomeInicial: ex?.nome,
            subcatIdInicial: ex?.subcatId,
            linkInicial: ex?.link,
          ),
        ),
      ),
    );
    if (salvou == true && mounted) await _carregar();
  }

  Future<void> _confirmarExcluir(ExercicioGestaoRow ex) async {
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
              texto: 'Excluir exercício?',
              textoauxiliar: '"${ex.nome}"',
              tipo: '2',
              fechasozinho: false,
              mostrabotoes: true,
              action: () async {
                await SupaFlow.client
                    .from('Exercicios')
                    .update({'IsDeleted': true}).eq('Id', ex.id);
              },
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) await _carregar();
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
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Center(
                      child: Text(
                        'Meus Exercícios',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
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
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => _abrirModal(),
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
                    ),
                  ],
                ),
              ),

              // ── BUSCA ──────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 4.0),
                child: TextFormField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        12.0, 12.0, 12.0, 12.0),
                    hintText: 'Buscar exercício...',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 18.0,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _searchFocusNode.unfocus();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 18.0,
                            ),
                          )
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                ),
              ),

              // ── HINT ───────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 12.0,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      'Exercícios com cadeado são padrão da plataforma',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11.0,
                            letterSpacing: 0.0,
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
                    : Builder(builder: (context) {
                        final filteredGrupos = _searchQuery.isEmpty
                            ? _model.grupos
                            : _model.grupos
                                .map((g) => SubcatGestaoGroup(
                                      g.id,
                                      g.nome,
                                      g.exercicios
                                          .where((e) => e.nome
                                              .toLowerCase()
                                              .contains(
                                                  _searchQuery.toLowerCase()))
                                          .toList(),
                                    ))
                                .where((g) => g.exercicios.isNotEmpty)
                                .toList();

                        if (filteredGrupos.isEmpty) {
                          return _buildEstadoVazio(context);
                        }
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: filteredGrupos
                                  .map((g) => _buildGrupoSection(context, g))
                                  .toList()
                                  .divide(const SizedBox(height: 16.0)),
                            ),
                          ),
                        );
                      }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── SECTION ───────────────────────────────────────────────────────────────

  Widget _buildGrupoSection(BuildContext context, SubcatGestaoGroup grupo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 8.0),
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
            children: grupo.exercicios.asMap().entries.map((e) {
              final ex = e.value;
              final isLast = e.key == grupo.exercicios.length - 1;
              if (ex.isGlobal) {
                return _buildGlobalRow(context, ex, isLast);
              }
              return _SwipeableExRow(
                key: ValueKey(ex.id),
                ex: ex,
                isLast: isLast,
                onEdit: () => _abrirModal(ex: ex),
                onDelete: () => _confirmarExcluir(ex),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── GLOBAL ROW (read-only) ────────────────────────────────────────────────

  Widget _buildGlobalRow(
      BuildContext context, ExercicioGestaoRow ex, bool isLast) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  ex.nome,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: theme.bodyMedium.fontWeight,
                      fontStyle: theme.bodyMedium.fontStyle,
                    ),
                    color: theme.secondaryText,
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Icon(
                Icons.lock_outline_rounded,
                color: theme.secondaryText,
                size: 15.0,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1.0,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
            color: theme.alternate,
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
              Icons.fitness_center_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 28.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Nenhum exercício encontrado',
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
            'Toque em + para cadastrar um exercício',
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

// ── SWIPEABLE ROW (personal exercises only) ───────────────────────────────

class _SwipeableExRow extends StatefulWidget {
  const _SwipeableExRow({
    super.key,
    required this.ex,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });

  final ExercicioGestaoRow ex;
  final bool isLast;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_SwipeableExRow> createState() => _SwipeableExRowState();
}

class _SwipeableExRowState extends State<_SwipeableExRow> {
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

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          // ── AÇÕES ──────────────────────────────────────────────
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: _actionWidth,
              child: Row(
                children: [
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
                            Icon(Icons.edit_outlined,
                                color: theme.primary, size: 20.0),
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
                            Icon(Icons.delete_outline_rounded,
                                color: Colors.white, size: 20.0),
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

          // ── CONTEÚDO ──────────────────────────────────────────
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              widget.ex.nome,
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
                          ),
                          Icon(
                            Icons.swipe_left_outlined,
                            color: theme.secondaryText.withValues(alpha: 0.35),
                            size: 13.0,
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

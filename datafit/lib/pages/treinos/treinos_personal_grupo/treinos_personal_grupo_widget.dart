import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/treinos_novo_sub_treino/treinos_novo_sub_treino_widget.dart';
import '/pages/treinos/treinos_personal_detalhe/treinos_personal_detalhe_widget.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'treinos_personal_grupo_model.dart';
export 'treinos_personal_grupo_model.dart';

class TreinosPersonalGrupoWidget extends StatefulWidget {
  const TreinosPersonalGrupoWidget({
    super.key,
    required this.grupo,
  });

  final GrupostreinosStruct grupo;

  static String routeName = 'treinosPersonalGrupo';
  static String routePath = '/treinosPersonalGrupo';

  @override
  State<TreinosPersonalGrupoWidget> createState() =>
      _TreinosPersonalGrupoWidgetState();
}

class _TreinosPersonalGrupoWidgetState
    extends State<TreinosPersonalGrupoWidget> {
  late TreinosPersonalGrupoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosPersonalGrupoModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _carregarSubTreinos();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ── LOAD ─────────────────────────────────────────────────────────────────

  Future<void> _carregarSubTreinos() async {
    safeSetState(() => _model.isLoading = true);
    try {
      final rows = await SupaFlow.client
          .from('Treinos')
          .select('Id, Descricao')
          .eq('GruposTreinoId', widget.grupo.grupoTreinoId)
          .or('IsDeleted.is.null,IsDeleted.eq.false')
          .order('Descricao', ascending: true);
      safeSetState(
          () => _model.subTreinos = List<Map<String, dynamic>>.from(rows));
    } catch (_) {
      safeSetState(() => _model.subTreinos = []);
    }
    safeSetState(() => _model.isLoading = false);
  }

  // ── CRUD ACTIONS ─────────────────────────────────────────────────────────

  Future<void> _abrirModalNome({int? id, String? nomeAtual}) async {
    final criou = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: TreinosNovoSubTreinoWidget(
            grupoTreinoId: widget.grupo.grupoTreinoId,
            treinoId: id,
            nomeInicial: nomeAtual,
          ),
        ),
      ),
    );
    if (criou == true && mounted) {
      await _carregarSubTreinos();
    }
  }

  Future<void> _confirmarExcluir(int id, String nome) async {
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
              texto: 'Excluir treino?',
              textoauxiliar: '"$nome"',
              tipo: '2',
              fechasozinho: false,
              mostrabotoes: true,
              action: () async {
                await SupaFlow.client
                    .from('Treinos')
                    .update({'IsDeleted': true}).eq('Id', id);
              },
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) await _carregarSubTreinos();
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
              // ── HEADER ──────────────────────────────────────────────
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
                        child: Text(
                          widget.grupo.nome.isNotEmpty
                              ? widget.grupo.nome
                              : 'Treino',
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
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => _abrirModalNome(),
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

              // ── BODY ────────────────────────────────────────────────
              Expanded(
                child: _model.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      )
                    : _model.subTreinos.isEmpty
                        ? _buildEstadoVazio(context)
                        : ListView.separated(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 40.0),
                            itemCount: _model.subTreinos.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1.0,
                              thickness: 1.0,
                              indent: 68.0,
                              endIndent: 16.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            itemBuilder: (context, index) {
                              final row = _model.subTreinos[index];
                              final id = (row['Id'] as num).toInt();
                              final nome = row['Descricao'] as String? ?? '';
                              final letra = String.fromCharCode(65 + index);
                              return _SwipeableRow(
                                key: ValueKey(id),
                                id: id,
                                nome: nome,
                                letra: letra,
                                onTap: () => context.pushNamed(
                                  TreinosPersonalDetalheWidget.routeName,
                                  queryParameters: {
                                    'treinoId':
                                        serializeParam(id, ParamType.int),
                                    'treinoNome': serializeParam(
                                      nome.isNotEmpty ? nome : 'Treino $letra',
                                      ParamType.String,
                                    ),
                                    'grupoNome': serializeParam(
                                      widget.grupo.nome,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    '__transition_info__': TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration:
                                          const Duration(milliseconds: 0),
                                    ),
                                  },
                                ),
                                onEdit: () => _abrirModalNome(
                                    id: id, nomeAtual: nome),
                                onDelete: () => _confirmarExcluir(
                                    id,
                                    nome.isNotEmpty
                                        ? nome
                                        : 'Treino $letra'),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
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
            'Nenhum treino cadastrado',
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
            'Toque em + para adicionar um treino',
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

// ── SWIPEABLE ROW ─────────────────────────────────────────────────────────

class _SwipeableRow extends StatefulWidget {
  const _SwipeableRow({
    super.key,
    required this.id,
    required this.nome,
    required this.letra,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final int id;
  final String nome;
  final String letra;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_SwipeableRow> createState() => _SwipeableRowState();
}

class _SwipeableRowState extends State<_SwipeableRow> {
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
    final displayName =
        widget.nome.isNotEmpty ? widget.nome : 'Treino ${widget.letra}';

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: ClipRect(
        child: Stack(
          children: [
            // ── ACTION BUTTONS (behind) ──────────────────────────────
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
                                    fontStyle:
                                        theme.bodyMedium.fontStyle,
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
                                    fontStyle:
                                        theme.bodyMedium.fontStyle,
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

            // ── MAIN CONTENT (foreground) ────────────────────────────
            Transform.translate(
              offset: Offset(_offset, 0),
              child: Material(
                color: theme.secondaryBackground,
                child: InkWell(
                  onTap: _offset == 0.0 ? widget.onTap : _close,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 14.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Letter badge
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: theme.accent1,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              widget.letra,
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: theme.bodyMedium.fontStyle,
                                ),
                                color: theme.primary,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        // Name + hint
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: theme.bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Ver exercícios',
                                style: theme.bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: theme.bodyMedium.fontWeight,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                  color: theme.secondaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ].divide(const SizedBox(height: 2.0)),
                          ),
                        ),
                        // Swipe hint chevron
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.secondaryText,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

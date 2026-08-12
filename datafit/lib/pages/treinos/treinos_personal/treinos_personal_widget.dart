import '/components/campo_busca.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/df_estado_vazio.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/navbar/navbar_widget.dart';
import '/pages/components/treinos_novo_treino/treinos_novo_treino_widget.dart';
import '/pages/treinos/treinos_personal_grupo/treinos_personal_grupo_widget.dart';
import '/pages/treinos/gestao_exercicios/gestao_exercicios_widget.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'treinos_personal_model.dart';
export 'treinos_personal_model.dart';

class TreinosPersonalWidget extends StatefulWidget {
  const TreinosPersonalWidget({super.key});

  static String routeName = 'treinosPersonal';
  static String routePath = '/treinosPersonal';

  @override
  State<TreinosPersonalWidget> createState() => _TreinosPersonalWidgetState();
}

class _TreinosPersonalWidgetState extends State<TreinosPersonalWidget> {
  late TreinosPersonalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosPersonalModel());
    _model.txtBuscaController ??= TextEditingController();
    _model.txtBuscaFocusNode ??= FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _carregarTreinos();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _carregarTreinos() async {
    safeSetState(() => _model.isLoading = true);

    final result = await PersonalGroup.getTreinosPersonalCall.call(
      pPersonalUuid: currentUserUid,
    );

    if (result.succeeded) {
      try {
        final raw = result.jsonBody;
        final list = raw is List ? raw : [raw];
        _model.treinos = (list
            .map((e) => GrupostreinosStruct.maybeFromMap(e))
            .whereType<GrupostreinosStruct>()
            .toList())
          ..sort((a, b) => a.nome.compareTo(b.nome));
      } catch (_) {
        _model.treinos = [];
      }
    }

    safeSetState(() => _model.isLoading = false);
  }

  Future<void> _abrirEditarGrupo(int id, String nome) async {
    final editou = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: TreinosNovoTreinoWidget(
            grupoTreinoId: id,
            nomeInicial: nome,
          ),
        ),
      ),
    );
    if (editou == true && mounted) await _carregarTreinos();
  }

  Future<void> _confirmarExcluirGrupo(int id, String nome) async {
    final ok = await showModalBottomSheet<bool>(
      useRootNavigator: true,
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
                    .from('GruposTreino')
                    .update({'Ativo': false}).eq('Id', id);
              },
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) await _carregarTreinos();
  }

  /// Abre o bottom sheet de novo treino e recarrega a lista se algo foi criado.
  ///
  /// Estava embutido no onTap do botao "+" do cabecalho; virou metodo para o
  /// card de atalho poder chamar a mesma coisa.
  Future<void> _abrirNovoTreino() async {
    final criou = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WebViewAware(
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: const TreinosNovoTreinoWidget(),
          ),
        );
      },
    );
    if (criou == true) {
      await _carregarTreinos();
    }
  }

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
          // A navbar reserva o inset inferior por dentro, para o branco
          // dela chegar ate a borda da tela no iPhone.
          bottom: false,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ── HEADER ───────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Center(
                          child: Text(
                            'Meus Treinos',
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
                      ],
                    ),
                  ),

                  // ── BUSCA ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 12.0, 16.0, 4.0),
                    child: CampoBusca(
                      controller: _model.txtBuscaController,
                      focusNode: _model.txtBuscaFocusNode,
                      onChanged: (_) => safeSetState(() {}),
                    ),
                  ),

                  // ── BODY ─────────────────────────────────────────────
                  Expanded(
                    child: _model.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          )
                        : CustomScrollView(
                            slivers: [
                              // Os atalhos rolam junto com a lista.
                              SliverToBoxAdapter(
                                child: _buildAtalhos(context),
                              ),
                              if (_model.treinos.isEmpty)
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _buildEstadoVazio(context),
                                )
                              else if (_model.treinosFiltrados.isEmpty)
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _buildSemResultados(context),
                                )
                              else
                                SliverPadding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 120.0),
                                  sliver: SliverList.separated(
                                    itemCount: _model.treinosFiltrados.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      indent: 68.0,
                                      endIndent: 16.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                    itemBuilder: (_, index) {
                                      final grupo =
                                          _model.treinosFiltrados[index];
                                      return _SwipeableGrupoRow(
                                        key: ValueKey(grupo.grupoTreinoId),
                                        grupo: grupo,
                                        onTap: () => context.pushNamed(
                                          TreinosPersonalGrupoWidget.routeName,
                                          queryParameters: {
                                            'grupo': serializeParam(
                                                grupo, ParamType.DataStruct),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            '__transition_info__':
                                                TransitionInfo(
                                              hasTransition: true,
                                              transitionType:
                                                  PageTransitionType.fade,
                                              duration: const Duration(
                                                  milliseconds: 0),
                                            ),
                                          },
                                        ),
                                        onEdit: () => _abrirEditarGrupo(
                                            grupo.grupoTreinoId, grupo.nome),
                                        onDelete: () => _confirmarExcluirGrupo(
                                            grupo.grupoTreinoId,
                                            grupo.nome.isNotEmpty
                                                ? grupo.nome
                                                : 'Treino sem nome'),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── ATALHOS ───────────────────────────────────────────────────────────
  // Estes dois cards substituem os botoes so-icone que ficavam no topo: em
  // 36x36 sem rotulo, nem o halter nem o "+" diziam para onde levavam. O
  // icone de cada um e o mesmo do botao antigo, para quem ja usava reconhecer.
  Widget _buildAtalhos(BuildContext context) {
    return Padding(
      // 12 em cima para o vao ate a busca ficar igual ao vao ate a lista.
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _CardAtalho(
                titulo: 'Novo treino',
                descricao: 'Monte um grupo e adicione exercícios',
                rotulo: 'Criar',
                icone: Icons.playlist_add_rounded,
                onTap: _abrirNovoTreino,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _CardAtalho(
                titulo: 'Exercícios',
                descricao: 'Seu catálogo para montar os treinos',
                rotulo: 'Gerenciar',
                icone: Icons.fitness_center_rounded,
                onTap: () => context.pushNamed(
                  GestaoExerciciosWidget.routeName,
                  extra: <String, dynamic>{
                    '__transition_info__': TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 0),
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ESTADO VAZIO ─────────────────────────────────────────────────────
  // Usa o componente compartilhado, igual a alunos, pagamentos e videos.
  Widget _buildEstadoVazio(BuildContext context) {
    return Center(
      child: DfEstadoVazio(
        icone: FFIcons.kproperty1FiRrGym,
        titulo: 'Nenhum treino criado',
        descricao: 'Monte seu primeiro treino e atribua aos seus alunos.',
      ),
    );
  }

  // ── SEM RESULTADOS DE BUSCA ───────────────────────────────────────────
  Widget _buildSemResultados(BuildContext context) {
    return Center(
      child: Text(
        'Nenhum resultado para "${_model.txtBuscaController?.text ?? ''}"',
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 13.0,
              letterSpacing: 0.0,
            ),
      ),
    );
  }
}

// ── SWIPEABLE GRUPO ROW ───────────────────────────────────────────────────

class _SwipeableGrupoRow extends StatefulWidget {
  const _SwipeableGrupoRow({
    super.key,
    required this.grupo,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final GrupostreinosStruct grupo;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_SwipeableGrupoRow> createState() => _SwipeableGrupoRowState();
}

class _SwipeableGrupoRowState extends State<_SwipeableGrupoRow> {
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
    final grupo = widget.grupo;
    final count = grupo.subagrupamentos.length;
    final displayName = grupo.nome.isNotEmpty ? grupo.nome : 'Treino sem nome';

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
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            // Branco, nao accent1: contra o fundo azulado o
                            // azul claro sumia dentro da propria tela.
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [theme.designToken.shadow.sm],
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              FFIcons.kproperty1FiRrGym,
                              color: theme.primary,
                              size: 20.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
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
                              if (count > 0)
                                Text(
                                  '$count treino${count > 1 ? 's' : ''}',
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

/// Card de atalho do topo de "Meus Treinos".
///
/// Diz o que e, o que faz e para onde leva — o oposto do botao so-icone que
/// existia antes. A seta a 45 graus e a mesma convencao de "isso abre outra
/// tela" usada fora do app.
class _CardAtalho extends StatelessWidget {
  const _CardAtalho({
    required this.titulo,
    required this.descricao,
    required this.rotulo,
    required this.icone,
    required this.onTap,
  });

  final String titulo;
  final String descricao;
  final String rotulo;
  final IconData icone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Material(
      color: tema.primaryBackground,
      borderRadius: BorderRadius.circular(14.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            // Kit do app: superficie branca com sombra, sem contorno.
            color: tema.primaryBackground,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: [tema.designToken.shadow.lg],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // O icone ganha um quadrado de azul claro e vai para cima do
              // titulo. Ao lado dele competia com o texto pela mesma linha e
              // lia como enfeite; em cima, ele apresenta o card.
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: tema.accent1,
                  borderRadius: BorderRadius.circular(11.0),
                ),
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Icon(
                  icone,
                  color: tema.primary,
                  size: 20.0,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                titulo,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: tema.primaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                descricao,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                  color: tema.secondaryText,
                  fontSize: 11.5,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w400,
                  lineHeight: 1.35,
                ),
              ),
              const SizedBox(height: 10.0),
              // Empurra a chamada para o rodape para os dois cards alinharem
              // a linha azul na mesma altura, mesmo com descricoes de tamanhos
              // diferentes.
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rotulo,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: tema.primary,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(
                    Icons.arrow_outward,
                    color: tema.primary,
                    size: 14.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                  // Os 36 de altura e os 8 embaixo nao sao arbitrarios: sao a
                  // medida do cabecalho das outras abas, onde a faixa e alta
                  // por causa do botao de sino. Aqui, que so tem titulo, ela
                  // media 17 — o titulo nascia mais alto e, junto com ele, o
                  // campo de busca. Trocar de aba fazia os dois pularem.
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 8.0),
                    child: SizedBox(
                      height: 36.0,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          // O "+" no canto, como nas demais telas de
                          // listagem. Criar treino era um cartao azul ocupando
                          // meia largura acima da lista; como botao de barra
                          // ele fica onde a pessoa ja procura por "adicionar"
                          // no resto do app, e devolve a linha inteira para o
                          // que a tela e — a lista de treinos.
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: InkWell(
                              onTap: _abrirNovoTreino,
                              borderRadius: BorderRadius.circular(999.0),
                              child: Container(
                                width: 36.0,
                                height: 36.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    FlutterFlowTheme.of(context)
                                        .designToken
                                        .shadow
                                        .sm
                                  ],
                                ),
                                child: const Icon(Icons.add_rounded,
                                    color: Colors.white, size: 20.0),
                              ),
                            ),
                          ),
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
                                    // Sem linha divisoria: cada treino agora
                                    // e um cartao, e a separacao vem do vao
                                    // entre eles.
                                    separatorBuilder: (_, __) =>
                                        const SizedBox.shrink(),
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
  /// O atalho para os exercícios.
  ///
  /// Sozinho e em largura cheia, depois que "Novo treino" virou o "+" da barra.
  /// Dividir a linha com outro cartão dava aos dois o formato de botão duplo —
  /// e eles nunca foram um par: um cria, o outro navega para outra tela.
  Widget _buildAtalhos(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
      child: Material(
        color: Color.alphaBlend(
            Colors.black.withValues(alpha: 0.18), tema.primary),
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
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
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding:
                const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
            // Azul escuro e sem quadrado de icone a esquerda.
            //
            // Branco com icone azul no canto era exatamente o desenho das
            // linhas de treino logo abaixo — o atalho se lia como mais um
            // treino da lista. Com outro fundo e sem o quadrado, ele deixa de
            // pertencer aquela sequencia e vira o que e: um caminho para outra
            // tela.
            decoration: BoxDecoration(
              // Um tom abaixo do primary: azul de acao e o dos botoes, e este
              // cartao nao e acao, e caminho. Escurecido, ele se distingue dos
              // botoes sem sair da familia de cor do app — e o amarelo que
              // estava aqui e cor de aviso, nao de navegacao.
              color: Color.alphaBlend(
                  Colors.black.withValues(alpha: 0.18), tema.primary),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meus exercícios',
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          color: Colors.white,
                          fontSize: 13.5,
                          letterSpacing: -0.1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 2.0, 0.0, 0.0),
                        child: Text(
                          'Cadastrar, editar e organizar por grupo',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tema.bodyMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w400),
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 11.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(FFIcons.kproperty1FiRrAngleSmallRight,
                    color: Colors.white.withValues(alpha: 0.8), size: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
    final treinos = grupo.subagrupamentos.length;
    final alunos = grupo.alunosVinculados;
    final displayName = grupo.nome.isNotEmpty ? grupo.nome : 'Treino sem nome';

    // "2 treinos · 4 alunos". Sem aluno vinculado a segunda metade some, em
    // vez de anunciar um zero: treino recem-criado ainda nao foi atribuido a
    // ninguem, e isso e o estado normal, nao um problema.
    final partes = <String>[
      if (treinos > 0) '$treinos treino${treinos > 1 ? 's' : ''}',
      if (alunos > 0) '$alunos aluno${alunos > 1 ? 's' : ''}',
    ];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
      child: GestureDetector(
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        // A sombra vive aqui fora, no pai do recorte.
        //
        // Ela estava no cartao de dentro, e o `ClipRRect` a recortava junto —
        // sombra e desenhada fora dos limites do widget, e e exatamente isso
        // que o recorte apaga. Por isso a lista parecia chapada apesar de ter
        // `boxShadow` no codigo.
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [FlutterFlowTheme.of(context).designToken.shadow.lg],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                // ── ACOES (atras) ────────────────────────────────────────
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
                                          fontWeight: FontWeight.w500),
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
                                  const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Excluir',
                                    style: theme.bodyMedium.override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500),
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

                // ── CARTAO (frente) ──────────────────────────────────────
                Transform.translate(
                  offset: Offset(_offset, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: _offset == 0.0 ? widget.onTap : _close,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 14.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 42.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: theme.accent1,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.bodyMedium.override(
                                        font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600),
                                        fontSize: 15.0,
                                        letterSpacing: -0.2,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (partes.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 3.0, 0.0, 0.0),
                                        child: Text(
                                          partes.join(' · '),
                                          style: theme.bodyMedium.override(
                                            font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500),
                                            color: theme.secondaryText,
                                            fontSize: 12.5,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: theme.secondaryText,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

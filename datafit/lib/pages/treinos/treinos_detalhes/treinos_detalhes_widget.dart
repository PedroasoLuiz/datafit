import '/components/chip_filtro.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/comemoracao.dart';
import '/components/folha_feedback_treino.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/treinos/treinos_detalhes_cardio_edit/treinos_detalhes_cardio_edit_widget.dart';
import '/pages/treinos/treinos_detalhes_cardio_novo/treinos_detalhes_cardio_novo_widget.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'treinos_detalhes_model.dart';
export 'treinos_detalhes_model.dart';
import '/pages/components/substituir_exercicio/substituir_exercicio_widget.dart';

class TreinosDetalhesWidget extends StatefulWidget {
  const TreinosDetalhesWidget({
    super.key,
    int? indexGrupo,
  }) : this.indexGrupo = indexGrupo ?? 0;

  final int indexGrupo;

  static String routeName = 'treinosDetalhes';
  static String routePath = '/treinosDetalhes';

  @override
  State<TreinosDetalhesWidget> createState() => _TreinosDetalhesWidgetState();
}

class _TreinosDetalhesWidgetState extends State<TreinosDetalhesWidget>
    with TickerProviderStateMixin {
  late TreinosDetalhesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var hasContainerTriggered1 = false;
  var hasContainerTriggered2 = false;
  final animationsMap = <String, AnimationInfo>{};

  /// O exercicio que a pessoa deve fazer agora.
  ///
  /// O primeiro que ainda nao foi concluido nem pulado, varrendo os grupos na
  /// ordem em que eles chegam — que e a ordem de execucao, garantida pela RPC.
  /// Nulo quando nao sobrou nenhum.
  int? get _proximoExecucaoId {
    // Só no treino que está acontecendo: num treino que ainda não começou (ou
    // que já foi fechado e voltou para a fila) não há "agora".
    if (_treinoAtual?.status != 'em_andamento') return null;
    final grupos = FFAppState()
            .treinosTemp
            .subagrupamentos
            .elementAtOrNull(_model.index)
            ?.grupos ??
        const <GrupossubcategoriasStruct>[];
    for (final grupo in grupos) {
      for (final ex in grupo.exercicios) {
        if (!ex.isConcluido && !ex.isPulado) return ex.execucaoId;
      }
    }
    return null;
  }

  /// Acende o deslizador que deve estar à mostra.
  ///
  /// Os dois — iniciar e concluir — nascem **invisíveis**: a animação deles
  /// tem `applyInitialState` com um `VisibilityEffect`, então só aparecem
  /// depois que alguém dispara o `forward`. Isso acontecia uma única vez, no
  /// carregamento da tela, escolhendo um dos dois pela situação daquele
  /// instante.
  ///
  /// Quem começava ou concluía o treino com a tela aberta trocava a situação,
  /// mas ninguém acendia o deslizador novo: ele passava a existir na árvore e
  /// continuava invisível. Só saindo e voltando — porque aí o `initState`
  /// rodava de novo — é que ele aparecia. Agora isso é uma chamada, feita
  /// também depois de iniciar e de concluir.
  /// Abre uma sessão extra deste treino, dentro do mesmo ciclo.
  ///
  /// Sessão nova, e não reabertura da atual: o treino já saiu nesta rodada, e
  /// desfazer isso faria o anel do dia regredir e o ciclo deixar de fechar. No
  /// banco ficam duas conclusões, que é o que de fato aconteceu.
  Future<void> _repetirTreino() async {
    final execucaoId = _treinoAtual?.treinoExecucaoId ?? 0;
    if (execucaoId == 0) return;

    try {
      final resposta = await SupaFlow.client
          .rpc('repetir_treino', params: {'p_execucao_id': execucaoId});
      final mapa = (resposta as Map?)?.cast<String, dynamic>() ?? {};
      if (mapa['sucesso'] != true) {
        if (mounted) _avisarFalhaRepeticao();
        return;
      }

      if (!mounted) return;
      await action_blocks.getTreinosAluno(context);
      if (!mounted) return;

      // A sessão nova entra no fim da fila; leva a tela até ela, senão a
      // pessoa continua olhando o cartão concluído e parece que nada
      // aconteceu.
      final destino = FFAppState()
          .treinosTemp
          .subagrupamentos
          .indexWhere((e) => e.status == 'em_andamento');
      safeSetState(() {
        if (destino >= 0) _model.index = destino;
      });
      _mostrarDeslizadorCerto();
    } catch (_) {
      if (mounted) _avisarFalhaRepeticao();
    }
  }

  void _avisarFalhaRepeticao() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Não consegui abrir o treino de novo. Tente outra vez.'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }

  void _mostrarDeslizadorCerto() {
    final emAndamento = FFAppState()
        .treinosTemp
        .subagrupamentos
        .where((e) => e.status == 'em_andamento')
        .isNotEmpty;

    final animacao = animationsMap[emAndamento
        ? 'containerOnActionTriggerAnimation2'
        : 'containerOnActionTriggerAnimation1'];
    if (animacao == null) return;

    safeSetState(() {
      if (emAndamento) {
        hasContainerTriggered2 = true;
      } else {
        hasContainerTriggered1 = true;
      }
    });
    SchedulerBinding.instance.addPostFrameCallback(
        (_) async => await animacao.controller.forward(from: 0.0));
  }

  /// O treino mostrado nesta tela.
  GruposStruct? get _treinoAtual =>
      FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index);

  /// Este treino já foi fechado no ciclo corrente.
  ///
  /// Ele continua na lista — vai para o fim da fila e espera o ciclo virar —,
  /// mas a partir daqui é um treino a fazer, não um treino feito.
  bool get _jaFeitoNesteCiclo =>
      _treinoAtual?.status == 'concluido' || _treinoAtual?.status == 'pulado';

  /// A lista como o servidor mandou.
  ///
  /// NAO ordenar aqui. A navegacao para a tela de execucao passa a POSICAO do
  /// grupo e do exercicio, e a outra ponta le a lista original: qualquer
  /// reordenacao so na exibicao faz os indices apontarem para outro exercicio
  /// — foi assim que a tela de execucao passou a abrir vazia. A ordem correta
  /// vem pronta de `get_treino_ativo_aluno`.
  List<GrupossubcategoriasStruct> _gruposEmOrdem(
      Iterable<GrupossubcategoriasStruct>? grupos) {
    // Os vistos do treino concluido ficam a mostra.
    //
    // Antes eles eram apagados, para a proxima volta comecar "como nova". Mas
    // agora repetir um treino abre uma sessao propria e zerada — quem esta
    // olhando esta ficha esta olhando o que ja foi feito, e apagar isso
    // esconderia justamente o que decide se vale repetir e o que ficou de
    // fora.
    return (grupos ?? const <GrupossubcategoriasStruct>[]).toList();
  }

  /// A pílula de concluir, para o resumo nascer de onde o dedo terminou.
  final GlobalKey _chaveConcluir = GlobalKey();

  /// Números do treino que acabou de ser fechado.
  ///
  /// Lido do estado antes de finalizar: o recarregamento que vem em seguida
  /// troca o treino ativo, e nesse ponto já não há de onde tirar o que foi
  /// feito hoje.
  List<ItemResumo> _resumoDoTreino() {
    final sub =
        FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index);
    final exercicios =
        _gruposEmOrdem(sub?.grupos).expand((g) => g.exercicios).toList();

    // Pulado não conta como feito: o número grande tem que querer dizer que o
    // treino foi cumprido, e não que ele terminou.
    final feitos = exercicios.where((e) => e.isConcluido && !e.isPulado).length;
    final pulados = exercicios.where((e) => e.isPulado).length;

    final cardios = sub?.cardios ?? const <CardioStruct>[];
    final minutosCardio =
        cardios.fold<int>(0, (soma, c) => soma + c.duracaoMinutos);

    // Duração pelo início gravado no banco, e não por cronômetro de tela: se
    // a pessoa fechou o app no meio, o cronômetro parou e o relógio não.
    final inicio = DateTime.tryParse(sub?.dataInicio ?? '');
    final minutos =
        inicio == null ? null : DateTime.now().difference(inicio).inMinutes;

    return [
      ItemResumo(
        icone: Icons.check_rounded,
        valor: '$feitos/${exercicios.length}',
        rotulo: exercicios.length == 1 ? 'exercício' : 'exercícios',
      ),
      // Zero pulos não vira cartão: um "0" ali chamaria atenção para o que
      // não aconteceu.
      if (pulados > 0)
        ItemResumo(
          icone: Icons.redo_rounded,
          valor: '$pulados',
          rotulo: pulados == 1 ? 'pulado' : 'pulados',
        ),
      if (minutos != null && minutos > 0)
        ItemResumo(
          icone: Icons.schedule_rounded,
          valor: minutos >= 60
              ? '${minutos ~/ 60}h${(minutos % 60).toString().padLeft(2, '0')}'
              : '${minutos}min',
          rotulo: 'de treino',
        ),
      if (minutosCardio > 0)
        ItemResumo(
          icone: Icons.directions_run_rounded,
          valor: '${minutosCardio}min',
          rotulo: 'de cárdio',
        ),
    ];
  }

  /// Folha de feedback do treino.
  ///
  /// O campo vivia numa seção própria no fim da tela, depois da lista inteira
  /// de exercícios — para escrever era preciso rolar por tudo, e o convite
  /// nunca era visto. Agora o cartão azul convida e a folha recebe o texto,
  /// já preenchido com o que houver: editar é o caso comum, não escrever do
  /// zero.
  Future<void> _abrirFeedback() async {
    final sub =
        FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index);
    _model.txtFeedbackTextController?.text = sub?.feedback ?? '';

    final salvou = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(ctx),
          child: FolhaFeedbackTreino(
            controlador: _model.txtFeedbackTextController!,
            aoSalvar: (texto) async {
              final r = await AlunoGroup.salvarFeedbackCall.call(
                pAlunoUuid: currentUserUid,
                pTreinoExecucaoId: sub?.treinoExecucaoId,
                pFeedback: texto,
              );
              if (!(r.succeeded)) return false;
              // Espelha no estado local para o cartao mostrar o texto novo
              // sem esperar uma recarga inteira do treino.
              FFAppState().updateTreinosTempStruct(
                (t) => t
                  ..updateSubagrupamentos(
                    (s) => s[_model.index].feedback = texto,
                  ),
              );
              return true;
            },
          ),
        ),
      ),
    );

    if (salvou == true && mounted) safeSetState(() {});
  }

  /// Codigo do erro para o rodape da tela de falha.
  ///
  /// Status HTTP e o corpo cortado: o corpo inteiro do Postgres passa de mil
  /// caracteres e nao cabe em tela nenhuma, mas as primeiras linhas trazem o
  /// que identifica o problema.
  String? _codigoDoErro(ApiCallResponse? r) {
    if (r == null) return null;
    final corpo = (r.jsonBody ?? '').toString().trim();
    final curto = corpo.length > 160 ? '${corpo.substring(0, 160)}…' : corpo;
    return curto.isEmpty
        ? 'HTTP ${r.statusCode}'
        : 'HTTP ${r.statusCode} · $curto';
  }

  /// Centro de um widget na tela, para a animacao nascer de onde o dedo
  /// estava. Nulo quando ele nao esta montado ou ainda nao foi medido.
  Offset? _centroDaAcao(GlobalKey chave) {
    final caixa = chave.currentContext?.findRenderObject() as RenderBox?;
    if (caixa == null || !caixa.hasSize) return null;
    return caixa.localToGlobal(caixa.size.center(Offset.zero));
  }

  Future<void> _mostrarResumoDoTreino(
    BuildContext context,
    List<ItemResumo> itens,
  ) async {
    final origem = _centroDaAcao(_chaveConcluir);

    await mostrarResumoTreino(
      context,
      titulo: 'Treino concluído!',
      subtitulo: FFAppState()
          .treinosTemp
          .subagrupamentos
          .elementAtOrNull(_model.index)
          ?.nome,
      itens: itens,
      origem: origem,
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosDetalhesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.index = widget!.indexGrupo;
      safeSetState(() {});
      safeSetState(() {
        _model.txtFeedbackTextController?.text = FFAppState()
            .treinosTemp
            .subagrupamentos
            .elementAtOrNull(_model.index)!
            .feedback;
      });
      _mostrarDeslizadorCerto();
    });

    _model.txtFeedbackTextController ??= TextEditingController();
    _model.txtFeedbackFocusNode ??= FocusNode();

    animationsMap.addAll({
      'iconOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Colors.black,
            begin: 0.0,
            end: 1.0,
          ),
          TintEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            color: FlutterFlowTheme.of(context).primary,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'iconOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Colors.black,
            begin: 0.0,
            end: 1.0,
          ),
          TintEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            color: FlutterFlowTheme.of(context).primary,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
          // A barra de baixo reserva o inset por dentro, para o gradiente
          // chegar ate a borda da tela no iPhone.
          bottom: false,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      primary: false,
                      controller: _model.columnController1,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 768.0,
                            ),
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 32.0;
                                            } else {
                                              return 32.0;
                                            }
                                          }(),
                                          0.0,
                                        ),
                                        16.0,
                                        valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 32.0;
                                            } else {
                                              return 32.0;
                                            }
                                          }(),
                                          0.0,
                                        ),
                                        8.0),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 768.0,
                                      ),
                                      decoration: BoxDecoration(),
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.safePop();
                                                },
                                                // Branco com sombra, como os
                                                // cartoes da tela: em cinza
                                                // chapado ele lia como parte do
                                                // fundo, e o unico jeito de
                                                // voltar ficava sendo o gesto
                                                // do sistema.
                                                child: Container(
                                                  width: 36.0,
                                                  height: 36.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .designToken
                                                          .shadow
                                                          .sm
                                                    ],
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      FFIcons
                                                          .kproperty1FiRrArrowSmallLeft,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState()
                                                                    .exercicioEmAndamento =
                                                                false;
                                                            safeSetState(() {});
                                                          },
                                                          child: Text(
                                                            'Detalhes do seu treino',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 36.0,
                                                    height: 36.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Icon(
                                                        Icons.check_rounded,
                                                        color:
                                                            Color(0x001B98E0),
                                                        size: 18.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  valueOrDefault<double>(
                                    () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 16.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 16.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 32.0;
                                      } else {
                                        return 32.0;
                                      }
                                    }(),
                                    0.0,
                                  ),
                                  16.0,
                                  valueOrDefault<double>(
                                    () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 16.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 16.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 32.0;
                                      } else {
                                        return 32.0;
                                      }
                                    }(),
                                    0.0,
                                  ),
                                  16.0),
                              // Chips no lugar do par de setas: assim se
                              // ve quantos treinos existem e em qual se
                              // esta, sem precisar clicar para descobrir.
                              child: LinhaChipsFiltro(
                                paddingHorizontal: 0.0,
                                chips: [
                                  for (var i = 0;
                                      i <
                                          FFAppState()
                                              .treinosTemp
                                              .subagrupamentos
                                              .length;
                                      i++)
                                    ChipFiltro(
                                      texto: valueOrDefault<String>(
                                        FFAppState()
                                            .treinosTemp
                                            .subagrupamentos
                                            .elementAtOrNull(i)
                                            ?.nome,
                                        '-',
                                      ),
                                      selecionado: _model.index == i,
                                      onTap: () {
                                        _model.index = i;
                                        _model.txtFeedbackTextController?.text =
                                            FFAppState()
                                                    .treinosTemp
                                                    .subagrupamentos
                                                    .elementAtOrNull(i)
                                                    ?.feedback ??
                                                '';
                                        safeSetState(() {});
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 32.0;
                                            } else {
                                              return 32.0;
                                            }
                                          }(),
                                          0.0,
                                        ),
                                        0.0,
                                        valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 32.0;
                                            } else {
                                              return 32.0;
                                            }
                                          }(),
                                          0.0,
                                        ),
                                        0.0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Quanto do treino ja foi feito.
                                          //
                                          // O card do baralho mostrava isso e a
                                          // informacao sumia justamente ao
                                          // abrir o treino, que e onde a pessoa
                                          // esta enquanto treina.
                                          _ProgressoDoTreino(
                                            grupos: _gruposEmOrdem(FFAppState()
                                                .treinosTemp
                                                .subagrupamentos
                                                .elementAtOrNull(_model.index)
                                                ?.grupos),
                                            feedback: _jaFeitoNesteCiclo
                                                ? null
                                                : _treinoAtual?.feedback,
                                            // So no treino em andamento: em
                                            // treino que nao comecou nao ha o
                                            // que comentar.
                                            aoTocarFeedback: (FFAppState()
                                                        .treinosTemp
                                                        .subagrupamentos
                                                        .elementAtOrNull(
                                                            _model.index)
                                                        ?.status ==
                                                    'em_andamento')
                                                ? _abrirFeedback
                                                : null,
                                          ),
                                          Builder(
                                            builder: (context) {
                                              // Na ordem em que o treino deve
                                              // ser feito, e nao na que o
                                              // payload chegou.
                                              //
                                              // `Ordem` sempre mandou na
                                              // sequencia — e o que o personal
                                              // define ao marcar o exercicio
                                              // inicial — mas esta tela
                                              // ignorava o campo. O treino da
                                              // Maria comeca no Peitoral
                                              // (ordem 0) e ela via Bracos
                                              // (ordem 4) primeiro.
                                              final subGrupos = _gruposEmOrdem(
                                                  FFAppState()
                                                      .treinosTemp
                                                      .subagrupamentos
                                                      .elementAtOrNull(
                                                          _model.index)
                                                      ?.grupos);

                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                    subGrupos.length,
                                                    (subGruposIndex) {
                                                  final subGruposItem =
                                                      subGrupos[subGruposIndex];
                                                  // O rotulo do grupo saiu de dentro do cartao: dentro, ele lia como
                                                  // titulo de uma secao do cartao, quando na verdade nomeia o cartao
                                                  // inteiro. Fora e acima, vira etiqueta — o mesmo papel que um
                                                  // cabecalho de lista tem.
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        // 2 a mais que o cartao de cada lado, para o rotulo nao
                                                        // nascer exatamente na quina.
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(2.0,
                                                                8.0, 2.0, 8.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            subGruposItem
                                                                .subcategoria,
                                                            '-',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 18.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          boxShadow: [
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .designToken
                                                                .shadow
                                                                .lg
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                final exercicios =
                                                                    subGruposItem
                                                                        .exercicios
                                                                        .toList();

                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: List.generate(
                                                                      exercicios
                                                                          .length,
                                                                      (exerciciosIndex) {
                                                                    final exerciciosItem =
                                                                        exercicios[
                                                                            exerciciosIndex];
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    // Centro, e nao topo: sem observacao o nome do exercicio e uma
                                                                                    // linha so, e alinhado pelo topo ele ficava acima da metade dos
                                                                                    // botoes de 32 dos dois lados. Com observacao o bloco cresce e
                                                                                    // segue centrado, que e como uma linha de lista se le.
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              if (exerciciosItem.isConcluido && !exerciciosItem.isPulado)
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                                  // Caixa de 32, igual a do botao
                                                                                                  // de play do outro lado da linha:
                                                                                                  // marcador de 20 num lado e botao
                                                                                                  // de 32 no outro nunca encontram a
                                                                                                  // mesma linha de centro, e cada
                                                                                                  // linha da lista ficava torta para
                                                                                                  // um lado.
                                                                                                  child: SizedBox(
                                                                                                    width: 32.0,
                                                                                                    height: 32.0,
                                                                                                    child: Icon(
                                                                                                      Icons.check_circle,
                                                                                                      // Verde de sucesso, o mesmo da
                                                                                                      // comemoracao ao finalizar: o azul
                                                                                                      // e a cor de acao do app, e um
                                                                                                      // exercicio feito nao pede acao
                                                                                                      // nenhuma.
                                                                                                      color: FlutterFlowTheme.of(context).success,
                                                                                                      size: 22.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              if (!exerciciosItem.isConcluido && !exerciciosItem.isPulado)
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                                  // Circulo vazio, sem o numero da
                                                                                                  // posicao: a ordem ja esta na
                                                                                                  // propria sequencia da lista, e o
                                                                                                  // numero repetia isso ocupando o
                                                                                                  // lugar onde o concluido mostra o
                                                                                                  // visto — o par so precisa dizer
                                                                                                  // feito ou nao feito.
                                                                                                  child: SizedBox(
                                                                                                    width: 32.0,
                                                                                                    height: 32.0,
                                                                                                    child: Center(
                                                                                                      child: Container(
                                                                                                        height: 22.0,
                                                                                                        width: 22.0,
                                                                                                        decoration: BoxDecoration(
                                                                                                          shape: BoxShape.circle,
                                                                                                          border: Border.all(
                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                            width: 2.1,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              if (exerciciosItem.isPulado)
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                                  child: SizedBox(
                                                                                                    width: 32.0,
                                                                                                    height: 32.0,
                                                                                                    child: Icon(
                                                                                                      Icons.snooze_rounded,
                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                      size: 22.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                if (!exerciciosItem.isConcluido)
                                                                                                  Expanded(
                                                                                                    child: Column(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        RichText(
                                                                                                          textScaler: MediaQuery.of(context).textScaler,
                                                                                                          text: TextSpan(
                                                                                                            children: [
                                                                                                              TextSpan(
                                                                                                                text: valueOrDefault<String>(
                                                                                                                  exerciciosItem.nome,
                                                                                                                  '-',
                                                                                                                ),
                                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                      font: GoogleFonts.inter(
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                      ),
                                                                                                                      color: _model.substitutos.containsKey(exerciciosItem.execucaoId) ? FlutterFlowTheme.of(context).secondaryText : null,
                                                                                                                      fontSize: 14.0,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                      decoration: _model.substitutos.containsKey(exerciciosItem.execucaoId) ? TextDecoration.lineThrough : null,
                                                                                                                    ),
                                                                                                              ),
                                                                                                              // "Próximo" no primeiro que ainda
                                                                                                              // falta: sem isso, a pessoa abria
                                                                                                              // o treino e tinha que procurar
                                                                                                              // onde retomar.
                                                                                                              //
                                                                                                              // Texto azul, e não mais pílula
                                                                                                              // preenchida: o botão de play do
                                                                                                              // mesmo exercício ja vem cheio de
                                                                                                              // cor, e dois destaques na mesma
                                                                                                              // linha disputavam o olho. Aqui a
                                                                                                              // palavra informa e o botao chama.
                                                                                                              if (exerciciosItem.execucaoId == _proximoExecucaoId)
                                                                                                                TextSpan(
                                                                                                                  text: '  Próximo',
                                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                                                        fontSize: 12.0,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                      ),
                                                                                                                ),
                                                                                                            ],
                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  font: GoogleFonts.inter(
                                                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                  ),
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        if (_model.substitutos.containsKey(exerciciosItem.execucaoId))
                                                                                                          Padding(
                                                                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                                                                                            child: Text(
                                                                                                              _model.substitutos[exerciciosItem.execucaoId]!,
                                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                    font: GoogleFonts.inter(
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                    ),
                                                                                                                    fontSize: 14.0,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                if (exerciciosItem.isConcluido)
                                                                                                  Expanded(
                                                                                                    child: Column(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        RichText(
                                                                                                          textScaler: MediaQuery.of(context).textScaler,
                                                                                                          text: TextSpan(
                                                                                                            children: [
                                                                                                              TextSpan(
                                                                                                                text: valueOrDefault<String>(
                                                                                                                  exerciciosItem.nome,
                                                                                                                  '-',
                                                                                                                ),
                                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                      font: GoogleFonts.inter(
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                      ),
                                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                      fontSize: 14.0,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                      decoration: TextDecoration.lineThrough,
                                                                                                                    ),
                                                                                                              )
                                                                                                            ],
                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  font: GoogleFonts.inter(
                                                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                  ),
                                                                                                                  fontSize: 16.0,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        if (_model.substitutos.containsKey(exerciciosItem.execucaoId))
                                                                                                          Padding(
                                                                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                                                                                            child: Text(
                                                                                                              _model.substitutos[exerciciosItem.execucaoId]!,
                                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                    font: GoogleFonts.inter(
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                    ),
                                                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                    fontSize: 14.0,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                if (exerciciosItem.observacao != '')
                                                                                                  Expanded(
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                                      child: Text(
                                                                                                        exerciciosItem.observacao,
                                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                              font: GoogleFonts.inter(
                                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                              ),
                                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                              fontSize: 12.0,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          // So onde ha substituto cadastrado: o botao
                                                                                          // aparecia em todo exercicio e a folha
                                                                                          // abria vazia na maioria deles. Quem sabe
                                                                                          // se ha para onde trocar e o banco, e a
                                                                                          // resposta ja vem no exercicio.
                                                                                          if ((FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.status == 'em_andamento') && !exerciciosItem.isConcluido && exerciciosItem.temSubstitutos)
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                focusColor: Colors.transparent,
                                                                                                hoverColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                onTap: () async {
                                                                                                  final String? nomeSubstituto = await showModalBottomSheet<String>(
                                                                                                    useRootNavigator: true,
                                                                                                    isScrollControlled: true,
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    enableDrag: false,
                                                                                                    context: context,
                                                                                                    builder: (ctx) => WebViewAware(
                                                                                                      child: GestureDetector(
                                                                                                        onTap: () {
                                                                                                          FocusScope.of(ctx).unfocus();
                                                                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                                                                        },
                                                                                                        child: Padding(
                                                                                                          padding: MediaQuery.viewInsetsOf(ctx),
                                                                                                          child: SubstituirExercicioWidget(
                                                                                                            execucaoId: exerciciosItem.execucaoId,
                                                                                                            nomeOriginal: exerciciosItem.nome,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                  if (nomeSubstituto == null) return;
                                                                                                  if (!context.mounted) return;
                                                                                                  safeSetState(() {
                                                                                                    _model.substitutos[exerciciosItem.execucaoId] = nomeSubstituto;
                                                                                                  });
                                                                                                },
                                                                                                // Redondo e de 24, igual ao + do
                                                                                                // cardio: sao todos botoes de acao de
                                                                                                // linha, e cada um com forma propria
                                                                                                // fazia a lista parecer montada por
                                                                                                // pessoas diferentes.
                                                                                                child: Container(
                                                                                                  width: 24.0,
                                                                                                  height: 24.0,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: FlutterFlowTheme.of(context).accent1,
                                                                                                    shape: BoxShape.circle,
                                                                                                  ),
                                                                                                  child: Align(
                                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                    child: Icon(
                                                                                                      FFIcons.kproperty1FiRrRefresh,
                                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                                      size: 12.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          if ((FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.status == 'em_andamento') && !exerciciosItem.isConcluido)
                                                                                            InkWell(
                                                                                              splashColor: Colors.transparent,
                                                                                              focusColor: Colors.transparent,
                                                                                              hoverColor: Colors.transparent,
                                                                                              highlightColor: Colors.transparent,
                                                                                              onTap: () async {
                                                                                                if (FFAppState().exercicioEmAndamento ? (FFAppState().exercicioTemp.execucaoId != exerciciosItem.execucaoId) : false) {
                                                                                                  await showModalBottomSheet(
                                                                                                    useRootNavigator: true,
                                                                                                    isScrollControlled: true,
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    enableDrag: false,
                                                                                                    context: context,
                                                                                                    builder: (context) {
                                                                                                      return WebViewAware(
                                                                                                        child: GestureDetector(
                                                                                                          onTap: () {
                                                                                                            FocusScope.of(context).unfocus();
                                                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                                                          },
                                                                                                          child: Padding(
                                                                                                            padding: MediaQuery.viewInsetsOf(context),
                                                                                                            child: MensagemWidget(
                                                                                                              texto: 'Conclua o exercício primeiro!',
                                                                                                              tipo: '3',
                                                                                                              fechasozinho: true,
                                                                                                              mostrabotoes: false,
                                                                                                              action: () async {
                                                                                                                safeSetState(() {});
                                                                                                              },
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    },
                                                                                                  ).then((value) => safeSetState(() {}));
                                                                                                } else {
                                                                                                  FFAppState().exercicioTemp = exerciciosItem;
                                                                                                  if (_model.substitutos.containsKey(exerciciosItem.execucaoId)) {
                                                                                                    final subNome = _model.substitutos[exerciciosItem.execucaoId]!;
                                                                                                    final subMap = FFAppState().exercicioTemp.toMap();
                                                                                                    subMap['nome'] = subNome;
                                                                                                    FFAppState().exercicioTemp = ExerciciosStruct.fromMap(subMap);
                                                                                                  }
                                                                                                  FFAppState().treinoExecucaoIdAtivo = FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)!.treinoExecucaoId;
                                                                                                  safeSetState(() {});

                                                                                                  context.pushNamed(
                                                                                                    TreinosExecucaoWidget.routeName,
                                                                                                    queryParameters: {
                                                                                                      'treinoABC': serializeParam(
                                                                                                        valueOrDefault<String>(
                                                                                                          FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.nome,
                                                                                                          '-',
                                                                                                        ),
                                                                                                        ParamType.String,
                                                                                                      ),
                                                                                                      'index': serializeParam(
                                                                                                        _model.index,
                                                                                                        ParamType.int,
                                                                                                      ),
                                                                                                      'indexGrupo': serializeParam(
                                                                                                        subGruposIndex,
                                                                                                        ParamType.int,
                                                                                                      ),
                                                                                                      'indexExercicio': serializeParam(
                                                                                                        exerciciosIndex + 1,
                                                                                                        ParamType.int,
                                                                                                      ),
                                                                                                    }.withoutNulls,
                                                                                                    extra: <String, dynamic>{
                                                                                                      '__transition_info__': TransitionInfo(
                                                                                                        hasTransition: true,
                                                                                                        transitionType: PageTransitionType.fade,
                                                                                                        duration: Duration(milliseconds: 0),
                                                                                                      ),
                                                                                                    },
                                                                                                  );
                                                                                                }
                                                                                              },
                                                                                              // Redondo e de 24, igual ao + do cardio.
                                                                                              //
                                                                                              // Tres estados, nesta ordem:
                                                                                              //
                                                                                              // 1. Ha outro exercicio em andamento e
                                                                                              //    este nao e ele: cinza. Nao da para
                                                                                              //    comecar dois ao mesmo tempo, e o
                                                                                              //    botao tem que dizer isso antes do
                                                                                              //    toque.
                                                                                              // 2. E o proximo da fila: azul cheio com
                                                                                              //    icone branco — e por onde continuar.
                                                                                              // 3. Os demais: azul claro com icone
                                                                                              //    azul.
                                                                                              //
                                                                                              // O cinza vem primeiro de proposito: um
                                                                                              // exercicio pode ser "o proximo" e ainda
                                                                                              // assim estar bloqueado porque outro
                                                                                              // esta rolando.
                                                                                              child: Builder(builder: (context) {
                                                                                                final tema = FlutterFlowTheme.of(context);
                                                                                                final liberado = FFAppState().exercicioEmAndamento ? FFAppState().exercicioTemp.execucaoId == exerciciosItem.execucaoId : true;
                                                                                                final ehProximo = exerciciosItem.execucaoId == _proximoExecucaoId;

                                                                                                final fundo = !liberado ? tema.alternate : (ehProximo ? tema.primary : tema.accent1);
                                                                                                final corIcone = !liberado ? tema.secondaryText : (ehProximo ? Colors.white : tema.primary);

                                                                                                return Container(
                                                                                                  width: 24.0,
                                                                                                  height: 24.0,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: fundo,
                                                                                                    shape: BoxShape.circle,
                                                                                                  ),
                                                                                                  child: Align(
                                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                    child: Icon(
                                                                                                      FFIcons.kproperty1FiRrPlay,
                                                                                                      color: corIcone,
                                                                                                      size: 12.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }),
                                                                                            ),
                                                                                        ].addToStart(SizedBox(width: 16.0)).addToEnd(SizedBox(width: 16.0)),
                                                                                      ),
                                                                                    ].addToStart(SizedBox(width: 16.0)),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                    // Respiro no
                                                                    // fim da lista:
                                                                    // sem as linhas
                                                                    // divisoras, o
                                                                    // ultimo
                                                                    // exercicio
                                                                    // encostava na
                                                                    // borda do
                                                                    // cartao.
                                                                  })
                                                                    ..add(const SizedBox(
                                                                        height:
                                                                            12.0)),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).divide(
                                                    SizedBox(height: 16.0)),
                                              );
                                            },
                                          ),
                                          // Mesma etiqueta das outras (Peitoral, Triceps...): fora do
                                          // cartao, com o mesmo peso e o mesmo respiro. Cardio e mais um
                                          // grupo da lista, e nada justificava um titulo proprio.
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(2.0, 8.0, 2.0, 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Text(
                                                    'Cárdio',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                // O botao anda junto do titulo, como nas metas: ali fica claro a
                                                // que lista ele adiciona. Dentro do cartao, o botao tracejado de
                                                // largura cheia competia com os proprios registros de cardio e
                                                // empurrava o cartao para baixo mesmo sem haver nada para somar.
                                                // Só no treino em execução, como era antes: em treino que ainda não
                                                // começou não há o que registrar, e o botão convidava para uma folha
                                                // que gravaria cárdio num treino que não estava acontecendo.
                                                if (FFAppState()
                                                        .treinosTemp
                                                        .subagrupamentos
                                                        .elementAtOrNull(
                                                            _model.index)
                                                        ?.status ==
                                                    'em_andamento')
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            8.0, 0.0, 0.0, 0.0),
                                                    child: Material(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: InkWell(
                                                        customBorder:
                                                            const CircleBorder(),
                                                        onTap: () async {
                                                          await showModalBottomSheet(
                                                            useRootNavigator:
                                                                true,
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            enableDrag: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return WebViewAware(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        TreinosDetalhesCardioNovoWidget(
                                                                      index: _model
                                                                          .index,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(() =>
                                                                  _model.add =
                                                                      value));

                                                          if (_model.add ==
                                                              true) {
                                                            await Future
                                                                .delayed(
                                                              Duration(
                                                                milliseconds:
                                                                    1000,
                                                              ),
                                                            );
                                                            if (!mounted)
                                                              return;
                                                            await action_blocks
                                                                .getTreinosAluno(
                                                                    context);
                                                            if (!mounted)
                                                              return;
                                                            await showModalBottomSheet(
                                                              useRootNavigator:
                                                                  true,
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return WebViewAware(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                      FocusManager
                                                                          .instance
                                                                          .primaryFocus
                                                                          ?.unfocus();
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: MediaQuery
                                                                          .viewInsetsOf(
                                                                              context),
                                                                      child:
                                                                          MensagemWidget(
                                                                        texto:
                                                                            'Cárdio adicionado!',
                                                                        tipo:
                                                                            '1',
                                                                        fechasozinho:
                                                                            true,
                                                                        mostrabotoes:
                                                                            false,
                                                                        action:
                                                                            () async {
                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          }

                                                          safeSetState(() {});
                                                        },
                                                        child: const SizedBox(
                                                          width: 24.0,
                                                          height: 24.0,
                                                          child: Icon(
                                                            Icons.add_rounded,
                                                            color: Colors.white,
                                                            size: 16.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          // O cartao branco so existe havendo cardio: vazio, ele era uma
                                          // caixa em branco anunciando que nao havia nada dentro.
                                          // Treino que ja voltou para a fila
                                          // nao mostra o cardio da volta
                                          // passada, pelo mesmo motivo dos
                                          // vistos dos exercicios.
                                          if (!_jaFeitoNesteCiclo &&
                                              (_treinoAtual
                                                      ?.cardios.isNotEmpty ??
                                                  false))
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                boxShadow: [
                                                  FlutterFlowTheme.of(context)
                                                      .designToken
                                                      .shadow
                                                      .lg
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              child: SingleChildScrollView(
                                                primary: false,
                                                controller:
                                                    _model.columnController2,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  16.0),
                                                      child: Builder(
                                                        builder: (context) {
                                                          final cardios = FFAppState()
                                                                  .treinosTemp
                                                                  .subagrupamentos
                                                                  .elementAtOrNull(
                                                                      _model
                                                                          .index)
                                                                  ?.cardios
                                                                  ?.map(
                                                                      (e) => e)
                                                                  .toList()
                                                                  ?.toList() ??
                                                              [];

                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: List.generate(
                                                                cardios.length,
                                                                (cardiosIndex) {
                                                              final cardiosItem =
                                                                  cardios[
                                                                      cardiosIndex];
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              16.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                [
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                    child: Icon(
                                                                                      Icons.check_circle,
                                                                                      color: FlutterFlowTheme.of(context).success,
                                                                                      size: 20.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: RichText(
                                                                                              textScaler: MediaQuery.of(context).textScaler,
                                                                                              text: TextSpan(
                                                                                                children: [
                                                                                                  TextSpan(
                                                                                                    text: valueOrDefault<String>(
                                                                                                      cardiosItem.descricao,
                                                                                                      '-',
                                                                                                    ),
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          font: GoogleFonts.inter(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                          fontSize: 14.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                          decoration: TextDecoration.lineThrough,
                                                                                                        ),
                                                                                                  )
                                                                                                ],
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        if (cardiosItem.observacao != '')
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                                                              child: Text(
                                                                                                cardiosItem.observacao,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                      fontSize: 12.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                      ].addToEnd(SizedBox(width: 16.0)),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          if (cardiosItem.distanciaKm > 0.0)
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                                                                                              child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).accent2,
                                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(6.0, 2.0, 6.0, 2.0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        '${valueOrDefault<String>(
                                                                                                          cardiosItem.distanciaKm.toString(),
                                                                                                          '-',
                                                                                                        )}km',
                                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                              font: GoogleFonts.inter(
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                              ),
                                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                                              fontSize: 12.0,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FontWeight.normal,
                                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              color: FlutterFlowTheme.of(context).accent2,
                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(4.0, 2.0, 6.0, 2.0),
                                                                                              child: Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                children: [
                                                                                                  Icon(
                                                                                                    FFIcons.kproperty1FiRrTimeQuarterPast,
                                                                                                    color: FlutterFlowTheme.of(context).secondary,
                                                                                                    size: 14.0,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    '${cardiosItem.duracaoMinutos.toString()}m',
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          font: GoogleFonts.inter(
                                                                                                            fontWeight: FontWeight.normal,
                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                                          fontSize: 12.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.normal,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                        ),
                                                                                                  ),
                                                                                                ].divide(SizedBox(width: 4.0)),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Align(
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    if (FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.status == 'em_andamento')
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                        child: InkWell(
                                                                                          splashColor: Colors.transparent,
                                                                                          focusColor: Colors.transparent,
                                                                                          hoverColor: Colors.transparent,
                                                                                          highlightColor: Colors.transparent,
                                                                                          onTap: () async {
                                                                                            if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
                                                                                              await animationsMap['containerOnActionTriggerAnimation2']!.controller.reverse();
                                                                                            }
                                                                                            _model.opAtv = true;
                                                                                            safeSetState(() {});
                                                                                            await showModalBottomSheet(
                                                                                              useRootNavigator: true,
                                                                                              isScrollControlled: true,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              enableDrag: false,
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return WebViewAware(
                                                                                                  child: GestureDetector(
                                                                                                    onTap: () {
                                                                                                      FocusScope.of(context).unfocus();
                                                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                                                    },
                                                                                                    child: Padding(
                                                                                                      padding: MediaQuery.viewInsetsOf(context),
                                                                                                      child: MensagemWidget(
                                                                                                        texto: 'Remover registro?',
                                                                                                        tipo: '2',
                                                                                                        fechasozinho: false,
                                                                                                        mostrabotoes: true,
                                                                                                        action: () async {
                                                                                                          await RegistrosCardioTable().delete(
                                                                                                            matchingRows: (rows) => rows.eqOrNull(
                                                                                                              'Id',
                                                                                                              cardiosItem.id,
                                                                                                            ),
                                                                                                          );
                                                                                                          await Future.delayed(
                                                                                                            Duration(
                                                                                                              milliseconds: 1000,
                                                                                                            ),
                                                                                                          );
                                                                                                          await action_blocks.getTreinosAluno(context);
                                                                                                          await showModalBottomSheet(
                                                                                                            useRootNavigator: true,
                                                                                                            isScrollControlled: true,
                                                                                                            backgroundColor: Colors.transparent,
                                                                                                            enableDrag: false,
                                                                                                            context: context,
                                                                                                            builder: (context) {
                                                                                                              return WebViewAware(
                                                                                                                child: GestureDetector(
                                                                                                                  onTap: () {
                                                                                                                    FocusScope.of(context).unfocus();
                                                                                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                                                                                  },
                                                                                                                  child: Padding(
                                                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                                                    child: MensagemWidget(
                                                                                                                      texto: 'Registro deletado com sucesso!',
                                                                                                                      tipo: '1',
                                                                                                                      fechasozinho: true,
                                                                                                                      mostrabotoes: false,
                                                                                                                      action: () async {
                                                                                                                        safeSetState(() {});
                                                                                                                      },
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              );
                                                                                                            },
                                                                                                          ).then((value) => safeSetState(() {}));
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ).then((value) => safeSetState(() {}));

                                                                                            _model.opAtv = false;
                                                                                            safeSetState(() {});
                                                                                            if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
                                                                                              safeSetState(() => hasContainerTriggered2 = true);
                                                                                              SchedulerBinding.instance.addPostFrameCallback((_) async => await animationsMap['containerOnActionTriggerAnimation2']!.controller.forward(from: 0.0));
                                                                                            }
                                                                                          },
                                                                                          child: Container(
                                                                                            width: 32.0,
                                                                                            height: 32.0,
                                                                                            decoration: BoxDecoration(
                                                                                              color: FlutterFlowTheme.of(context).accent1,
                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                            ),
                                                                                            child: Align(
                                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                                              child: Icon(
                                                                                                FFIcons.kproperty1FiRrTrash,
                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                size: 14.0,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    if (FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.status == 'em_andamento')
                                                                                      InkWell(
                                                                                        splashColor: Colors.transparent,
                                                                                        focusColor: Colors.transparent,
                                                                                        hoverColor: Colors.transparent,
                                                                                        highlightColor: Colors.transparent,
                                                                                        onTap: () async {
                                                                                          if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
                                                                                            await animationsMap['containerOnActionTriggerAnimation2']!.controller.reverse();
                                                                                          }
                                                                                          _model.opAtv = true;
                                                                                          safeSetState(() {});
                                                                                          await showModalBottomSheet(
                                                                                            useRootNavigator: true,
                                                                                            isScrollControlled: true,
                                                                                            backgroundColor: Colors.transparent,
                                                                                            enableDrag: false,
                                                                                            context: context,
                                                                                            builder: (context) {
                                                                                              return WebViewAware(
                                                                                                child: GestureDetector(
                                                                                                  onTap: () {
                                                                                                    FocusScope.of(context).unfocus();
                                                                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                                                                  },
                                                                                                  child: Padding(
                                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                                    child: TreinosDetalhesCardioEditWidget(
                                                                                                      index: _model.index,
                                                                                                      cardio: cardiosItem,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ).then((value) => safeSetState(() => _model.editou = value));

                                                                                          _model.opAtv = false;
                                                                                          safeSetState(() {});
                                                                                          if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
                                                                                            safeSetState(() => hasContainerTriggered2 = true);
                                                                                          }
                                                                                          if (_model.editou!) {
                                                                                            await Future.delayed(
                                                                                              Duration(
                                                                                                milliseconds: 1000,
                                                                                              ),
                                                                                            );
                                                                                            await action_blocks.getTreinosAluno(context);
                                                                                            safeSetState(() {});
                                                                                            await showModalBottomSheet(
                                                                                              useRootNavigator: true,
                                                                                              isScrollControlled: true,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              enableDrag: false,
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return WebViewAware(
                                                                                                  child: GestureDetector(
                                                                                                    onTap: () {
                                                                                                      FocusScope.of(context).unfocus();
                                                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                                                    },
                                                                                                    child: Padding(
                                                                                                      padding: MediaQuery.viewInsetsOf(context),
                                                                                                      child: MensagemWidget(
                                                                                                        texto: 'Cárdio atualizado!',
                                                                                                        tipo: '1',
                                                                                                        fechasozinho: true,
                                                                                                        mostrabotoes: false,
                                                                                                        action: () async {
                                                                                                          safeSetState(() {});
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ).then((value) => safeSetState(() {}));
                                                                                          }

                                                                                          safeSetState(() {});
                                                                                        },
                                                                                        child: Container(
                                                                                          width: 32.0,
                                                                                          height: 32.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: FlutterFlowTheme.of(context).accent1,
                                                                                            borderRadius: BorderRadius.circular(12.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Icon(
                                                                                              FFIcons.kproperty1FiRrEdit,
                                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                                              size: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                  ].addToStart(SizedBox(width: 8.0)).addToEnd(SizedBox(width: 16.0)),
                                                                                ),
                                                                              ),
                                                                            ].addToStart(SizedBox(width: 16.0)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  if (cardiosIndex !=
                                                                      (valueOrDefault<
                                                                              int>(
                                                                            FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.cardios?.length,
                                                                            0,
                                                                          ) -
                                                                          1))
                                                                    Divider(
                                                                      height:
                                                                          1.0,
                                                                      thickness:
                                                                          1.0,
                                                                      indent:
                                                                          46.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                    ),
                                                                ],
                                                              );
                                                            }),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ]
                                            .divide(SizedBox(height: 16.0))
                                            // Espaco morto no fim da rolagem:
                                            // a barra de deslizar flutua sobre
                                            // o conteudo, e sem folga o ultimo
                                            // item — hoje a etiqueta do cardio
                                            // — parava atras dela e nao havia
                                            // como rolar para ve-lo.
                                            .addToEnd(
                                                const SizedBox(height: 200.0)),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (!_model.opAtv)
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: ClipRect(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 0.0,
                        sigmaY: 0.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x00F2F4F7), Color(0x71181818)],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                        ),
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0,
                            MediaQuery.paddingOf(context).bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Duas condicoes, e nao uma: nenhum outro treino
                            // em andamento (nao da para tocar dois ao mesmo
                            // tempo) E este aqui ainda pendente. Sem a
                            // segunda, treino ja feito no ciclo aparecia com
                            // "deslize para iniciar" e podia ser refeito,
                            // gravando execucao em cima do que ja estava
                            // fechado.
                            if ((FFAppState()
                                        .treinosTemp
                                        .subagrupamentos
                                        .where(
                                            (e) => e.status == 'em_andamento')
                                        .toList()
                                        .length ==
                                    0) &&
                                // Concluido tambem mostra: dai o deslizador
                                // abre uma sessao extra em vez de iniciar a
                                // que ja foi fechada.
                                ((FFAppState()
                                            .treinosTemp
                                            .subagrupamentos
                                            .elementAtOrNull(_model.index)
                                            ?.status ==
                                        'pendente') ||
                                    _jaFeitoNesteCiclo) &&
                                !_model.opAtv)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointLarge) {
                                          return 32.0;
                                        } else {
                                          return 32.0;
                                        }
                                      }(),
                                      0.0,
                                    ),
                                    16.0,
                                    valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointLarge) {
                                          return 32.0;
                                        } else {
                                          return 32.0;
                                        }
                                      }(),
                                      0.0,
                                    ),
                                    40.0),
                                child: Container(
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      FlutterFlowTheme.of(context)
                                          .designToken
                                          .shadow
                                          .lg
                                    ],
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 100.0,
                                          child: custom_widgets.SlideToConfirm(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            height: 100.0,
                                            // Vidro, como o "deslize para
                                            // desligar" do iPhone.
                                            vidro: true,
                                            text: _jaFeitoNesteCiclo
                                                ? 'Deslize para treinar de novo'
                                                : 'Deslize para iniciar',
                                            thumbColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            onConfirm: () async {
                                              // Ja fechado nesta rodada: abre
                                              // sessao extra em vez de
                                              // reiniciar a execucao antiga.
                                              if (_jaFeitoNesteCiclo) {
                                                await _repetirTreino();
                                                return;
                                              }
                                              _model.apiResult7ye =
                                                  await AlunoGroup
                                                      .iniciarTreinoCall
                                                      .call(
                                                pAlunoUuid: currentUserUid,
                                                pTreinoExecucao:
                                                    valueOrDefault<int>(
                                                  FFAppState()
                                                      .treinosTemp
                                                      .subagrupamentos
                                                      .elementAtOrNull(
                                                          _model.index)
                                                      ?.treinoExecucaoId,
                                                  0,
                                                ),
                                              );

                                              if ((_model.apiResult7ye
                                                      ?.succeeded ??
                                                  true)) {
                                                await action_blocks
                                                    .getTreinosAluno(context);
                                                safeSetState(() {});
                                                _mostrarDeslizadorCerto();
                                                await showModalBottomSheet(
                                                  useRootNavigator: true,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return WebViewAware(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child: MensagemWidget(
                                                            texto:
                                                                'Treino iniciado com sucesso!',
                                                            tipo: '1',
                                                            fechasozinho: true,
                                                            mostrabotoes: false,
                                                            action: () async {
                                                              safeSetState(
                                                                  () {});
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              } else {
                                                await mostrarFalha(
                                                  context,
                                                  subtitulo:
                                                      'Nao consegui iniciar o treino agora.',
                                                  codigo: _codigoDoErro(
                                                      _model.apiResult7ye),
                                                );
                                              }

                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animateOnActionTrigger(
                                    animationsMap[
                                        'containerOnActionTriggerAnimation1']!,
                                    hasBeenTriggered: hasContainerTriggered1),
                              ),
                            if ((FFAppState()
                                        .treinosTemp
                                        .subagrupamentos
                                        .elementAtOrNull(_model.index)
                                        ?.status ==
                                    'em_andamento') &&
                                !_model.opAtv)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointLarge) {
                                          return 32.0;
                                        } else {
                                          return 32.0;
                                        }
                                      }(),
                                      0.0,
                                    ),
                                    16.0,
                                    valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 16.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointLarge) {
                                          return 32.0;
                                        } else {
                                          return 32.0;
                                        }
                                      }(),
                                      0.0,
                                    ),
                                    40.0),
                                child: Container(
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      FlutterFlowTheme.of(context)
                                          .designToken
                                          .shadow
                                          .lg
                                    ],
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          key: _chaveConcluir,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 100.0,
                                          child: custom_widgets.SlideToConfirm(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            height: 100.0,
                                            // Azul do app, nao verde: verde aqui
                                            // lia como "ja concluido", quando
                                            // o gesto ainda esta por fazer.
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .accent1,
                                            text:
                                                'Deslize para concluir esse treino',
                                            thumbColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            onConfirm: () async {
                                              // Medido antes de finalizar: o
                                              // recarregamento que vem depois
                                              // troca o treino ativo, e os
                                              // numeros do que acabou de ser
                                              // feito se perderiam.
                                              final resumo = _resumoDoTreino();
                                              final navRaiz = Navigator.of(
                                                  context,
                                                  rootNavigator: true);

                                              // O resumo entra na hora, e o banco
                                              // trabalha por baixo dele. Antes eram duas
                                              // idas a rede — finalizar e recarregar —
                                              // com o dedo ja fora do deslizador e a tela
                                              // parada: o gesto terminava e nada
                                              // acontecia por um tempo que a pessoa nao
                                              // sabia medir.
                                              final finalizando = AlunoGroup
                                                  .finalizarTreinoCall
                                                  .call(
                                                pAlunoUuid: currentUserUid,
                                                pTreinoExecucaoId: FFAppState()
                                                    .treinosTemp
                                                    .subagrupamentos
                                                    .elementAtOrNull(
                                                        _model.index)
                                                    ?.treinoExecucaoId,
                                                pPulado: false,
                                                pFeedback: _model
                                                    .txtFeedbackTextController
                                                    .text,
                                              );
                                              final resumoNaTela =
                                                  _mostrarResumoDoTreino(
                                                      context, resumo);

                                              _model.resultEnd =
                                                  await finalizando;

                                              if ((_model
                                                      .resultEnd?.succeeded ??
                                                  true)) {
                                                // Recarrega enquanto o resumo ainda cobre
                                                // a tela: quando a pessoa fecha, a lista
                                                // ja esta certa por tras.
                                                await action_blocks
                                                    .getTreinosAluno(context);
                                                if (mounted) {
                                                  safeSetState(() {});
                                                  _mostrarDeslizadorCerto();
                                                }
                                                await resumoNaTela;
                                                if (mounted) {
                                                  safeSetState(() {});
                                                }
                                              } else {
                                                // Falha em tela cheia, no mesmo desenho do
                                                // resumo: antes era uma folha cinza com o
                                                // corpo da resposta HTTP no meio da frase,
                                                // ilegivel para quem usa e inutil para quem
                                                // vai reportar. O codigo agora fica no
                                                // rodape. Para tentar de novo basta
                                                // deslizar outra vez — o botao continua ali.
                                                await mostrarFalha(
                                                  context,
                                                  subtitulo:
                                                      'Nao consegui concluir o treino agora.',
                                                  codigo: _codigoDoErro(
                                                      _model.resultEnd),
                                                  origem: _centroDaAcao(
                                                      _chaveConcluir),
                                                );
                                              }

                                              FFAppState()
                                                  .exercicioEmAndamento = false;
                                              FFAppState().timerResetTrigger =
                                                  FFAppState()
                                                          .timerResetTrigger +
                                                      1;
                                              safeSetState(() {});

                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animateOnActionTrigger(
                                    animationsMap[
                                        'containerOnActionTriggerAnimation2']!,
                                    hasBeenTriggered: hasContainerTriggered2),
                              ),
                          ].addToStart(SizedBox(height: 16.0)),
                        ),
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
}

/// Progresso do treino aberto, no topo da tela de detalhes.
///
/// Segue o mesmo desenho dos indicadores de exercicio: uma frase que diz o que
/// o numero significa, a barra logo abaixo e, quando o treino tem mais de um
/// grupo muscular, uma linha por grupo. O numero solto nao dizia se era muito
/// ou pouco, feito ou por fazer.
/// Clareia ([delta] positivo) ou escurece uma cor mantendo matiz e saturação.
///
/// Misturar com preto lava a cor: o azul vai virando cinza-escuro e deixa de
/// ser o azul da marca. Mexer só na luminância do HSL fecha o tom sem trocar
/// de cor.
Color _tom(Color cor, double delta) {
  final hsl = HSLColor.fromColor(cor);
  return hsl.withLightness((hsl.lightness + delta).clamp(0.0, 1.0)).toColor();
}

class _ProgressoDoTreino extends StatelessWidget {
  const _ProgressoDoTreino({
    required this.grupos,
    this.feedback,
    this.aoTocarFeedback,
  });

  final List<GrupossubcategoriasStruct> grupos;

  /// O que já foi escrito. Vazio ou nulo mostra o convite.
  final String? feedback;

  /// Nulo esconde a linha inteira — é o caso do treino que não está em
  /// andamento, onde não há o que comentar ainda.
  final Future<void> Function()? aoTocarFeedback;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final exercicios = grupos.expand((g) => g.exercicios).toList();
    final total = exercicios.length;
    if (total == 0) return const SizedBox.shrink();

    // Pulado nao conta como feito: a barra cheia precisa significar que o
    // treino foi cumprido, e nao que ele terminou.
    final feitos = exercicios.where((e) => e.isConcluido).length;
    final pulados = exercicios.where((e) => e.isPulado).length;

    return Padding(
      // Vao curto: com 16 embaixo o cartao ficava descolado da lista que ele
      // resume, e mesmo com 8 ainda sobrava ar demais entre o resumo e o que
      // ele esta resumindo.
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          // Azul chapado, num tom mais fechado que o `primary`. Derivado dele
          // por HSL e nao escrito em hexadecimal: trocando a cor da marca,
          // este cartao acompanha em vez de descolar.
          color: _tom(tema.primary, -0.20),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [tema.designToken.shadow.lg],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$feitos',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: Colors.white,
                    fontSize: 26.0,
                    letterSpacing: -0.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'de $total exercícios feitos',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      // Branco a 85%: puro, ele competia com o numero ao lado
                      // e os dois liam com o mesmo peso.
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999.0),
                child: LinearProgressIndicator(
                  value: feitos / total,
                  minHeight: 6.0,
                  // Sobre o azul, o trilho e um branco rebaixado e o
                  // preenchimento e branco cheio: com as cores do tema a barra
                  // sumia dentro do proprio cartao.
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    feitos == total ? tema.success : Colors.white,
                  ),
                ),
              ),
            ),
            if (pulados > 0)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  pulados == 1
                      ? '1 exercício pulado'
                      : '$pulados exercícios pulados',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 11.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            // Convite ao feedback, dentro do cartao que ja resume o treino:
            // ele morava numa secao propria la embaixo, depois da lista
            // inteira, e ninguem rolava ate la. Aqui esta ao lado do numero
            // que ele comenta.
            if (aoTocarFeedback != null)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () => aoTocarFeedback!(),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            (feedback ?? '').isEmpty
                                ? Icons.chat_bubble_outline_rounded
                                : Icons.edit_outlined,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 16.0,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              (feedback ?? '').isEmpty
                                  ? 'Deixe seu feedback sobre este treino'
                                  : feedback!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              // O que ja foi escrito vem em branco cheio e o
                              // convite em branco rebaixado: assim da para
                              // saber se ha texto sem precisar ler.
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500),
                                color: (feedback ?? '').isEmpty
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : Colors.white,
                                fontSize: 12.5,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
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

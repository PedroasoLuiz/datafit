import 'dart:async' show unawaited;

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/diagnostico.dart';
import '/backend/schema/structs/index.dart';
import '/components/comemoracao.dart';
import '/components/esqueleto.dart';
import '/components/mensagem_widget.dart';
import '/components/video_exercicio.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/unidade_carga.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/treinos/videoplay/videoplay_widget.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'treinos_execucao_model.dart';
export 'treinos_execucao_model.dart';

class TreinosExecucaoWidget extends StatefulWidget {
  const TreinosExecucaoWidget({
    super.key,
    required this.treinoABC,
    int? index,
    required this.indexGrupo,
    required this.indexExercicio,
  }) : this.index = index ?? 0;

  final String? treinoABC;
  final int index;
  final int? indexGrupo;
  final int? indexExercicio;

  static String routeName = 'treinosExecucao';
  static String routePath = '/treinosExecucao';

  @override
  State<TreinosExecucaoWidget> createState() => _TreinosExecucaoWidgetState();
}

class _TreinosExecucaoWidgetState extends State<TreinosExecucaoWidget>
    with TickerProviderStateMixin {
  late TreinosExecucaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  /// Campo de carga. `_model.peso` guarda o numero que esta na tela, na
  /// unidade do seletor ao lado; a conversao para kg acontece na gravacao.
  final TextEditingController _pesoController = TextEditingController();

  /// O seletor de unidade da propria tela manda aqui (2 = Lb, 1 = Kg).
  bool get _emLibras => _model.dropDownValue == 2;

  /// Segundos como a pessoa fala: "45s", "1min", "1min30".
  ///
  /// `mm:ss` e leitura de cronometro — bom para tempo que corre, ruim para
  /// prescricao, que se le uma vez e se guarda.
  String _formatarDescanso(int segundos) {
    if (segundos < 60) return '${segundos}s';
    final minutos = segundos ~/ 60;
    final resto = segundos % 60;
    return resto == 0 ? '${minutos}min' : '${minutos}min${resto}';
  }

  /// Pulso do número quando o peso muda pelos botões.
  ///
  /// O campo continua sendo editável, então o número não pode virar um
  /// `AnimatedSwitcher` — o que anima é o campo inteiro: cresce um pouco e
  /// desliza no sentido da mudança, para cima somando e para baixo tirando.
  /// Sem isso, tocar em `+` mexia num dígito no meio da tela e o toque não
  /// tinha resposta nenhuma.
  late final AnimationController _pulsoPeso = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  /// +1 subindo, -1 descendo. Decide de que lado o número entra.
  double _sentidoPeso = 1.0;

  /// A pílula de ação da barra, para a comemoração nascer de onde o dedo
  /// tocou em vez do meio da tela.
  final GlobalKey _chaveAcao = GlobalKey();

  /// Centro da pílula em coordenadas da tela.
  ///
  /// Nulo se o botão não estiver montado ou ainda não tiver sido medido — a
  /// comemoração então cai no centro, que é um destino razoável.
  Offset? _centroDaAcao() {
    final caixa = _chaveAcao.currentContext?.findRenderObject() as RenderBox?;
    if (caixa == null || !caixa.hasSize) return null;
    return caixa.localToGlobal(caixa.size.center(Offset.zero));
  }

  /// Altera a carga e mantem o campo de texto em sincronia.
  ///
  /// [pulsar] só vem dos botões de mais e menos. Digitar não pulsa (o número
  /// já está debaixo do dedo) e a carga sugerida que chega do banco também
  /// não, porque ali ninguém pediu nada.
  void _definirPeso(double valor, {bool pulsar = false}) {
    final novo = valor < 0 ? 0.0 : valor;
    if (pulsar) {
      _sentidoPeso = novo >= _model.peso ? 1.0 : -1.0;
      _pulsoPeso.forward(from: 0.0);
    }
    _model.peso = novo;
    _pesoController.text = formatarCarga(novo);
    _pesoController.selection =
        TextSelection.collapsed(offset: _pesoController.text.length);
    safeSetState(() {});
  }

  /// Enquanto a ultima carga nao chega, o campo mostra um bloco cinza no
  /// lugar do numero: zerado ele parecia resposta pronta, e o valor sugerido
  /// aparecendo depois dava a impressao de que alguem tinha digitado.
  bool _buscandoUltimaCarga = true;

  /// Busca a ultima carga que o aluno usou neste exercicio para abrir o campo
  /// preenchido em vez de zerado. O valor vem em kg.
  Future<void> _carregarUltimaCarga() async {
    try {
      final resposta = await SupaFlow.client.rpc(
        'get_ultima_carga_exercicio',
        params: {
          'p_aluno_uuid': currentUserUid,
          'p_execucao_id': FFAppState().exercicioTemp.execucaoId,
        },
      );
      final mapa = (resposta as Map?)?.cast<String, dynamic>() ?? {};
      if (!mounted || mapa['temRegistro'] != true) return;
      final kg = (mapa['peso'] as num?)?.toDouble();
      if (kg == null || kg <= 0) return;
      _definirPeso(deKg(kg, emLibras: _emLibras));
    } catch (_) {
      // Sugestao e conveniencia: falhando, o campo so fica vazio.
    } finally {
      if (mounted) safeSetState(() => _buscandoUltimaCarga = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosExecucaoModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // A tela abriu so com o cabecalho e ninguem sabe por que. Anota o estado
      // de entrada: quais indices vieram, se `exercicioTemp` esta preenchido e
      // se os indices ainda encontram alguma coisa na lista. Ler o codigo ja
      // me levou a uma conclusao errada hoje.
      final ex = FFAppState().exercicioTemp;
      final sub = FFAppState()
          .treinosTemp
          .subagrupamentos
          .elementAtOrNull(widget!.index ?? -1);
      final grupo = sub?.grupos.elementAtOrNull(widget!.indexGrupo ?? -1);
      unawaited(anotarDiagnostico(
        'execucao_abriu',
        'index=${widget!.index} indexGrupo=${widget!.indexGrupo} '
            'indexExercicio=${widget!.indexExercicio} '
            'exercicioTemp.nome="${ex.nome}" execucaoId=${ex.execucaoId} '
            'series=${ex.series} subagrupamentos=${FFAppState().treinosTemp.subagrupamentos.length} '
            'subEncontrado=${sub != null} grupoEncontrado=${grupo != null} '
            'exerciciosNoGrupo=${grupo?.exercicios.length} '
            'emAndamento=${FFAppState().exercicioEmAndamento}',
      ));

      _model.repets = FFAppState().exercicioTemp.repeticoes;
      // Unidade inicial vem da preferencia do perfil; o seletor ao lado do
      // campo continua podendo trocar so para esta digitacao.
      _model.dropDownValue ??= usaLibras ? 2 : kMedidaKgId;
      safeSetState(() {});
      await _carregarUltimaCarga();
    });

    animationsMap.addAll({
      'buttonOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 0.0),
            end: Offset(-100.0, 0.0),
          ),
        ],
      ),
      // Mesma entrada da navbar: a barra sobe e aparece em vez de já estar
      // pintada quando a tela abre.
      'barraOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeOutCubic,
            delay: 0.0.ms,
            duration: 420.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 320.0.ms,
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
    _pesoController.dispose();
    _pulsoPeso.dispose();
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
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
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
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
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
                            alignment: AlignmentDirectional(0.0, 0.0),
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
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.safePop();
                                    },
                                    child: Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.navigate_before_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    widget!.treinoABC,
                                                    '-',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
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
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 36.0,
                                        height: 36.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Icon(
                                            Icons.check_rounded,
                                            color: Color(0x001B98E0),
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
              Expanded(
                child: SingleChildScrollView(
                  controller: _model.columnController,
                  // `min`, e nao `max`: dentro de um scroll a altura chega sem
                  // limite, e uma Column que pede o maximo tenta ocupar
                  // infinito. Em debug isso vira asserção; em release as
                  // asserções somem e o layout so nao pinta — sobrava o
                  // cabecalho, que fica fora do scroll.
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            valueOrDefault<double>(
                              () {
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
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
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointLarge) {
                                  return 32.0;
                                } else {
                                  return 32.0;
                                }
                              }(),
                              0.0,
                            ),
                            0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Na mesma linha do "Exercício x de x", à direita:
                            // é prescrição, e mora junto com o resto do que
                            // situa o exercício. Dentro do botão ela
                            // competia com o cronômetro correndo e os dois
                            // números se confundiam.
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Exercício ${widget!.indexExercicio?.toString()}  de ${(FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(widget!.index)?.grupos?.elementAtOrNull(widget!.indexGrupo!))?.exercicios?.length?.toString()}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                if (FFAppState()
                                        .exercicioTemp
                                        .tempoDescansoSeg >
                                    0)
                                  Text(
                                    'Descanso indicado ${_formatarDescanso(FFAppState().exercicioTemp.tempoDescansoSeg)}',
                                    // Mesmo peso e mesma cor do "Exercício x
                                    // de x": são a mesma linha e a mesma
                                    // natureza de informação, então nada ali
                                    // deve puxar o olho mais que o outro.
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Text(
                                      valueOrDefault<String>(
                                        FFAppState().exercicioTemp.nome,
                                        '-',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 22.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (FFAppState().exercicioTemp.observacao != '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        valueOrDefault<String>(
                                          FFAppState().exercicioTemp.observacao,
                                          'Sem observações',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  final series = functions
                                      .gerarListaSeries(
                                          FFAppState().exercicioTemp.series)
                                      .map((e) => e)
                                      .toList();

                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(series.length,
                                        (seriesIndex) {
                                      final seriesItem = series[seriesIndex];
                                      return Expanded(
                                        child: Container(
                                          width: 100.0,
                                          height: 6.0,
                                          decoration: BoxDecoration(
                                            color: valueOrDefault<Color>(
                                              seriesItem <=
                                                      FFAppState()
                                                          .exercicioTemp
                                                          .seriesFeitas
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : FlutterFlowTheme.of(context)
                                                      .alternate,
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      );
                                    }).divide(SizedBox(width: 4.0)),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: Text(
                                    'Série ${FFAppState().exercicioTemp.seriesFeitas.toString()} de ${valueOrDefault<String>(
                                      FFAppState()
                                          .exercicioTemp
                                          .series
                                          .toString(),
                                      '0',
                                    )}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: RichText(
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: valueOrDefault<String>(
                                            FFAppState()
                                                .exercicioTemp
                                                .repeticoes
                                                .toString(),
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        TextSpan(
                                          text: ' repetições',
                                          style: TextStyle(),
                                        )
                                      ],
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
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
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            valueOrDefault<double>(
                              () {
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
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
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
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
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            valueOrDefault<double>(
                              () {
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointLarge) {
                                  return 32.0;
                                } else {
                                  return 32.0;
                                }
                              }(),
                              0.0,
                            ),
                            32.0,
                            valueOrDefault<double>(
                              () {
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width <
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
                          decoration: BoxDecoration(
                            boxShadow: [
                              FlutterFlowTheme.of(context).designToken.shadow.lg
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Cartao fechado nos quatro cantos: o de baixo
                              // era reto porque a faixa do video vinha colada
                              // aqui. Agora o video e cartao proprio, entao
                              // este termina em si mesmo.
                              Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Text(
                                                'Peso neste exercício é:',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            // Sem o Row externo: ele tinha um
                                            // filho so, entao o spaceBetween
                                            // nao separava nada — e um Row
                                            // dentro de outro Row chega sem
                                            // largura, o que torna ilegal o
                                            // Expanded do campo de peso aqui
                                            // dentro. Em release a assercao
                                            // some e o layout se vira; em
                                            // debug a tela inteira falhava.
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                // Acompanha o numero
                                                // digitado, e nao a largura
                                                // toda: com Expanded a
                                                // unidade era empurrada para
                                                // a borda oposta do cartao,
                                                // longe do valor que ela
                                                // qualifica. Antes disso o
                                                // Row chegava sem largura e
                                                // o Expanded nao expandia
                                                // nada — parecia certo por
                                                // acidente.
                                                if (_buscandoUltimaCarga)
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 4.0),
                                                    child: BlocoEsqueleto(
                                                        largura: 76.0,
                                                        altura: 28.0),
                                                  )
                                                else
                                                  Flexible(
                                                    child: AnimatedBuilder(
                                                      animation: _pulsoPeso,
                                                      builder:
                                                          (context, filho) {
                                                        // Meia onda de seno:
                                                        // sai de zero, chega
                                                        // ao pico no meio e
                                                        // volta a zero — o
                                                        // numero cresce e
                                                        // assenta, sem
                                                        // precisar de duas
                                                        // animacoes em
                                                        // sequencia.
                                                        final onda = sin(pi *
                                                            _pulsoPeso.value);
                                                        return Transform
                                                            .translate(
                                                          offset: Offset(
                                                              0.0,
                                                              -_sentidoPeso *
                                                                  7.0 *
                                                                  onda),
                                                          child:
                                                              Transform.scale(
                                                            scale: 1.0 +
                                                                0.13 * onda,
                                                            child: filho,
                                                          ),
                                                        );
                                                      },
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                minWidth: 44.0),
                                                        child: IntrinsicWidth(
                                                          child: TextFormField(
                                                            controller:
                                                                _pesoController,
                                                            keyboardType:
                                                                const TextInputType
                                                                    .numberWithOptions(
                                                                    decimal:
                                                                        true),
                                                            inputFormatters: [
                                                              // So digito, virgula e ponto. Evita sinal, espaco e letras.
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[0-9.,]')),
                                                            ],
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            onChanged: (texto) {
                                                              final valor =
                                                                  lerCargaDigitada(
                                                                      texto);
                                                              if (valor !=
                                                                  null) {
                                                                _model.peso =
                                                                    valor;
                                                              }
                                                            },
                                                            onTapOutside: (_) =>
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus(),
                                                            decoration:
                                                                const InputDecoration(
                                                              isDense: true,
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              hintText: '0',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts.inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      30.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                FlutterFlowDropDown<int>(
                                                  controller: _model
                                                          .dropDownValueController ??=
                                                      FormFieldController<int>(
                                                    _model.dropDownValue ??= 1,
                                                  ),
                                                  options:
                                                      List<int>.from([2, 1]),
                                                  optionLabels: ['Lb', 'Kg'],
                                                  onChanged: (val) {
                                                    // Converte o valor
                                                    // exibido para a
                                                    // nova unidade.
                                                    final eraLb = _emLibras;
                                                    final emKg = paraKg(
                                                        _model.peso,
                                                        emLibras: eraLb);
                                                    _model.dropDownValue = val;
                                                    _definirPeso(deKg(emKg,
                                                        emLibras: val == 2));
                                                  },
                                                  width: 42.0,
                                                  height: 24.0,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  hintText: 'Kg',
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    size: 16.0,
                                                  ),
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  elevation: 2.0,
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderWidth: 0.0,
                                                  borderRadius: 0.0,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          4.0, 0.0, 0.0, 0.0),
                                                  hidesUnderline: true,
                                                  isOverButton: false,
                                                  isSearchable: false,
                                                  isMultiSelect: false,
                                                ),
                                              ].divide(SizedBox(width: 8.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 12.0, 22.0, 12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FlutterFlowIconButton(
                                            borderRadius: 12.0,
                                            buttonSize: 40.0,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .accent1,
                                            disabledColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            disabledIconColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            icon: Icon(
                                              FFIcons.kproperty1FiRrMinusSmall,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 20.0,
                                            ),
                                            onPressed: (_model.peso <= 0.0)
                                                ? null
                                                : () async {
                                                    _definirPeso(
                                                        _model.peso - 0.5,
                                                        pulsar: true);
                                                    safeSetState(() {});
                                                  },
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onLongPress: () async {
                                              _definirPeso(_model.peso + 10.0,
                                                  pulsar: true);
                                              safeSetState(() {});
                                            },
                                            child: FlutterFlowIconButton(
                                              borderRadius: 12.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              icon: Icon(
                                                FFIcons.kproperty1FiRrPlusSmall,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                size: 20.0,
                                              ),
                                              onPressed: () async {
                                                _definirPeso(_model.peso + 0.5,
                                                    pulsar: true);
                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (false)
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          valueOrDefault<double>(
                                        valueOrDefault<String>(
                                                      FFAppState()
                                                          .exercicioTemp
                                                          .linkInstrucao,
                                                      '-',
                                                    ) !=
                                                    null &&
                                                valueOrDefault<String>(
                                                      FFAppState()
                                                          .exercicioTemp
                                                          .linkInstrucao,
                                                      '-',
                                                    ) !=
                                                    ''
                                            ? 0.0
                                            : 16.0,
                                        0.0,
                                      )),
                                      bottomRight: Radius.circular(
                                          valueOrDefault<double>(
                                        valueOrDefault<String>(
                                                      FFAppState()
                                                          .exercicioTemp
                                                          .linkInstrucao,
                                                      '-',
                                                    ) !=
                                                    null &&
                                                valueOrDefault<String>(
                                                      FFAppState()
                                                          .exercicioTemp
                                                          .linkInstrucao,
                                                      '-',
                                                    ) !=
                                                    ''
                                            ? 0.0
                                            : 16.0,
                                        0.0,
                                      )),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: Text(
                                                  'Suas repetições são:',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          _model.repets
                                                              .toString(),
                                                          '0',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      30.0,
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
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 22.0, 12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FlutterFlowIconButton(
                                              borderRadius: 12.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              disabledColor:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              disabledIconColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              icon: Icon(
                                                FFIcons
                                                    .kproperty1FiRrMinusSmall,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 20.0,
                                              ),
                                              onPressed: (_model.repets <= 0)
                                                  ? null
                                                  : () async {
                                                      if (_model.repets > 0) {
                                                        _model.repets =
                                                            _model.repets + -1;
                                                        safeSetState(() {});
                                                      }
                                                    },
                                            ),
                                            FlutterFlowIconButton(
                                              borderRadius: 12.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              icon: Icon(
                                                FFIcons.kproperty1FiRrPlusSmall,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                size: 20.0,
                                              ),
                                              onPressed: () async {
                                                _model.repets =
                                                    _model.repets + 1;
                                                safeSetState(() {});
                                              },
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (FFAppState().exercicioTemp.serieAquecimento >
                                  1)
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Aquecimento:',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: valueOrDefault<
                                                              String>(
                                                            FFAppState()
                                                                .exercicioTemp
                                                                .serieAquecimento
                                                                .toString(),
                                                            '0',
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
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 30.0,
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
                                                        TextSpan(
                                                          text: valueOrDefault<
                                                              String>(
                                                            valueOrDefault<int>(
                                                                      FFAppState()
                                                                          .exercicioTemp
                                                                          .serieAquecimento,
                                                                      0,
                                                                    ) >
                                                                    1
                                                                ? ' séries'
                                                                : 'série',
                                                            'série',
                                                          ),
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 26.0,
                                                          ),
                                                        )
                                                      ],
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      _CardVideoExercicio(),
                    ],
                  ),
                ),
              ),
              _barraDeAcoes(context),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Ações do exercício ────────────────────────────────────────────────
  //
  // Cada uma era o corpo de um FFButtonWidget dentro da barra. Como agora a
  // barra mostra uma ação de cada vez, elas precisam existir separadas do
  // botão que as dispara — o corpo é o mesmo de antes, linha por linha.

  /// Aviso de que a ação não foi para o banco.
  ///
  /// Só aparece quando o app já tinha mostrado a ação como feita e precisou
  /// voltar atrás — sem ele, a tela desfaria sozinha e ninguém entenderia
  /// por quê.
  Future<void> _avisarFalha(
    BuildContext context,
    String texto, {
    ApiCallResponse? resposta,
  }) async {
    if (!mounted) return;
    await mostrarFalha(
      context,
      subtitulo: texto,
      codigo: _codigoDoErro(resposta),
      origem: _centroDaAcao(),
    );
  }

  /// Código do erro para o rodapé da tela de falha.
  ///
  /// Status HTTP e o corpo cortado: o corpo inteiro do Postgres passa de mil
  /// caracteres e não cabe em tela nenhuma, mas as primeiras linhas trazem o
  /// que identifica o problema.
  String? _codigoDoErro(ApiCallResponse? r) {
    if (r == null) return null;
    final corpo = (r.jsonBody ?? '').toString().trim();
    final curto = corpo.length > 160 ? '${corpo.substring(0, 160)}…' : corpo;
    return curto.isEmpty
        ? 'HTTP ${r.statusCode}'
        : 'HTTP ${r.statusCode} · $curto';
  }

  /// Começa o exercício sem esperar o banco.
  ///
  /// A tela mudava só depois do RPC voltar, e numa conexão de academia isso
  /// é um botão que não responde por um segundo ou dois — tempo suficiente
  /// para a pessoa tocar de novo. Agora o estado vira na hora e só volta
  /// atrás se o servidor recusar, que é o caso raro.
  Future<void> _iniciarExercicio() async {
    final estadoAnterior = FFAppState().exercicioEmAndamento;
    final descansoAnterior = FFAppState().timerDescansando;

    FFAppState().exercicioEmAndamento = true;
    FFAppState().timerDescansando = false;
    FFAppState().update(() {});
    safeSetState(() {});

    _model.apiResultbkm = await AlunoGroup.iniciarExercicioCall.call(
      pAlunoUuid: currentUserUid,
      pTreinoExecucaoId: FFAppState().treinoExecucaoIdAtivo,
      pExercicioExecucaoId: FFAppState().exercicioTemp.execucaoId,
    );

    if (!(_model.apiResultbkm?.succeeded ?? true)) {
      FFAppState().exercicioEmAndamento = estadoAnterior;
      FFAppState().timerDescansando = descansoAnterior;
      FFAppState().update(() {});
      safeSetState(() {});
      await _avisarFalha(
        context,
        'Não consegui iniciar o exercício agora. Tente de novo.',
        resposta: _model.apiResultbkm,
      );
      return;
    }

    safeSetState(() {});
  }

  /// Conta a série e começa o descanso na hora.
  ///
  /// Antes o descanso só começava depois de duas idas ao servidor — gravar a
  /// série e recarregar o treino inteiro. Entre o toque e o cronômetro
  /// andando havia um vão em que a tela não dizia nada, e o descanso já
  /// estava correndo na vida real. Agora conta desde o toque; o servidor
  /// confirma depois e a contagem oficial vem dele.
  Future<void> _concluirSerie(BuildContext context) async {
    final feitasAntes = FFAppState().exercicioTemp.seriesFeitas;
    final serieNumero = feitasAntes + 1;

    _model.descansando = true;
    final otimista = FFAppState().exercicioTemp;
    otimista.seriesFeitas = serieNumero;
    FFAppState().exercicioTemp = otimista;
    FFAppState().timerDescansando = true;
    FFAppState().descansoinicio = getCurrentTimestamp.toString();
    FFAppState().update(() {});
    safeSetState(() {});

    _model.apiResultzvs = await AlunoGroup.registrarSerieCall.call(
      pAlunoUuid: currentUserUid,
      pTreinoExecucaoId: FFAppState().treinoExecucaoIdAtivo,
      pExercicioExecucaoId: FFAppState().exercicioTemp.execucaoId,
      pSeriesTotal: FFAppState().exercicioTemp.series,
      pSerieNumero: serieNumero,
      pRepeticoes: _model.repets,
      // Normalizado: o banco guarda sempre em quilos.
      pPeso: paraKg(_model.peso, emLibras: _emLibras),
      pMedidaId: kMedidaKgId,
      pPulado: false,
      pSerieAquecimento: false,
    );

    if (!(_model.apiResultzvs?.succeeded ?? true)) {
      _model.descansando = false;
      final volta = FFAppState().exercicioTemp;
      volta.seriesFeitas = feitasAntes;
      FFAppState().exercicioTemp = volta;
      FFAppState().timerDescansando = false;
      FFAppState().update(() {});
      safeSetState(() {});
      await _avisarFalha(
        context,
        'Não consegui registrar a série agora. Tente de novo.',
        resposta: _model.apiResultzvs,
      );
      return;
    }

    // Reconciliação: o número que vale é o do banco. O palpite otimista
    // acerta quase sempre, mas não quando a mesma série foi registrada de
    // outro lugar.
    await action_blocks.getTreinosAluno(context);
    if (!mounted) return;
    final doServidor = FFAppState()
        .treinosTemp
        .subagrupamentos
        .elementAtOrNull(widget.index)
        ?.grupos
        .elementAtOrNull(widget.indexGrupo!)
        ?.exercicios
        .where((e) => e.execucaoId == FFAppState().exercicioTemp.execucaoId)
        .firstOrNull;
    // Sem `!`: se os índices não acharem nada, o palpite otimista fica de pé
    // em vez de a tela morrer com erro de nulo.
    if (doServidor != null) {
      FFAppState().exercicioTemp = doServidor;
      FFAppState().update(() {});
    }

    safeSetState(() {});
  }

  Future<void> _finalizarExercicio(BuildContext context) async {
    // Medido antes de tudo: é do botão que a comemoração nasce, e ele precisa
    // ainda estar na tela quando o centro dele é lido.
    final origem = _centroDaAcao();
    final nome = FFAppState().exercicioTemp.nome;

    // O recarregamento corre junto com a animação em vez de antes dela: são
    // uns bons décimos de rede que a pessoa passaria olhando um botão parado.
    final recarregando = action_blocks.getTreinosAluno(context);

    // Comemoração de tela cheia no lugar da folha de aviso: terminar o
    // exercício era anunciado com o mesmo retângulo cinza que anuncia erro.
    // O `await` importa — voltar antes do fim deixaria a animação tocando
    // por cima de uma tela que já não é a dela.
    await mostrarComemoracao(
      context,
      titulo: 'Exercício concluído!',
      subtitulo: nome,
      origem: origem,
    );
    await recarregando;

    // Só agora o exercício deixa de estar em andamento. Zerar isso antes de
    // animar fazia a barra atrás voltar a dizer "Iniciar" — e era esse
    // "Iniciar" que aparecia por baixo, como se o exercício tivesse
    // recomeçado no instante em que acabou.
    FFAppState().exercicioEmAndamento = false;
    FFAppState().timerResetTrigger = FFAppState().timerResetTrigger + 1;
    FFAppState().update(() {});

    if (!mounted) return;
    safeSetState(() {});
    context.safePop();
  }

  Future<void> _pularExercicio(BuildContext context) async {
    _model.resu = await AlunoGroup.pularExercicioCall.call(
      pAlunoUuid: currentUserUid,
      pTreinoExecucaoId: FFAppState().treinoExecucaoIdAtivo,
      pExercicioExecucaoId: FFAppState().exercicioTemp.execucaoId,
      pPulado: true,
    );

    if ((_model.resu?.succeeded ?? true)) {
      FFAppState().exercicioEmAndamento = false;
      FFAppState().timerResetTrigger = FFAppState().timerResetTrigger + 1;
      safeSetState(() {});
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
                  texto: 'Você pulou esse exercício.',
                  tipo: '3',
                  fechasozinho: true,
                  mostrabotoes: false,
                  action: () async {
                    await action_blocks.getTreinosAluno(context);
                  },
                ),
              ),
            ),
          );
        },
      ).then((value) => safeSetState(() {}));

      context.safePop();
    }

    safeSetState(() {});
  }

  Future<void> _continuarAposDescanso() async {
    _model.res = await AlunoGroup.registrarDescansoCall.call(
      pAlunoUuid: currentUserUid,
      pTreinoExecucaoId: FFAppState().treinoExecucaoIdAtivo,
      pExercicioExecucaoId: FFAppState().exercicioTemp.execucaoId,
      pDuracaoSegundos: valueOrDefault<int>(
        functions.calcularDuracaoSegundos(FFAppState().descansoinicio),
        0,
      ),
    );

    if ((_model.res?.succeeded ?? true)) {
      _model.descansando = false;
      safeSetState(() {});
      FFAppState().timerDescansando = false;
      safeSetState(() {});
    }

    safeSetState(() {});
  }

  /// Os dois cronômetros, sempre montados.
  ///
  /// Só um aparece por vez, mas os dois ficam no ar: o `PersistentTimer`
  /// guarda o instante de início em disco e, ao ser montado de novo enquanto
  /// `running`, soma o tempo decorrido ao que já havia salvo. Desmontar e
  /// remontar a cada troca de estado contaria o mesmo intervalo duas vezes.
  /// `Offstage` tira da tela sem tirar da árvore.
  Widget _cronometro(
    BuildContext context, {
    required bool descanso,
    bool mostrar = true,
  }) {
    final visivel = mostrar && descanso == _model.descansando;

    // O descanso é uma contagem nova a cada série, e não um acumulado do
    // exercício inteiro: com o gatilho compartilhado ele só zerava ao
    // finalizar ou pular, então o segundo descanso já começava somando o
    // primeiro. A série feita entra no gatilho porque é exatamente o que
    // muda quando um descanso começa.
    final gatilho = descanso
        ? FFAppState().timerResetTrigger * 1000 +
            FFAppState().exercicioTemp.seriesFeitas
        : FFAppState().timerResetTrigger;

    return Offstage(
      offstage: !visivel,
      child: SizedBox(
        height: 22.0,
        child: custom_widgets.PersistentTimer(
          height: 22.0,
          storageKey: descanso ? 'timer_descanso' : 'timer_execucao',
          running: descanso
              ? (FFAppState().timerDescansando &&
                  FFAppState().exercicioEmAndamento)
              : (!FFAppState().timerDescansando &&
                  FFAppState().exercicioEmAndamento),
          resetTrigger: gatilho,
          textColor: Colors.white,
          fontSize: 14.0,
          alignment: 'center',
        ),
      ),
    );
  }

  /// Barra de ações do exercício.
  ///
  /// Antes eram dois cronômetros grandes numa linha e até três botões na
  /// outra, todos com o mesmo peso visual — a pessoa tinha que ler os três
  /// para descobrir qual era o próximo passo. Agora a barra diz uma coisa só:
  /// a ação do momento, numa pílula com o tempo corrente dentro dela. O que
  /// sobra (pular, ou concluir mais uma série depois da última) vira ícone
  /// sem rótulo, como as abas inativas da navbar.
  ///
  /// A pílula troca sozinha conforme o estado, e é a mesma pílula: por isso a
  /// cor e a largura animam em vez de um botão sumir e outro aparecer.
  Widget _barraDeAcoes(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final emAndamento = FFAppState().exercicioEmAndamento;
    final descansando = _model.descansando;
    final ultimaSerieFeita = FFAppState().exercicioTemp.seriesFeitas >=
        FFAppState().exercicioTemp.series;

    // A ordem importa: descanso vence "concluir série" porque durante ele não
    // há série a concluir, e "finalizar" vence o descanso quando as séries já
    // acabaram — era assim que as condições dos botões antigos se resolviam.
    final String rotulo;
    final IconData icone;
    final Color cor;
    final String? prefixoTempo;
    final Future<void> Function() acao;

    if (!emAndamento) {
      rotulo = 'Iniciar';
      icone = FFIcons.kproperty1FiRrPlay;
      cor = tema.primary;
      prefixoTempo = null;
      acao = _iniciarExercicio;
    } else if (ultimaSerieFeita) {
      rotulo = 'Finalizar';
      icone = FFIcons.kproperty1FiRrCheck;
      cor = tema.success;
      prefixoTempo = null;
      acao = () => _finalizarExercicio(context);
    } else if (descansando) {
      rotulo = 'Continuar';
      icone = FFIcons.kproperty1FiRrPlay;
      // Laranja para o descanso: é o único estado em que a barra pede espera
      // em vez de esforço, e a cor diz isso antes da palavra. É o `secondary`
      // do tema — o `warning` é mostarda, e não a laranja da marca.
      cor = tema.secondary;
      prefixoTempo = 'descanso';
      acao = _continuarAposDescanso;
    } else {
      rotulo = 'Concluir série';
      icone = FFIcons.kproperty1FiRrCheck;
      cor = tema.primary;
      prefixoTempo = null;
      acao = () => _concluirSerie(context);
    }

    // Sem tempo antes de começar, porque o cronômetro está zerado e mostrá-lo
    // daria a impressão de que já está correndo — e sem tempo no "Finalizar",
    // porque ali o trabalho acabou: o número seguir subindo sugeria que ainda
    // havia algo em curso, quando o que falta é só encerrar.
    final mostraTempo = emAndamento && !ultimaSerieFeita;

    final secundarias = <Widget>[
      // Depois da última série ainda dá para fazer mais uma; a pílula virou
      // "Finalizar", então esta ação precisava de um lugar para continuar
      // existindo.
      if (emAndamento && !descansando && ultimaSerieFeita)
        _AcaoSecundaria(
          // Um "mais", e não outro visto: com o visto ficavam dois iguais
          // lado a lado, e o pequeno parecia um Finalizar menor.
          icone: Icons.add_rounded,
          rotuloCurto: 'Série',
          rotuloSemantico: 'Concluir mais uma série',
          onTap: () => _concluirSerie(context),
        ),
      // Durante o descanso também: desistir do exercício é justamente o que
      // se decide na pausa, e ali o botão sumia. Mas não depois da última
      // série — pular o que já foi feito não quer dizer nada, e ali a única
      // saída é finalizar.
      if (emAndamento && !ultimaSerieFeita)
        _AcaoSecundaria(
          // Nem shuffle (que sugeria reordenar) nem skip de faixa (que
          // parecia controle de música): a seta atravessando é a de "seguir
          // adiante sem este".
          icone: Icons.redo_rounded,
          rotuloCurto: 'Pular',
          rotuloSemantico: 'Pular exercício',
          onTap: () => _pularExercicio(context),
        ),
    ];

    final barra = Container(
      decoration: BoxDecoration(
        // Mesma receita da navbar: translúcida com desfoque no iPhone, sólida
        // nas outras plataformas, onde sem o BackdropFilter a transparência
        // só mostraria o fundo cru.
        color: isiOS
            ? tema.primaryBackground.withValues(alpha: 0.58)
            : tema.primaryBackground,
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: tema.primaryText.withValues(alpha: 0.06),
          width: 1.0,
        ),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
      // Centralizado e do tamanho do que carrega, como as abas da navbar: a
      // pílula esticada de ponta a ponta virava um botão de barra comum, e a
      // largura fixa fazia "Iniciar" ocupar o mesmo espaço de "Concluir
      // série" — o tamanho deixava de dizer qualquer coisa.
      child: Row(
        // `min`: a cápsula branca acompanha o que carrega, como a da navbar.
        // Com `max` ela ia de borda a borda e voltava a parecer uma barra de
        // rodapé, que é o desenho de que a pílula estava fugindo.
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final s in secundarias) ...[s, const SizedBox(width: 4.0)],
          Flexible(
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(999.0),
              onTap: () async => await acao(),
              child: AnimatedContainer(
                // A chave existe para a comemoração saber de onde nascer: é
                // deste retângulo que se lê o centro na tela.
                key: _chaveAcao,
                duration: const Duration(milliseconds: 380),
                // easeOutBack passa um pouco do alvo e volta — é o que dá à
                // pílula a sensação de assentar, igual à da navbar.
                curve: Curves.easeOutBack,
                height: 44.0,
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 22.0, 0.0),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(999.0),
                ),
                // Sem `alignment`: um Container com alinhamento estica para
                // ocupar toda a restricao que recebe, e era isso que fazia a
                // pilula continuar de ponta a ponta mesmo depois de tirar o
                // Expanded. O Row de dentro ja se centra sozinho.
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icone, color: Colors.white, size: 16.0),
                    const SizedBox(width: 8.0),
                    // O rótulo troca com fade: sem isso a palavra mudava de
                    // estalo no meio da pílula que ainda estava animando.
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: Text(
                        rotulo,
                        key: ValueKey(rotulo),
                        style: tema.titleSmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          color: Colors.white,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // O separador e o prefixo só existem junto com o tempo.
                    //
                    // O bloco é sempre construído, mesmo sem tempo à mostra:
                    // os dois cronômetros vivem aqui dentro e precisam ficar
                    // montados. Quem some são os textos; os cronômetros ficam
                    // fora de cena, ocupando zero.
                    ClipRect(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 380),
                        curve: Curves.easeOutCubic,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              mostraTempo ? 8.0 : 0.0, 0.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (mostraTempo) ...[
                                Text(
                                  prefixoTempo == null
                                      ? '·'
                                      : '· $prefixoTempo',
                                  style: tema.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500),
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                              ],
                              _cronometro(context,
                                  descanso: false, mostrar: mostraTempo),
                              _cronometro(context,
                                  descanso: true, mostrar: mostraTempo),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // fim da pílula
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      // Flutua como a navbar: respira nas laterais e fica acima do indicador
      // do iPhone em vez de encostar na borda.
      padding: EdgeInsetsDirectional.fromSTEB(
        16.0,
        8.0,
        16.0,
        MediaQuery.paddingOf(context).bottom + 10.0,
      ),
      // O Align e o que mantem a capsula centrada agora que ela nao ocupa a
      // largura toda — sem ele o alinhamento dependeria de quem a contem.
      child: Align(
        alignment: const AlignmentDirectional(0.0, 1.0),
        child: Material(
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999.0),
            child: isiOS
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                    child: barra,
                  )
                : barra,
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['barraOnPageLoadAnimation']!);
  }
}

/// Cartão do vídeo do exercício, abaixo do cartão de peso.
///
/// Era uma faixa cinza colada na base do cartão de peso, com a marca do
/// YouTube fixa — herança de quando todo vídeo vinha de lá. Agora o vídeo
/// também mora no bucket da plataforma, então a origem decide o que aparece:
/// o vídeo do personal ganha a prévia do próprio quadro, e o link antigo
/// continua com a marca do YouTube e nada mais, porque miniatura de lá é
/// carregada de fora.
///
/// Cartão solto, e não faixa acoplada: sem vídeo ele simplesmente não existe,
/// e o cartão de peso termina fechado nos quatro cantos em vez de ficar com a
/// base reta esperando por algo que não vem.
class _CardVideoExercicio extends StatelessWidget {
  const _CardVideoExercicio();

  /// Mesmo respiro lateral dos outros cartões da tela.
  double _lateral(BuildContext context) =>
      MediaQuery.sizeOf(context).width < kBreakpointMedium ? 16.0 : 32.0;

  /// Vídeo da plataforma abre em tela cheia, no mesmo reels da grade do
  /// personal: é vídeo vertical de demonstração, e dentro da folha ele ficava
  /// do tamanho de um selo, com metade da tela ocupada por cabeçalho e
  /// moldura. O link do YouTube continua na folha, porque lá quem desenha o
  /// player é a view nativa deles.
  Future<void> _abrir(BuildContext context,
      {required bool daPlataforma}) async {
    if (daPlataforma) {
      await mostrarVideoEmTelaCheia(
        context,
        url: FFAppState().exercicioTemp.linkInstrucao,
        // Parado, esperando o play: o toque pode ter sido sem querer no meio
        // de uma série.
        autoPlay: false,
      );
      return;
    }

    await showModalBottomSheet(
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
            child: VideoplayWidget(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final exercicio = FFAppState().exercicioTemp;
    final url = exercicio.linkInstrucao;
    if (url.isEmpty) return const SizedBox.shrink();

    final daPlataforma = ehVideoDaPlataforma(url);
    final lateral = _lateral(context);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(lateral, 12.0, lateral, 0.0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => _abrir(context, daPlataforma: daPlataforma),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              // Branco com sombra, igual ao cartão de peso logo acima: são
              // dois cartões irmãos, e o azul fazia este parecer um aviso.
              // O cinza fixo `0xFFDDDDDD` de antes era a única cor escrita à
              // mão na tela, sem seguir o tema em lugar nenhum.
              color: tema.primaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [tema.designToken.shadow.lg],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (daPlataforma) _previa(context, exercicio, url),
                _linha(context, tema, daPlataforma),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Quadro parado do vídeo, ocupando a largura do cartão.
  ///
  /// A capa gerada no envio (`ThumbUrl`) entra como imagem comum e vai para o
  /// cache; sem ela — exercício enviado antes da capa existir — o próprio
  /// `video_player` pinta o primeiro quadro, que custa um controlador vivo.
  /// É um por tela aqui, não uma lista.
  Widget _previa(
    BuildContext context,
    ExerciciosStruct exercicio,
    String url,
  ) {
    final capa = exercicio.thumbUrl;
    final segundo = exercicio.thumbSegundo > 0 ? exercicio.thumbSegundo : null;

    final quadro = capa.isNotEmpty
        ? Image(
            image: CachedNetworkImageProvider(capa),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                CapaVideoPlataforma(url: url, segundo: segundo),
          )
        : CapaVideoPlataforma(url: url, segundo: segundo);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: SizedBox(
        height: 190.0,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            quadro,
            // O play é branco e o quadro pode ser claro: sem o escurecido no
            // centro ele sumia em vídeo gravado contra parede branca.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 54.0,
                height: 54.0,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A linha de sempre — só o ícone muda com a origem do vídeo.
  Widget _linha(
      BuildContext context, FlutterFlowTheme tema, bool daPlataforma) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (daPlataforma)
            Icon(
              Icons.play_circle_fill_rounded,
              color: tema.primary,
              size: 16.0,
            )
          else
            FaIcon(
              FontAwesomeIcons.youtube,
              color: tema.error,
              size: 14.0,
            ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Dúvidas neste exercício?',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            daPlataforma ? 'Ver o vídeo' : 'Assista ao tutorial',
            style: tema.titleSmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: tema.primary,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: tema.primary,
            size: 18.0,
          ),
        ],
      ),
    );
  }
}

/// Ação secundária da barra: só o ícone, sem fundo.
///
/// É o mesmo par da navbar — a ação do momento é a pílula cheia, e o que
/// existe mas não é o próximo passo fica em ícone. Sem rótulo visível, mas
/// com rótulo semântico: quem usa leitor de tela precisa saber o que é.
class _AcaoSecundaria extends StatelessWidget {
  const _AcaoSecundaria({
    required this.icone,
    required this.rotuloCurto,
    required this.rotuloSemantico,
    required this.onTap,
  });

  final IconData icone;

  /// A palavra que aparece ao lado do ícone.
  final String rotuloCurto;
  final String rotuloSemantico;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Semantics(
      button: true,
      label: rotuloSemantico,
      child: Tooltip(
        message: rotuloSemantico,
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(999.0),
          onTap: () async => await onTap(),
          // Com rotulo ao lado do icone: so a seta nao dizia o que ela faz, e
          // "pular" nao e uma acao que se adivinha — quem toca sem saber pode
          // perder o exercicio.
          child: Container(
            height: 44.0,
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 14.0, 0.0),
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icone, color: tema.secondaryText, size: 20.0),
                const SizedBox(width: 6.0),
                Text(
                  rotuloCurto,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: tema.secondaryText,
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
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

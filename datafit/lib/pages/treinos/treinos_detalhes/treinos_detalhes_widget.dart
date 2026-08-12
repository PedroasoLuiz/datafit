import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
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
      if (FFAppState()
              .treinosTemp
              .subagrupamentos
              .where((e) => e.status == 'em_andamento')
              .toList()
              .length ==
          0) {
        if (animationsMap['containerOnActionTriggerAnimation1'] != null) {
          safeSetState(() => hasContainerTriggered1 = true);
          SchedulerBinding.instance.addPostFrameCallback((_) async =>
              await animationsMap['containerOnActionTriggerAnimation1']!
                  .controller
                  .forward(from: 0.0));
        }
      } else {
        if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
          safeSetState(() => hasContainerTriggered2 = true);
          SchedulerBinding.instance.addPostFrameCallback((_) async =>
              await animationsMap['containerOnActionTriggerAnimation2']!
                  .controller
                  .forward(from: 0.0));
        }
      }
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
                                                child: Container(
                                                  width: 36.0,
                                                  height: 36.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      Icons
                                                          .navigate_before_rounded,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
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
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    valueOrDefault<String>(
                                      FFAppState()
                                          .treinosTemp
                                          .subagrupamentos
                                          .elementAtOrNull(_model.index)
                                          ?.nome,
                                      '-',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (_model.index == 0) {
                                                _model.index =
                                                    valueOrDefault<int>(
                                                  FFAppState()
                                                          .treinosTemp
                                                          .subagrupamentos
                                                          .length -
                                                      1,
                                                  0,
                                                );
                                                safeSetState(() {});
                                              } else {
                                                _model.index =
                                                    _model.index + -1;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {
                                                _model.txtFeedbackTextController
                                                        ?.text =
                                                    FFAppState()
                                                        .treinosTemp
                                                        .subagrupamentos
                                                        .elementAtOrNull(
                                                            _model.index)!
                                                        .feedback;
                                              });
                                            },
                                            child: Container(
                                              width: 32.0,
                                              height: 32.0,
                                              decoration: BoxDecoration(),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  FFIcons
                                                      .kproperty1FiRrAngleSmallLeft,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 18.0,
                                                ).animateOnActionTrigger(
                                                  animationsMap[
                                                      'iconOnActionTriggerAnimation1']!,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 26.0,
                                            child: VerticalDivider(
                                              width: 24.0,
                                              thickness: 1.0,
                                              indent: 5.0,
                                              endIndent: 5.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (_model.index >=
                                                  valueOrDefault<int>(
                                                    FFAppState()
                                                            .treinosTemp
                                                            .subagrupamentos
                                                            .length -
                                                        1,
                                                    0,
                                                  )) {
                                                _model.index = 0;
                                                safeSetState(() {});
                                              } else {
                                                _model.index = _model.index + 1;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {
                                                _model.txtFeedbackTextController
                                                        ?.text =
                                                    FFAppState()
                                                        .treinosTemp
                                                        .subagrupamentos
                                                        .elementAtOrNull(
                                                            _model.index)!
                                                        .feedback;
                                              });
                                            },
                                            child: Container(
                                              width: 32.0,
                                              height: 32.0,
                                              decoration: BoxDecoration(),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  FFIcons
                                                      .kproperty1FiRrAngleSmallRight,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 18.0,
                                                ).animateOnActionTrigger(
                                                  animationsMap[
                                                      'iconOnActionTriggerAnimation2']!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                    ),
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
                                          Builder(
                                            builder: (context) {
                                              final subGrupos = FFAppState()
                                                      .treinosTemp
                                                      .subagrupamentos
                                                      .elementAtOrNull(
                                                          _model.index)
                                                      ?.grupos
                                                      ?.map((e) => e)
                                                      .toList()
                                                      ?.toList() ??
                                                  [];

                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                    subGrupos.length,
                                                    (subGruposIndex) {
                                                  final subGruposItem =
                                                      subGrupos[subGruposIndex];
                                                  return Container(
                                                    decoration: BoxDecoration(
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
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      16.0,
                                                                      16.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        0.0),
                                                                child: Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    subGruposItem
                                                                        .subcategoria,
                                                                    '-',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Builder(
                                                          builder: (context) {
                                                            final exercicios =
                                                                subGruposItem
                                                                    .exercicios
                                                                    .map((e) =>
                                                                        e)
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
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                              child: Icon(
                                                                                                Icons.check_circle,
                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                size: 20.0,
                                                                                              ),
                                                                                            ),
                                                                                          if (!exerciciosItem.isConcluido && !exerciciosItem.isPulado)
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                              child: Container(
                                                                                                height: 20.0,
                                                                                                constraints: BoxConstraints(
                                                                                                  minWidth: 20.0,
                                                                                                ),
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(30.0),
                                                                                                  shape: BoxShape.rectangle,
                                                                                                  border: Border.all(
                                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                    width: 2.1,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Align(
                                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                                                                                                    child: Text(
                                                                                                      valueOrDefault<String>(
                                                                                                        (exerciciosIndex + 1).toString(),
                                                                                                        '0',
                                                                                                      ),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            font: GoogleFonts.inter(
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                            fontSize: 11.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          if (exerciciosItem.isPulado)
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                              child: Icon(
                                                                                                Icons.snooze_rounded,
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                size: 20.0,
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
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Container(
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
                                                                                                        '${exerciciosItem.series.toString()} x ${exerciciosItem.repeticoes.toString()}',
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
                                                                                                        'Descanso ${exerciciosItem.tempoDescansoSeg.toString()}s',
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
                                                                                            ].divide(SizedBox(width: 6.0)),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      if ((FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.status == 'em_andamento') && !exerciciosItem.isConcluido)
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                          child: InkWell(
                                                                                            splashColor: Colors.transparent,
                                                                                            focusColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            highlightColor: Colors.transparent,
                                                                                            onTap: () async {
                                                                                              final String? nomeSubstituto = await showModalBottomSheet<String>(
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
                                                                                                  FFIcons.kproperty1FiRrRefresh,
                                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                                  size: 14.0,
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
                                                                                          child: Container(
                                                                                            width: 32.0,
                                                                                            height: 32.0,
                                                                                            decoration: BoxDecoration(
                                                                                              color: valueOrDefault<Color>(
                                                                                                (FFAppState().exercicioEmAndamento == true ? (FFAppState().exercicioTemp.execucaoId == exerciciosItem.execucaoId) : true) ? FlutterFlowTheme.of(context).accent1 : FlutterFlowTheme.of(context).alternate,
                                                                                                FlutterFlowTheme.of(context).accent1,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                            ),
                                                                                            child: Align(
                                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                                              child: Icon(
                                                                                                FFIcons.kproperty1FiRrPlay,
                                                                                                color: valueOrDefault<Color>(
                                                                                                  (FFAppState().exercicioEmAndamento ? (FFAppState().exercicioTemp.execucaoId == exerciciosItem.execucaoId) : true) ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                                                                                                  FlutterFlowTheme.of(context).primary,
                                                                                                ),
                                                                                                size: 14.0,
                                                                                              ),
                                                                                            ),
                                                                                          ),
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
                                                                    if (exerciciosIndex !=
                                                                        (subGruposItem.exercicios.length -
                                                                            1))
                                                                      Divider(
                                                                        height:
                                                                            1.0,
                                                                        thickness:
                                                                            1.0,
                                                                        indent:
                                                                            46.0,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                      ),
                                                                  ],
                                                                );
                                                              }),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).divide(
                                                    SizedBox(height: 16.0)),
                                              );
                                            },
                                          ),
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
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16.0,
                                                                16.0,
                                                                16.0,
                                                                0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Text(
                                                            'Cárdio',
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
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      14.0,
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
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 16.0),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final cardios = FFAppState()
                                                                .treinosTemp
                                                                .subagrupamentos
                                                                .elementAtOrNull(
                                                                    _model
                                                                        .index)
                                                                ?.cardios
                                                                ?.map((e) => e)
                                                                .toList()
                                                                ?.toList() ??
                                                            [];

                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
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
                                                                  child: Column(
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
                                                                                    color: FlutterFlowTheme.of(context).primary,
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
                                                                          FFAppState()
                                                                              .treinosTemp
                                                                              .subagrupamentos
                                                                              .elementAtOrNull(_model.index)
                                                                              ?.cardios
                                                                              ?.length,
                                                                          0,
                                                                        ) -
                                                                        1))
                                                                  Divider(
                                                                    height: 1.0,
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
                                                  if (FFAppState()
                                                          .treinosTemp
                                                          .subagrupamentos
                                                          .elementAtOrNull(
                                                              _model.index)
                                                          ?.status ==
                                                      'em_andamento')
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  16.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1.0,
                                                        height: 38.0,
                                                        child: custom_widgets
                                                            .DashedButton(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  1.0,
                                                          height: 38.0,
                                                          label:
                                                              'Adicionar exercício',
                                                          labelSize: 14.0,
                                                          labelColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                          icon: Icon(
                                                            Icons.add,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            size: 18.0,
                                                          ),
                                                          iconColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                          iconGap: 4.0,
                                                          borderColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                          borderRadius: 10.0,
                                                          borderWidth: 1.0,
                                                          dashWidth: 4.0,
                                                          dashGap: 4.0,
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
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
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                enableDrag:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return WebViewAware(
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            MediaQuery.viewInsetsOf(context),
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
                                                                            safeSetState(() {});
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
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 16.0)),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      if (FFAppState()
                                              .treinosTemp
                                              .subagrupamentos
                                              .elementAtOrNull(_model.index)
                                              ?.status ==
                                          'em_andamento')
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  valueOrDefault<double>(
                                                    () {
                                                      if (MediaQuery.sizeOf(
                                                                  context)
                                                              .width <
                                                          kBreakpointSmall) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width <
                                                          kBreakpointMedium) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
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
                                                      if (MediaQuery.sizeOf(
                                                                  context)
                                                              .width <
                                                          kBreakpointSmall) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width <
                                                          kBreakpointMedium) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
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
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            decoration: BoxDecoration(),
                                            child: Text(
                                              'Feedback',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      if (FFAppState()
                                              .treinosTemp
                                              .subagrupamentos
                                              .elementAtOrNull(_model.index)
                                              ?.status ==
                                          'em_andamento')
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  valueOrDefault<double>(
                                                    () {
                                                      if (MediaQuery.sizeOf(
                                                                  context)
                                                              .width <
                                                          kBreakpointSmall) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width <
                                                          kBreakpointMedium) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
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
                                                      if (MediaQuery.sizeOf(
                                                                  context)
                                                              .width <
                                                          kBreakpointSmall) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width <
                                                          kBreakpointMedium) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
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
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                FlutterFlowTheme.of(context)
                                                    .designToken
                                                    .shadow
                                                    .lg
                                              ],
                                            ),
                                            child: Container(
                                              width: 200.0,
                                              child: TextFormField(
                                                controller: _model
                                                    .txtFeedbackTextController,
                                                focusNode:
                                                    _model.txtFeedbackFocusNode,
                                                onFieldSubmitted: (_) async {
                                                  _model.reultFeedback =
                                                      await AlunoGroup
                                                          .salvarFeedbackCall
                                                          .call(
                                                    pAlunoUuid: currentUserUid,
                                                    pTreinoExecucaoId:
                                                        FFAppState()
                                                            .treinosTemp
                                                            .subagrupamentos
                                                            .elementAtOrNull(
                                                                _model.index)
                                                            ?.treinoExecucaoId,
                                                    pFeedback: _model
                                                        .txtFeedbackTextController
                                                        .text
                                                        .trim(),
                                                  );

                                                  if ((_model.reultFeedback
                                                          ?.succeeded ??
                                                      true)) {
                                                    FFAppState()
                                                        .updateTreinosTempStruct(
                                                      (e) => e
                                                        ..updateSubagrupamentos(
                                                          (e) => e[_model.index]
                                                            ..feedback = _model
                                                                .txtFeedbackTextController
                                                                .text
                                                                .trim(),
                                                        ),
                                                    );
                                                    safeSetState(() {});
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
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
                                                            child: Padding(
                                                              padding: MediaQuery
                                                                  .viewInsetsOf(
                                                                      context),
                                                              child:
                                                                  MensagemWidget(
                                                                texto:
                                                                    'Feedback salvo com sucesso!',
                                                                tipo: '1',
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
                                                        safeSetState(() {}));
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return WebViewAware(
                                                          child: AlertDialog(
                                                            content: Text((_model
                                                                        .reultFeedback
                                                                        ?.jsonBody ??
                                                                    '')
                                                                .toString()),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }

                                                  safeSetState(() {});
                                                },
                                                autofocus: false,
                                                enabled: true,
                                                textInputAction:
                                                    TextInputAction.go,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .labelMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                  hintText:
                                                      'Deixe seu feedback sobre este treino....',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .labelMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  contentPadding:
                                                      EdgeInsets.all(16.0),
                                                ),
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
                                                              .primaryText,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                maxLines: 5,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                enableInteractiveSelection:
                                                    true,
                                                validator: _model
                                                    .txtFeedbackTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ]
                                        .divide(SizedBox(height: 16.0))
                                        .addToEnd(SizedBox(height: 140.0)),
                                  ),
                                ),
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
                            if ((FFAppState()
                                        .treinosTemp
                                        .subagrupamentos
                                        .where(
                                            (e) => e.status == 'em_andamento')
                                        .toList()
                                        .length ==
                                    0) &&
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
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .accent1,
                                            text: 'Desliza para iniciar',
                                            thumbColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            onConfirm: () async {
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
                                                await showModalBottomSheet(
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
                                                await showModalBottomSheet(
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
                                                                'O sistema reportou o seguinte erro: ${(_model.apiResult7ye?.jsonBody ?? '').toString()}. Deseja tentar novamente?',
                                                            tipo: '2',
                                                            fechasozinho: false,
                                                            mostrabotoes: true,
                                                            action: () async {
                                                              _model.subserult =
                                                                  await AlunoGroup
                                                                      .iniciarTreinoCall
                                                                      .call(
                                                                pAlunoUuid:
                                                                    currentUserUid,
                                                                pTreinoExecucao:
                                                                    valueOrDefault<
                                                                        int>(
                                                                  FFAppState()
                                                                      .treinosTemp
                                                                      .subagrupamentos
                                                                      .elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.treinoExecucaoId,
                                                                  0,
                                                                ),
                                                              );

                                                              if ((_model
                                                                      .subserult
                                                                      ?.succeeded ??
                                                                  true)) {
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return WebViewAware(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              MensagemWidget(
                                                                            texto:
                                                                                'Treino iniciado com sucesso!',
                                                                            tipo:
                                                                                '1',
                                                                            fechasozinho:
                                                                                true,
                                                                            mostrabotoes:
                                                                                false,
                                                                            action:
                                                                                () async {
                                                                              safeSetState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              } else {
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return WebViewAware(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              MensagemWidget(
                                                                            texto:
                                                                                'O sistema reportou o seguinte erro: ${(_model.subserult?.jsonBody ?? '').toString()}. Deseja tentar novamente?',
                                                                            tipo:
                                                                                '2',
                                                                            fechasozinho:
                                                                                false,
                                                                            mostrabotoes:
                                                                                true,
                                                                            action:
                                                                                () async {
                                                                              _model.subResult = await AlunoGroup.iniciarTreinoCall.call(
                                                                                pAlunoUuid: currentUserUid,
                                                                                pTreinoExecucao: valueOrDefault<int>(
                                                                                  FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.treinoExecucaoId,
                                                                                  0,
                                                                                ),
                                                                              );

                                                                              if ((_model.subResult?.succeeded ?? true)) {
                                                                                await showModalBottomSheet(
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
                                                                                            texto: 'Treino iniciado com sucesso!',
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
                                                                              } else {
                                                                                await showModalBottomSheet(
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
                                                                                            texto: 'O sistema reportou o seguinte erro: ${(_model.subResult?.jsonBody ?? '').toString()}. Deseja tentar novamente?',
                                                                                            tipo: '2',
                                                                                            fechasozinho: false,
                                                                                            mostrabotoes: true,
                                                                                            action: () async {
                                                                                              _model.apiResult7yeCopy = await AlunoGroup.iniciarTreinoCall.call(
                                                                                                pAlunoUuid: currentUserUid,
                                                                                                pTreinoExecucao: valueOrDefault<int>(
                                                                                                  FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.treinoExecucaoId,
                                                                                                  0,
                                                                                                ),
                                                                                              );

                                                                                              if ((_model.apiResult7yeCopy?.succeeded ?? true)) {
                                                                                                await showModalBottomSheet(
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
                                                                                                            texto: 'Treino iniciado com sucesso!',
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
                                                                                              } else {
                                                                                                await showModalBottomSheet(
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
                                                                                                            texto: 'O sistema reportou o seguinte erro: ${(_model.apiResult7yeCopy?.jsonBody ?? '').toString()}. Deseja tentar novamente?',
                                                                                                            tipo: '2',
                                                                                                            fechasozinho: false,
                                                                                                            mostrabotoes: true,
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
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ).then((value) => safeSetState(() {}));
                                                                              }
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
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
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
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 100.0,
                                          child: custom_widgets.SlideToConfirm(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            height: 100.0,
                                            backgroundColor: Color(0xFFC8F4E8),
                                            text:
                                                'Deslize para concluir esse treino',
                                            thumbColor:
                                                FlutterFlowTheme.of(context)
                                                    .success,
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            onConfirm: () async {
                                              _model.resultEnd =
                                                  await AlunoGroup
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

                                              if ((_model
                                                      .resultEnd?.succeeded ??
                                                  true)) {
                                                await action_blocks
                                                    .getTreinosAluno(context);
                                                safeSetState(() {});
                                                await showModalBottomSheet(
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
                                                                'Treino concluído com sucesso!',
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
                                                await showModalBottomSheet(
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
                                                                'O sistema reportou o seguinte erro: ${(_model.resultEnd?.jsonBody ?? '').toString()}. Deseja tentar novamente?',
                                                            tipo: '2',
                                                            fechasozinho: false,
                                                            mostrabotoes: true,
                                                            action: () async {
                                                              _model.subResult2 =
                                                                  await AlunoGroup
                                                                      .iniciarTreinoCall
                                                                      .call(
                                                                pAlunoUuid:
                                                                    currentUserUid,
                                                                pTreinoExecucao:
                                                                    valueOrDefault<
                                                                        int>(
                                                                  FFAppState()
                                                                      .treinosTemp
                                                                      .subagrupamentos
                                                                      .elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.treinoExecucaoId,
                                                                  0,
                                                                ),
                                                              );

                                                              if ((_model
                                                                      .subResult2
                                                                      ?.succeeded ??
                                                                  true)) {
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return WebViewAware(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              MensagemWidget(
                                                                            texto:
                                                                                'Treino iniciado com sucesso!',
                                                                            tipo:
                                                                                '1',
                                                                            fechasozinho:
                                                                                true,
                                                                            mostrabotoes:
                                                                                false,
                                                                            action:
                                                                                () async {
                                                                              safeSetState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              } else {
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return WebViewAware(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              MensagemWidget(
                                                                            texto:
                                                                                'O sistema reportou o seguinte erro: ${(_model.subResult2?.jsonBody ?? '').toString()}. Deseja tentar novamente?',
                                                                            tipo:
                                                                                '2',
                                                                            fechasozinho:
                                                                                false,
                                                                            mostrabotoes:
                                                                                true,
                                                                            action:
                                                                                () async {
                                                                              _model.apiResult7yeCopy2 = await AlunoGroup.iniciarTreinoCall.call(
                                                                                pAlunoUuid: currentUserUid,
                                                                                pTreinoExecucao: valueOrDefault<int>(
                                                                                  FFAppState().treinosTemp.subagrupamentos.elementAtOrNull(_model.index)?.treinoExecucaoId,
                                                                                  0,
                                                                                ),
                                                                              );

                                                                              if ((_model.apiResult7yeCopy2?.succeeded ?? true)) {
                                                                                await showModalBottomSheet(
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
                                                                                            texto: 'Treino iniciado com sucesso!',
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
                                                                              } else {
                                                                                await showModalBottomSheet(
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
                                                                                            texto: 'O sistema reportou o seguinte erro: ${(_model.apiResult7yeCopy2?.jsonBody ?? '').toString()}. Deseja tentar novamente?',
                                                                                            tipo: '2',
                                                                                            fechasozinho: false,
                                                                                            mostrabotoes: true,
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
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
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

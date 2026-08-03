import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'perfil_aluno_status_model.dart';
export 'perfil_aluno_status_model.dart';

class PerfilAlunoStatusWidget extends StatefulWidget {
  const PerfilAlunoStatusWidget({super.key});

  @override
  State<PerfilAlunoStatusWidget> createState() =>
      _PerfilAlunoStatusWidgetState();
}

class _PerfilAlunoStatusWidgetState extends State<PerfilAlunoStatusWidget>
    with TickerProviderStateMixin {
  late PerfilAlunoStatusModel _model;

  var hasContainerTriggered = false;
  var hasIconButtonTriggered1 = false;
  var hasIconButtonTriggered2 = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilAlunoStatusModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if (animationsMap['containerOnActionTriggerAnimation'] != null) {
            safeSetState(() => hasContainerTriggered = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['containerOnActionTriggerAnimation']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
        Future(() async {
          if (animationsMap['iconButtonOnActionTriggerAnimation2'] != null) {
            safeSetState(() => hasIconButtonTriggered2 = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['iconButtonOnActionTriggerAnimation2']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
        Future(() async {
          if (animationsMap['iconButtonOnActionTriggerAnimation1'] != null) {
            safeSetState(() => hasIconButtonTriggered1 = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['iconButtonOnActionTriggerAnimation1']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
      ]);
    });

    _model.switchValue = FFAppState().alunotemp.ativo;
    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOutQuint,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(-5.0, -5.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconButtonOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 650.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 650.0.ms,
            duration: 600.0.ms,
            begin: Offset(-40.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'iconButtonOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          RotateEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: -0.25,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, -100.0),
            end: Offset(0.0, 0.0),
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
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    context.watch<cupertino_time_picker_hiuzb7_app_state.FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SingleChildScrollView(
                controller: _model.columnController,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent1,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                'Edição',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                            Icon(
                              FFIcons.kproperty1FiRrSettings,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 18.0,
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              'Status do aluno',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Switch.adaptive(
                            value: _model.switchValue!,
                            onChanged: (newValue) async {
                              safeSetState(
                                  () => _model.switchValue = newValue!);
                              if (newValue!) {
                                _model.result1 =
                                    await PersonalGroup.statusAlunoCall.call(
                                  uuidPersonal: currentUserUid,
                                  uuidAluno: FFAppState().alunotemp.alunoUuid,
                                );

                                if ((_model.result1?.succeeded ?? true)) {
                                  await action_blocks.getPerfilAluno(
                                    context,
                                    alunoId: FFAppState().alunotemp.alunoUuid,
                                  );
                                  safeSetState(() {});
                                  await action_blocks.alunosdopersonal(
                                    context,
                                    uuidpersonal: currentUserUid,
                                  );
                                  safeSetState(() {});
                                  await Future.wait([
                                    Future(() async {
                                      if (animationsMap[
                                              'containerOnActionTriggerAnimation'] !=
                                          null) {
                                        await animationsMap[
                                                'containerOnActionTriggerAnimation']!
                                            .controller
                                            .reverse();
                                      }
                                    }),
                                    Future(() async {
                                      if (animationsMap[
                                              'iconButtonOnActionTriggerAnimation2'] !=
                                          null) {
                                        await animationsMap[
                                                'iconButtonOnActionTriggerAnimation2']!
                                            .controller
                                            .reverse();
                                      }
                                    }),
                                  ]);
                                  Navigator.pop(context);
                                }

                                safeSetState(() {});
                              } else {
                                _model.result1Copy =
                                    await PersonalGroup.statusAlunoCall.call(
                                  uuidPersonal: currentUserUid,
                                  uuidAluno: FFAppState().alunotemp.alunoUuid,
                                );

                                if ((_model.result1Copy?.succeeded ?? true)) {
                                  await action_blocks.getPerfilAluno(
                                    context,
                                    alunoId: FFAppState().alunotemp.alunoUuid,
                                  );
                                  safeSetState(() {});
                                  await action_blocks.alunosdopersonal(
                                    context,
                                    uuidpersonal: currentUserUid,
                                  );
                                  safeSetState(() {});
                                  await Future.wait([
                                    Future(() async {
                                      if (animationsMap[
                                              'containerOnActionTriggerAnimation'] !=
                                          null) {
                                        await animationsMap[
                                                'containerOnActionTriggerAnimation']!
                                            .controller
                                            .reverse();
                                      }
                                    }),
                                    Future(() async {
                                      if (animationsMap[
                                              'iconButtonOnActionTriggerAnimation2'] !=
                                          null) {
                                        await animationsMap[
                                                'iconButtonOnActionTriggerAnimation2']!
                                            .controller
                                            .reverse();
                                      }
                                    }),
                                  ]);
                                  Navigator.pop(context);
                                }

                                safeSetState(() {});
                              }
                            },
                            activeColor: FlutterFlowTheme.of(context).accent1,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).primary,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).alternate,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ],
                      ),
                    ),
                  ].addToEnd(SizedBox(height: 16.0)),
                ),
              ),
            ),
          ).animateOnActionTrigger(
              animationsMap['containerOnActionTriggerAnimation']!,
              hasBeenTriggered: hasContainerTriggered),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (responsiveVisibility(
              context: context,
              phone: false,
              tablet: false,
              tabletLandscape: false,
            ))
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 20.0,
                  buttonSize: 56.0,
                  fillColor: FlutterFlowTheme.of(context).primary,
                  icon: Icon(
                    Icons.check_rounded,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    await Future.wait([
                      Future(() async {
                        if (animationsMap[
                                'containerOnActionTriggerAnimation'] !=
                            null) {
                          await animationsMap[
                                  'containerOnActionTriggerAnimation']!
                              .controller
                              .reverse();
                        }
                      }),
                      Future(() async {
                        if (animationsMap[
                                'iconButtonOnActionTriggerAnimation1'] !=
                            null) {
                          await animationsMap[
                                  'iconButtonOnActionTriggerAnimation1']!
                              .controller
                              .reverse();
                        }
                      }),
                      Future(() async {
                        if (animationsMap[
                                'iconButtonOnActionTriggerAnimation2'] !=
                            null) {
                          await animationsMap[
                                  'iconButtonOnActionTriggerAnimation2']!
                              .controller
                              .reverse();
                        }
                      }),
                    ]);
                    Navigator.pop(context, true);
                  },
                ).animateOnActionTrigger(
                    animationsMap['iconButtonOnActionTriggerAnimation1']!,
                    hasBeenTriggered: hasIconButtonTriggered1),
              ),
            FlutterFlowIconButton(
              borderRadius: 20.0,
              buttonSize: 56.0,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              icon: Icon(
                FFIcons.kproperty1FiRrCrossSmall,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
              onPressed: () async {
                await Future.wait([
                  Future(() async {
                    if (animationsMap['containerOnActionTriggerAnimation'] !=
                        null) {
                      await animationsMap['containerOnActionTriggerAnimation']!
                          .controller
                          .reverse();
                    }
                  }),
                  Future(() async {
                    if (animationsMap['iconButtonOnActionTriggerAnimation2'] !=
                        null) {
                      await animationsMap[
                              'iconButtonOnActionTriggerAnimation2']!
                          .controller
                          .reverse();
                    }
                  }),
                ]);
                Navigator.pop(context);
              },
            ).animateOnActionTrigger(
                animationsMap['iconButtonOnActionTriggerAnimation2']!,
                hasBeenTriggered: hasIconButtonTriggered2),
          ],
        ),
      ]
          .divide(SizedBox(height: 16.0))
          .addToStart(SizedBox(height: 40.0))
          .addToEnd(SizedBox(height: 40.0)),
    );
  }
}

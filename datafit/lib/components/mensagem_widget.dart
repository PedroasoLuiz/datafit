import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mensagem_model.dart';
export 'mensagem_model.dart';

class MensagemWidget extends StatefulWidget {
  const MensagemWidget({
    super.key,
    required this.texto,
    required this.tipo,
    required this.action,
    bool? fechasozinho,
    bool? mostrabotoes,
    this.textoauxiliar,
  })  : this.fechasozinho = fechasozinho ?? false,
        this.mostrabotoes = mostrabotoes ?? true;

  final String? texto;
  final String? tipo;
  final Future Function()? action;
  final bool fechasozinho;
  final bool mostrabotoes;
  final String? textoauxiliar;

  @override
  State<MensagemWidget> createState() => _MensagemWidgetState();
}

class _MensagemWidgetState extends State<MensagemWidget>
    with TickerProviderStateMixin {
  late MensagemModel _model;

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
    _model = createModel(context, () => MensagemModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if (animationsMap['containerOnActionTriggerAnimation'] != null) {
            await animationsMap['containerOnActionTriggerAnimation']!
                .controller
                .forward(from: 0.0);
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
        Future(() async {
          if (animationsMap['iconButtonOnActionTriggerAnimation2'] != null) {
            safeSetState(() => hasIconButtonTriggered2 = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['iconButtonOnActionTriggerAnimation2']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
      ]);
      if (widget!.fechasozinho) {
        await Future.delayed(
          Duration(
            milliseconds: 3000,
          ),
        );
        await Future.wait([
          Future(() async {
            if (animationsMap['containerOnActionTriggerAnimation'] != null) {
              await animationsMap['containerOnActionTriggerAnimation']!
                  .controller
                  .reverse();
            }
          }),
          Future(() async {
            if (widget!.mostrabotoes) {
              await Future.wait([
                Future(() async {
                  if (animationsMap['iconButtonOnActionTriggerAnimation2'] !=
                      null) {
                    await animationsMap['iconButtonOnActionTriggerAnimation2']!
                        .controller
                        .reverse();
                  }
                }),
                Future(() async {
                  if (animationsMap['iconButtonOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['iconButtonOnActionTriggerAnimation1']!
                        .controller
                        .reverse();
                  }
                }),
              ]);
            }
          }),
        ]);
        Navigator.pop(context);
      }
    });

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
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
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                boxShadow: [FlutterFlowTheme.of(context).designToken.shadow.lg],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    // 16, nao 12: com o icone em circulo o bloco ficou mais
                    // alto e o respiro de 12 encostava o texto na borda.
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // O icone ganha um circulo da propria cor a 12%,
                        // como os selos do resto do app. Solto sobre o branco
                        // ele era um risco fino de 24px ao lado de um bloco
                        // de texto — nao dava tempo de ler se aquilo era
                        // sucesso, erro ou recado antes de ler a frase.
                        Builder(builder: (context) {
                          final tema = FlutterFlowTheme.of(context);
                          final (IconData icone, Color cor) =
                              switch (widget!.tipo) {
                            '1' => (Icons.check_rounded, tema.success),
                            '2' => (Icons.priority_high_rounded, tema.error),
                            _ => (Icons.info_outline_rounded, tema.primary),
                          };
                          return Container(
                            width: 34.0,
                            height: 34.0,
                            decoration: BoxDecoration(
                              color: cor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(icone, color: cor, size: 19.0),
                          );
                        }),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Text(
                              valueOrDefault<String>(
                                widget!.texto,
                                '-',
                              ),
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
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget!.textoauxiliar != null &&
                      widget!.textoauxiliar != '')
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              valueOrDefault<String>(
                                widget!.textoauxiliar,
                                '-',
                              ),
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
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ).animateOnActionTrigger(
              animationsMap['containerOnActionTriggerAnimation']!,
            ),
            if (widget!.mostrabotoes)
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 20.0,
                          buttonSize: 56.0,
                          fillColor: FlutterFlowTheme.of(context).primary,
                          icon: Icon(
                            Icons.check_rounded,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            size: 24.0,
                          ),
                          showLoadingIndicator: true,
                          onPressed: () async {
                            await widget.action?.call();
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
                            animationsMap[
                                'iconButtonOnActionTriggerAnimation1']!,
                            hasBeenTriggered: hasIconButtonTriggered1),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              4.0, 0.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderRadius: 20.0,
                            buttonSize: 56.0,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            icon: Icon(
                              FFIcons.kproperty1FiRrCrossSmall,
                              color: FlutterFlowTheme.of(context).secondaryText,
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
                              Navigator.pop(context);
                            },
                          ).animateOnActionTrigger(
                              animationsMap[
                                  'iconButtonOnActionTriggerAnimation2']!,
                              hasBeenTriggered: hasIconButtonTriggered2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

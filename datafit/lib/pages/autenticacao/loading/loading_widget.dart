import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'loading_model.dart';
export 'loading_model.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  static String routeName = 'loading';
  static String routePath = '/loading';

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late LoadingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          while (_model.initial < 100) {
            _model.initial = _model.initial + 1;
            safeSetState(() {});
            await Future.delayed(
              Duration(
                milliseconds: 10,
              ),
            );
          }
        }),
        Future(() async {
          try {
            await action_blocks.perfil(context);
            safeSetState(() {});
            await Future.wait([
              Future(() async {
                try {
                  await action_blocks.loadingNotifica(context);
                  safeSetState(() {});
                } catch (_) {}
              }),
              Future(() async {
                try {
                  if (FFAppState().perfil.tipoPerfilId == 2) {
                    await action_blocks.metasAluno(context);
                    safeSetState(() {});
                    await action_blocks.getTreinosAluno(context);
                    safeSetState(() {});
                  } else {
                    await Future.wait([
                      Future(() async {
                        try {
                          await action_blocks.alunosdopersonal(
                            context,
                            uuidpersonal: currentUserUid,
                          );
                          safeSetState(() {});
                        } catch (_) {}
                      }),
                      Future(() async {
                        try {
                          await action_blocks.exercicios(
                            context,
                            idpersonal: FFAppState().perfil.tipoPerfilId,
                          );
                          safeSetState(() {});
                        } catch (_) {}
                      }),
                      Future(() async {
                        try {
                          await action_blocks.musculos(context);
                          safeSetState(() {});
                        } catch (_) {}
                      }),
                      Future(() async {
                        try {
                          await action_blocks.pagamentos(
                            context,
                            uuidpersonal: currentUserUid,
                          );
                          safeSetState(() {});
                        } catch (_) {}
                      }),
                    ]);
                  }
                } catch (_) {}
              }),
            ]);
          } catch (_) {}
        }),
      ]);

      if (!mounted) return;

      // Sem perfil o papel vem 0 e a pessoa caía no `else` abaixo, indo parar
      // na lista de alunos do personal. Acontece com quem se cadastra sozinho:
      // nada além do `criar_ou_vincular_aluno` criava o registro em Perfis.
      if (FFAppState().perfil.tipoPerfilId == 0) {
        context.goNamed(EscolherPapelWidget.routeName);
        return;
      }

      // goNamed e nao pushNamed: o Loading nao deve sobrar na pilha, senao o
      // botao voltar na home devolve o usuario para a tela de carregamento.
      if (FFAppState().perfil.tipoPerfilId == 2) {
        context.goNamed(
          TreinosWidget.routeName,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 220),
            ),
          },
        );
      } else {
        context.goNamed(
          AlunoWidget.routeName,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 220),
            ),
          },
        );
      }
    });

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
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        _model.initial.toString(),
                        '0',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            fontSize: 58.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Text(
                      '%',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                'Carregando...',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

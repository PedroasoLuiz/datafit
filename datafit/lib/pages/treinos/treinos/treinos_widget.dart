import '/actions/actions.dart' as action_blocks;
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/acesso_bloqueado_widget.dart';
import '/components/convite_personal_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/navbar/navbar_widget.dart';
import 'dart:convert';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'treinos_model.dart';
export 'treinos_model.dart';

class TreinosWidget extends StatefulWidget {
  const TreinosWidget({super.key});

  static String routeName = 'treinos';
  static String routePath = '/treinos';

  @override
  State<TreinosWidget> createState() => _TreinosWidgetState();
}

class _TreinosWidgetState extends State<TreinosWidget> {
  late TreinosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().treinosTemp = FFAppState().treinosTemp;
      safeSetState(() {});
      await _verificarConvitesEPerfil();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _verificarConvitesEPerfil() async {
    await action_blocks.getConvitesPendentes(context);

    while (FFAppState().convitesPendentes.isNotEmpty) {
      if (!mounted) return;
      final convite = FFAppState().convitesPendentes.first;
      await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        builder: (context) => ConvitePersonalWidget(convite: convite),
      );
    }

    if (!mounted) return;

    final acesso = await action_blocks.verificarAcessoAluno(
      context,
      alunoUuid: currentUserUid,
    );
    if (acesso != null) {
      final temPersonal = acesso['temPersonal'] as bool? ?? false;
      final assinaturaValida = acesso['assinaturaValida'] as bool? ?? true;
      final alunoAtivo = acesso['alunoAtivo'] as bool? ?? true;

      if (!temPersonal) {
        if (!mounted) return;
        // Navigator raiz: dentro do ShellRoute o padrao e o navegador do
        // shell, e a navbar ficaria por cima do aviso.
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) =>
                const AcessoBloqueadoWidget(tipo: TipoBloqueio.semPersonal),
          ),
        );
        return;
      }
      if (!assinaturaValida) {
        if (!mounted) return;
        // Navigator raiz: dentro do ShellRoute o padrao e o navegador do
        // shell, e a navbar ficaria por cima do aviso.
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => const AcessoBloqueadoWidget(
                tipo: TipoBloqueio.assinaturaVencida),
          ),
        );
        return;
      }
      if (!alunoAtivo) {
        if (!mounted) return;
        // Navigator raiz: dentro do ShellRoute o padrao e o navegador do
        // shell, e a navbar ficaria por cima do aviso.
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) =>
                const AcessoBloqueadoWidget(tipo: TipoBloqueio.alunoInativo),
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    final perfil = FFAppState().perfil;
    final perfilIncompleto = !perfil.hasDataNascimento() ||
        !perfil.hasTelefones() ||
        !perfil.hasPesoAtual() ||
        !perfil.hasAltura() ||
        !perfil.hasCpf();
    if (perfilIncompleto) {
      context.goNamed(CompletarPerfilWidget.routeName);
    }
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
          // A navbar reserva o inset inferior por dentro, para o branco
          // dela chegar ate a borda da tela no iPhone.
          bottom: false,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      primary: false,
                      controller: _model.columnController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
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
                                        16.0),
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
                                                    Icons
                                                        .navigate_before_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    size: 20.0,
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
                                                        child: Text(
                                                          'Seus exercícios',
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
                                                                fontSize: 14.0,
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
                                                        FFIcons
                                                            .kproperty1FiRrApple,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
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
                                0.0,
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
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.asset(
                                    'assets/images/Workoutsummary.png',
                                  ).image,
                                ),
                                boxShadow: [
                                  FlutterFlowTheme.of(context)
                                      .designToken
                                      .shadow
                                      .lg
                                ],
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      FFAppState().treinosTemp.nome,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        'Validade: ${valueOrDefault<String>(
                                          dateTimeFormat(
                                            "dd/MM/yyyy",
                                            functions.formataData(FFAppState()
                                                .treinosTemp
                                                .dataValidade),
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          '-',
                                        )}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    // Faixa do personal. O fundo e o chevron
                                    // sao o que faltava: com a foto solta,
                                    // nada indicava que dava para tocar.
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 14.0, 0.0, 0.0),
                                      child: Material(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground
                                            .withValues(alpha: 0.85),
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                          onTap: () async {
                                            _model.result = await AlunoGroup
                                                .getPerfilPersonalCall
                                                .call(
                                              pAlunoUuid: currentUserUid,
                                              pPersonalUuid: FFAppState()
                                                  .treinosTemp
                                                  .personalUuid,
                                            );

                                            if ((_model.result?.succeeded ??
                                                true)) {
                                              context.pushNamed(
                                                PerfilpersonalWidget.routeName,
                                                queryParameters: {
                                                  'perosnal': serializeParam(
                                                    PerfilPersonalStruct
                                                        .maybeFromMap((_model
                                                                .result
                                                                ?.jsonBody ??
                                                            '')),
                                                    ParamType.DataStruct,
                                                  ),
                                                }.withoutNulls,
                                                extra: <String, dynamic>{
                                                  '__transition_info__':
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                    duration: Duration(
                                                        milliseconds: 0),
                                                  ),
                                                },
                                              );
                                            } else {
                                              await showDialog(
                                                useRootNavigator: true,
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return WebViewAware(
                                                    child: AlertDialog(
                                                      content: Text((_model
                                                                  .result
                                                                  ?.jsonBody ??
                                                              '')
                                                          .toString()),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }

                                            safeSetState(() {});
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 8.0, 12.0, 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  child: FFAppState()
                                                              .treinosTemp
                                                              .hasPersonalFotoUrl() &&
                                                          FFAppState()
                                                              .treinosTemp
                                                              .personalFotoUrl
                                                              .isNotEmpty
                                                      ? Image.network(
                                                          FFAppState()
                                                              .treinosTemp
                                                              .personalFotoUrl,
                                                          width: 38.0,
                                                          height: 38.0,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                            'assets/images/Profile_Image.png',
                                                            width: 38.0,
                                                            height: 38.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          'assets/images/Profile_Image.png',
                                                          width: 38.0,
                                                          height: 38.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 8.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Seu personal',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              fontSize: 10.5,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                      Text(
                                                        FFAppState()
                                                                .treinosTemp
                                                                .personalNome
                                                                .isNotEmpty
                                                            ? FFAppState()
                                                                .treinosTemp
                                                                .personalNome
                                                            : 'Ver perfil',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              fontSize: 13.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
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
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView(
                                // O baralho tem sombra e cartas assomando dos
                                // lados; encostado no card do personal os dois
                                // blocos se liam como um so.
                                padding: const EdgeInsets.only(top: 16.0),
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
                                      // Sem fundo: o card branco agora e de
                                      // cada item, nao do conjunto.
                                      decoration: BoxDecoration(),
                                      child: Builder(
                                        builder: (context) {
                                          final treinos = FFAppState()
                                              .treinosTemp
                                              .subagrupamentos
                                              .map((e) => e)
                                              .toList()
                                              .sortedList(
                                                  keyOf: (e) => e.ordem,
                                                  desc: false)
                                              .toList();

                                          return _CarrosselLeque(
                                            quantidade: treinos.length,
                                            construir: (context, treinosIndex) {
                                              final treinosItem =
                                                  treinos[treinosIndex];
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  boxShadow: [
                                                    FlutterFlowTheme.of(context)
                                                        .designToken
                                                        .shadow
                                                        .lg
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    onTap: () async {
                                                      context.pushNamed(
                                                        TreinosDetalhesWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'indexGrupo':
                                                              serializeParam(
                                                            treinosIndex,
                                                            ParamType.int,
                                                          ),
                                                        }.withoutNulls,
                                                        extra: <String,
                                                            dynamic>{
                                                          '__transition_info__':
                                                              TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType:
                                                                PageTransitionType
                                                                    .fade,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    0),
                                                          ),
                                                        },
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child:
                                                          _ConteudoCardTreino(
                                                        treino: treinosItem,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 32.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'DATAFITⓒ 2026',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Versão 1.0.1',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ].addToEnd(SizedBox(height: 120.0)),
                      ),
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
}

/// Baralho dos treinos do dia.
///
/// A versao anterior era um leque: os vizinhos ficavam ao lado, inclinados.
/// Aqui eles ficam ATRAS do card da frente, com as pontas assomando dos dois
/// lados, como uma pilha de cartas.
///
/// Arrastar para qualquer um dos lados manda a carta da frente para o fim da
/// pilha. Nao existe descartar: e uma fila circular, entao a mesma carta
/// sempre volta depois de dar a volta.
class _CarrosselLeque extends StatefulWidget {
  const _CarrosselLeque({
    required this.quantidade,
    required this.construir,
  });

  final int quantidade;
  final Widget Function(BuildContext, int) construir;

  @override
  State<_CarrosselLeque> createState() => _CarrosselLequeState();
}

class _CarrosselLequeState extends State<_CarrosselLeque>
    with SingleTickerProviderStateMixin {
  static const double _altura = 250.0;

  /// Quanto cada carta de tras assoma para o lado, e quanto ela encolhe.
  static const double _passoLateral = 26.0;
  static const double _passoEscala = 0.06;

  /// Giro das cartas de tras, em radianos (~8 graus). A da esquerda gira para
  /// um lado e a da direita para o outro, abrindo o leque.
  ///
  /// Comecou em 30 graus e ficou deitado demais: a carta de tras virava um
  /// losango e competia com a da frente em vez de so sugerir profundidade.
  static const double _giroFundo = 0.14;

  /// A carta da frente nao ocupa a largura toda: e a sobra que deixa as
  /// pontas das de tras aparecerem sem precisar empurra-las para fora.
  static const double _larguraFrente = 0.86;

  /// Cartas de tras visiveis. Acima disso a pilha vira sujeira visual.
  static const int _visiveis = 2;

  /// Indice da carta que esta na frente.
  int _topo = 0;

  /// Deslocamento horizontal do arraste em andamento.
  double _arraste = 0.0;

  late final AnimationController _controle;

  @override
  void initState() {
    super.initState();
    _controle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  void _aoArrastar(DragUpdateDetails d) {
    if (widget.quantidade < 2) return;
    setState(() => _arraste += d.delta.dx);
  }

  void _aoSoltar(DragEndDetails d, double largura) {
    if (widget.quantidade < 2) {
      _animarAte(0.0);
      return;
    }

    // Passou de um terco da largura, ou saiu com velocidade: vai para o fim.
    final velocidade = d.velocity.pixelsPerSecond.dx;
    final passou = _arraste.abs() > largura / 3 || velocidade.abs() > 700;

    if (!passou) {
      _animarAte(0.0, curva: Curves.easeOutBack);
      return;
    }

    final destino = _arraste.isNegative ? -largura * 1.3 : largura * 1.3;
    _animarAte(destino, aoTerminar: () {
      setState(() {
        _topo = (_topo + 1) % widget.quantidade;
        _arraste = 0.0;
      });
    });
  }

  void _animarAte(
    double destino, {
    Curve curva = Curves.easeOut,
    VoidCallback? aoTerminar,
  }) {
    final anim = Tween<double>(begin: _arraste, end: destino).animate(
      CurvedAnimation(parent: _controle, curve: curva),
    );
    void ouvir() => _arraste = anim.value;

    _controle.reset();
    _controle.addListener(ouvir);
    _controle.forward().whenComplete(() {
      _controle.removeListener(ouvir);
      if (aoTerminar != null) {
        aoTerminar();
      } else {
        _arraste = destino;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quantidade == 0) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, restricoes) {
        final largura = restricoes.maxWidth;

        // A da frente mais as de tras visiveis, nunca mais do que existem.
        final qtd = widget.quantidade < _visiveis + 1
            ? widget.quantidade
            : _visiveis + 1;

        final cartas = <Widget>[];
        // De tras para frente, para a da frente terminar por cima na Stack.
        for (var camada = qtd - 1; camada >= 0; camada--) {
          final indice = (_topo + camada) % widget.quantidade;
          cartas.add(_carta(context, camada, indice, largura));
        }

        return SizedBox(
          height: _altura,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: cartas,
          ),
        );
      },
    );
  }

  Widget _carta(BuildContext context, int camada, int indice, double largura) {
    final daFrente = camada == 0;

    // Enquanto a da frente e arrastada, as de tras se adiantam. Sem isso so a
    // de cima se mexeria e a pilha pareceria congelada.
    final progresso =
        largura == 0 ? 0.0 : (_arraste.abs() / largura).clamp(0.0, 1.0);
    final camadaEfetiva = daFrente ? 0.0 : camada - progresso;

    final escala = 1.0 - (_passoEscala * camadaEfetiva);

    // As de tras alternam de lado: uma ponta na esquerda, a outra na direita.
    final paraDireita = camada.isOdd;
    final desloc = daFrente
        ? _arraste
        : (paraDireita ? 1 : -1) * _passoLateral * camadaEfetiva;

    // Frente: gira conforme o arraste. Fundo: giro fixo, alternando o lado.
    final giro = daFrente
        ? (largura > 0 ? (_arraste / largura) * 0.22 : 0.0)
        : (paraDireita ? 1 : -1) * _giroFundo * camadaEfetiva;

    final carta = Transform.translate(
      offset: Offset(desloc, 0.0),
      child: Transform.rotate(
        angle: giro,
        child: Transform.scale(
          scale: escala,
          child: Opacity(
            opacity: daFrente ? 1.0 : (1.0 - 0.2 * camadaEfetiva),
            child: FractionallySizedBox(
              widthFactor: _larguraFrente,
              child: widget.construir(context, indice),
            ),
          ),
        ),
      ),
    );

    // So a da frente responde ao gesto.
    if (!daFrente) {
      return IgnorePointer(child: carta);
    }

    return GestureDetector(
      onHorizontalDragUpdate: _aoArrastar,
      onHorizontalDragEnd: (d) => _aoSoltar(d, largura),
      child: carta,
    );
  }
}

/// Conteudo do card de treino no baralho.
///
/// Antes o card trazia so o nome e a lista de subcategorias. Faltava o que a
/// pessoa precisa para decidir se abre: em que pe esta o treino, quanto falta
/// e qual e o proximo exercicio.
class _ConteudoCardTreino extends StatelessWidget {
  const _ConteudoCardTreino({required this.treino});

  final GruposStruct treino;

  /// Todos os exercicios do treino, achatados das subcategorias.
  List<ExerciciosStruct> get _exercicios =>
      treino.grupos.expand((g) => g.exercicios).toList();

  /// Proximo a fazer: o primeiro que nao foi concluido nem pulado, na ordem.
  /// `null` quando nao sobrou nenhum.
  ExerciciosStruct? get _proximo {
    final pendentes = _exercicios
        .where((e) => !e.isConcluido && !e.isPulado)
        .toList()
      ..sort((a, b) => a.ordem.compareTo(b.ordem));
    return pendentes.isEmpty ? null : pendentes.first;
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final exercicios = _exercicios;
    final total = exercicios.length;
    final feitos = exercicios.where((e) => e.isConcluido || e.isPulado).length;
    final proximo = _proximo;

    final subcategorias =
        treino.grupos.map((g) => g.subcategoria).where((s) => s.isNotEmpty);

    // Rotulo e cor do estado, derivados do status que a RPC ja devolve.
    late String rotulo;
    late Color corEstado;
    if (treino.status == 'concluido') {
      rotulo = 'Concluído';
      corEstado = tema.success;
    } else if (treino.status == 'em_andamento') {
      rotulo = 'Em andamento';
      corEstado = tema.primary;
    } else if (treino.status == 'pulado') {
      rotulo = 'Pulado';
      corEstado = tema.secondaryText;
    } else {
      rotulo = 'A fazer';
      corEstado = tema.secondaryText;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                treino.nome,
                overflow: TextOverflow.ellipsis,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: tema.primaryText,
                  fontSize: 20.0,
                  letterSpacing: -0.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
              decoration: BoxDecoration(
                color: corEstado.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Text(
                rotulo,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: corEstado,
                  fontSize: 10.5,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (subcategorias.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
            child: Text(
              subcategorias.join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                color: tema.secondaryText,
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        const Spacer(),
        // O proximo exercicio e a informacao que responde "e agora?".
        if (proximo != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 8.0, 10.0, 8.0),
            decoration: BoxDecoration(
              color: tema.accent1,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  color: tema.primary,
                  size: 16.0,
                ),
                const SizedBox(width: 6.0),
                Expanded(
                  child: Text(
                    proximo.nome,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: tema.primary,
                      fontSize: 12.5,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (total > 0)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999.0),
                  child: LinearProgressIndicator(
                    value: feitos / total,
                    minHeight: 5.0,
                    backgroundColor: tema.alternate,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      treino.status == 'concluido'
                          ? tema.success
                          : tema.primary,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: Text(
                    '$feitos de $total exercícios',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      color: tema.secondaryText,
                      fontSize: 11.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

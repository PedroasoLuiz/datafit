import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'metas_fotos_model.dart';
export 'metas_fotos_model.dart';

class MetasFotosWidget extends StatefulWidget {
  const MetasFotosWidget({super.key});

  @override
  State<MetasFotosWidget> createState() => _MetasFotosWidgetState();
}

class _MetasFotosWidgetState extends State<MetasFotosWidget>
    with TickerProviderStateMixin {
  late MetasFotosModel _model;

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
    _model = createModel(context, () => MetasFotosModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.instantTimer = InstantTimer.periodic(
            duration: Duration(milliseconds: 1000),
            callback: (timer) async {
              FFAppState().updatingvariable = 1;
              safeSetState(() {});
            },
            startImmediately: true,
          );
        }),
        Future(() async {
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
              if (animationsMap['iconButtonOnActionTriggerAnimation1'] !=
                  null) {
                safeSetState(() => hasIconButtonTriggered1 = true);
                SchedulerBinding.instance.addPostFrameCallback((_) async =>
                    await animationsMap['iconButtonOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0));
              }
            }),
            Future(() async {
              if (animationsMap['iconButtonOnActionTriggerAnimation2'] !=
                  null) {
                safeSetState(() => hasIconButtonTriggered2 = true);
                SchedulerBinding.instance.addPostFrameCallback((_) async =>
                    await animationsMap['iconButtonOnActionTriggerAnimation2']!
                        .controller
                        .forward(from: 0.0));
              }
            }),
          ]);
        }),
      ]);
    });

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
                  mainAxisSize: MainAxisSize.min,
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
                                'Sua evolução',
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
                              FFIcons.kproperty1FiRrPulse,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 18.0,
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: Container(
                        height: 300.0,
                        child: Builder(
                          builder: (context) {
                            final fotos = functions
                                .gerarMeses(FFAppState().perfil.createdAt)
                                .map((e) => e)
                                .toList();

                            return Container(
                              width: double.infinity,
                              height: 300.0,
                              child: CarouselSlider.builder(
                                itemCount: fotos.length,
                                itemBuilder: (context, fotosIndex, _) {
                                  final fotosItem = fotos[fotosIndex];
                                  return Stack(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: 100.0,
                                                  height: 6.0,
                                                  decoration: BoxDecoration(
                                                    color: fotosIndex == 0
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 20.0,
                                                height: 20.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: 100.0,
                                                  height: 6.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 8.0, 16.0, 12.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    dateTimeFormat(
                                                      "MMMM \'de\' y",
                                                      fotosItem,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    '-',
                                                  ),
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
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
                                            ],
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 4.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    border: Border.all(
                                                      color: (dateTimeFormat(
                                                                    "MM y",
                                                                    fotosItem,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ) ==
                                                                  dateTimeFormat(
                                                                    "MM y",
                                                                    functions.formataData(FFAppState()
                                                                        .registro1
                                                                        .mesAno),
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  )) ||
                                                              (dateTimeFormat(
                                                                    "MM y",
                                                                    fotosItem,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ) ==
                                                                  dateTimeFormat(
                                                                    "MM y",
                                                                    functions.formataData(FFAppState()
                                                                        .resumo2
                                                                        .mesAno),
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ))
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      width: 1.6,
                                                    ),
                                                  ),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      if (FFAppState()
                                                              .registro1
                                                              .id >
                                                          0) {
                                                        if (FFAppState()
                                                                .resumo2
                                                                .id >
                                                            0) {
                                                          FFAppState()
                                                                  .registro1 =
                                                              ResumoMesStruct();
                                                          FFAppState().resumo2 =
                                                              ResumoMesStruct();
                                                          FFAppState()
                                                              .update(() {});
                                                        } else {
                                                          FFAppState().resumo2 =
                                                              FFAppState()
                                                                  .metasTemp
                                                                  .acompanhamentoMensal
                                                                  .where((e) =>
                                                                      dateTimeFormat(
                                                                        "MM y",
                                                                        functions
                                                                            .formataData(e.mesAno),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ) ==
                                                                      dateTimeFormat(
                                                                        "MM y",
                                                                        fotosItem,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ))
                                                                  .toList()
                                                                  .firstOrNull!;
                                                          FFAppState()
                                                              .update(() {});
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
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      } else {
                                                        FFAppState().registro1 =
                                                            FFAppState()
                                                                .metasTemp
                                                                .acompanhamentoMensal
                                                                .where((e) =>
                                                                    dateTimeFormat(
                                                                      "MM y",
                                                                      functions
                                                                          .formataData(
                                                                              e.mesAno),
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ) ==
                                                                    dateTimeFormat(
                                                                      "MM y",
                                                                      fotosItem,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ))
                                                                .toList()
                                                                .firstOrNull!;
                                                        safeSetState(() {});
                                                      }
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      child: Image.network(
                                                        valueOrDefault<String>(
                                                          FFAppState()
                                                              .metasTemp
                                                              .acompanhamentoMensal
                                                              .where((e) =>
                                                                  dateTimeFormat(
                                                                    "MM y",
                                                                    functions
                                                                        .formataData(
                                                                            e.mesAno),
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ) ==
                                                                  dateTimeFormat(
                                                                    "MM y",
                                                                    fotosItem,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ))
                                                              .toList()
                                                              .firstOrNull
                                                              ?.urlImg,
                                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                        ),
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1.0,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                1.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if ((valueOrDefault<String>(
                                                    FFAppState()
                                                        .metasTemp
                                                        .acompanhamentoMensal
                                                        .where((e) =>
                                                            dateTimeFormat(
                                                              "MM y",
                                                              functions
                                                                  .formataData(
                                                                      e.mesAno),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ) ==
                                                            dateTimeFormat(
                                                              "MM y",
                                                              fotosItem,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ))
                                                        .toList()
                                                        .firstOrNull
                                                        ?.urlImg,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                  ) ==
                                                  null ||
                                              valueOrDefault<String>(
                                                    FFAppState()
                                                        .metasTemp
                                                        .acompanhamentoMensal
                                                        .where((e) =>
                                                            dateTimeFormat(
                                                              "MM y",
                                                              functions
                                                                  .formataData(
                                                                      e.mesAno),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ) ==
                                                            dateTimeFormat(
                                                              "MM y",
                                                              fotosItem,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ))
                                                        .toList()
                                                        .firstOrNull
                                                        ?.urlImg,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                  ) ==
                                                  '') &&
                                          ((dateTimeFormat(
                                                    "MM y",
                                                    fotosItem,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) ==
                                                  dateTimeFormat(
                                                    "MM y",
                                                    getCurrentTimestamp,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  )) ||
                                              (dateTimeFormat(
                                                    "MM y",
                                                    fotosItem,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) ==
                                                  (DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                      .month -
                                                                  1)
                                                          .month
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      ' ' +
                                                      DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                      .month -
                                                                  1)
                                                          .year
                                                          .toString()))))
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 4.0),
                                            child: FlutterFlowIconButton(
                                              borderRadius: 16.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              icon: Icon(
                                                FFIcons.kproperty1FiRrPicture,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 16.0,
                                              ),
                                              onPressed: () async {
                                                final selectedMedia =
                                                    await selectMediaWithSourceBottomSheet(
                                                  context: context,
                                                  storageFolderPath:
                                                      '${currentUserUid}/Evolucao/',
                                                  allowPhoto: true,
                                                );
                                                if (selectedMedia != null &&
                                                    selectedMedia.every((m) =>
                                                        validateFileFormat(
                                                            m.storagePath,
                                                            context))) {
                                                  safeSetState(() => _model
                                                          .isDataUploading_upfoto =
                                                      true);
                                                  var selectedUploadedFiles =
                                                      <FFUploadedFile>[];

                                                  var downloadUrls = <String>[];
                                                  try {
                                                    selectedUploadedFiles =
                                                        selectedMedia
                                                            .map((m) =>
                                                                FFUploadedFile(
                                                                  name: m
                                                                      .storagePath
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  bytes:
                                                                      m.bytes,
                                                                  height: m
                                                                      .dimensions
                                                                      ?.height,
                                                                  width: m
                                                                      .dimensions
                                                                      ?.width,
                                                                  blurHash: m
                                                                      .blurHash,
                                                                  originalFilename:
                                                                      m.originalFilename,
                                                                ))
                                                            .toList();

                                                    downloadUrls =
                                                        await uploadSupabaseStorageFiles(
                                                      bucketName: 'Imagens',
                                                      selectedFiles:
                                                          selectedMedia,
                                                    );
                                                  } finally {
                                                    _model.isDataUploading_upfoto =
                                                        false;
                                                  }
                                                  if (selectedUploadedFiles
                                                              .length ==
                                                          selectedMedia
                                                              .length &&
                                                      downloadUrls.length ==
                                                          selectedMedia
                                                              .length) {
                                                    safeSetState(() {
                                                      _model.uploadedLocalFile_upfoto =
                                                          selectedUploadedFiles
                                                              .first;
                                                      _model.uploadedFileUrl_upfoto =
                                                          downloadUrls.first;
                                                    });
                                                  } else {
                                                    safeSetState(() {});
                                                    return;
                                                  }
                                                }

                                                if (_model.uploadedFileUrl_upfoto !=
                                                        null &&
                                                    _model.uploadedFileUrl_upfoto !=
                                                        '') {
                                                  _model.apiResultzvb =
                                                      await AlunoGroup
                                                          .upsertRegMensalCall
                                                          .call(
                                                    pAlunoUuid: currentUserUid,
                                                    pUrlImg: _model
                                                        .uploadedFileUrl_upfoto,
                                                    pMesAno: functions
                                                        .primeiroDiaDoMes(
                                                            fotosItem),
                                                  );

                                                  if ((_model.apiResultzvb
                                                          ?.succeeded ??
                                                      true)) {
                                                    await action_blocks
                                                        .metasAluno(context);
                                                    safeSetState(() {});
                                                  }
                                                }

                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      if ((valueOrDefault<String>(
                                                    FFAppState()
                                                        .metasTemp
                                                        .acompanhamentoMensal
                                                        .where((e) =>
                                                            dateTimeFormat(
                                                              "MM y",
                                                              functions
                                                                  .formataData(
                                                                      e.mesAno),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ) ==
                                                            dateTimeFormat(
                                                              "MM y",
                                                              fotosItem,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ))
                                                        .toList()
                                                        .firstOrNull
                                                        ?.urlImg,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                  ) !=
                                                  null &&
                                              valueOrDefault<String>(
                                                    FFAppState()
                                                        .metasTemp
                                                        .acompanhamentoMensal
                                                        .where((e) =>
                                                            dateTimeFormat(
                                                              "MM y",
                                                              functions
                                                                  .formataData(
                                                                      e.mesAno),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ) ==
                                                            dateTimeFormat(
                                                              "MM y",
                                                              fotosItem,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ))
                                                        .toList()
                                                        .firstOrNull
                                                        ?.urlImg,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                  ) !=
                                                  '') &&
                                          ((dateTimeFormat(
                                                    "MM y",
                                                    fotosItem,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) ==
                                                  dateTimeFormat(
                                                    "MM y",
                                                    getCurrentTimestamp,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  )) ||
                                              (dateTimeFormat(
                                                    "MM y",
                                                    fotosItem,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) ==
                                                  (DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                      .month -
                                                                  1)
                                                          .month
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      ' ' +
                                                      DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                      .month -
                                                                  1)
                                                          .year
                                                          .toString()))))
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0,
                                                    0.0,
                                                    valueOrDefault<double>(
                                                      (valueOrDefault<String>(
                                                                        FFAppState()
                                                                            .metasTemp
                                                                            .acompanhamentoMensal
                                                                            .where((e) =>
                                                                                dateTimeFormat(
                                                                                  "MM y",
                                                                                  functions.formataData(e.mesAno),
                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                ) ==
                                                                                dateTimeFormat(
                                                                                  "MM y",
                                                                                  fotosItem,
                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                ))
                                                                            .toList()
                                                                            .firstOrNull
                                                                            ?.urlImg,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                                      ) !=
                                                                      null &&
                                                                  valueOrDefault<
                                                                          String>(
                                                                        FFAppState()
                                                                            .metasTemp
                                                                            .acompanhamentoMensal
                                                                            .where((e) =>
                                                                                dateTimeFormat(
                                                                                  "MM y",
                                                                                  functions.formataData(e.mesAno),
                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                ) ==
                                                                                dateTimeFormat(
                                                                                  "MM y",
                                                                                  fotosItem,
                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                ))
                                                                            .toList()
                                                                            .firstOrNull
                                                                            ?.urlImg,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                                      ) !=
                                                                      '') &&
                                                              (dateTimeFormat(
                                                                    "MM y",
                                                                    fotosItem,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ) ==
                                                                  dateTimeFormat(
                                                                    "MM y",
                                                                    getCurrentTimestamp,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ))
                                                          ? 44.0
                                                          : 0.0,
                                                      0.0,
                                                    ),
                                                    4.0),
                                            child: FlutterFlowIconButton(
                                              borderRadius: 16.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              icon: Icon(
                                                FFIcons.kproperty1FiRrRefresh,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 16.0,
                                              ),
                                              onPressed: () async {
                                                final selectedMedia =
                                                    await selectMediaWithSourceBottomSheet(
                                                  context: context,
                                                  storageFolderPath:
                                                      '${currentUserUid}/Evolucao/',
                                                  allowPhoto: true,
                                                );
                                                if (selectedMedia != null &&
                                                    selectedMedia.every((m) =>
                                                        validateFileFormat(
                                                            m.storagePath,
                                                            context))) {
                                                  safeSetState(() => _model
                                                          .isDataUploading_upfoto2 =
                                                      true);
                                                  var selectedUploadedFiles =
                                                      <FFUploadedFile>[];

                                                  var downloadUrls = <String>[];
                                                  try {
                                                    selectedUploadedFiles =
                                                        selectedMedia
                                                            .map((m) =>
                                                                FFUploadedFile(
                                                                  name: m
                                                                      .storagePath
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  bytes:
                                                                      m.bytes,
                                                                  height: m
                                                                      .dimensions
                                                                      ?.height,
                                                                  width: m
                                                                      .dimensions
                                                                      ?.width,
                                                                  blurHash: m
                                                                      .blurHash,
                                                                  originalFilename:
                                                                      m.originalFilename,
                                                                ))
                                                            .toList();

                                                    downloadUrls =
                                                        await uploadSupabaseStorageFiles(
                                                      bucketName: 'Imagens',
                                                      selectedFiles:
                                                          selectedMedia,
                                                    );
                                                  } finally {
                                                    _model.isDataUploading_upfoto2 =
                                                        false;
                                                  }
                                                  if (selectedUploadedFiles
                                                              .length ==
                                                          selectedMedia
                                                              .length &&
                                                      downloadUrls.length ==
                                                          selectedMedia
                                                              .length) {
                                                    safeSetState(() {
                                                      _model.uploadedLocalFile_upfoto2 =
                                                          selectedUploadedFiles
                                                              .first;
                                                      _model.uploadedFileUrl_upfoto2 =
                                                          downloadUrls.first;
                                                    });
                                                  } else {
                                                    safeSetState(() {});
                                                    return;
                                                  }
                                                }

                                                if (_model.uploadedFileUrl_upfoto2 !=
                                                        null &&
                                                    _model.uploadedFileUrl_upfoto2 !=
                                                        '') {
                                                  _model.apiResultzvb2 =
                                                      await AlunoGroup
                                                          .upsertRegMensalCall
                                                          .call(
                                                    pAlunoUuid: currentUserUid,
                                                    pUrlImg: _model
                                                        .uploadedFileUrl_upfoto2,
                                                    pMesAno: functions
                                                        .primeiroDiaDoMes(
                                                            fotosItem),
                                                  );

                                                  if ((_model.apiResultzvb2
                                                          ?.succeeded ??
                                                      true)) {
                                                    await deleteSupabaseFileFromPublicUrl(
                                                        FFAppState()
                                                            .metasTemp
                                                            .acompanhamentoMensal
                                                            .where((e) =>
                                                                dateTimeFormat(
                                                                  "MM y",
                                                                  functions
                                                                      .formataData(
                                                                          e.mesAno),
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ) ==
                                                                dateTimeFormat(
                                                                  "MM y",
                                                                  fotosItem,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ))
                                                            .toList()
                                                            .firstOrNull!
                                                            .urlImg);
                                                    await action_blocks
                                                        .metasAluno(context);
                                                    safeSetState(() {});
                                                  }
                                                }

                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      if ((valueOrDefault<String>(
                                                    FFAppState()
                                                        .metasTemp
                                                        .acompanhamentoMensal
                                                        .where((e) =>
                                                            dateTimeFormat(
                                                              "MM y",
                                                              functions
                                                                  .formataData(
                                                                      e.mesAno),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ) ==
                                                            dateTimeFormat(
                                                              "MM y",
                                                              fotosItem,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ))
                                                        .toList()
                                                        .firstOrNull
                                                        ?.urlImg,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                  ) !=
                                                  null &&
                                              valueOrDefault<String>(
                                                    FFAppState()
                                                        .metasTemp
                                                        .acompanhamentoMensal
                                                        .where((e) =>
                                                            dateTimeFormat(
                                                              "MM y",
                                                              functions
                                                                  .formataData(
                                                                      e.mesAno),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ) ==
                                                            dateTimeFormat(
                                                              "MM y",
                                                              fotosItem,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ))
                                                        .toList()
                                                        .firstOrNull
                                                        ?.urlImg,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/datafit-yuopjj/assets/b1so7onglxu0/123.png',
                                                  ) !=
                                                  '') &&
                                          (dateTimeFormat(
                                                "MM y",
                                                fotosItem,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ) ==
                                              dateTimeFormat(
                                                "MM y",
                                                getCurrentTimestamp,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )))
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    44.0, 0.0, 0.0, 4.0),
                                            child: FlutterFlowIconButton(
                                              borderRadius: 16.0,
                                              buttonSize: 40.0,
                                              fillColor: Color(0xFFFFD5D6),
                                              icon: Icon(
                                                FFIcons.kproperty1FiRrTrash,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                size: 16.0,
                                              ),
                                              onPressed: () async {
                                                await showModalBottomSheet(
                                                  useRootNavigator: true,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return WebViewAware(
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child: MensagemWidget(
                                                          texto:
                                                              'Remover registro?',
                                                          tipo: '2',
                                                          fechasozinho: false,
                                                          mostrabotoes: true,
                                                          textoauxiliar:
                                                              'Tem certeza de que deseja remover esse registro?',
                                                          action: () async {
                                                            await RegistrosMensaisTable()
                                                                .delete(
                                                              matchingRows:
                                                                  (rows) => rows
                                                                      .eqOrNull(
                                                                'Id',
                                                                FFAppState()
                                                                    .metasTemp
                                                                    .acompanhamentoMensal
                                                                    .where((e) =>
                                                                        dateTimeFormat(
                                                                          "MM y",
                                                                          functions
                                                                              .formataData(e.mesAno),
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ) ==
                                                                        dateTimeFormat(
                                                                          "MM y",
                                                                          fotosItem,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ))
                                                                    .toList()
                                                                    .firstOrNull
                                                                    ?.id,
                                                              ),
                                                            );
                                                            await deleteSupabaseFileFromPublicUrl(FFAppState()
                                                                .metasTemp
                                                                .acompanhamentoMensal
                                                                .where((e) =>
                                                                    dateTimeFormat(
                                                                      "MM y",
                                                                      functions
                                                                          .formataData(
                                                                              e.mesAno),
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ) ==
                                                                    dateTimeFormat(
                                                                      "MM y",
                                                                      fotosItem,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ))
                                                                .toList()
                                                                .firstOrNull!
                                                                .urlImg);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) => safeSetState(
                                                    () => _model.removeu =
                                                        value));

                                                if (_model.removeu!) {
                                                  await action_blocks
                                                      .metasAluno(context);
                                                  safeSetState(() {});
                                                }

                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                                carouselController:
                                    _model.carouselController ??=
                                        CarouselSliderController(),
                                options: CarouselOptions(
                                  initialPage: max(0, min(1, fotos.length - 1)),
                                  viewportFraction: 0.8,
                                  disableCenter: true,
                                  enlargeCenterPage: false,
                                  enlargeFactor: 0.0,
                                  enableInfiniteScroll: false,
                                  scrollDirection: Axis.horizontal,
                                  autoPlay: false,
                                  onPageChanged: (index, _) =>
                                      _model.carouselCurrentIndex = index,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ].addToEnd(SizedBox(height: 40.0)),
                ),
              ),
            ),
          ).animateOnActionTrigger(
              animationsMap['containerOnActionTriggerAnimation']!,
              hasBeenTriggered: hasContainerTriggered),
        ),
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  showLoadingIndicator: true,
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
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                  child: FlutterFlowIconButton(
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
                      animationsMap['iconButtonOnActionTriggerAnimation2']!,
                      hasBeenTriggered: hasIconButtonTriggered2),
                ),
              ),
            ],
          ),
        ),
      ]
          .divide(SizedBox(height: 8.0))
          .addToStart(SizedBox(height: 40.0))
          .addToEnd(SizedBox(height: 40.0)),
    );
  }
}

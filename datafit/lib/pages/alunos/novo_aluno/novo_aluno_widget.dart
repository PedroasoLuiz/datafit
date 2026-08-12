import '/auth/supabase_auth/auth_util.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'novo_aluno_model.dart';
export 'novo_aluno_model.dart';

class NovoAlunoWidget extends StatefulWidget {
  const NovoAlunoWidget({super.key});

  @override
  State<NovoAlunoWidget> createState() => _NovoAlunoWidgetState();
}

class _NovoAlunoWidgetState extends State<NovoAlunoWidget>
    with TickerProviderStateMixin {
  late NovoAlunoModel _model;

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
    _model = createModel(context, () => NovoAlunoModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().existeCadastro = null;
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

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

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
        Flexible(
          child: Padding(
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
                                  'Novo Aluno',
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
                                FFIcons.kproperty1FiRrModePortrait,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 18.0,
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
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
                                0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Nome',
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
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.nomeTextController,
                                    focusNode: _model.nomeFocusNode,
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                      hintText: '...',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      contentPadding: EdgeInsets.all(16.0),
                                    ),
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
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    maxLines: null,
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    enableInteractiveSelection: true,
                                    validator: _model
                                        .nomeTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'E-mail',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: TextFormField(
                                        controller: _model.emailTextController,
                                        focusNode: _model.emailFocusNode,
                                        onChanged: (_) {
                                          FFAppState().existeCadastro = null;
                                          safeSetState(() {});
                                          EasyDebounce.debounce(
                                            '_model.emailTextController',
                                            Duration(milliseconds: 2000),
                                            () async {
                                              if (_model
                                                  .emailTextController.text
                                                  .trim()
                                                  .isEmpty) return;
                                              await action_blocks
                                                  .verificaCadastroEmail(
                                                context,
                                                email: _model
                                                    .emailTextController.text,
                                              );
                                              safeSetState(() {});
                                            },
                                          );
                                        },
                                        autofocus: false,
                                        enabled: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                          hintText: 'nome@gmail.com',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
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
                                                        .labelMedium
                                                        .fontStyle,
                                                lineHeight: 1.0,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                          contentPadding: EdgeInsets.all(16.0),
                                        ),
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
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        maxLines: null,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        enableInteractiveSelection: true,
                                        validator: _model
                                            .emailTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    if (FFAppState().existeCadastro != null &&
                                        getJsonField(
                                                FFAppState().existeCadastro,
                                                r'''$.existeNaAuth''') ==
                                            true)
                                      Builder(builder: (context) {
                                        final primeiroNome = FFAppState()
                                            .perfil
                                            .nome
                                            .trim()
                                            .split(' ')
                                            .first;
                                        final perfilCompleto = getJsonField(
                                                FFAppState().existeCadastro,
                                                r'''$.perfilCompleto''') ==
                                            true;
                                        final outrosPersonais = getJsonField(
                                                    FFAppState().existeCadastro,
                                                    r'''$.outrosPersonais''')
                                                as List? ??
                                            [];
                                        final temPersonal =
                                            outrosPersonais.isNotEmpty;
                                        final nomePersonal = temPersonal
                                            ? (outrosPersonais.first['nome']
                                                    ?.toString() ??
                                                '')
                                            : '';
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Ei $primeiroNome! Encontrei um cadastro com esse e-mail.',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .warning,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  perfilCompleto
                                                      ? 'Perfil completo.'
                                                      : 'Perfil incompleto.',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                if (temPersonal)
                                                  Text(
                                                    'Já vinculada a $nomePersonal.',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .inter(),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  ],
                                ),
                              ].addToEnd(SizedBox(height: 16.0)),
                            ),
                          ),
                        ],
                      ),
                    ].addToEnd(SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ).animateOnActionTrigger(
                animationsMap['containerOnActionTriggerAnimation']!,
                hasBeenTriggered: hasContainerTriggered),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
                onPressed: () async {
                  final resultadoRaw = await actions.cadastrarAluno(
                    currentUserUid,
                    _model.nomeTextController.text.trim(),
                    _model.emailTextController.text,
                    null,
                    '',
                    null,
                    null,
                    null,
                    false,
                    null,
                    null,
                    true,
                    getJsonField(
                      FFAppState().existeCadastro,
                      r'''$.userId''',
                    ).toString(),
                  );

                  Map<String, dynamic> resultado;
                  try {
                    resultado =
                        jsonDecode(resultadoRaw) as Map<String, dynamic>;
                  } catch (e) {
                    resultado = {
                      'sucesso': false,
                      'mensagem': 'Erro ao processar resposta do servidor.',
                    };
                  }
                  final sucesso = resultado['sucesso'] == true;
                  final mensagem = resultado['mensagem']?.toString() ??
                      (sucesso
                          ? 'Convite enviado.'
                          : 'Não foi possível enviar o convite.');

                  if (!context.mounted) return;
                  await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    builder: (sheetCtx) => WebViewAware(
                      child: Padding(
                        padding: MediaQuery.viewInsetsOf(sheetCtx),
                        child: MensagemWidget(
                          texto: mensagem,
                          tipo: sucesso ? '1' : '2',
                          action: () async {},
                          fechasozinho: sucesso,
                          mostrabotoes: !sucesso,
                        ),
                      ),
                    ),
                  );

                  if (!context.mounted || !sucesso) {
                    return;
                  }

                  await Future.wait([
                    Future(() async {
                      if (animationsMap['containerOnActionTriggerAnimation'] !=
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
            Padding(
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
                      if (animationsMap['containerOnActionTriggerAnimation'] !=
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
                  ]);
                  Navigator.pop(context);
                },
              ).animateOnActionTrigger(
                  animationsMap['iconButtonOnActionTriggerAnimation2']!,
                  hasBeenTriggered: hasIconButtonTriggered2),
            ),
          ],
        ),
      ]
          .divide(SizedBox(height: 16.0))
          .addToStart(SizedBox(height: 40.0))
          .addToEnd(SizedBox(height: 40.0)),
    );
  }
}

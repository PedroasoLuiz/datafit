import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'treinos_novo_exercicio_treino_model.dart';
export 'treinos_novo_exercicio_treino_model.dart';

class TreinosNovoExercicioTreinoWidget extends StatefulWidget {
  const TreinosNovoExercicioTreinoWidget({
    super.key,
    required this.treinoId,
    this.nextOrdem,
    // edit mode — when etId != null the form pre-fills and updates
    this.etId,
    this.exercicioNome,
    this.series,
    this.reps,
    this.seriesAque,
    this.repsAque,
    this.descanso,
    this.obs,
  });

  final int treinoId;
  final int? nextOrdem;
  final int? etId;
  final String? exercicioNome;
  final int? series;
  final int? reps;
  final int? seriesAque;
  final int? repsAque;
  final int? descanso;
  final String? obs;

  @override
  State<TreinosNovoExercicioTreinoWidget> createState() =>
      _TreinosNovoExercicioTreinoWidgetState();
}

class _TreinosNovoExercicioTreinoWidgetState
    extends State<TreinosNovoExercicioTreinoWidget>
    with TickerProviderStateMixin {
  late TreinosNovoExercicioTreinoModel _model;

  var hasContainerTriggered1 = false;
  var hasContainerTriggered2 = false;
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
    _model = createModel(context, () => TreinosNovoExercicioTreinoModel());

    final isEdit = widget.etId != null;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
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
        Future(() async {
          if (animationsMap['containerOnActionTriggerAnimation1'] != null) {
            safeSetState(() => hasContainerTriggered1 = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['containerOnActionTriggerAnimation1']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
        if (!isEdit)
          Future(() async {
            try {
              _model.apiResultdup = await TreinoGroup.getExerciciosCall.call(
                personalUuid: currentUserUid,
              );
              if (_model.apiResultdup?.succeeded == true) {
                final body = _model.apiResultdup!.jsonBody;
                if (body is List) {
                  _model.exercicios = (body
                      .map<ExerciciossimplyStruct?>(
                          ExerciciossimplyStruct.maybeFromMap)
                      .whereType<ExerciciossimplyStruct>()
                      .toList())
                    ..sort((a, b) => (a.nome ?? '').compareTo(b.nome ?? ''));
                }
              }
            } catch (_) {}
            if (mounted) safeSetState(() {});
          }),
        // show warmup section if pre-filled
        if (isEdit && (widget.seriesAque != null || widget.repsAque != null))
          Future(() async {
            _model.aquecimento = true;
            safeSetState(() {});
            if (animationsMap['containerOnActionTriggerAnimation2'] != null) {
              safeSetState(() => hasContainerTriggered2 = true);
              SchedulerBinding.instance.addPostFrameCallback((_) async =>
                  await animationsMap['containerOnActionTriggerAnimation2']!
                      .controller
                      .forward(from: 0.0));
            }
          }),
      ]);
    });

    _model.txtSeriesTextController ??=
        TextEditingController(text: widget.series?.toString() ?? '');
    _model.txtSeriesFocusNode ??= FocusNode();

    _model.txtRepetTextController ??=
        TextEditingController(text: widget.reps?.toString() ?? '');
    _model.txtRepetFocusNode ??= FocusNode();

    _model.txtDescansoTextController ??=
        TextEditingController(text: widget.descanso?.toString() ?? '');
    _model.txtDescansoFocusNode ??= FocusNode();

    _model.txtSeriesAqueTextController ??=
        TextEditingController(text: widget.seriesAque?.toString() ?? '');
    _model.txtSeriesAqueFocusNode ??= FocusNode();

    _model.txtRepetAqueTextController ??=
        TextEditingController(text: widget.repsAque?.toString() ?? '');
    _model.txtRepetAqueFocusNode ??= FocusNode();

    _model.txtObsTextController ??=
        TextEditingController(text: widget.obs ?? '');
    _model.txtObsFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOutQuint,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(-5.0, -5.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOutQuint,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(-5.0, -5.0),
            end: const Offset(1.0, 1.0),
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
            begin: const Offset(-40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'iconButtonOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
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
            begin: const Offset(0.0, -100.0),
            end: const Offset(0.0, 0.0),
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

  Future<void> _fecharComAnimacao() async {
    await Future.wait([
      Future(() async {
        if (animationsMap['iconButtonOnActionTriggerAnimation1'] != null) {
          await animationsMap['iconButtonOnActionTriggerAnimation1']!
              .controller
              .reverse();
        }
      }),
      Future(() async {
        if (animationsMap['iconButtonOnActionTriggerAnimation2'] != null) {
          await animationsMap['iconButtonOnActionTriggerAnimation2']!
              .controller
              .reverse();
        }
      }),
      Future(() async {
        if (animationsMap['containerOnActionTriggerAnimation1'] != null) {
          await animationsMap['containerOnActionTriggerAnimation1']!
              .controller
              .reverse();
        }
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    context.watch<cupertino_time_picker_hiuzb7_app_state.FFAppState>();

    final isEdit = widget.etId != null;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    controller: _model.columnController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── HEADER ─────────────────────────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    isEdit
                                        ? 'Editar exercício'
                                        : 'Novo exercício',
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
                                        ),
                                  ),
                                ),
                                Icon(
                                  FFIcons.kproperty1FiRrGym,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 18.0,
                                ),
                              ].divide(const SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          thickness: 1.0,
                          indent: 16.0,
                          endIndent: 16.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),

                        // ── EXERCISE PICKER (create only) ──────────────
                        if (!isEdit) ...[
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 0.0, 8.0),
                            child: Text(
                              'Exercício',
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
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: FlutterFlowDropDown<int>(
                              controller: _model.dpExerciciosValueController ??=
                                  FormFieldController<int>(
                                      _model.dpExerciciosValue),
                              options: List<int>.from(
                                  _model.exercicios.map((e) => e.id ?? 0)),
                              optionLabels: _model.exercicios
                                  .map((e) => e.nome ?? '')
                                  .toList(),
                              onChanged: (val) => safeSetState(
                                  () => _model.dpExerciciosValue = val),
                              width: MediaQuery.sizeOf(context).width,
                              height: 40.0,
                              maxHeight: 200.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                              hintText: 'Selecione...',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              elevation: 2.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 0.0,
                              borderRadius: 12.0,
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                          ),
                        ],

                        // ── EXERCISE NAME (edit only) ──────────────────
                        if (isEdit &&
                            (widget.exercicioNome?.isNotEmpty ?? false))
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate),
                              ),
                              child: Text(
                                widget.exercicioNome!,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),

                        // ── SERIES + REPS ──────────────────────────────
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 0.0, 8.0),
                          child: Text(
                            'Séries',
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
                                ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 4.0, 0.0),
                                child: _buildNumericField(
                                  context,
                                  ctrl: _model.txtSeriesTextController!,
                                  focus: _model.txtSeriesFocusNode!,
                                  hint: '3',
                                  validator: _model
                                      .txtSeriesTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: Text(
                                'de',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 16.0, 0.0),
                                child: _buildNumericField(
                                  context,
                                  ctrl: _model.txtRepetTextController!,
                                  focus: _model.txtRepetFocusNode!,
                                  hint: '15',
                                  validator: _model
                                      .txtRepetTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ── DESCANSO ───────────────────────────────────
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 0.0, 8.0),
                          child: Text(
                            'Descanso',
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
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: (_model.txtDescansoFocusNode?.hasFocus ??
                                        false)
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _model.txtDescansoTextController,
                                    focusNode: _model.txtDescansoFocusNode,
                                    autofocus: false,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 12.0, 12.0, 12.0),
                                      hintText: '60',
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
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
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
                                        ),
                                    maxLength: 4,
                                    buildCounter: (_,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.number,
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+$'))
                                    ],
                                    validator: _model
                                        .txtDescansoTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 12.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4.0, 0.0, 4.0, 0.0),
                                      child: Text(
                                        'segundos',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ── OBSERVAÇÃO ─────────────────────────────────
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 0.0, 8.0),
                          child: Text(
                            'Observação',
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
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: TextFormField(
                            controller: _model.txtObsTextController,
                            focusNode: _model.txtObsFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      12.0, 12.0, 12.0, 12.0),
                              hintText: 'Opcional...',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
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
                                ),
                            maxLines: null,
                            minLines: 2,
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),

                        // ── AQUECIMENTO (toggle) ──────────────────────
                        if (_model.aquecimento)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).alternate,
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 8.0,
                                          height: 8.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              'Aquecimento',
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
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            safeSetState(() {
                                              _model.txtSeriesAqueTextController
                                                  ?.clear();
                                              _model.txtRepetAqueTextController
                                                  ?.clear();
                                            });
                                            if (animationsMap[
                                                    'containerOnActionTriggerAnimation2'] !=
                                                null) {
                                              await animationsMap[
                                                      'containerOnActionTriggerAnimation2']!
                                                  .controller
                                                  .reverse();
                                            }
                                            _model.aquecimento = false;
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 20.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 0.5,
                                    thickness: 0.5,
                                    indent: 16.0,
                                    endIndent: 16.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 0.0, 8.0),
                                    child: Text(
                                      'Séries',
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
                                                .primaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 0.0, 4.0, 0.0),
                                            child: _buildNumericField(
                                              context,
                                              ctrl: _model
                                                  .txtSeriesAqueTextController!,
                                              focus: _model
                                                  .txtSeriesAqueFocusNode!,
                                              hint: '1',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                          child: Text(
                                            'de',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4.0, 0.0, 16.0, 0.0),
                                            child: _buildNumericField(
                                              context,
                                              ctrl: _model
                                                  .txtRepetAqueTextController!,
                                              focus:
                                                  _model.txtRepetAqueFocusNode!,
                                              hint: '15',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animateOnActionTrigger(
                                animationsMap[
                                    'containerOnActionTriggerAnimation2']!,
                                hasBeenTriggered: hasContainerTriggered2),
                          ),

                        // ── ADD WARMUP BUTTON ──────────────────────────
                        if (!_model.aquecimento)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (animationsMap[
                                        'containerOnActionTriggerAnimation2'] !=
                                    null) {
                                  safeSetState(
                                      () => hasContainerTriggered2 = true);
                                  SchedulerBinding.instance.addPostFrameCallback(
                                      (_) async => await animationsMap[
                                              'containerOnActionTriggerAnimation2']!
                                          .controller
                                          .forward(from: 0.0));
                                }
                                _model.aquecimento = true;
                                safeSetState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 38.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 18.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      'Adicionar aquecimento',
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
                                                .primary,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ].addToEnd(const SizedBox(height: 16.0)),
                    ),
                  ),
                ),
              ),
            ).animateOnActionTrigger(
              animationsMap['containerOnActionTriggerAnimation1']!,
              hasBeenTriggered: hasContainerTriggered1,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
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
                  _model.valido = true;
                  if (!_model.formKey.currentState!.validate()) {
                    _model.valido = false;
                  }
                  if (!isEdit && _model.dpExerciciosValue == null) {
                    _model.valido = false;
                  }

                  if (!_model.valido) return;

                  final s = int.tryParse(
                      _model.txtSeriesTextController?.text.trim() ?? '');
                  final r = int.tryParse(
                      _model.txtRepetTextController?.text.trim() ?? '');
                  final d = int.tryParse(
                      _model.txtDescansoTextController?.text.trim() ?? '');
                  final sa = int.tryParse(
                      _model.txtSeriesAqueTextController?.text.trim() ?? '');
                  final ra = int.tryParse(
                      _model.txtRepetAqueTextController?.text.trim() ?? '');
                  final obs = _model.txtObsTextController?.text.trim() ?? '';

                  if (isEdit) {
                    await SupaFlow.client.from('ExerciciosTreinos').update({
                      'SerieExecucao': s,
                      'RepeticaoExecucao': r,
                      'SerieAquecimento': sa,
                      'RepeticaoAquecimento': ra,
                      'TempoDescansoSegundos': d,
                      'Observacao': obs.isEmpty ? null : obs,
                    }).eq('Id', widget.etId!);
                  } else {
                    await SupaFlow.client.from('ExerciciosTreinos').insert({
                      'TreinosId': widget.treinoId,
                      'ExerciciosId': _model.dpExerciciosValue,
                      'SerieExecucao': s,
                      'RepeticaoExecucao': r,
                      if (sa != null) 'SerieAquecimento': sa,
                      if (ra != null) 'RepeticaoAquecimento': ra,
                      if (d != null) 'TempoDescansoSegundos': d,
                      if (obs.isNotEmpty) 'Observacao': obs,
                      'Ordem': widget.nextOrdem ?? 1,
                    });
                  }

                  await _fecharComAnimacao();
                  if (!mounted) return;
                  Navigator.pop(context, true);
                },
              ).animateOnActionTrigger(
                  animationsMap['iconButtonOnActionTriggerAnimation1']!,
                  hasBeenTriggered: hasIconButtonTriggered1),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
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
                  await _fecharComAnimacao();
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ).animateOnActionTrigger(
                  animationsMap['iconButtonOnActionTriggerAnimation2']!,
                  hasBeenTriggered: hasIconButtonTriggered2),
            ),
          ],
        ),
      ]
          .divide(const SizedBox(height: 16.0))
          .addToStart(const SizedBox(height: 40.0))
          .addToEnd(const SizedBox(height: 40.0)),
    );
  }

  Widget _buildNumericField(
    BuildContext context, {
    required TextEditingController ctrl,
    required FocusNode focus,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      focusNode: focus,
      autofocus: false,
      textInputAction: TextInputAction.next,
      obscureText: false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
        hintText: hint,
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
      maxLength: 3,
      buildCounter:
          (_, {required currentLength, required isFocused, maxLength}) => null,
      keyboardType: TextInputType.number,
      cursorColor: FlutterFlowTheme.of(context).primaryText,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+$'))],
      validator: validator,
    );
  }
}

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'substituir_exercicio_model.dart';
export 'substituir_exercicio_model.dart';

class SubstituirExercicioWidget extends StatefulWidget {
  const SubstituirExercicioWidget({
    super.key,
    required this.execucaoId,
    required this.nomeOriginal,
  });

  final int execucaoId;
  final String nomeOriginal;

  @override
  State<SubstituirExercicioWidget> createState() =>
      _SubstituirExercicioWidgetState();
}

class _SubstituirExercicioWidgetState extends State<SubstituirExercicioWidget>
    with TickerProviderStateMixin {
  late SubstituirExercicioModel _model;

  var hasCardTriggered = false;
  var hasBtn1Triggered = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubstituirExercicioModel());

    animationsMap.addAll({
      'cardOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
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
      'closeButtonOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 650.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 650.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 100.0),
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

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if (animationsMap['cardOnActionTriggerAnimation'] != null) {
            safeSetState(() => hasCardTriggered = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['cardOnActionTriggerAnimation']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
        Future(() async {
          if (animationsMap['closeButtonOnActionTriggerAnimation'] != null) {
            safeSetState(() => hasBtn1Triggered = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['closeButtonOnActionTriggerAnimation']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
      ]);
      await _carregar();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _fechar([String? result]) async {
    await Future.wait([
      Future(() async {
        if (animationsMap['cardOnActionTriggerAnimation'] != null) {
          await animationsMap['cardOnActionTriggerAnimation']!
              .controller
              .reverse();
        }
      }),
      Future(() async {
        if (animationsMap['closeButtonOnActionTriggerAnimation'] != null) {
          await animationsMap['closeButtonOnActionTriggerAnimation']!
              .controller
              .reverse();
        }
      }),
    ]);
    if (mounted) Navigator.pop(context, result);
  }

  Future<void> _carregar() async {
    safeSetState(() => _model.isLoading = true);

    final result = await AlunoGroup.getSubstitutosExercicioCall.call(
      pExecucaoId: widget.execucaoId,
    );

    if (!mounted) return;

    if (result.succeeded) {
      try {
        final raw = result.jsonBody;
        final list = raw is List ? raw : [];
        _model.substitutos =
            list.map((e) => e as Map<String, dynamic>).toList();
      } catch (_) {
        _model.substitutos = [];
      }
    }

    safeSetState(() => _model.isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ───────────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: theme.accent1,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Substituir exercício',
                                      style: theme.bodyMedium.override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: theme.bodyMedium.fontStyle,
                                        ),
                                        color: theme.primaryText,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      widget.nomeOriginal,
                                      style: theme.bodyMedium.override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: theme.bodyMedium.fontStyle,
                                        ),
                                        color: theme.secondaryText,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                FFIcons.kproperty1FiRrRefresh,
                                color: theme.primary,
                                size: 18.0,
                              ),
                            ].divide(const SizedBox(width: 8.0)),
                          ),
                        ),
                      ),

                      // ── Conteúdo ─────────────────────────────────────
                      if (_model.isLoading)
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child:
                              CircularProgressIndicator(color: theme.primary),
                        )
                      else if (_model.substitutos.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text(
                            'Não há substitutos disponíveis para este exercício.',
                            textAlign: TextAlign.center,
                            style: theme.bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: theme.bodyMedium.fontWeight,
                                fontStyle: theme.bodyMedium.fontStyle,
                              ),
                              color: theme.secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        )
                      else
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.48,
                          ),
                          child: SingleChildScrollView(
                            child: ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: _model.substitutos.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1.0,
                                thickness: 1.0,
                                indent: 16.0,
                                endIndent: 16.0,
                                color: theme.alternate,
                              ),
                              itemBuilder: (_, index) {
                                final s = _model.substitutos[index];
                                final nome = s['descricao'] as String? ?? '';
                                return InkWell(
                                  onTap: () => _fechar(nome),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 14.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36.0,
                                          height: 36.0,
                                          decoration: BoxDecoration(
                                            color: theme.accent1,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0.0, 0.0),
                                            child: Icon(
                                              FFIcons.kproperty1FiRrRefresh,
                                              color: theme.primary,
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: Text(
                                            nome,
                                            style: theme.bodyMedium.override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    theme.bodyMedium.fontStyle,
                                              ),
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: theme.secondaryText,
                                          size: 18.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ).animateOnActionTrigger(
                animationsMap['cardOnActionTriggerAnimation']!,
                hasBeenTriggered: hasCardTriggered,
              ),
            ),
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
              onPressed: () => _fechar(null),
            ).animateOnActionTrigger(
              animationsMap['closeButtonOnActionTriggerAnimation']!,
              hasBeenTriggered: hasBtn1Triggered,
            ),
          ),
        ]
            .divide(const SizedBox(height: 16.0))
            .addToStart(const SizedBox(height: 40.0))
            .addToEnd(const SizedBox(height: 40.0)),
      ),
    );
  }
}

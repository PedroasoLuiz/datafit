import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import '/components/video_exercicio.dart';
import '/backend/supabase/storage/storage.dart';
import '/flutter_flow/upload_data.dart';
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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'novo_exercicio_model.dart';
export 'novo_exercicio_model.dart';

class NovoExercicioWidget extends StatefulWidget {
  const NovoExercicioWidget({
    super.key,
    this.exercicioId,
    this.nomeInicial,
    this.subcatIdInicial,
    this.linkInicial,
  });

  final int? exercicioId;
  final String? nomeInicial;
  final int? subcatIdInicial;
  final String? linkInicial;

  @override
  State<NovoExercicioWidget> createState() => _NovoExercicioWidgetState();
}

class _NovoExercicioWidgetState extends State<NovoExercicioWidget>
    with TickerProviderStateMixin {
  late NovoExercicioModel _model;

  /// Envio do video do exercicio para o bucket `Videos`.
  ///
  /// O caminho comeca com o uid porque a politica de storage exige isso: sem
  /// a pasta do dono, um personal poderia sobrescrever o video de outro.
  bool _enviandoVideo = false;

  Future<void> _enviarVideo() async {
    if (_enviandoVideo) return;

    final selecionados = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: currentUserUid,
      allowPhoto: false,
      allowVideo: true,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      textColor: FlutterFlowTheme.of(context).primaryText,
    );
    if (selecionados == null || selecionados.isEmpty) return;

    safeSetState(() => _enviandoVideo = true);
    try {
      final urls = await uploadSupabaseStorageFiles(
        bucketName: 'Videos',
        selectedFiles: selecionados,
      );
      final url = urls.firstOrNull;
      if (!mounted) return;
      safeSetState(() {
        _enviandoVideo = false;
        if (url != null && url.isNotEmpty) {
          _model.txtLinkTextController?.text = url;
        }
      });
      if (url == null || url.isEmpty) {
        await _avisar('Nao consegui enviar o video. Tente outro arquivo.');
      }
    } catch (_) {
      if (!mounted) return;
      safeSetState(() => _enviandoVideo = false);
      // O limite do bucket e 100 MB; acima disso o storage recusa.
      await _avisar(
          'Nao consegui enviar o video. Veja se ele tem menos de 100 MB.');
    }
  }

  Future<void> _avisar(String texto) async {
    await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => MensagemWidget(
        texto: texto,
        tipo: '2',
        action: () async {},
        fechasozinho: true,
        mostrabotoes: false,
      ),
    );
  }

  var hasContainerTriggered = false;
  var hasIconButtonTriggered1 = false;
  var hasIconButtonTriggered2 = false;
  final animationsMap = <String, AnimationInfo>{};

  List<SubcatOption> _subcats = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovoExercicioModel());

    _model.txtNomeTextController ??=
        TextEditingController(text: widget.nomeInicial ?? '');
    _model.txtNomeFocusNode ??= FocusNode();

    _model.txtLinkTextController ??=
        TextEditingController(text: widget.linkInicial ?? '');
    _model.txtLinkFocusNode ??= FocusNode();

    _model.columnController ??= ScrollController();

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

    // Carregamento de subcats separado das animações para não interferir no timing
    _carregarSubcats();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _carregarSubcats() async {
    try {
      final rows = await SupaFlow.client
          .from('SubCategoriasTrabalhadas')
          .select('Id, Descricao')
          .order('Descricao', ascending: true);
      final list = (rows as List)
          .map((r) => SubcatOption(
                id: (r['Id'] as num).toInt(),
                nome: r['Descricao'] as String? ?? '',
              ))
          .toList();
      if (mounted) safeSetState(() => _subcats = list);
    } catch (_) {}
  }

  Future<void> _fecharComAnimacao() async {
    await Future.wait([
      Future(() async {
        if (animationsMap['containerOnActionTriggerAnimation'] != null) {
          await animationsMap['containerOnActionTriggerAnimation']!
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
        if (animationsMap['iconButtonOnActionTriggerAnimation1'] != null) {
          await animationsMap['iconButtonOnActionTriggerAnimation1']!
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

    final isEdit = widget.exercicioId != null;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
                    // ── HEADER ────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent1,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                isEdit ? 'Editar exercício' : 'Novo exercício',
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
                                    ),
                              ),
                            ),
                            Icon(
                              Icons.fitness_center_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 18.0,
                            ),
                          ].divide(const SizedBox(width: 8.0)),
                        ),
                      ),
                    ),

                    // ── NOME ──────────────────────────────────────
                    _buildLabel(context, 'Nome do exercício'),
                    _buildTextField(
                      context,
                      controller: _model.txtNomeTextController!,
                      focusNode: _model.txtNomeFocusNode!,
                      hint: 'Ex: Supino reto com barra',
                      autofocus: true,
                    ),

                    // ── SUBCATEGORIA ───────────────────────────────
                    _buildLabel(context, 'Grupo muscular (opcional)'),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      child: FlutterFlowDropDown<int>(
                        controller: _model.subcatController ??=
                            FormFieldController<int>(
                                widget.subcatIdInicial ?? 0),
                        options: [0, ..._subcats.map((s) => s.id)],
                        optionLabels: [
                          'Nenhum',
                          ..._subcats.map((s) => s.nome),
                        ],
                        onChanged: (val) => safeSetState(
                            () => _model.subcatController!.value = val),
                        width: double.infinity,
                        height: 48.0,
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
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                        hintText: 'Selecionar grupo...',
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24.0,
                        ),
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        elevation: 2.0,
                        borderColor: FlutterFlowTheme.of(context).alternate,
                        borderWidth: 1.0,
                        borderRadius: 12.0,
                        margin: const EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        hidesUnderline: true,
                        isOverButton: false,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                    ),

                    // ── VIDEO ─────────────────────────────────────
                    // Enviar pelo app e o caminho principal. O campo de link
                    // continua abaixo porque 22 exercicios ja apontam para o
                    // YouTube e seguem validos.
                    _buildLabel(context, 'Vídeo de demonstração (opcional)'),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 4.0, 0.0, 0.0),
                      child: Material(
                        color: FlutterFlowTheme.of(context).accent1,
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: _enviandoVideo ? null : _enviarVideo,
                          child: Container(
                            width: double.infinity,
                            height: 46.0,
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: _enviandoVideo
                                ? SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.videocam_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 18.0,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        ehVideoDaPlataforma(_model
                                                .txtLinkTextController?.text)
                                            ? 'Trocar vídeo'
                                            : 'Enviar vídeo',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    if (ehVideoDaPlataforma(_model.txtLinkTextController?.text))
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 8.0, 0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: PlayerVideoPlataforma(
                            url: _model.txtLinkTextController!.text,
                          ),
                        ),
                      ),

                    // ── LINK ──────────────────────────────────────
                    _buildLabel(context, 'ou link do YouTube (opcional)'),
                    _buildTextField(
                      context,
                      controller: _model.txtLinkTextController!,
                      focusNode: _model.txtLinkFocusNode!,
                      hint: 'https://youtube.com/...',
                    ),
                  ].addToEnd(const SizedBox(height: 16.0)),
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
                  final nome = _model.txtNomeTextController?.text.trim() ?? '';
                  if (nome.isEmpty) return;

                  // Validar nome duplicado
                  final existentes = await SupaFlow.client
                      .from('Exercicios')
                      .select('Id')
                      .or('CriadorPerfisId.is.null,CriadorPerfisId.eq.$currentUserUid')
                      .or('IsDeleted.is.null,IsDeleted.eq.false')
                      .ilike('Descricao', nome);
                  final duplicatas =
                      List<Map<String, dynamic>>.from(existentes as List);
                  if (isEdit) {
                    duplicatas.removeWhere(
                        (e) => (e['Id'] as num).toInt() == widget.exercicioId);
                  }
                  if (duplicatas.isNotEmpty) {
                    if (!mounted) return;
                    await showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      builder: (ctx) => Padding(
                        padding: MediaQuery.viewInsetsOf(ctx),
                        child: MensagemWidget(
                          texto: 'Já existe um exercício com este nome',
                          tipo: '2',
                          fechasozinho: true,
                          mostrabotoes: false,
                          action: () async {},
                        ),
                      ),
                    );
                    return;
                  }

                  final link = _model.txtLinkTextController?.text.trim();
                  final rawSubcat = _model.subcatController?.value ?? 0;
                  final subcatId = rawSubcat > 0 ? rawSubcat : null;

                  if (isEdit) {
                    await SupaFlow.client.from('Exercicios').update({
                      'Descricao': nome,
                      'SubCategoriasTrabalhadasId': subcatId,
                      'LinkInstrucao':
                          (link != null && link.isNotEmpty) ? link : null,
                    }).eq('Id', widget.exercicioId!);
                  } else {
                    await SupaFlow.client.from('Exercicios').insert({
                      'Descricao': nome,
                      'CriadorPerfisId': currentUserUid,
                      if (subcatId != null)
                        'SubCategoriasTrabalhadasId': subcatId,
                      if (link != null && link.isNotEmpty)
                        'LinkInstrucao': link,
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

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 8.0),
      child: Text(
        text,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    bool autofocus = false,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        obscureText: false,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
          hintText: hint,
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14.0,
                letterSpacing: 0.0,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
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
        cursorColor: FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }
}

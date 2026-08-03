import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selecionar_treino_aluno_model.dart';
export 'selecionar_treino_aluno_model.dart';

class SelecionarTreinoAlunoWidget extends StatefulWidget {
  const SelecionarTreinoAlunoWidget({
    super.key,
    required this.alunoUuid,
    required this.grupoTreinoIdAtual,
    this.dataValidadeAtual,
  });

  final String alunoUuid;
  final int grupoTreinoIdAtual;
  final String? dataValidadeAtual;

  @override
  State<SelecionarTreinoAlunoWidget> createState() =>
      _SelecionarTreinoAlunoWidgetState();
}

class _SelecionarTreinoAlunoWidgetState
    extends State<SelecionarTreinoAlunoWidget> with TickerProviderStateMixin {
  late SelecionarTreinoAlunoModel _model;

  var hasCardTriggered = false;
  var hasCloseTriggered = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecionarTreinoAlunoModel());

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
            safeSetState(() => hasCloseTriggered = true);
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

  Future<void> _fechar([bool result = false]) async {
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

    final execPendente = await SupaFlow.client
        .from('TreinosExecucao')
        .select('Id')
        .eq('ExecutorPerfisId', widget.alunoUuid)
        .eq('Status', 'pendente')
        .or('IsDeleted.is.null,IsDeleted.eq.false')
        .limit(1);

    if (!mounted) return;

    if ((execPendente as List).isNotEmpty) {
      final execId = execPendente.first['Id'];
      final sessaoAtiva = await SupaFlow.client
          .from('TreinosConclusao')
          .select('Id')
          .eq('TreinosExecucaoId', execId)
          .eq('IsTreinoConcluido', false)
          .limit(1);

      if (!mounted) return;

      if ((sessaoAtiva as List).isNotEmpty) {
        safeSetState(() {
          _model.emExecucao = true;
          _model.isLoading = false;
        });
        return;
      }
    }

    final result = await PersonalGroup.getTreinosPersonalCall.call(
      pPersonalUuid: currentUserUid,
    );

    if (!mounted) return;

    if (result.succeeded) {
      try {
        final raw = result.jsonBody;
        final list = raw is List ? raw : [raw];
        _model.treinos = list
            .map((e) => GrupostreinosStruct.maybeFromMap(e))
            .whereType<GrupostreinosStruct>()
            .where((t) => t.ativo)
            .toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));
      } catch (_) {
        _model.treinos = [];
      }
    }

    safeSetState(() => _model.isLoading = false);
  }

  Future<void> _selecionar(GrupostreinosStruct treino) async {
    DateTime defaultDate = DateTime.now().add(const Duration(days: 30));
    final dv = widget.dataValidadeAtual;
    if (dv != null && dv.isNotEmpty) {
      try {
        final parsed = DateTime.parse(dv);
        if (parsed.isAfter(DateTime.now())) defaultDate = parsed;
      } catch (_) {}
    }

    final pickedDate = await custom_widgets.showCustomDatePicker(
      context,
      initialDate: defaultDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2099),
    );
    if (!mounted || pickedDate == null) return;

    safeSetState(() => _model.isLoading = true);
    final dateStr =
        '${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    try {
      final raw =
          await SupaFlow.client.rpc('atribuir_grupo_treino_aluno', params: {
        'p_personal_uuid': currentUserUid,
        'p_aluno_uuid': widget.alunoUuid,
        'p_grupo_treino_id': treino.grupoTreinoId,
        'p_data_validade': dateStr,
      });
      if (!mounted) return;
      final resultData = (raw is List && raw.isNotEmpty) ? raw.first : raw;
      final sucesso = resultData is Map && resultData['sucesso'] == true;
      if (sucesso) {
        Navigator.pop(context, true);
      } else {
        final msg = resultData is Map
            ? (resultData['mensagem'] ?? 'Erro ao atribuir treino.')
            : 'Erro ao atribuir treino.';
        safeSetState(() => _model.isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg.toString()),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ));
      }
    } catch (_) {
      if (!mounted) return;
      safeSetState(() => _model.isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Erro ao atribuir treino.'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final filtrados = _model.treinosFiltrados;
    final visiveis = filtrados.length.clamp(0, _model.itemsVisiveis);
    final temMais = filtrados.length > _model.itemsVisiveis;

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
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──────────────────────────────────────
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
                              child: Text(
                                'Selecionar Treino',
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
                            ),
                            Icon(
                              FFIcons.kproperty1FiRrGym,
                              color: theme.primary,
                              size: 18.0,
                            ),
                          ].divide(const SizedBox(width: 8.0)),
                        ),
                      ),
                    ),

                    // ── Campo de busca ───────────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
                      child: TextFormField(
                        controller: _model.buscaController,
                        focusNode: _model.buscaFocusNode,
                        onChanged: (v) => safeSetState(() {
                          _model.buscaTexto = v;
                          _model.itemsVisiveis = 10;
                        }),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Buscar treino...',
                          hintStyle: theme.labelMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontStyle: theme.labelMedium.fontStyle,
                            ),
                            color: theme.secondaryText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: theme.secondaryText,
                            size: 18.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.alternate, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.primary, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: theme.primaryBackground,
                          contentPadding:
                              const EdgeInsetsDirectional.fromSTEB(
                                  12.0, 10.0, 12.0, 10.0),
                        ),
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
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
                    else if (_model.emExecucao)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 28.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_clock_outlined,
                                color: theme.warning, size: 36.0),
                            const SizedBox(height: 12.0),
                            Text(
                              'O aluno está executando um treino.',
                              textAlign: TextAlign.center,
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: theme.bodyMedium.fontStyle),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Aguarde ele concluir para trocar.',
                              textAlign: TextAlign.center,
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: theme.bodyMedium.fontWeight,
                                    fontStyle: theme.bodyMedium.fontStyle),
                                color: theme.secondaryText,
                                fontSize: 13.0,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (filtrados.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          _model.buscaTexto.isEmpty
                              ? 'Nenhum treino criado ainda.'
                              : 'Nenhum treino encontrado.',
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
                              MediaQuery.of(context).size.height * 0.45,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: visiveis,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1.0,
                                  thickness: 1.0,
                                  indent: 68.0,
                                  endIndent: 16.0,
                                  color: theme.alternate,
                                ),
                                itemBuilder: (_, index) {
                                  final treino = filtrados[index];
                                  final selecionado = treino.grupoTreinoId ==
                                      widget.grupoTreinoIdAtual;
                                  final count =
                                      treino.subagrupamentos.length;
                                  final displayName = treino.nome.isNotEmpty
                                      ? treino.nome
                                      : 'Treino sem nome';

                                  return InkWell(
                                    onTap: selecionado
                                        ? null
                                        : () => _selecionar(treino),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 14.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color: selecionado
                                                  ? theme.primary
                                                  : theme.accent1,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                              child: Icon(
                                                selecionado
                                                    ? Icons.check_rounded
                                                    : FFIcons
                                                        .kproperty1FiRrGym,
                                                color: selecionado
                                                    ? Colors.white
                                                    : theme.primary,
                                                size: 20.0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12.0),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  displayName,
                                                  style: theme.bodyMedium
                                                      .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle: theme
                                                          .bodyMedium
                                                          .fontStyle,
                                                    ),
                                                    color: selecionado
                                                        ? theme.primary
                                                        : theme.primaryText,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                if (count > 0)
                                                  Text(
                                                    '$count sub-treino${count > 1 ? 's' : ''}',
                                                    style: theme.bodyMedium
                                                        .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight: theme
                                                            .bodyMedium
                                                            .fontWeight,
                                                        fontStyle: theme
                                                            .bodyMedium
                                                            .fontStyle,
                                                      ),
                                                      color:
                                                          theme.secondaryText,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                                  ),
                                              ].divide(
                                                  const SizedBox(height: 2.0)),
                                            ),
                                          ),
                                          if (selecionado)
                                            Icon(
                                                Icons
                                                    .radio_button_checked_rounded,
                                                color: theme.primary,
                                                size: 18.0)
                                          else
                                            Icon(
                                                Icons.radio_button_off_rounded,
                                                color: theme.secondaryText,
                                                size: 18.0),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (temMais)
                                InkWell(
                                  onTap: () => safeSetState(
                                      () => _model.itemsVisiveis += 10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0),
                                    child: Text(
                                      'Ver mais (${filtrados.length - _model.itemsVisiveis} restantes)',
                                      style: theme.bodyMedium.override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              theme.bodyMedium.fontStyle,
                                        ),
                                        color: theme.primary,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ).animateOnActionTrigger(
            animationsMap['cardOnActionTriggerAnimation']!,
            hasBeenTriggered: hasCardTriggered,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
          child: FlutterFlowIconButton(
            borderRadius: 20.0,
            buttonSize: 56.0,
            fillColor: theme.secondaryBackground,
            icon: Icon(
              FFIcons.kproperty1FiRrCrossSmall,
              color: theme.secondaryText,
              size: 24.0,
            ),
            onPressed: _fechar,
          ).animateOnActionTrigger(
            animationsMap['closeButtonOnActionTriggerAnimation']!,
            hasBeenTriggered: hasCloseTriggered,
          ),
        ),
      ]
          .divide(const SizedBox(height: 16.0))
          .addToStart(const SizedBox(height: 40.0))
          .addToEnd(const SizedBox(height: 40.0)),
    );
  }
}

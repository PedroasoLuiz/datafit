import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'treinos_novo_exercicio_treino_model.dart';
export 'treinos_novo_exercicio_treino_model.dart';

class TreinosNovoExercicioTreinoWidget extends StatefulWidget {
  const TreinosNovoExercicioTreinoWidget({
    super.key,
    required this.treinoId,
    this.nextOrdem,
    // Modo edição: com `etId` o formulário nasce preenchido e grava por update.
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
    extends State<TreinosNovoExercicioTreinoWidget> {
  late TreinosNovoExercicioTreinoModel _model;

  bool get _ehEdicao => widget.etId != null;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosNovoExercicioTreinoModel());

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

    // Aquecimento ja preenchido nasce a mostra: escondido atras do botao de
    // adicionar, ele parecia vazio numa ficha que ja tinha os numeros.
    _model.aquecimento =
        _ehEdicao && (widget.seriesAque != null || widget.repsAque != null);

    if (!_ehEdicao) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) async => _carregarExercicios());
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _carregarExercicios() async {
    try {
      _model.apiResultdup = await TreinoGroup.getExerciciosCall
          .call(personalUuid: currentUserUid);

      final corpo = _model.apiResultdup?.jsonBody;
      if (_model.apiResultdup?.succeeded == true && corpo is List) {
        _model.exercicios = corpo
            .map<ExerciciossimplyStruct?>(ExerciciossimplyStruct.maybeFromMap)
            .whereType<ExerciciossimplyStruct>()
            .toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));
      }
    } catch (_) {}

    if (mounted) safeSetState(() {});
  }

  int? _numero(TextEditingController? c) => int.tryParse(c?.text.trim() ?? '');

  Future<Object?> _gravar() async {
    // Sem exercicio escolhido nao ha o que inserir. Na edicao ele ja esta
    // definido e nao se troca por aqui.
    if (!_ehEdicao && _model.dpExerciciosValue == null) return null;

    final series = _numero(_model.txtSeriesTextController);
    final reps = _numero(_model.txtRepetTextController);
    final descanso = _numero(_model.txtDescansoTextController);
    final obs = _model.txtObsTextController?.text.trim() ?? '';

    // Aquecimento desligado limpa os numeros: deixa-los gravados faria a
    // ficha do aluno mostrar um aquecimento que o personal acabou de tirar.
    final seriesAque =
        _model.aquecimento ? _numero(_model.txtSeriesAqueTextController) : null;
    final repsAque =
        _model.aquecimento ? _numero(_model.txtRepetAqueTextController) : null;

    if (_ehEdicao) {
      await SupaFlow.client.from('ExerciciosTreinos').update({
        'SerieExecucao': series,
        'RepeticaoExecucao': reps,
        'SerieAquecimento': seriesAque,
        'RepeticaoAquecimento': repsAque,
        'TempoDescansoSegundos': descanso,
        'Observacao': obs.isEmpty ? null : obs,
      }).eq('Id', widget.etId!);
    } else {
      await SupaFlow.client.from('ExerciciosTreinos').insert({
        'TreinosId': widget.treinoId,
        'ExerciciosId': _model.dpExerciciosValue,
        'SerieExecucao': series,
        'RepeticaoExecucao': reps,
        if (seriesAque != null) 'SerieAquecimento': seriesAque,
        if (repsAque != null) 'RepeticaoAquecimento': repsAque,
        'TempoDescansoSegundos': descanso,
        if (obs.isNotEmpty) 'Observacao': obs,
        'Ordem': widget.nextOrdem ?? 1,
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final apenasDigitos = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ];

    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        CabecaFolha(
          titulo: _ehEdicao ? 'Editar exercício' : 'Novo exercício',
          apoio: _ehEdicao
              ? widget.exercicioNome
              : 'Escolha o exercício e como ele deve ser feito.',
          icone: FFIcons.kproperty1FiRrGym,
        ),
        if (!_ehEdicao)
          DropFolha<int>(
            primeiro: true,
            rotulo: 'Exercício',
            dica: 'Selecione...',
            controlador: _model.dpExerciciosValueController ??=
                FormFieldController<int>(_model.dpExerciciosValue),
            opcoes: List<int>.from(_model.exercicios.map((e) => e.id)),
            rotulos: _model.exercicios.map((e) => e.nome).toList(),
            preenchido: _model.dpExerciciosValue != null,
            aoMudar: (valor) =>
                safeSetState(() => _model.dpExerciciosValue = valor),
          ),
        LinhaCamposFolha(
          primeiro: _ehEdicao,
          campos: [
            CampoCompacto(
              rotulo: 'Séries',
              dica: '3',
              controlador: _model.txtSeriesTextController,
              foco: _model.txtSeriesFocusNode,
              teclado: TextInputType.number,
              formatadores: apenasDigitos,
            ),
            CampoCompacto(
              rotulo: 'Repetições',
              dica: '12',
              controlador: _model.txtRepetTextController,
              foco: _model.txtRepetFocusNode,
              teclado: TextInputType.number,
              formatadores: apenasDigitos,
            ),
            CampoCompacto(
              rotulo: 'Descanso (s)',
              dica: '60',
              controlador: _model.txtDescansoTextController,
              foco: _model.txtDescansoFocusNode,
              teclado: TextInputType.number,
              formatadores: apenasDigitos,
            ),
          ],
        ),
        ChaveFolha(
          titulo: 'Aquecimento',
          apoio: 'Séries leves antes da carga de trabalho.',
          ligada: _model.aquecimento,
          aoMudar: (liga) => safeSetState(() => _model.aquecimento = liga),
        ),
        if (_model.aquecimento)
          LinhaCamposFolha(
            campos: [
              CampoCompacto(
                rotulo: 'Séries de aquecimento',
                dica: '1',
                controlador: _model.txtSeriesAqueTextController,
                foco: _model.txtSeriesAqueFocusNode,
                teclado: TextInputType.number,
                formatadores: apenasDigitos,
              ),
              CampoCompacto(
                rotulo: 'Repetições',
                dica: '15',
                controlador: _model.txtRepetAqueTextController,
                foco: _model.txtRepetAqueFocusNode,
                teclado: TextInputType.number,
                formatadores: apenasDigitos,
              ),
            ],
          ),
        CampoFolha(
          rotulo: 'Observação',
          dica: 'Opcional...',
          controlador: _model.txtObsTextController,
          foco: _model.txtObsFocusNode,
          linhas: 3,
        ),
      ],
    );
  }
}

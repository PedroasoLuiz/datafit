import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/selecionar_exercicio/selecionar_exercicio_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'alunos_novo_exercicio_model.dart';
export 'alunos_novo_exercicio_model.dart';

class AlunosNovoExercicioWidget extends StatefulWidget {
  const AlunosNovoExercicioWidget({
    super.key,
    required this.grupo,
    required this.treinoExecucaoId,
  });

  final int? grupo;
  final int? treinoExecucaoId;

  @override
  State<AlunosNovoExercicioWidget> createState() =>
      _AlunosNovoExercicioWidgetState();
}

class _AlunosNovoExercicioWidgetState extends State<AlunosNovoExercicioWidget> {
  late AlunosNovoExercicioModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlunosNovoExercicioModel());

    _model.txtSeriesTextController ??= TextEditingController();
    _model.txtSeriesFocusNode ??= FocusNode();

    _model.txtRepetTextController ??= TextEditingController();
    _model.txtRepetFocusNode ??= FocusNode();

    _model.txtDescansoTextController ??= TextEditingController();
    _model.txtDescansoFocusNode ??= FocusNode();

    _model.txtSeriesAqueTextController ??= TextEditingController();
    _model.txtSeriesAqueFocusNode ??= FocusNode();

    _model.txtRepetAqueTextController ??= TextEditingController();
    _model.txtRepetAqueFocusNode ??= FocusNode();

    _model.txtDescricaoTextController ??= TextEditingController();
    _model.txtDescricaoFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  int? _numero(TextEditingController? c) => int.tryParse(c?.text.trim() ?? '');

  Future<void> _escolherExercicio() async {
    final escolhido = await showModalBottomSheet<ExerciciossimplyStruct>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (folha) => Padding(
        padding: MediaQuery.viewInsetsOf(folha),
        child: SelecionarExercicioWidget(
          grupoMuscular: widget.grupo,
          treinoExecucaoId: widget.treinoExecucaoId,
        ),
      ),
    );

    if (escolhido == null || !mounted) return;
    safeSetState(() {
      _model.exercicioSelecionadoId = escolhido.id;
      _model.exercicioSelecionadoNome = escolhido.nome;
    });
  }

  Future<void> _avisar(String texto) async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (folha) => WebViewAware(
        child: MensagemWidget(
          texto: texto,
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: false,
          action: () async {},
        ),
      ),
    );
  }

  Future<Object?> _gravar() async {
    if (_model.exercicioSelecionadoId == null) {
      await _avisar('Selecione um exercício.');
      return null;
    }

    // Aquecimento desligado nao grava numero: deixa-los faria a ficha do
    // aluno mostrar um aquecimento que ninguem pediu.
    final seriesAque =
        _model.aquecimento ? _numero(_model.txtSeriesAqueTextController) : null;
    final repsAque =
        _model.aquecimento ? _numero(_model.txtRepetAqueTextController) : null;

    try {
      // O `TreinosExecucao` aponta para o `Treinos` de origem: o exercicio
      // entra no treino, e nao na execucao, para valer nos proximos ciclos.
      final execucoes = await TreinosExecucaoTable().queryRows(
        queryFn: (q) => q.eq('Id', widget.treinoExecucaoId!),
      );
      final treinosId = execucoes.first.treinosId;

      await ExerciciosTreinosTable().insert({
        'ExerciciosId': _model.exercicioSelecionadoId,
        'TreinosId': treinosId,
        'SerieExecucao': _numero(_model.txtSeriesTextController),
        'RepeticaoExecucao': _numero(_model.txtRepetTextController),
        'TempoDescansoSegundos': _numero(_model.txtDescansoTextController),
        'SerieAquecimento': seriesAque,
        'RepeticaoAquecimento': repsAque,
        'Observacao': _model.txtDescricaoTextController?.text.trim() ?? '',
      });

      return true;
    } catch (_) {
      if (!mounted) return null;
      await _avisar('Erro ao salvar exercício. Tente novamente.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final apenasDigitos = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ];

    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        const CabecaFolha(
          titulo: 'Novo exercício',
          apoio: 'Ele entra no treino e vale para os próximos ciclos.',
          icone: FFIcons.kproperty1FiRrGym,
        ),
        CampoToqueFolha(
          primeiro: true,
          rotulo: 'Exercício',
          vazio: 'Selecione...',
          icone: Icons.search_rounded,
          valor: _model.exercicioSelecionadoNome.isEmpty
              ? null
              : _model.exercicioSelecionadoNome,
          aoTocar: _escolherExercicio,
        ),
        LinhaCamposFolha(
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
          dica: 'Uma orientação para seu aluno...',
          controlador: _model.txtDescricaoTextController,
          foco: _model.txtDescricaoFocusNode,
          linhas: 3,
        ),
      ],
    );
  }
}

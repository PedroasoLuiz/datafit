import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'alunos_edit_exercicio_model.dart';
export 'alunos_edit_exercicio_model.dart';

class AlunosEditExercicioWidget extends StatefulWidget {
  const AlunosEditExercicioWidget({
    super.key,
    required this.exercicio,
  });

  final ExerciciosStruct? exercicio;

  @override
  State<AlunosEditExercicioWidget> createState() =>
      _AlunosEditExercicioWidgetState();
}

class _AlunosEditExercicioWidgetState extends State<AlunosEditExercicioWidget> {
  late AlunosEditExercicioModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlunosEditExercicioModel());

    final ex = widget.exercicio;

    _model.txtSeriesTextController ??=
        TextEditingController(text: ex?.series.toString() ?? '');
    _model.txtSeriesFocusNode ??= FocusNode();

    _model.txtRepetTextController ??=
        TextEditingController(text: ex?.repeticoes.toString() ?? '');
    _model.txtRepetFocusNode ??= FocusNode();

    _model.txtDescansoTextController ??=
        TextEditingController(text: ex?.tempoDescansoSeg.toString() ?? '');
    _model.txtDescansoFocusNode ??= FocusNode();

    _model.txtDescricaoTextController ??=
        TextEditingController(text: ex?.observacao ?? '');
    _model.txtDescricaoFocusNode ??= FocusNode();

    _model.exerc = ex;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  int? _numero(TextEditingController? c) => int.tryParse(c?.text.trim() ?? '');

  Future<Object?> _gravar() async {
    await ExerciciosTreinosTable().update(
      data: {
        'SerieExecucao': _numero(_model.txtSeriesTextController),
        'RepeticaoExecucao': _numero(_model.txtRepetTextController),
        'TempoDescansoSegundos': _numero(_model.txtDescansoTextController),
        'Observacao': _model.txtDescricaoTextController?.text ?? '',
      },
      matchingRows: (linhas) =>
          linhas.eqOrNull('Id', widget.exercicio?.execucaoId),
    );

    return true;
  }

  /// Remover passa pela folha de confirmação.
  ///
  /// O exercício sai do treino do aluno junto com o histórico de séries que
  /// ele já registrou, e não há como desfazer.
  Future<void> _remover() async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (folha) => WebViewAware(
        child: MensagemWidget(
          texto: 'Remover exercício?',
          textoauxiliar: 'Ele sai do treino deste aluno.',
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: true,
          action: () async {
            await ExerciciosExecucaoTable().delete(
              matchingRows: (linhas) =>
                  linhas.eqOrNull('Id', widget.exercicio?.execucaoId),
            );
            if (!mounted) return;
            await FolhaPadrao.fechar(context, true);
          },
        ),
      ),
    );
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
          titulo: 'Editar exercício',
          // O nome do exercicio como apoio: e o que a folha esta editando, e
          // repeti-lo como titulo tiraria o lugar da acao.
          apoio: widget.exercicio?.nome.isNotEmpty == true
              ? widget.exercicio!.nome
              : null,
          icone: FFIcons.kproperty1FiRrGym,
        ),
        LinhaCamposFolha(
          primeiro: true,
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
        CampoFolha(
          rotulo: 'Observação',
          dica: 'Deixe uma orientação para seu aluno aqui...',
          controlador: _model.txtDescricaoTextController,
          foco: _model.txtDescricaoFocusNode,
          linhas: 3,
        ),
        AcaoDestrutivaFolha(texto: 'Remover exercício', aoTocar: _remover),
      ],
    );
  }
}

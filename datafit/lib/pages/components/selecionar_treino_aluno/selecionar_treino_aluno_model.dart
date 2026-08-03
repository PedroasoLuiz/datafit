import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'selecionar_treino_aluno_widget.dart';
export 'selecionar_treino_aluno_widget.dart';

class SelecionarTreinoAlunoModel
    extends FlutterFlowModel<SelecionarTreinoAlunoWidget> {
  List<GrupostreinosStruct> treinos = [];
  bool isLoading = true;
  bool emExecucao = false;

  String buscaTexto = '';
  int itemsVisiveis = 10;

  TextEditingController? buscaController;
  FocusNode? buscaFocusNode;

  List<GrupostreinosStruct> get treinosFiltrados {
    if (buscaTexto.isEmpty) return treinos;
    final q = buscaTexto.toLowerCase();
    return treinos.where((t) => t.nome.toLowerCase().contains(q)).toList();
  }

  @override
  void initState(BuildContext context) {
    buscaController ??= TextEditingController();
    buscaFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    buscaController?.dispose();
    buscaFocusNode?.dispose();
  }
}

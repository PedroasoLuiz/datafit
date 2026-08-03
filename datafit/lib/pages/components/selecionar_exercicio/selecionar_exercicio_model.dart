import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'selecionar_exercicio_widget.dart';
export 'selecionar_exercicio_widget.dart';

class SelecionarExercicioModel
    extends FlutterFlowModel<SelecionarExercicioWidget> {
  List<ExerciciossimplyStruct> exercicios = [];
  bool isLoading = true;
  String buscaTexto = '';
  int itemsVisiveis = 15;

  TextEditingController? buscaController;
  FocusNode? buscaFocusNode;

  List<ExerciciossimplyStruct> get filtrados {
    if (buscaTexto.isEmpty) return exercicios;
    final q = buscaTexto.toLowerCase();
    return exercicios.where((e) => e.nome.toLowerCase().contains(q)).toList();
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

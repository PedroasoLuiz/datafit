import '/flutter_flow/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/navbar/navbar_model.dart';
import '/backend/schema/structs/index.dart';
import 'package:flutter/material.dart';
import 'treinos_personal_widget.dart';
export 'treinos_personal_widget.dart';

class TreinosPersonalModel extends FlutterFlowModel<TreinosPersonalWidget> {
  late NavbarModel navbarModel;

  List<GrupostreinosStruct> treinos = [];
  bool isLoading = true;

  TextEditingController? txtBuscaController;
  FocusNode? txtBuscaFocusNode;

  List<GrupostreinosStruct> get treinosFiltrados {
    final q = txtBuscaController?.text.trim().toLowerCase() ?? '';
    if (q.isEmpty) return treinos;
    return treinos.where((t) => t.nome.toLowerCase().contains(q)).toList();
  }

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    navbarModel.dispose();
    txtBuscaController?.dispose();
    txtBuscaFocusNode?.dispose();
  }
}

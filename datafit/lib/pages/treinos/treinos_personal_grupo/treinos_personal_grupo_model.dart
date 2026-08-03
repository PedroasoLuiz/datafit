import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'treinos_personal_grupo_widget.dart';
export 'treinos_personal_grupo_widget.dart';

class TreinosPersonalGrupoModel
    extends FlutterFlowModel<TreinosPersonalGrupoWidget> {
  bool isLoading = true;

  // Each entry: {'id': int, 'nome': String}
  List<Map<String, dynamic>> subTreinos = [];

  TextEditingController? txtNomeController;
  FocusNode? txtNomeFocusNode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    txtNomeController?.dispose();
    txtNomeFocusNode?.dispose();
  }
}

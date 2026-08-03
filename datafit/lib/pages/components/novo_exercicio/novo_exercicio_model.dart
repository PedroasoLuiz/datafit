import '/flutter_flow/flutter_flow_model.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'novo_exercicio_widget.dart';
export 'novo_exercicio_widget.dart';

class NovoExercicioModel extends FlutterFlowModel<NovoExercicioWidget> {
  TextEditingController? txtNomeTextController;
  FocusNode? txtNomeFocusNode;

  TextEditingController? txtLinkTextController;
  FocusNode? txtLinkFocusNode;

  FormFieldController<int>? subcatController;

  ScrollController? columnController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    txtNomeTextController?.dispose();
    txtNomeFocusNode?.dispose();
    txtLinkTextController?.dispose();
    txtLinkFocusNode?.dispose();
    subcatController?.dispose();
    columnController?.dispose();
  }
}

class SubcatOption {
  final int id;
  final String nome;
  const SubcatOption({required this.id, required this.nome});
}

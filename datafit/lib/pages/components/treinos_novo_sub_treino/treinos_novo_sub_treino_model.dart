import '/flutter_flow/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'treinos_novo_sub_treino_widget.dart';
export 'treinos_novo_sub_treino_widget.dart';

class TreinosNovoSubTreinoModel
    extends FlutterFlowModel<TreinosNovoSubTreinoWidget> {
  TextEditingController? txtNomeTextController;
  FocusNode? txtNomeFocusNode;
  String? Function(BuildContext, String?)? txtNomeTextControllerValidator;

  final ScrollController columnController = ScrollController();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    txtNomeTextController?.dispose();
    txtNomeFocusNode?.dispose();
    columnController.dispose();
  }
}

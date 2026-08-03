import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'completar_perfil_widget.dart' show CompletarPerfilWidget;

class CompletarPerfilModel extends FlutterFlowModel<CompletarPerfilWidget> {
  FocusNode? telefoneFocusNode;
  TextEditingController? telefoneTextController;
  late MaskTextInputFormatter telefoneMask;

  FocusNode? nicknameFocusNode;
  TextEditingController? nicknameTextController;

  FocusNode? pesoFocusNode;
  TextEditingController? pesoTextController;

  FocusNode? alturaFocusNode;
  TextEditingController? alturaTextController;

  FocusNode? cpfFocusNode;
  TextEditingController? cpfTextController;
  late MaskTextInputFormatter cpfMask;

  bool isWhatsapp = true;
  bool isSaving = false;

  @override
  void initState(BuildContext context) {
    telefoneMask = MaskTextInputFormatter(mask: '(##) # ####-####');
    cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  }

  @override
  void dispose() {
    telefoneFocusNode?.dispose();
    telefoneTextController?.dispose();

    nicknameFocusNode?.dispose();
    nicknameTextController?.dispose();

    pesoFocusNode?.dispose();
    pesoTextController?.dispose();

    alturaFocusNode?.dispose();
    alturaTextController?.dispose();

    cpfFocusNode?.dispose();
    cpfTextController?.dispose();
  }
}

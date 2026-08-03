import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'dart:ui';
import '/index.dart';
import 'cadastro_widget.dart' show CadastroWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CadastroModel extends FlutterFlowModel<CadastroWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for senha widget.
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  late bool senhaVisibility;
  String? Function(BuildContext, String?)? senhaTextControllerValidator;
  // State field(s) for confirmar widget.
  FocusNode? confirmarFocusNode;
  TextEditingController? confirmarTextController;
  late bool confirmarVisibility;
  String? Function(BuildContext, String?)? confirmarTextControllerValidator;
  // Stores action output result for [Backend Call - API (usercreate)] action in Button widget.
  ApiCallResponse? resultUserCreate;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    senhaVisibility = false;
    confirmarVisibility = false;
  }

  @override
  void dispose() {
    columnController?.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();

    senhaFocusNode?.dispose();
    senhaTextController?.dispose();

    confirmarFocusNode?.dispose();
    confirmarTextController?.dispose();
  }
}

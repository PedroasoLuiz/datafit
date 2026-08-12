import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'alunos_novo_exercicio_widget.dart' show AlunosNovoExercicioWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AlunosNovoExercicioModel
    extends FlutterFlowModel<AlunosNovoExercicioWidget> {
  ///  Local state fields for this component.

  int? exercicioSelecionadoId;
  String exercicioSelecionadoNome = '';

  bool aquecimento = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Column widget.
  ScrollController? columnController;
  // Stores action output result for [Backend Call - Insert Row] action in btConfirm widget.
  ExerciciosExecucaoRow? inserted;
  // State field(s) for txtDescricao widget.
  FocusNode? txtDescricaoFocusNode;
  TextEditingController? txtDescricaoTextController;
  String? Function(BuildContext, String?)? txtDescricaoTextControllerValidator;
  // State field(s) for txtSeries widget.
  FocusNode? txtSeriesFocusNode;
  TextEditingController? txtSeriesTextController;
  String? Function(BuildContext, String?)? txtSeriesTextControllerValidator;
  String? _txtSeriesTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '3 is required';
    }

    return null;
  }

  // State field(s) for txtRepet widget.
  FocusNode? txtRepetFocusNode;
  TextEditingController? txtRepetTextController;
  String? Function(BuildContext, String?)? txtRepetTextControllerValidator;
  String? _txtRepetTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '15 is required';
    }

    return null;
  }

  // State field(s) for txtDescanso widget.
  FocusNode? txtDescansoFocusNode;
  TextEditingController? txtDescansoTextController;
  String? Function(BuildContext, String?)? txtDescansoTextControllerValidator;
  // State field(s) for txtSeriesAque widget.
  FocusNode? txtSeriesAqueFocusNode;
  TextEditingController? txtSeriesAqueTextController;
  String? Function(BuildContext, String?)? txtSeriesAqueTextControllerValidator;
  // State field(s) for txtRepetAque widget.
  FocusNode? txtRepetAqueFocusNode;
  TextEditingController? txtRepetAqueTextController;
  String? Function(BuildContext, String?)? txtRepetAqueTextControllerValidator;
  // State field(s) for txtLink widget.
  FocusNode? txtLinkFocusNode;
  TextEditingController? txtLinkTextController;
  String? Function(BuildContext, String?)? txtLinkTextControllerValidator;
  // Stores action output result for [Validate Form] action in btConfirm widget.
  bool? valido;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    txtSeriesTextControllerValidator = _txtSeriesTextControllerValidator;
    txtRepetTextControllerValidator = _txtRepetTextControllerValidator;
  }

  @override
  void dispose() {
    columnController?.dispose();
    txtDescricaoFocusNode?.dispose();
    txtDescricaoTextController?.dispose();

    txtSeriesFocusNode?.dispose();
    txtSeriesTextController?.dispose();

    txtRepetFocusNode?.dispose();
    txtRepetTextController?.dispose();

    txtDescansoFocusNode?.dispose();
    txtDescansoTextController?.dispose();

    txtSeriesAqueFocusNode?.dispose();
    txtSeriesAqueTextController?.dispose();

    txtRepetAqueFocusNode?.dispose();
    txtRepetAqueTextController?.dispose();

    txtLinkFocusNode?.dispose();
    txtLinkTextController?.dispose();
  }
}

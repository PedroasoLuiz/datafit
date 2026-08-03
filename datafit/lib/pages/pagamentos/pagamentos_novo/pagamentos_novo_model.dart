import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/components/calendar_picker/calendar_picker_widget.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'pagamentos_novo_widget.dart' show PagamentosNovoWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PagamentosNovoModel extends FlutterFlowModel<PagamentosNovoWidget> {
  ///  Local state fields for this component.

  List<ExerciciossimplyStruct> exercicios = [];
  void addToExercicios(ExerciciossimplyStruct item) => exercicios.add(item);
  void removeFromExercicios(ExerciciossimplyStruct item) =>
      exercicios.remove(item);
  void removeAtIndexFromExercicios(int index) => exercicios.removeAt(index);
  void insertAtIndexInExercicios(int index, ExerciciossimplyStruct item) =>
      exercicios.insert(index, item);
  void updateExerciciosAtIndex(
          int index, Function(ExerciciossimplyStruct) updateFn) =>
      exercicios[index] = updateFn(exercicios[index]);

  bool aquecimento = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for dpPgtos widget.
  String? dpPgtosValue;
  FormFieldController<String>? dpPgtosValueController;
  // State field(s) for dpAlunos widget.
  String? dpAlunosValue;
  FormFieldController<String>? dpAlunosValueController;
  // State field(s) for txtDescricao widget.
  FocusNode? txtDescricaoFocusNode;
  TextEditingController? txtDescricaoTextController;
  String? Function(BuildContext, String?)? txtDescricaoTextControllerValidator;
  // State field(s) for txtValor widget.
  FocusNode? txtValorFocusNode;
  TextEditingController? txtValorTextController;
  String? Function(BuildContext, String?)? txtValorTextControllerValidator;
  String? _txtValorTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '3 is required';
    }

    return null;
  }

  // State field(s) for txtVencimento widget.
  FocusNode? txtVencimentoFocusNode;
  TextEditingController? txtVencimentoTextController;
  String? Function(BuildContext, String?)? txtVencimentoTextControllerValidator;
  // Stores action output result for [Backend Call - API (insert pgto aluno)] action in btConfirm widget.
  ApiCallResponse? inseriu;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    txtValorTextControllerValidator = _txtValorTextControllerValidator;
  }

  @override
  void dispose() {
    columnController?.dispose();
    txtDescricaoFocusNode?.dispose();
    txtDescricaoTextController?.dispose();

    txtValorFocusNode?.dispose();
    txtValorTextController?.dispose();

    txtVencimentoFocusNode?.dispose();
    txtVencimentoTextController?.dispose();
  }
}

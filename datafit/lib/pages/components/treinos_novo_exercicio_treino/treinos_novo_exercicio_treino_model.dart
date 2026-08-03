import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'treinos_novo_exercicio_treino_widget.dart';
export 'treinos_novo_exercicio_treino_widget.dart';

class TreinosNovoExercicioTreinoModel
    extends FlutterFlowModel<TreinosNovoExercicioTreinoWidget> {
  final ScrollController columnController = ScrollController();

  TextEditingController? txtSeriesTextController;
  FocusNode? txtSeriesFocusNode;
  String? Function(BuildContext, String?)? txtSeriesTextControllerValidator;

  TextEditingController? txtRepetTextController;
  FocusNode? txtRepetFocusNode;
  String? Function(BuildContext, String?)? txtRepetTextControllerValidator;

  TextEditingController? txtDescansoTextController;
  FocusNode? txtDescansoFocusNode;
  String? Function(BuildContext, String?)? txtDescansoTextControllerValidator;

  TextEditingController? txtSeriesAqueTextController;
  FocusNode? txtSeriesAqueFocusNode;

  TextEditingController? txtRepetAqueTextController;
  FocusNode? txtRepetAqueFocusNode;

  TextEditingController? txtObsTextController;
  FocusNode? txtObsFocusNode;

  FormFieldController<int>? dpExerciciosValueController;
  int? dpExerciciosValue;

  List<ExerciciossimplyStruct> exercicios = [];
  bool aquecimento = false;
  bool valido = true;
  ApiCallResponse? apiResultdup;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    columnController.dispose();
    txtSeriesTextController?.dispose();
    txtSeriesFocusNode?.dispose();
    txtRepetTextController?.dispose();
    txtRepetFocusNode?.dispose();
    txtDescansoTextController?.dispose();
    txtDescansoFocusNode?.dispose();
    txtSeriesAqueTextController?.dispose();
    txtSeriesAqueFocusNode?.dispose();
    txtRepetAqueTextController?.dispose();
    txtRepetAqueFocusNode?.dispose();
    txtObsTextController?.dispose();
    txtObsFocusNode?.dispose();
  }
}

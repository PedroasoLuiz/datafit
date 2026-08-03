import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/components/empty_aluno_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/alunos/novo_aluno/novo_aluno_widget.dart';
import '/pages/components/navbar/navbar_widget.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'aluno_widget.dart' show AlunoWidget;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class AlunoModel extends FlutterFlowModel<AlunoWidget> {
  ///  Local state fields for this page.

  int menu = 0;

  List<PersonalalunosStruct> alunospersonal = [];
  void addToAlunospersonal(PersonalalunosStruct item) =>
      alunospersonal.add(item);
  void removeFromAlunospersonal(PersonalalunosStruct item) =>
      alunospersonal.remove(item);
  void removeAtIndexFromAlunospersonal(int index) =>
      alunospersonal.removeAt(index);
  void insertAtIndexInAlunospersonal(int index, PersonalalunosStruct item) =>
      alunospersonal.insert(index, item);
  void updateAlunospersonalAtIndex(
          int index, Function(PersonalalunosStruct) updateFn) =>
      alunospersonal[index] = updateFn(alunospersonal[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Bottom Sheet - novoAluno] action in Container widget.
  bool? adicionou;
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    columnController2?.dispose();
    navbarModel.dispose();
  }
}

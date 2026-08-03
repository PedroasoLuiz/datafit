import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/treinos/treinos_detalhes_cardio_edit/treinos_detalhes_cardio_edit_widget.dart';
import '/pages/treinos/treinos_detalhes_cardio_novo/treinos_detalhes_cardio_novo_widget.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'treinos_detalhes_widget.dart' show TreinosDetalhesWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class TreinosDetalhesModel extends FlutterFlowModel<TreinosDetalhesWidget> {
  ///  Local state fields for this page.

  bool treinoIniciado = false;

  int index = 0;

  bool opAtv = false;

  /// Maps execucaoId → nome substituto selecionado nesta sessão.
  Map<int, String> substitutos = {};

  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Stores action output result for [Bottom Sheet - treinosDetalhesCardioEdit] action in Container widget.
  bool? editou;
  // Stores action output result for [Bottom Sheet - treinosDetalhesCardioNovo] action in DashedButton widget.
  bool? add;
  // State field(s) for txtFeedback widget.
  FocusNode? txtFeedbackFocusNode;
  TextEditingController? txtFeedbackTextController;
  String? Function(BuildContext, String?)? txtFeedbackTextControllerValidator;
  // Stores action output result for [Backend Call - API (Salvar Feedback)] action in txtFeedback widget.
  ApiCallResponse? reultFeedback;
  // Stores action output result for [Backend Call - API (iniciarTreino)] action in SlideToConfirm widget.
  ApiCallResponse? apiResult7ye;
  // Stores action output result for [Backend Call - API (iniciarTreino)] action in SlideToConfirm widget.
  ApiCallResponse? apiResult7yeCopy;
  // Stores action output result for [Backend Call - API (iniciarTreino)] action in SlideToConfirm widget.
  ApiCallResponse? subResult;
  // Stores action output result for [Backend Call - API (iniciarTreino)] action in SlideToConfirm widget.
  ApiCallResponse? subserult;
  // Stores action output result for [Backend Call - API (FinalizarTreino)] action in SlideToConfirm widget.
  ApiCallResponse? resultEnd;
  // Stores action output result for [Backend Call - API (iniciarTreino)] action in SlideToConfirm widget.
  ApiCallResponse? apiResult7yeCopy2;
  // Stores action output result for [Backend Call - API (iniciarTreino)] action in SlideToConfirm widget.
  ApiCallResponse? subResult2;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    txtFeedbackFocusNode?.dispose();
    txtFeedbackTextController?.dispose();
  }
}

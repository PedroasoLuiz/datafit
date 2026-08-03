import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'alunos_edit_exercicio_widget.dart' show AlunosEditExercicioWidget;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AlunosEditExercicioModel
    extends FlutterFlowModel<AlunosEditExercicioWidget> {
  ///  Local state fields for this component.

  ExerciciosStruct? exerc;
  void updateExercStruct(Function(ExerciciosStruct) updateFn) {
    updateFn(exerc ??= ExerciciosStruct());
  }

  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for txtSeries widget.
  FocusNode? txtSeriesFocusNode;
  TextEditingController? txtSeriesTextController;
  String? Function(BuildContext, String?)? txtSeriesTextControllerValidator;
  // State field(s) for txtRepet widget.
  FocusNode? txtRepetFocusNode;
  TextEditingController? txtRepetTextController;
  String? Function(BuildContext, String?)? txtRepetTextControllerValidator;
  // State field(s) for txtDescanso widget.
  FocusNode? txtDescansoFocusNode;
  TextEditingController? txtDescansoTextController;
  String? Function(BuildContext, String?)? txtDescansoTextControllerValidator;
  // State field(s) for txtDescricao widget.
  FocusNode? txtDescricaoFocusNode;
  TextEditingController? txtDescricaoTextController;
  String? Function(BuildContext, String?)? txtDescricaoTextControllerValidator;
  // State field(s) for txtLink widget.
  FocusNode? txtLinkFocusNode;
  TextEditingController? txtLinkTextController;
  String? Function(BuildContext, String?)? txtLinkTextControllerValidator;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    columnController?.dispose();
    txtSeriesFocusNode?.dispose();
    txtSeriesTextController?.dispose();

    txtRepetFocusNode?.dispose();
    txtRepetTextController?.dispose();

    txtDescansoFocusNode?.dispose();
    txtDescansoTextController?.dispose();

    txtDescricaoFocusNode?.dispose();
    txtDescricaoTextController?.dispose();

    txtLinkFocusNode?.dispose();
    txtLinkTextController?.dispose();
  }
}

import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'treinos_detalhes_cardio_edit_widget.dart'
    show TreinosDetalhesCardioEditWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TreinosDetalhesCardioEditModel
    extends FlutterFlowModel<TreinosDetalhesCardioEditWidget> {
  ///  Local state fields for this component.

  double distancia = 0.0;

  DateTime? inicio;

  DateTime? fim;

  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for txtDescricao widget.
  final txtDescricaoKey = GlobalKey();
  FocusNode? txtDescricaoFocusNode;
  TextEditingController? txtDescricaoTextController;
  String? txtDescricaoSelectedOption;
  String? Function(BuildContext, String?)? txtDescricaoTextControllerValidator;
  // State field(s) for dpKm widget.
  String? dpKmValue;
  FormFieldController<String>? dpKmValueController;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for txtObs widget.
  FocusNode? txtObsFocusNode;
  TextEditingController? txtObsTextController;
  String? Function(BuildContext, String?)? txtObsTextControllerValidator;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    columnController?.dispose();
    txtDescricaoFocusNode?.dispose();

    txtObsFocusNode?.dispose();
    txtObsTextController?.dispose();
  }
}

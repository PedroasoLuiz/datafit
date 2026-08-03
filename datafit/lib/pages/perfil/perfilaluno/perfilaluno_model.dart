import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/alunos_edit_exercicio/alunos_edit_exercicio_widget.dart';
import '/pages/components/alunos_editar_objetivo/alunos_editar_objetivo_widget.dart';
import '/pages/components/alunos_novo_exercicio/alunos_novo_exercicio_widget.dart';
import '/pages/components/alunos_novo_objetivo/alunos_novo_objetivo_widget.dart';
import '/pages/perfil/perfil_aluno_status/perfil_aluno_status_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'perfilaluno_widget.dart' show PerfilalunoWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PerfilalunoModel extends FlutterFlowModel<PerfilalunoWidget> {
  ///  Local state fields for this page.

  int? menu = 0;

  String? indexexercicios;

  String? data;

  bool isLoading = true;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Stores action output result for [Bottom Sheet - alunosEditExercicio] action in Icon widget.
  bool? editou;
  // Stores action output result for [Bottom Sheet - alunosNovoExercicio] action in DashedButton widget.
  bool? editou1;
  // State field(s) for Column widget.
  ScrollController? columnController3;
  // Stores action output result for [Bottom Sheet - alunosNovoObjetivo] action in DashedButton widget.
  bool? cadastroumeta;
  // Stores action output result for [Bottom Sheet - alunosEditarObjetivo] action in Column widget.
  bool? editoumetas;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    columnController3 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    columnController3?.dispose();
  }
}

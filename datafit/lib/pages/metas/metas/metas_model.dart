import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/alunos_editar_objetivo/alunos_editar_objetivo_widget.dart';
import '/pages/components/alunos_novo_objetivo/alunos_novo_objetivo_widget.dart';
import '/pages/components/navbar/navbar_widget.dart';
import '/pages/metas/metas_fotos/metas_fotos_widget.dart';
import 'dart:convert';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'metas_widget.dart' show MetasWidget;
import 'package:badges/badges.dart' as badges;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class MetasModel extends FlutterFlowModel<MetasWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // Stores action output result for [Bottom Sheet - alunosEditarObjetivo] action in Column widget.
  bool? editoumetas;
  // Stores action output result for [Bottom Sheet - alunosNovoObjetivo] action in IconButton widget.
  bool? add;
  // Stores action output result for [Bottom Sheet - alunosEditarObjetivo] action in Column widget.
  bool? editoumetas2;
  // Model for navbar component.
  late NavbarModel navbarModel;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Stores action output result for [Backend Call - API (marcar noti como lida)] action in Container widget.
  ApiCallResponse? apiResultde4;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    navbarModel = createModel(context, () => NavbarModel());
    columnController2 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    navbarModel.dispose();
    columnController2?.dispose();
  }
}

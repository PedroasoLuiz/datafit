import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/navbar/navbar_widget.dart';
import '/pages/pagamentos/notificacaoalunos/notificacaoalunos_widget.dart';
import '/pages/pagamentos/pagamentos_novo/pagamentos_novo_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'pagamentos_widget.dart' show PagamentosWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PagamentosModel extends FlutterFlowModel<PagamentosWidget> {
  ///  Local state fields for this page.

  int? menu = 2;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Bottom Sheet - pagamentosNovo] action in Container widget.
  bool? cadastrou;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // Stores action output result for [Bottom Sheet - notificacaoalunos] action in Column widget.
  bool? sim;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    columnController?.dispose();
    navbarModel.dispose();
  }
}

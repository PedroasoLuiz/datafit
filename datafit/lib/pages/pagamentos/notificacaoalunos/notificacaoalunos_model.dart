import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/pagamentos/pagamentos_edit/pagamentos_edit_widget.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'notificacaoalunos_widget.dart' show NotificacaoalunosWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class NotificacaoalunosModel extends FlutterFlowModel<NotificacaoalunosWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (criar notificacao)] action in Container widget.
  ApiCallResponse? mandou;
  // Stores action output result for [Bottom Sheet - pagamentosEdit] action in Container widget.
  bool? editou;
  // Stores action output result for [Bottom Sheet - mensagem] action in Container widget.
  bool? deletou;
  // Stores action output result for [Backend Call - API (delete pgto)] action in Container widget.
  ApiCallResponse? resu;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

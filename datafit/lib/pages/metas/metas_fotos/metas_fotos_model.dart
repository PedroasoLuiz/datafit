import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'metas_fotos_widget.dart' show MetasFotosWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class MetasFotosModel extends FlutterFlowModel<MetasFotosWidget> {
  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  bool isDataUploading_upfoto = false;
  FFUploadedFile uploadedLocalFile_upfoto =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_upfoto = '';

  // Stores action output result for [Backend Call - API (Upsert Reg Mensal)] action in IconButton widget.
  ApiCallResponse? apiResultzvb;
  bool isDataUploading_upfoto2 = false;
  FFUploadedFile uploadedLocalFile_upfoto2 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_upfoto2 = '';

  // Stores action output result for [Backend Call - API (Upsert Reg Mensal)] action in replace widget.
  ApiCallResponse? apiResultzvb2;
  // Stores action output result for [Bottom Sheet - mensagem] action in delete widget.
  bool? removeu;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    columnController?.dispose();
  }
}

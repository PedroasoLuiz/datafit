import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:convert';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'perfil_edit_widget.dart' show PerfilEditWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PerfilEditModel extends FlutterFlowModel<PerfilEditWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? temPhoto;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  bool isDataUploading_upPerfil = false;
  FFUploadedFile uploadedLocalFile_upPerfil =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_upPerfil2 = false;
  FFUploadedFile uploadedLocalFile_upPerfil2 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for txtNome widget.
  FocusNode? txtNomeFocusNode;
  TextEditingController? txtNomeTextController;
  String? Function(BuildContext, String?)? txtNomeTextControllerValidator;
  // State field(s) for txtCpf widget.
  FocusNode? txtCpfFocusNode;
  TextEditingController? txtCpfTextController;
  String? Function(BuildContext, String?)? txtCpfTextControllerValidator;
  // State field(s) for txtNick widget.
  FocusNode? txtNickFocusNode;
  TextEditingController? txtNickTextController;
  String? Function(BuildContext, String?)? txtNickTextControllerValidator;
  // State field(s) for txtAniversario widget.
  FocusNode? txtAniversarioFocusNode;
  TextEditingController? txtAniversarioTextController;
  late MaskTextInputFormatter txtAniversarioMask;
  String? Function(BuildContext, String?)?
      txtAniversarioTextControllerValidator;
  // State field(s) for txtTel widget.
  FocusNode? txtTelFocusNode;
  TextEditingController? txtTelTextController;
  late MaskTextInputFormatter txtTelMask;
  String? Function(BuildContext, String?)? txtTelTextControllerValidator;
  // State field(s) for ckWpp widget.
  bool? ckWppValue;
  // State field(s) for txtBio widget.
  FocusNode? txtBioFocusNode;
  TextEditingController? txtBioTextController;
  String? Function(BuildContext, String?)? txtBioTextControllerValidator;
  // State field(s) for txtPeso widget.
  FocusNode? txtPesoFocusNode;
  TextEditingController? txtPesoTextController;
  String? Function(BuildContext, String?)? txtPesoTextControllerValidator;
  // State field(s) for txtAltura widget.
  FocusNode? txtAlturaFocusNode;
  TextEditingController? txtAlturaTextController;
  String? Function(BuildContext, String?)? txtAlturaTextControllerValidator;
  // State field(s) for txtGordura widget.
  FocusNode? txtGorduraFocusNode;
  TextEditingController? txtGorduraTextController;
  String? Function(BuildContext, String?)? txtGorduraTextControllerValidator;

  // State field(s) for medidas corporais (PerimetrosCorporais).
  FocusNode? txtBracoDirFocusNode;
  TextEditingController? txtBracoDirTextController;
  FocusNode? txtPeitoralFocusNode;
  TextEditingController? txtPeitoralTextController;
  FocusNode? txtCinturaFocusNode;
  TextEditingController? txtCinturaTextController;
  FocusNode? txtAbdomenFocusNode;
  TextEditingController? txtAbdomenTextController;
  FocusNode? txtQuadrilFocusNode;
  TextEditingController? txtQuadrilTextController;
  FocusNode? txtCoxaDirFocusNode;
  TextEditingController? txtCoxaDirTextController;

  bool isDataUploading_updata = false;
  FFUploadedFile uploadedLocalFile_updata =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_updata = '';

  // Pix (personal only)
  // CREF: a credencial do personal. Vive junto do Pix por ser tambem um dado
  // que so o personal preenche.
  FocusNode? txtCrefFocusNode;
  TextEditingController? txtCrefTextController;

  FocusNode? txtChavePixFocusNode;
  TextEditingController? txtChavePixTextController;
  String? Function(BuildContext, String?)? txtChavePixTextControllerValidator;
  String? dpTipoPixValue;

  // Campos personalizados
  List<CampoPersonalizadoStruct> camposPersonalizados = [];
  // controllers para edição inline dos campos existentes
  List<TextEditingController> campoNomeControllers = [];
  List<TextEditingController> campoUnidadeControllers = [];
  List<TextEditingController> campoValorControllers = [];

  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<PerfisRow>? ceucerto;
  // Stores action output result for [Backend Call - API (Upsert Info Corporais)] action in Button widget.
  ApiCallResponse? apiResulthbw;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    txtNomeFocusNode?.dispose();
    txtNomeTextController?.dispose();

    txtCpfFocusNode?.dispose();
    txtCpfTextController?.dispose();

    txtNickFocusNode?.dispose();
    txtNickTextController?.dispose();

    txtAniversarioFocusNode?.dispose();
    txtAniversarioTextController?.dispose();

    txtTelFocusNode?.dispose();
    txtTelTextController?.dispose();

    txtBioFocusNode?.dispose();
    txtBioTextController?.dispose();

    txtPesoFocusNode?.dispose();
    txtPesoTextController?.dispose();

    txtAlturaFocusNode?.dispose();
    txtAlturaTextController?.dispose();

    txtGorduraFocusNode?.dispose();
    txtGorduraTextController?.dispose();

    txtBracoDirFocusNode?.dispose();
    txtBracoDirTextController?.dispose();
    txtPeitoralFocusNode?.dispose();
    txtPeitoralTextController?.dispose();
    txtCinturaFocusNode?.dispose();
    txtCinturaTextController?.dispose();
    txtAbdomenFocusNode?.dispose();
    txtAbdomenTextController?.dispose();
    txtQuadrilFocusNode?.dispose();
    txtQuadrilTextController?.dispose();
    txtCoxaDirFocusNode?.dispose();
    txtCoxaDirTextController?.dispose();

    txtCrefFocusNode?.dispose();
    txtCrefTextController?.dispose();
    txtChavePixFocusNode?.dispose();
    txtChavePixTextController?.dispose();

    for (final c in campoNomeControllers) c.dispose();
    for (final c in campoUnidadeControllers) c.dispose();
    for (final c in campoValorControllers) c.dispose();
  }

  void syncCampoControllers() {
    for (final c in campoNomeControllers) c.dispose();
    for (final c in campoUnidadeControllers) c.dispose();
    for (final c in campoValorControllers) c.dispose();
    campoNomeControllers = camposPersonalizados
        .map((c) => TextEditingController(text: c.nome))
        .toList();
    campoUnidadeControllers = camposPersonalizados
        .map((c) => TextEditingController(text: c.unidade))
        .toList();
    campoValorControllers = camposPersonalizados
        .map((c) => TextEditingController(text: c.valor))
        .toList();
  }
}

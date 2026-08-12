import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'completar_perfil_model.dart';
export 'completar_perfil_model.dart';

class CompletarPerfilWidget extends StatefulWidget {
  const CompletarPerfilWidget({super.key});

  static String routeName = 'completarPerfil';
  static String routePath = '/completarPerfil';

  @override
  State<CompletarPerfilWidget> createState() => _CompletarPerfilWidgetState();
}

class _CompletarPerfilWidgetState extends State<CompletarPerfilWidget> {
  late CompletarPerfilModel _model;

  DateTime? _nascimentoSelecionado;
  String? _cpfErro;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompletarPerfilModel());

    _model.telefoneTextController ??= TextEditingController();
    _model.telefoneFocusNode ??= FocusNode();

    _model.nicknameTextController ??= TextEditingController();
    _model.nicknameFocusNode ??= FocusNode();

    _model.pesoTextController ??= TextEditingController();
    _model.pesoFocusNode ??= FocusNode();

    _model.alturaTextController ??= TextEditingController();
    _model.alturaFocusNode ??= FocusNode();

    _model.cpfTextController ??= TextEditingController();
    _model.cpfFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  bool _validarCpf(String cpf) {
    final d = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length != 11) return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(d)) return false;

    int soma = 0;
    for (int i = 0; i < 9; i++) soma += int.parse(d[i]) * (10 - i);
    int d1 = (soma * 10) % 11;
    if (d1 >= 10) d1 = 0;
    if (d1 != int.parse(d[9])) return false;

    soma = 0;
    for (int i = 0; i < 10; i++) soma += int.parse(d[i]) * (11 - i);
    int d2 = (soma * 10) % 11;
    if (d2 >= 10) d2 = 0;
    return d2 == int.parse(d[10]);
  }

  InputDecoration _decoration(BuildContext context, String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.normal),
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.normal,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: FlutterFlowTheme.of(context).primary, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).primaryBackground,
      contentPadding: const EdgeInsets.all(16.0),
    );
  }

  Widget _fieldLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 8.0),
      child: Text(
        label,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.normal),
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }

  TextStyle _fieldTextStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        );
  }

  Future<void> _concluir(BuildContext context) async {
    // Valida CPF se preenchido
    final cpfTexto = _model.cpfTextController!.text;
    if (cpfTexto.isNotEmpty && !_validarCpf(cpfTexto)) {
      safeSetState(() => _cpfErro = 'CPF inválido');
      return;
    }

    safeSetState(() => _model.isSaving = true);

    String? nascimentoNormalizado;
    if (_nascimentoSelecionado != null) {
      final d = _nascimentoSelecionado!;
      nascimentoNormalizado =
          '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    final telefoneDigitos =
        _model.telefoneTextController!.text.replaceAll(RegExp(r'[^0-9]'), '');

    final cpfDigitos = cpfTexto.replaceAll(RegExp(r'[^0-9]'), '');

    await action_blocks.completarPerfilAluno(
      context,
      nascimento: nascimentoNormalizado,
      telefone: telefoneDigitos.isEmpty ? null : telefoneDigitos,
      isWhatsapp: _model.isWhatsapp,
      peso:
          double.tryParse(_model.pesoTextController!.text.replaceAll(',', '.')),
      altura: double.tryParse(
          _model.alturaTextController!.text.replaceAll(',', '.')),
      nickname: _model.nicknameTextController!.text.isEmpty
          ? null
          : _model.nicknameTextController!.text,
      cpf: cpfDigitos.isEmpty ? null : cpfDigitos,
    );

    await action_blocks.perfil(context);

    if (!context.mounted) return;
    context.goNamed(TreinosWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete seu perfil',
                  style: theme.headlineSmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                  child: Text(
                    'Precisamos de mais algumas informações antes de você começar.',
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),

                // CPF
                _fieldLabel(context, 'CPF'),
                TextFormField(
                  controller: _model.cpfTextController,
                  focusNode: _model.cpfFocusNode,
                  decoration: _decoration(context, '000.000.000-00').copyWith(
                    errorText: _cpfErro,
                  ),
                  style: _fieldTextStyle(context),
                  keyboardType: TextInputType.number,
                  inputFormatters: [_model.cpfMask],
                  onChanged: (value) {
                    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.length == 11) {
                      safeSetState(() {
                        _cpfErro = _validarCpf(value) ? null : 'CPF inválido';
                      });
                    } else if (_cpfErro != null) {
                      safeSetState(() => _cpfErro = null);
                    }
                  },
                ),

                // Nascimento — date picker
                _fieldLabel(context, 'Nascimento'),
                InkWell(
                  onTap: () async {
                    final picked = await custom_widgets.showCustomDatePicker(
                      context,
                      initialDate:
                          _nascimentoSelecionado ?? DateTime(1990, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      safeSetState(() => _nascimentoSelecionado = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _nascimentoSelecionado != null
                                ? '${_nascimentoSelecionado!.day.toString().padLeft(2, '0')}/${_nascimentoSelecionado!.month.toString().padLeft(2, '0')}/${_nascimentoSelecionado!.year}'
                                : '__/__/____',
                            style: _nascimentoSelecionado != null
                                ? _fieldTextStyle(context)
                                : theme.labelMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.normal),
                                    color: theme.secondaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                  ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_rounded,
                          color: theme.primary,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                ),

                // Telefone
                _fieldLabel(context, 'Telefone'),
                TextFormField(
                  controller: _model.telefoneTextController,
                  focusNode: _model.telefoneFocusNode,
                  decoration: _decoration(context, '(__) _ ____-____'),
                  style: _fieldTextStyle(context),
                  keyboardType: TextInputType.number,
                  inputFormatters: [_model.telefoneMask],
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: const CircleBorder(),
                          ),
                          unselectedWidgetColor: theme.alternate,
                        ),
                        child: Checkbox(
                          value: _model.isWhatsapp,
                          onChanged: (newValue) =>
                              safeSetState(() => _model.isWhatsapp = newValue!),
                          activeColor: theme.primary,
                          checkColor: theme.info,
                        ),
                      ),
                      Text(
                        'WhatsApp',
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: theme.secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),

                // Nickname
                _fieldLabel(context, 'Nickname (opcional)'),
                TextFormField(
                  controller: _model.nicknameTextController,
                  focusNode: _model.nicknameFocusNode,
                  decoration: _decoration(context, '@seunome'),
                  style: _fieldTextStyle(context),
                ),

                // Peso / Altura
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel(context, 'Peso (kg)'),
                          TextFormField(
                            controller: _model.pesoTextController,
                            focusNode: _model.pesoFocusNode,
                            decoration: _decoration(context, '0.0'),
                            style: _fieldTextStyle(context),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel(context, 'Altura (m)'),
                          TextFormField(
                            controller: _model.alturaTextController,
                            focusNode: _model.alturaFocusNode,
                            decoration: _decoration(context, '0.00'),
                            style: _fieldTextStyle(context),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed:
                        _model.isSaving ? null : () => _concluir(context),
                    text: 'Concluir',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 40.0,
                      color: theme.primary,
                      textStyle: theme.titleSmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        color: theme.primaryBackground,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    showLoadingIndicator: _model.isSaving,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

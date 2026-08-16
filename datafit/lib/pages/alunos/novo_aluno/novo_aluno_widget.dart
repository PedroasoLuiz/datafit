import '/auth/supabase_auth/auth_util.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'dart:convert';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'novo_aluno_model.dart';
export 'novo_aluno_model.dart';

class NovoAlunoWidget extends StatefulWidget {
  const NovoAlunoWidget({super.key});

  @override
  State<NovoAlunoWidget> createState() => _NovoAlunoWidgetState();
}

class _NovoAlunoWidgetState extends State<NovoAlunoWidget> {
  late NovoAlunoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovoAlunoModel());

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();
    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  /// Consulta o e-mail dois segundos depois da ultima tecla.
  ///
  /// Sem a espera, cada letra digitada virava uma ida ao servidor — e a
  /// resposta de uma tecla antiga chegava depois da atual, piscando um aviso
  /// sobre um e-mail que ja nao era o do campo.
  void _aoDigitarEmail(String _) {
    FFAppState().existeCadastro = null;
    safeSetState(() {});

    EasyDebounce.debounce(
      '_model.emailTextController',
      const Duration(milliseconds: 2000),
      () async {
        if (_model.emailTextController.text.trim().isEmpty) return;
        await action_blocks.verificaCadastroEmail(
          context,
          email: _model.emailTextController.text,
        );
        safeSetState(() {});
      },
    );
  }

  Future<Object?> _convidar() async {
    final respostaCrua = await actions.cadastrarAluno(
      currentUserUid,
      _model.nomeTextController.text.trim(),
      _model.emailTextController.text,
      null,
      '',
      null,
      null,
      null,
      false,
      null,
      null,
      true,
      getJsonField(FFAppState().existeCadastro, r'''$.userId''').toString(),
    );

    Map<String, dynamic> resposta;
    try {
      resposta = jsonDecode(respostaCrua) as Map<String, dynamic>;
    } catch (_) {
      resposta = {
        'sucesso': false,
        'mensagem': 'Erro ao processar resposta do servidor.',
      };
    }

    final sucesso = resposta['sucesso'] == true;
    final mensagem = resposta['mensagem']?.toString() ??
        (sucesso ? 'Convite enviado.' : 'Não foi possível enviar o convite.');

    if (!mounted) return null;
    await showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (folha) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(folha),
          child: MensagemWidget(
            texto: mensagem,
            tipo: sucesso ? '1' : '2',
            action: () async {},
            fechasozinho: sucesso,
            mostrabotoes: !sucesso,
          ),
        ),
      ),
    );

    // Falhou: a folha fica aberta com o que foi digitado, para corrigir o
    // e-mail sem redigitar o nome.
    return sucesso ? true : null;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FolhaPadrao(
      aoConfirmar: _convidar,
      filhos: [
        const CabecaFolha(
          titulo: 'Novo aluno',
          apoio:
              'Ele recebe um convite por e-mail e entra com a própria conta.',
          icone: FFIcons.kproperty1FiRrModePortrait,
        ),
        CampoFolha(
          primeiro: true,
          rotulo: 'Nome',
          dica: 'Como você chama seu aluno',
          controlador: _model.nomeTextController,
          foco: _model.nomeFocusNode,
          validador: _model.nomeTextControllerValidator,
        ),
        CampoFolha(
          rotulo: 'E-mail',
          dica: 'nome@gmail.com',
          controlador: _model.emailTextController,
          foco: _model.emailFocusNode,
          teclado: TextInputType.emailAddress,
          aoMudar: _aoDigitarEmail,
          validador: _model.emailTextControllerValidator,
          abaixo: _avisoDeCadastro(context),
        ),
      ],
    );
  }

  /// O que o app ja sabe sobre este e-mail.
  ///
  /// Fica sob o campo, no amarelo de atencao: nao impede o convite, so conta
  /// que a pessoa ja existe — e se ela ja treina com outro personal, isso
  /// muda o que voce vai dizer a ela.
  Widget _avisoDeCadastro(BuildContext context) {
    final cadastro = FFAppState().existeCadastro;
    if (cadastro == null) return const SizedBox.shrink();
    if (getJsonField(cadastro, r'''$.existeNaAuth''') != true) {
      return const SizedBox.shrink();
    }

    final tema = FlutterFlowTheme.of(context);
    final primeiroNome = FFAppState().perfil.nome.trim().split(' ').first;
    final perfilCompleto =
        getJsonField(cadastro, r'''$.perfilCompleto''') == true;
    final outrosPersonais =
        getJsonField(cadastro, r'''$.outrosPersonais''') as List? ?? [];
    final nomePersonal = outrosPersonais.isEmpty
        ? ''
        : (outrosPersonais.first['nome']?.toString() ?? '');

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
        decoration: BoxDecoration(
          color: tema.warning.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ei $primeiroNome! Encontrei um cadastro com esse e-mail.',
              style: tema.bodySmall.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.warning,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              perfilCompleto ? 'Perfil completo.' : 'Perfil incompleto.',
              style: tema.bodySmall.override(
                font: GoogleFonts.inter(),
                color: tema.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
            if (nomePersonal.isNotEmpty)
              Text(
                'Já vinculada a $nomePersonal.',
                style: tema.bodySmall.override(
                  font: GoogleFonts.inter(),
                  color: tema.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

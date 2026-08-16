import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'pagamentos_novo_model.dart';
export 'pagamentos_novo_model.dart';

class PagamentosNovoWidget extends StatefulWidget {
  const PagamentosNovoWidget({super.key});

  @override
  State<PagamentosNovoWidget> createState() => _PagamentosNovoWidgetState();
}

class _PagamentosNovoWidgetState extends State<PagamentosNovoWidget> {
  late PagamentosNovoModel _model;

  DateTime? _vencimento;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagamentosNovoModel());

    _model.txtDescricaoTextController ??= TextEditingController();
    _model.txtDescricaoFocusNode ??= FocusNode();

    _model.txtValorTextController ??= TextEditingController();
    _model.txtValorFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  /// Só os alunos ativos, em ordem de nome.
  ///
  /// Cobrar quem foi desligado cria uma dívida que ninguém vai ver: o aluno
  /// inativo perdeu o acesso e não recebe a notificação.
  List<dynamic> get _alunos => FFAppState()
      .alunosdopersonal
      .where((a) => a.ativo)
      .sortedList(keyOf: (e) => e.nome, desc: false)
      .toList();

  String _mostrar(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _emReais(double v) =>
      'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

  Future<void> _escolherVencimento() async {
    final escolhida = await custom_widgets.showCustomDatePicker(
      context,
      initialDate: _vencimento ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2099),
    );
    if (escolhida == null || !mounted) return;
    safeSetState(() => _vencimento = escolhida);
  }

  Future<Object?> _enviar() async {
    final aluno = _model.dpAlunosValue;
    final descricao = _model.txtDescricaoTextController?.text.trim() ?? '';
    final valor = double.tryParse(
            (_model.txtValorTextController?.text ?? '').replaceAll(',', '.')) ??
        0.0;

    // Aluno, valor e vencimento são o que faz a cobrança existir. Sem eles a
    // folha fica aberta com o que já foi digitado.
    if (aluno == null || aluno.isEmpty || valor <= 0 || _vencimento == null) {
      return null;
    }

    _model.inseriu = await PersonalGroup.insertPgtoAlunoCall.call(
      pPersonalUuid: currentUserUid,
      pAlunoUuid: aluno,
      pDescricao: descricao,
      pValor: valor,
      // Nulo de propósito: o RPC mantém o tipo que já estiver gravado quando
      // recebe nulo, então a forma que o aluno informar depois não se perde.
      pTipoPagamento: null,
      pDataVencimento:
          functions.formataDataParaSalvar(_mostrar(_vencimento!)).toString(),
    );

    if (!mounted) return null;

    if (_model.inseriu?.succeeded != true) {
      await _avisar('Não consegui registrar a cobrança. Tente de novo.',
          erro: true);
      return null;
    }

    await PerfilGroup.criarNotificacaoCall.call(
      destinatario: aluno,
      remetente: currentUserUid,
      titulo: 'Nova cobrança registrada',
      descricao: 'Seu personal registrou uma cobrança de ${_emReais(valor)} '
          'com vencimento em ${_mostrar(_vencimento!)}.',
      tag: 'Cobrança',
    );

    if (!mounted) return null;
    await _avisar('Cobrança enviada!');
    return true;
  }

  Future<void> _avisar(String texto, {bool erro = false}) async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (folha) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(folha),
          child: MensagemWidget(
            texto: texto,
            tipo: erro ? '2' : '1',
            fechasozinho: !erro,
            mostrabotoes: false,
            action: () async {},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final alunos = _alunos;

    return FolhaPadrao(
      aoConfirmar: _enviar,
      filhos: [
        const CabecaFolha(
          titulo: 'Enviar cobrança',
          apoio: 'O aluno recebe um aviso com o valor e o vencimento.',
          icone: Icons.payments_rounded,
        ),
        DropFolha<String>(
          primeiro: true,
          rotulo: 'Aluno',
          dica: alunos.isEmpty ? 'Nenhum aluno ativo' : 'Selecione...',
          controlador: _model.dpAlunosValueController ??=
              FormFieldController<String>(_model.dpAlunosValue),
          opcoes: List<String>.from(alunos.map((e) => e.alunoUuid)),
          rotulos: alunos.map<String>((e) => e.nome as String).toList(),
          preenchido: (_model.dpAlunosValue ?? '').isNotEmpty,
          aoMudar: (valor) => safeSetState(() => _model.dpAlunosValue = valor),
        ),
        CampoFolha(
          rotulo: 'Descrição',
          dica: 'Ex: Mensalidade de setembro',
          controlador: _model.txtDescricaoTextController,
          foco: _model.txtDescricaoFocusNode,
          validador: _model.txtDescricaoTextControllerValidator,
        ),
        CampoFolha(
          rotulo: 'Valor',
          dica: '0,00',
          controlador: _model.txtValorTextController,
          foco: _model.txtValorFocusNode,
          teclado: const TextInputType.numberWithOptions(decimal: true),
          formatadores: [FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))],
          aoMudar: (_) => safeSetState(() {}),
        ),
        CampoToqueFolha(
          rotulo: 'Vencimento',
          vazio: 'Escolha a data',
          icone: Icons.calendar_today_rounded,
          valor: _vencimento == null ? null : _mostrar(_vencimento!),
          aoTocar: _escolherVencimento,
        ),
        if (alunos.isEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                MedidasFolha.lado, 16.0, MedidasFolha.lado, 0.0),
            child: Text(
              'Você ainda não tem alunos ativos para cobrar.',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
      ],
    );
  }
}

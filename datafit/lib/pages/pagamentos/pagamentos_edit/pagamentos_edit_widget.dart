import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'pagamentos_edit_model.dart';
export 'pagamentos_edit_model.dart';

class PagamentosEditWidget extends StatefulWidget {
  const PagamentosEditWidget({
    super.key,
    this.pgto,
  });

  final PersonalpagamentosStruct? pgto;

  @override
  State<PagamentosEditWidget> createState() => _PagamentosEditWidgetState();
}

class _PagamentosEditWidgetState extends State<PagamentosEditWidget> {
  late PagamentosEditModel _model;

  DateTime? _vencimento;
  DateTime? _pagamento;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagamentosEditModel());

    final pgto = widget.pgto;

    _model.txtDescricaoTextController ??=
        TextEditingController(text: pgto?.descricao ?? '');
    _model.txtDescricaoFocusNode ??= FocusNode();

    _model.txtValorTextController ??= TextEditingController(
      text: pgto == null ? '' : _valorEditavel(pgto.valor),
    );
    _model.txtValorFocusNode ??= FocusNode();

    // As datas viram `DateTime` aqui, e nao texto formatado num `Future`
    // depois do primeiro quadro.
    //
    // Aquele atraso era a origem da tela vermelha: o `FFLocalizations.of`
    // rodava fora do frame, e se a folha ja tivesse sido fechada ele
    // procurava um ancestral de um widget desativado.
    _vencimento = _lerData(pgto?.dataVencimento);
    _pagamento = _lerData(pgto?.dataPagamento);
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  /// Le a data gravada. Nulo quando nao ha data, e nao "hoje".
  ///
  /// `formataData` devolve `DateTime.now()` para entrada vazia — o que faria
  /// uma cobranca em aberto abrir marcada como paga hoje.
  DateTime? _lerData(String? cru) {
    if (cru == null || cru.trim().isEmpty) return null;
    final direta = DateTime.tryParse(cru);
    if (direta != null) return direta;
    final lida = functions.formataData(cru);
    return lida.year < 1990 ? null : lida;
  }

  String _mostrar(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _valorEditavel(double v) => v.toStringAsFixed(2).replaceAll('.', ',');

  Future<void> _escolherVencimento() async {
    final escolhida = await custom_widgets.showCustomDatePicker(
      context,
      initialDate: _vencimento ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2099),
    );
    if (escolhida == null || !mounted) return;
    safeSetState(() => _vencimento = escolhida);
  }

  Future<void> _escolherPagamento() async {
    final escolhida = await custom_widgets.showCustomDatePicker(
      context,
      initialDate: _pagamento ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (escolhida == null || !mounted) return;
    safeSetState(() => _pagamento = escolhida);
  }

  Future<Object?> _gravar() async {
    final descricao = _model.txtDescricaoTextController?.text.trim() ?? '';

    // So o vencimento e obrigatorio, e falta dele o visto diz o porque.
    //
    // Antes eu exigia a descricao aqui e o botao nao respondia a nada: quem
    // editava uma cobranca sem descricao ficava tocando no visto sem que a
    // tela explicasse o que faltava.
    if (_vencimento == null) {
      await _avisar('Escolha a data de vencimento.', erro: true);
      return null;
    }

    final valor = double.tryParse(
            (_model.txtValorTextController?.text ?? '').replaceAll(',', '.')) ??
        0.0;

    _model.inseriu = await PersonalGroup.updatePgtoAlunoCall.call(
      pPersonalUuid: currentUserUid,
      pAlunoUuid: widget.pgto?.alunoUuid,
      pDescricao: descricao,
      pValor: valor,
      // Nulo de proposito: o RPC mantem o tipo que ja estiver gravado quando
      // recebe nulo, entao editar a cobranca nao apaga a forma que o aluno
      // informou.
      pTipoPagamento: null,
      pDataVencimento:
          functions.formataDataParaSalvar(_mostrar(_vencimento!)).toString(),
      pDataPagamento: _pagamento == null
          ? ''
          : functions.formataDataParaSalvar(_mostrar(_pagamento!)).toString(),
      pId: widget.pgto?.id,
    );

    if (!mounted) return null;

    if (_model.inseriu?.succeeded != true) {
      await _avisar('Não consegui salvar agora. Tente de novo.', erro: true);
      return null;
    }

    await PerfilGroup.criarNotificacaoCall.call(
      destinatario: widget.pgto?.alunoUuid,
      remetente: currentUserUid,
      titulo: 'Pagamento atualizado.',
      descricao: 'Seu personal atualizou um registro de pagamento.',
      tag: 'Cobrança',
    );

    if (!mounted) return null;
    await _avisar('Pagamento atualizado com sucesso!');
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
    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        CabecaFolha(
          titulo: 'Editar cobrança',
          apoio: widget.pgto?.nome.isNotEmpty == true
              ? widget.pgto!.nome
              : 'O aluno recebe um aviso da alteração.',
          icone: Icons.payments_rounded,
        ),
        CampoFolha(
          primeiro: true,
          rotulo: 'Descrição',
          dica: 'Ex: Mensalidade de agosto',
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
          formatadores: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
          ],
        ),
        CampoToqueFolha(
          rotulo: 'Vencimento',
          vazio: 'Escolha a data',
          icone: Icons.calendar_today_rounded,
          valor: _vencimento == null ? null : _mostrar(_vencimento!),
          aoTocar: _escolherVencimento,
        ),
        // "Pago em" fica em branco enquanto a cobranca nao foi quitada, e
        // preenche-lo e o que a marca como paga.
        CampoToqueFolha(
          rotulo: 'Pago em',
          vazio: 'Ainda não foi pago',
          icone: Icons.calendar_today_rounded,
          valor: _pagamento == null ? null : _mostrar(_pagamento!),
          aoTocar: _escolherPagamento,
        ),
        if (_pagamento != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                MedidasFolha.lado, 10.0, MedidasFolha.lado, 0.0),
            child: InkWell(
              onTap: () => safeSetState(() => _pagamento = null),
              child: Text(
                'Marcar como não pago',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 12.5,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

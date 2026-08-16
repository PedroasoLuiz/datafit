import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'informar_pagamento_model.dart';
export 'informar_pagamento_model.dart';

class InformarPagamentoWidget extends StatefulWidget {
  const InformarPagamentoWidget({
    super.key,
    required this.pagamento,
  });

  final PagamentosStruct pagamento;

  @override
  State<InformarPagamentoWidget> createState() =>
      _InformarPagamentoWidgetState();
}

class _InformarPagamentoWidgetState extends State<InformarPagamentoWidget> {
  late InformarPagamentoModel _model;

  /// Forma escolhida pelo aluno.
  ///
  /// A cobranca ja nasce com um TipoPagamento definido pelo personal, mas a
  /// forma so se decide na hora de pagar: quem combinou boleto acaba mandando
  /// Pix. Sem isso o personal recebia "pagamento informado" sem saber onde
  /// procurar o dinheiro.
  String? _forma;

  static const List<String> _formas = [
    'Pix',
    'Dinheiro',
    'Cartão',
    'Transferência',
    'Boleto',
    'Outro',
  ];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InformarPagamentoModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  String _data(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _dataApi(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// "2026-08-13" vira "13/08/2026".
  String _dataDoTexto(String iso) {
    final partes = iso.split('-');
    if (partes.length != 3) return iso;
    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  String _valor(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

  Future<void> _escolherData() async {
    final escolhida = await custom_widgets.showCustomDatePicker(
      context,
      initialDate: _model.dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (escolhida == null || !mounted) return;
    safeSetState(() => _model.dataSelecionada = escolhida);
  }

  Future<Object?> _informar() async {
    // Sem data ou sem forma a folha nao fecha: sao as duas unicas coisas que
    // ela pergunta, e informar um pagamento sem elas nao diz nada ao personal.
    if (_model.dataSelecionada == null || _forma == null) return null;

    safeSetState(() => _model.isLoading = true);

    final resposta = await AlunoGroup.informarPagamentoCall.call(
      pPagamentoId: widget.pagamento.id,
      pAlunoUuid: currentUserUid,
      pDataPagamento: _dataApi(_model.dataSelecionada!),
      pTipoPagamento: _forma,
    );

    if (!mounted) return null;
    safeSetState(() => _model.isLoading = false);

    if (resposta.succeeded) return true;

    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (folha) => WebViewAware(
        child: MensagemWidget(
          texto: 'Erro ao informar pagamento. Tente novamente.',
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: false,
          action: () async {},
        ),
      ),
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pgto = widget.pagamento;

    return FolhaPadrao(
      aoConfirmar: _informar,
      filhos: [
        const CabecaFolha(
          titulo: 'Informar pagamento',
          apoio: 'Seu personal recebe o aviso e confirma o recebimento.',
          icone: Icons.payments_rounded,
        ),
        ResumoFolha(
          titulo: pgto.descricao.isEmpty ? 'Cobrança' : pgto.descricao,
          destaque: _valor(pgto.valor),
          apoio: pgto.dataVencimento.isEmpty
              ? null
              : 'Vence em ${_dataDoTexto(pgto.dataVencimento)}',
        ),
        CampoToqueFolha(
          rotulo: 'Data do pagamento',
          vazio: 'Quando você pagou?',
          icone: Icons.calendar_today_rounded,
          valor: _model.dataSelecionada == null
              ? null
              : _data(_model.dataSelecionada!),
          aoTocar: _escolherData,
        ),
        EscolhaFolha(
          rotulo: 'Como você pagou?',
          opcoes: _formas,
          escolhida: _forma,
          aoEscolher: (opcao) => safeSetState(() => _forma = opcao),
        ),
      ],
    );
  }
}

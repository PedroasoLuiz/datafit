import '/components/folha_kit.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

/// Formas de pagamento que o personal pode registrar.
///
/// A mesma lista da folha que o aluno usa para informar: se as duas
/// divergirem, o que o aluno declara não casa com o que o personal confirma.
const List<String> kFormasPagamento = [
  'Pix',
  'Dinheiro',
  'Cartão',
  'Transferência',
  'Boleto',
  'Outro',
];

/// Confirma o recebimento de uma cobrança e devolve a forma escolhida.
///
/// Devolve `null` quando o personal desiste. A forma volta como texto porque
/// é ela que o RPC grava, e não há id: a lista é fixa e curta.
Future<String?> confirmarRecebimento(
  BuildContext context, {
  required String descricao,
  required String valor,
  required String nomeAluno,
  String? formaInformada,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (folha) => WebViewAware(
      child: Padding(
        padding: MediaQuery.viewInsetsOf(folha),
        child: _FolhaConfirmar(
          descricao: descricao,
          valor: valor,
          nomeAluno: nomeAluno,
          formaInformada: formaInformada,
        ),
      ),
    ),
  );
}

class _FolhaConfirmar extends StatefulWidget {
  const _FolhaConfirmar({
    required this.descricao,
    required this.valor,
    required this.nomeAluno,
    this.formaInformada,
  });

  final String descricao;
  final String valor;
  final String nomeAluno;

  /// O que o aluno declarou ao informar o pagamento, quando declarou.
  final String? formaInformada;

  @override
  State<_FolhaConfirmar> createState() => _FolhaConfirmarState();
}

class _FolhaConfirmarState extends State<_FolhaConfirmar> {
  late String _forma;

  @override
  void initState() {
    super.initState();
    // Cai no Pix quando o aluno nao declarou nada: e o caso comum, e deixar
    // sem selecao obrigaria um toque a mais para o que quase sempre e isso.
    final informada = widget.formaInformada;
    _forma = (informada != null && kFormasPagamento.contains(informada))
        ? informada
        : kFormasPagamento.first;
  }

  @override
  Widget build(BuildContext context) {
    return FolhaPadrao(
      aoConfirmar: () async => _forma,
      filhos: [
        CabecaFolha(
          titulo: 'Confirmar recebimento',
          apoio: 'O aluno recebe o aviso de que a cobrança foi quitada.',
          icone: Icons.payments_rounded,
        ),
        ResumoFolha(
          titulo: widget.descricao.isEmpty
              ? widget.nomeAluno
              : '${widget.nomeAluno} · ${widget.descricao}',
          destaque: 'R\$ ${widget.valor}',
          apoio: widget.formaInformada == null
              ? null
              : 'O aluno informou que pagou por ${widget.formaInformada}',
        ),
        EscolhaFolha(
          rotulo: 'Como você recebeu?',
          opcoes: kFormasPagamento,
          escolhida: _forma,
          aoEscolher: (opcao) => setState(() => _forma = opcao),
        ),
      ],
    );
  }
}

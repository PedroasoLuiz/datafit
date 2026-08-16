/// Folha de confirmacao de recebimento, do lado do personal.
///
/// Fecha o ciclo que estava aberto: o aluno informava o pagamento, o personal
/// recebia "Confirme se recebeu" e nao tinha onde confirmar — a unica saida
/// era abrir a edicao e preencher a data na mao, que nao avisava o aluno.
///
/// A forma ja vem escolhida com o que o aluno declarou. O personal so mexe se
/// o dinheiro entrou por outro caminho — quem combinou Pix as vezes paga em
/// dinheiro, e e o personal que sabe onde conferiu.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/components/chip_filtro.dart';

/// Formas aceitas. Os mesmos rotulos de `informar_pagamento_widget`: o banco
/// normaliza para minusculo sem acento na hora de gravar.
const List<String> kFormasPagamento = [
  'Pix',
  'Dinheiro',
  'Cartão',
  'Transferência Bancária',
  'Boleto',
  'Outro',
];

/// Abre a folha e devolve a forma confirmada, ou nulo se desistiu.
///
/// Devolve a forma (nunca vazio) para quem chama repassar ao RPC.
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
    builder: (context) => _FolhaConfirmar(
      descricao: descricao,
      valor: valor,
      nomeAluno: nomeAluno,
      formaInformada: formaInformada,
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
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Puxador: a folha abre por cima da lista e sem ele nao se le
              // como algo que se arrasta para fechar.
              Center(
                child: Container(
                  width: 36.0,
                  height: 4.0,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 14.0),
                  decoration: BoxDecoration(
                    color: tema.alternate,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 2.0),
                child: Text(
                  'Confirmar recebimento',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: tema.primaryText,
                    fontSize: 18.0,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                child: Text(
                  '${widget.nomeAluno} informou o pagamento de '
                  '${widget.descricao}.',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                    color: tema.secondaryText,
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: tema.primaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: tema.alternate, width: 1.0),
                  ),
                  child: Text(
                    widget.valor,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primary,
                      fontSize: 22.0,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 8.0),
                child: Text(
                  widget.formaInformada != null
                      ? 'O aluno informou que pagou por'
                      : 'Como você recebeu?',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: tema.secondaryText,
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                child: LinhaChipsFiltro(
                  paddingHorizontal: 20.0,
                  chips: [
                    for (final f in kFormasPagamento)
                      ChipFiltro(
                        texto: f,
                        selecionado: _forma == f,
                        onTap: () => setState(() => _forma = f),
                      ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: tema.primaryBackground,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: Text(
                            'Agora não',
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: tema.secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.pop(context, _forma),
                        child: Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: tema.primary,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: Text(
                            'Confirmar recebimento',
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: tema.primaryBackground,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

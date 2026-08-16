import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/treinos/treinos_detalhes_cardio_novo/treinos_detalhes_cardio_novo_widget.dart'
    show kTiposCardio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'treinos_detalhes_cardio_edit_model.dart';
export 'treinos_detalhes_cardio_edit_model.dart';

class TreinosDetalhesCardioEditWidget extends StatefulWidget {
  const TreinosDetalhesCardioEditWidget({
    super.key,
    required this.index,
    required this.cardio,
  });

  final int index;
  final CardioStruct? cardio;

  @override
  State<TreinosDetalhesCardioEditWidget> createState() =>
      _TreinosDetalhesCardioEditWidgetState();
}

class _TreinosDetalhesCardioEditWidgetState
    extends State<TreinosDetalhesCardioEditWidget> {
  late TreinosDetalhesCardioEditModel _model;

  final _horas = TextEditingController();
  final _minutos = TextEditingController();
  final _distancia = TextEditingController();

  String _unidade = 'km';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosDetalhesCardioEditModel());

    final c = widget.cardio;

    _model.txtDescricaoTextController ??=
        TextEditingController(text: c?.descricao ?? '');
    _model.txtDescricaoFocusNode ??= FocusNode();

    _model.txtKcalTextController ??= TextEditingController(
        text: (c?.kcal ?? 0) > 0 ? c!.kcal.toString() : '');
    _model.txtKcalFocusNode ??= FocusNode();

    _model.txtObsTextController ??=
        TextEditingController(text: c?.observacao ?? '');
    _model.txtObsFocusNode ??= FocusNode();

    // A duracao editavel vem em horas e minutos, e nao em duas datas.
    //
    // O registro guarda inicio e fim, mas ninguem corrige um cardio dizendo
    // "comecou 18:07": corrige-se dizendo "foram 40 minutos". O inicio fica
    // como estava e o fim se recalcula a partir dele.
    final minutos = (c?.duracaoMinutos ?? 0).round();
    if (minutos > 0) {
      _horas.text = (minutos ~/ 60).toString();
      _minutos.text = (minutos % 60).toString();
    }

    final km = c?.distanciaKm ?? 0.0;
    if (km > 0) {
      _distancia.text = km.toString().replaceAll('.', ',');
    }

    _model.inicio = DateTime.tryParse(c?.dataHoraInicio ?? '');
    _model.fim = DateTime.tryParse(c?.dataHoraFim ?? '');
  }

  @override
  void dispose() {
    _horas.dispose();
    _minutos.dispose();
    _distancia.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  int _inteiro(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;

  int get _duracao => _inteiro(_horas) * 60 + _inteiro(_minutos);

  double get _emKm {
    final bruta =
        double.tryParse(_distancia.text.trim().replaceAll(',', '.')) ?? 0.0;
    return _unidade == 'km' ? bruta : bruta / 1000;
  }

  Future<Object?> _gravar() async {
    final descricao = _model.txtDescricaoTextController?.text.trim() ?? '';
    if (descricao.isEmpty || _duracao <= 0) return null;

    final inicio = _model.inicio ?? DateTime.now();
    final kcal = _model.txtKcalTextController?.text.trim() ?? '';

    await RegistrosCardioTable().update(
      data: {
        'PerfisId': currentUserUid,
        'TreinosExecucaoId': FFAppState()
            .treinosTemp
            .subagrupamentos
            .elementAtOrNull(widget.index)
            ?.treinoExecucaoId,
        'Descricao': descricao,
        'DuracaoMinutos': _duracao,
        'DistanciaKm': _emKm,
        // Campo vazio grava null, nao 0: "nao informei" e diferente de
        // "gastei zero caloria".
        'Kcal': kcal.isEmpty ? null : int.tryParse(kcal),
        'Observacao': _model.txtObsTextController?.text.trim() ?? '',
        'DataHoraInicio': supaSerialize<DateTime>(inicio),
        'DataHoraFim':
            supaSerialize<DateTime>(inicio.add(Duration(minutes: _duracao))),
      },
      matchingRows: (linhas) => linhas.eqOrNull('Id', widget.cardio?.id),
    );

    return true;
  }

  Future<void> _excluir() async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (folha) => WebViewAware(
        child: MensagemWidget(
          texto: 'Excluir este cárdio?',
          textoauxiliar: 'Ele sai do seu histórico e das métricas.',
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: true,
          action: () async {
            await RegistrosCardioTable().delete(
              matchingRows: (linhas) =>
                  linhas.eqOrNull('Id', widget.cardio?.id),
            );
            if (!mounted) return;
            await FolhaPadrao.fechar(context, true);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final digitos = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ];
    final escrita = _model.txtDescricaoTextController?.text.trim();

    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        const CabecaFolha(
          titulo: 'Editar cárdio',
          apoio: 'Ajuste o que ficou diferente do que você registrou.',
          icone: Icons.directions_run_rounded,
        ),
        EscolhaFolha(
          primeiro: true,
          rotulo: 'O que você fez',
          opcoes: kTiposCardio,
          escolhida: kTiposCardio.contains(escrita) ? escrita : null,
          aoEscolher: (opcao) => safeSetState(
              () => _model.txtDescricaoTextController?.text = opcao),
        ),
        CampoFolha(
          rotulo: 'Ou escreva',
          dica: 'Caminhada, futebol, natação...',
          controlador: _model.txtDescricaoTextController,
          foco: _model.txtDescricaoFocusNode,
          aoMudar: (_) => safeSetState(() {}),
        ),
        LinhaCamposFolha(
          campos: [
            CampoCompacto(
              rotulo: 'Horas',
              dica: '0',
              controlador: _horas,
              teclado: TextInputType.number,
              formatadores: digitos,
            ),
            CampoCompacto(
              rotulo: 'Minutos',
              dica: '30',
              controlador: _minutos,
              teclado: TextInputType.number,
              formatadores: digitos,
            ),
            CampoCompacto(
              rotulo: 'Kcal (opcional)',
              dica: '250',
              controlador: _model.txtKcalTextController,
              foco: _model.txtKcalFocusNode,
              teclado: TextInputType.number,
              formatadores: digitos,
            ),
          ],
        ),
        LinhaCamposFolha(
          campos: [
            CampoCompacto(
              rotulo: 'Distância',
              dica: '0',
              controlador: _distancia,
              teclado: const TextInputType.numberWithOptions(decimal: true),
              formatadores: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))
              ],
            ),
            EscolhaFolhaSimples(
              rotulo: 'Unidade',
              opcoes: const ['km', 'm'],
              escolhida: _unidade,
              aoEscolher: (opcao) => safeSetState(() => _unidade = opcao),
            ),
          ],
        ),
        CampoFolha(
          rotulo: 'Observação (opcional)',
          dica: 'Como foi, o ritmo, o percurso...',
          controlador: _model.txtObsTextController,
          foco: _model.txtObsFocusNode,
          linhas: 2,
        ),
        AcaoDestrutivaFolha(texto: 'Excluir cárdio', aoTocar: _excluir),
      ],
    );
  }
}

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'treinos_detalhes_cardio_novo_model.dart';
export 'treinos_detalhes_cardio_novo_model.dart';

/// Sugestões de cárdio. Um toque no lugar de digitar o de sempre.
const List<String> kTiposCardio = [
  'Caminhada',
  'Corrida',
  'Esteira',
  'Bike',
  'Elíptico',
  'Escada',
];

class TreinosDetalhesCardioNovoWidget extends StatefulWidget {
  const TreinosDetalhesCardioNovoWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<TreinosDetalhesCardioNovoWidget> createState() =>
      _TreinosDetalhesCardioNovoWidgetState();
}

class _TreinosDetalhesCardioNovoWidgetState
    extends State<TreinosDetalhesCardioNovoWidget> {
  late TreinosDetalhesCardioNovoModel _model;

  /// Calorias informadas pelo aluno. Opcional: vazio grava nulo, que é
  /// diferente de zero ("gastei 0 kcal").
  final _kcal = TextEditingController();

  final _horas = TextEditingController();
  final _minutos = TextEditingController();
  final _distancia = TextEditingController();

  /// Unidade da distância. Quem corre na rua conta em km, quem faz escada
  /// conta em metros; converter de cabeça é onde o número sai errado.
  String _unidade = 'km';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosDetalhesCardioNovoModel());

    _model.txtDescricaoTextController ??= TextEditingController();
    _model.txtDescricaoFocusNode ??= FocusNode();

    _model.txtObsTextController ??= TextEditingController();
    _model.txtObsFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _kcal.dispose();
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

    // Sem descrição e sem duração o registro não diz nada: apareceria na
    // ficha como uma linha em branco de zero minuto.
    if (descricao.isEmpty || _duracao <= 0) return null;

    final inicio = DateTime.now();

    await RegistrosCardioTable().insert({
      'PerfisId': currentUserUid,
      'TreinosExecucaoId': FFAppState()
          .treinosTemp
          .subagrupamentos
          .elementAtOrNull(widget.index)
          ?.treinoExecucaoId,
      'Descricao': descricao,
      'DuracaoMinutos': _duracao,
      'DistanciaKm': _emKm,
      'Kcal': _kcal.text.trim().isEmpty ? null : _inteiro(_kcal),
      'Observacao': _model.txtObsTextController?.text.trim() ?? '',
      'DataHoraInicio': supaSerialize<DateTime>(inicio),
      'DataHoraFim':
          supaSerialize<DateTime>(inicio.add(Duration(minutes: _duracao))),
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final digitos = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ];

    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        const CabecaFolha(
          titulo: 'Cárdio',
          apoio: 'Registre o que você fez fora da série de musculação.',
          icone: Icons.directions_run_rounded,
        ),
        EscolhaFolha(
          primeiro: true,
          rotulo: 'O que você fez',
          opcoes: kTiposCardio,
          escolhida: kTiposCardio
                  .contains(_model.txtDescricaoTextController?.text.trim())
              ? _model.txtDescricaoTextController!.text.trim()
              : null,
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
              controlador: _kcal,
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
      ],
    );
  }
}

import '/backend/api_requests/api_calls.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'substituir_exercicio_model.dart';
export 'substituir_exercicio_model.dart';

class SubstituirExercicioWidget extends StatefulWidget {
  const SubstituirExercicioWidget({
    super.key,
    required this.execucaoId,
    required this.nomeOriginal,
  });

  final int execucaoId;
  final String nomeOriginal;

  @override
  State<SubstituirExercicioWidget> createState() =>
      _SubstituirExercicioWidgetState();
}

class _SubstituirExercicioWidgetState extends State<SubstituirExercicioWidget> {
  late SubstituirExercicioModel _model;

  /// Quantos substitutos à mostra. A lista costuma ser curta, mas a mesma
  /// paginação das demais folhas evita que um exercício com trinta
  /// alternativas nasça com trinta linhas desenhadas.
  int _visiveis = 10;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubstituirExercicioModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async => _carregar());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    safeSetState(() => _model.isLoading = true);

    final resposta = await AlunoGroup.getSubstitutosExercicioCall.call(
      pExecucaoId: widget.execucaoId,
    );

    if (!mounted) return;

    if (resposta.succeeded) {
      try {
        final cru = resposta.jsonBody;
        _model.substitutos = (cru is List ? cru : [])
            .map((e) => e as Map<String, dynamic>)
            .toList();
      } catch (_) {
        _model.substitutos = [];
      }
    }

    safeSetState(() => _model.isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return FolhaPadrao(
      fixos: [
        CabecaFolha(
          titulo: 'Substituir exercício',
          // O nome do original como apoio: e a pergunta que a folha
          // responde, "no lugar de qual?".
          apoio: widget.nomeOriginal,
          icone: FFIcons.kproperty1FiRrRefresh,
        ),
      ],
      filhos: [
        ListaFolha<Map<String, dynamic>>(
          itens: _model.substitutos,
          carregando: _model.isLoading,
          visiveis: _visiveis,
          aoVerMais: () => safeSetState(() => _visiveis += 10),
          textoVazio: 'Não há substitutos disponíveis para este exercício.',
          construir: (contexto, item) {
            final nome = item['descricao'] as String? ?? '';
            return ItemFolha(
              titulo: nome,
              icone: FFIcons.kproperty1FiRrRefresh,
              aoTocar: () => FolhaPadrao.fechar(context, nome),
            );
          },
        ),
      ],
    );
  }
}

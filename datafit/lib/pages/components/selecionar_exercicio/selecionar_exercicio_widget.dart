import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'selecionar_exercicio_model.dart';
export 'selecionar_exercicio_model.dart';

class SelecionarExercicioWidget extends StatefulWidget {
  const SelecionarExercicioWidget({
    super.key,
    this.grupoMuscular,
    this.treinoExecucaoId,
  });

  final int? grupoMuscular;
  final int? treinoExecucaoId;

  @override
  State<SelecionarExercicioWidget> createState() =>
      _SelecionarExercicioWidgetState();
}

class _SelecionarExercicioWidgetState extends State<SelecionarExercicioWidget> {
  late SelecionarExercicioModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecionarExercicioModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async => _carregar());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    safeSetState(() => _model.isLoading = true);

    final resposta = await TreinoGroup.getExerciciosCall.call(
      personalUuid: currentUserUid,
      grupoMuscular: widget.grupoMuscular,
      treinoExecucaoId: widget.treinoExecucaoId,
    );

    if (!mounted) return;

    if (resposta.succeeded) {
      try {
        final cru = resposta.jsonBody;
        _model.exercicios = (cru is List ? cru : [cru])
            .map((e) => ExerciciossimplyStruct.maybeFromMap(e))
            .whereType<ExerciciossimplyStruct>()
            .toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));
      } catch (_) {
        _model.exercicios = [];
      }
    }

    safeSetState(() => _model.isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _model.filtrados;

    return FolhaPadrao(
      // Sem `aoConfirmar`: escolher um exercicio ja e a confirmacao, entao
      // so o X aparece. Um visto aqui perguntaria de novo o que o toque
      // acabou de responder.
      fixos: [
        const CabecaFolha(
          titulo: 'Selecionar exercício',
          apoio: 'Toque para adicionar ao treino.',
          icone: FFIcons.kproperty1FiRrGym,
        ),
        BuscaFolha(
          controlador: _model.buscaController,
          foco: _model.buscaFocusNode,
          dica: 'Buscar exercício...',
          // A busca reinicia a paginação: continuar na página 3 de uma lista
          // que acabou de mudar mostra o meio de um resultado novo.
          aoMudar: (texto) => safeSetState(() {
            _model.buscaTexto = texto;
            _model.itemsVisiveis = 15;
          }),
        ),
      ],
      filhos: [
        ListaFolha<ExerciciossimplyStruct>(
          itens: filtrados,
          carregando: _model.isLoading,
          visiveis: _model.itemsVisiveis,
          aoVerMais: () => safeSetState(() => _model.itemsVisiveis += 15),
          textoVazio: _model.buscaTexto.isEmpty
              ? 'Nenhum exercício encontrado.'
              : 'Nenhum resultado para "${_model.buscaTexto}".',
          construir: (contexto, exercicio) => ItemFolha(
            titulo: exercicio.nome,
            icone: FFIcons.kproperty1FiRrGym,
            aoTocar: () => FolhaPadrao.fechar(context, exercicio),
          ),
        ),
      ],
    );
  }
}

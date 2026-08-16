import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'selecionar_treino_aluno_model.dart';
export 'selecionar_treino_aluno_model.dart';

class SelecionarTreinoAlunoWidget extends StatefulWidget {
  const SelecionarTreinoAlunoWidget({
    super.key,
    required this.alunoUuid,
    required this.grupoTreinoIdAtual,
    this.dataValidadeAtual,
  });

  final String alunoUuid;
  final int grupoTreinoIdAtual;
  final String? dataValidadeAtual;

  @override
  State<SelecionarTreinoAlunoWidget> createState() =>
      _SelecionarTreinoAlunoWidgetState();
}

class _SelecionarTreinoAlunoWidgetState
    extends State<SelecionarTreinoAlunoWidget> {
  late SelecionarTreinoAlunoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecionarTreinoAlunoModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async => _carregar());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    safeSetState(() => _model.isLoading = true);

    // Treino em execucao trava a troca: puxar a ficha debaixo de quem esta
    // no meio da serie apaga o que ele acabou de marcar.
    final pendente = await SupaFlow.client
        .from('TreinosExecucao')
        .select('Id')
        .eq('ExecutorPerfisId', widget.alunoUuid)
        .eq('Status', 'pendente')
        .or('IsDeleted.is.null,IsDeleted.eq.false')
        .limit(1);

    if (!mounted) return;

    if ((pendente as List).isNotEmpty) {
      final sessao = await SupaFlow.client
          .from('TreinosConclusao')
          .select('Id')
          .eq('TreinosExecucaoId', pendente.first['Id'])
          .eq('IsTreinoConcluido', false)
          .limit(1);

      if (!mounted) return;

      if ((sessao as List).isNotEmpty) {
        safeSetState(() {
          _model.emExecucao = true;
          _model.isLoading = false;
        });
        return;
      }
    }

    final resposta = await PersonalGroup.getTreinosPersonalCall.call(
      pPersonalUuid: currentUserUid,
    );

    if (!mounted) return;

    if (resposta.succeeded) {
      try {
        final cru = resposta.jsonBody;
        _model.treinos = (cru is List ? cru : [cru])
            .map((e) => GrupostreinosStruct.maybeFromMap(e))
            .whereType<GrupostreinosStruct>()
            .where((t) => t.ativo)
            .toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));
      } catch (_) {
        _model.treinos = [];
      }
    }

    safeSetState(() => _model.isLoading = false);
  }

  /// Escolher o treino pede a validade antes de gravar.
  ///
  /// A data vem primeiro porque atribuir sem prazo cria um treino que nunca
  /// vence: e ninguem volta aqui so para preencher o que ja parece pronto.
  Future<void> _selecionar(GrupostreinosStruct treino) async {
    var sugerida = DateTime.now().add(const Duration(days: 30));
    final atual = widget.dataValidadeAtual;
    if (atual != null && atual.isNotEmpty) {
      final lida = DateTime.tryParse(atual);
      if (lida != null && lida.isAfter(DateTime.now())) sugerida = lida;
    }

    final escolhida = await custom_widgets.showCustomDatePicker(
      context,
      initialDate: sugerida,
      firstDate: DateTime.now(),
      lastDate: DateTime(2099),
    );
    if (!mounted || escolhida == null) return;

    safeSetState(() => _model.isLoading = true);

    final texto = '${escolhida.year.toString().padLeft(4, '0')}'
        '-${escolhida.month.toString().padLeft(2, '0')}'
        '-${escolhida.day.toString().padLeft(2, '0')}';

    String? erro;
    try {
      final cru =
          await SupaFlow.client.rpc('atribuir_grupo_treino_aluno', params: {
        'p_personal_uuid': currentUserUid,
        'p_aluno_uuid': widget.alunoUuid,
        'p_grupo_treino_id': treino.grupoTreinoId,
        'p_data_validade': texto,
      });
      if (!mounted) return;

      final dados = (cru is List && cru.isNotEmpty) ? cru.first : cru;

      // Zero treinos criados nao e sucesso: a funcao chegou a devolver
      // `sucesso: true` com nenhuma execucao criada, e a folha fechava como
      // se o aluno tivesse recebido o treino.
      final criados =
          dados is Map ? ((dados['treinosCriados'] as num?)?.toInt() ?? 0) : 0;
      final ok = dados is Map && dados['sucesso'] == true && criados > 0;

      if (ok) {
        await FolhaPadrao.fechar(context, true);
        return;
      }
      erro = dados is Map
          ? (dados['mensagem']?.toString() ?? 'Erro ao atribuir treino.')
          : 'Erro ao atribuir treino.';
    } catch (_) {
      erro = 'Erro ao atribuir treino.';
    }

    if (!mounted) return;
    safeSetState(() => _model.isLoading = false);

    // O componente de mensagem do app, e nao um SnackBar: o aviso nasce no
    // mesmo lugar de todos os outros do Datafit.
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (folha) => WebViewAware(
        child: MensagemWidget(
          texto: erro!,
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: false,
          action: () async {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _model.treinosFiltrados;

    return FolhaPadrao(
      fixos: [
        const CabecaFolha(
          titulo: 'Treino do aluno',
          apoio: 'Escolha o plano e a data de validade.',
          icone: FFIcons.kproperty1FiRrGym,
        ),
        // A busca some enquanto nao ha o que buscar: um campo sobre uma
        // lista vazia so ocupa a folha.
        if (!_model.emExecucao &&
            !_model.isLoading &&
            _model.treinos.isNotEmpty)
          BuscaFolha(
            controlador: _model.buscaController,
            foco: _model.buscaFocusNode,
            dica: 'Buscar treino...',
            aoMudar: (texto) => safeSetState(() {
              _model.buscaTexto = texto;
              _model.itemsVisiveis = 10;
            }),
          ),
      ],
      filhos: [
        if (_model.emExecucao)
          _travado(context)
        else
          ListaFolha<GrupostreinosStruct>(
            itens: filtrados,
            carregando: _model.isLoading,
            visiveis: _model.itemsVisiveis,
            aoVerMais: () => safeSetState(() => _model.itemsVisiveis += 10),
            textoVazio: _model.buscaTexto.isEmpty
                ? 'Nenhum treino criado ainda.'
                : 'Nenhum resultado para "${_model.buscaTexto}".',
            construir: (contexto, treino) {
              final atual = treino.grupoTreinoId == widget.grupoTreinoIdAtual;
              final quantos = treino.subagrupamentos.length;

              return ItemFolha(
                titulo:
                    treino.nome.isNotEmpty ? treino.nome : 'Treino sem nome',
                apoio: atual
                    ? 'Em uso por este aluno'
                    : (quantos > 0
                        ? '$quantos ${quantos == 1 ? 'treino' : 'treinos'}'
                        : null),
                icone: FFIcons.kproperty1FiRrGym,
                selecionado: atual,
                // O que ja esta em uso nao responde ao toque: reatribuir o
                // mesmo plano refaria o ciclo do zero.
                aoTocar: atual ? null : () => _selecionar(treino),
              );
            },
          ),
      ],
    );
  }

  /// Aviso de treino em andamento, no lugar da lista.
  Widget _travado(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, 6.0, MedidasFolha.lado, 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
        decoration: BoxDecoration(
          color: tema.warning.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_clock_outlined, color: tema.warning, size: 26.0),
            const SizedBox(height: 10.0),
            Text(
              'O aluno está executando um treino.',
              textAlign: TextAlign.center,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.primaryText,
                fontSize: 13.5,
                letterSpacing: -0.1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Aguarde ele concluir para trocar.',
              textAlign: TextAlign.center,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                color: tema.secondaryText,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

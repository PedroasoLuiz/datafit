import '/components/chip_filtro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/backend/schema/structs/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/backend/api_requests/api_calls.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/components/mensagem_widget.dart';
import '/components/confirmar_recebimento.dart';
import '/components/painel_metricas.dart';
import '/components/atalho_cartao.dart';
import '/components/baralho_cartas.dart';
import '/components/perfil_kit.dart';
import '/components/folha_kit.dart';
import '/components/foto_tela_cheia.dart';
import '/backend/cache_curto.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/components/selecionar_treino_aluno/selecionar_treino_aluno_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/alunos_edit_exercicio/alunos_edit_exercicio_widget.dart';
import '/pages/components/alunos_editar_objetivo/alunos_editar_objetivo_widget.dart';
import '/pages/components/alunos_novo_exercicio/alunos_novo_exercicio_widget.dart';
import '/pages/components/alunos_novo_objetivo/alunos_novo_objetivo_widget.dart';
import '/pages/perfil/perfil_aluno_status/perfil_aluno_status_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'perfilaluno_model.dart';
export 'perfilaluno_model.dart';

class PerfilalunoWidget extends StatefulWidget {
  const PerfilalunoWidget({
    super.key,
    required this.alunoId,
  });

  final String? alunoId;

  static String routeName = 'perfilaluno';
  static String routePath = '/perfilaluno';

  @override
  State<PerfilalunoWidget> createState() => _PerfilalunoWidgetState();
}

class _PerfilalunoWidgetState extends State<PerfilalunoWidget> {
  late PerfilalunoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Janela de tempo dos graficos de evolucao.
  ///
  /// Mesmas opcoes e mesmo padrao da tela de metricas: o personal olhando o
  /// perfil de um aluno precisa da mesma pergunta que faz no proprio painel —
  /// "isso melhorou em quanto tempo?".
  static const List<String> _periodos = [
    '7 dias',
    '15 dias',
    '30 dias',
    '2 meses',
    '3 meses',
    '4 meses',
    '6 meses',
  ];

  String _periodo = '4 meses';
  final FormFieldController<String> _periodoController =
      FormFieldController<String>('4 meses');

  /// Recarrega as metricas do aluno aberto na janela escolhida.
  Future<void> _carregarMetricas() => action_blocks.getMetricasAluno(
        context,
        meses: 4,
        periodo: _periodo,
        alunoUuid: widget.alunoId,
      );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilalunoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await action_blocks.getPerfilAluno(context, alunoId: widget.alunoId);
      // Metricas do aluno aberto, nao do personal logado.
      await _carregarMetricas();
      if (mounted) safeSetState(() {});
      if (mounted) {
        _model.isLoading = false;
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Qual recorte de Desenvolvimento esta a mostra: 0 metricas, 1 cargas,
  /// 2 corpo. Sem calendario: o personal quer o retrato do periodo, e o dia
  /// a dia ja e o assunto da aba Treinos.
  int _subAba = 0;

  /// Perimetros do aluno, buscados sob demanda.
  ///
  /// Nao vem no payload do perfil de proposito: e uma lista de ate treze
  /// medidas que so a aba Corpo usa, e carrega-la em toda abertura de ficha
  /// seria pagar por ela o tempo todo.
  List<dynamic>? _perimetros;
  String _perimetrosEm = '';
  bool _buscandoPerimetros = false;

  /// Exercicio do grafico de carga. Nulo ate a primeira escolha: ai assume o
  /// primeiro da lista, que e o que o grafico ja mostrava antes de existir
  /// seletor.
  String? _exercicioCarga;

  /// O exercicio em exibicao no grafico de carga.
  ///
  /// Cai no primeiro da lista quando ainda nao houve escolha: ou quando o
  /// escolhido some do periodo, o que acontece ao encurtar a janela: sem essa
  /// volta, o grafico ficaria pedindo um exercicio que nao existe mais ali.
  String _exercicioDaVez() {
    final lista = functions.listarExercicios(FFAppState().metricasTemp);
    if (lista.isEmpty) return '';
    if (_exercicioCarga != null && lista.contains(_exercicioCarga)) {
      return _exercicioCarga!;
    }
    return lista.first;
  }

  Future<void> _carregarPerimetros() async {
    if (_buscandoPerimetros) return;
    _buscandoPerimetros = true;

    final resposta = await CacheCurto.obter<Map<String, dynamic>>(
      'perimetros:${widget.alunoId}',
      () async {
        final cru = await SupaFlow.client.rpc('get_perimetros_aluno',
            params: {'p_aluno_uuid': widget.alunoId});
        return (cru as Map?)?.cast<String, dynamic>() ?? {};
      },
    );

    if (!mounted) {
      _buscandoPerimetros = false;
      return;
    }

    safeSetState(() {
      _perimetros = (resposta?['itens'] as List?) ?? const [];
      _perimetrosEm = resposta?['dataUltima']?.toString() ?? '';
      _buscandoPerimetros = false;
    });
  }

  /// As medidas de fita, abaixo da composicao corporal.
  ///
  /// Peso e IMC dizem o total; o perimetro diz onde ele foi parar. Sao as duas
  /// metades da mesma pergunta, e por isso ficam no mesmo lugar.
  Widget _perimetrosDoAluno(FlutterFlowTheme tema) {
    // Busca na primeira vez que a aba Corpo aparece, e nao no `initState`:
    // quem abre a ficha para ver o treino nunca precisou desta lista.
    if (_perimetros == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _carregarPerimetros());
      return const SizedBox.shrink();
    }
    if (_perimetros!.isEmpty) return const SizedBox.shrink();

    String medida(num v) =>
        '${v.toStringAsFixed(v % 1 == 0 ? 0 : 1).replaceAll('.', ',')} cm';

    final data = DateTime.tryParse(_perimetrosEm);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
        decoration: BoxDecoration(
          color: tema.primaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [tema.designToken.shadow.lg],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Perímetros',
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: tema.primaryText,
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (data != null)
                    Text(
                      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}',
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                        color: tema.secondaryText,
                        fontSize: 11.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
              child: Wrap(
                spacing: 18.0,
                runSpacing: 10.0,
                children: [
                  for (final item in _perimetros!)
                    Builder(builder: (context) {
                      final mapa = (item as Map).cast<String, dynamic>();
                      final atual = (mapa['atual'] as num?) ?? 0;
                      final variacao = (mapa['variacao'] as num?) ?? 0;
                      final medicoes = (mapa['medicoes'] as num?)?.toInt() ?? 1;

                      // A variacao so aparece com duas medicoes ou mais: com
                      // uma so ela e sempre zero, e um "0,0 cm" ao lado de
                      // toda medida vira ruido que ninguem le.
                      final mostraVariacao = medicoes > 1 && variacao != 0;
                      final subiu = variacao > 0;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                medida(atual),
                                style: tema.bodyMedium.override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                  color: tema.primaryText,
                                  fontSize: 15.0,
                                  letterSpacing: -0.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (mostraVariacao) ...[
                                const SizedBox(width: 4.0),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 2.0),
                                  child: Text(
                                    '${subiu ? '+' : ''}'
                                    '${variacao.toStringAsFixed(1).replaceAll('.', ',')}',
                                    style: tema.bodyMedium.override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600),
                                      color:
                                          subiu ? tema.primary : tema.secondary,
                                      fontSize: 10.5,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            mapa['tipo']?.toString() ?? '',
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400),
                              color: tema.secondaryText,
                              fontSize: 10.5,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Treino e validade abaixo do baralho, no mesmo desenho da tela do aluno.
  ///
  /// Os dois moravam num cartao acima das cartas, um ao lado do outro numa
  /// linha so: o nome do treino a esquerda e a validade em cinza a direita,
  /// ambos clicaveis sem parecer. Como atalhos eles ganham o quadrado de cor,
  /// o rotulo do que sao e a seta que promete o que o toque faz.
  Widget _atalhosDoTreino(FlutterFlowTheme tema) {
    final grupo = FFAppState().alunotemp.grupoTreino;
    final validade = functions.formataData(grupo.dataValidade);
    final hoje = DateTime.now();
    final dias = DateTime(validade.year, validade.month, validade.day)
        .difference(DateTime(hoje.year, hoje.month, hoje.day))
        .inDays;
    final vencido = dias < 0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AtalhoCartao(
            icone: FFIcons.kproperty1FiRrGym,
            cor: tema.primary,
            titulo: grupo.nome.isEmpty ? 'Nenhum treino atribuído' : grupo.nome,
            apoio: 'Toque para trocar o treino deste aluno',
            aoTocar: _trocarTreino,
          ),
          const SizedBox(height: 10.0),
          AtalhoCartao(
            // Vencido pinta de erro e ganha selo: e a unica das duas linhas
            // que pode exigir acao hoje, e em cinza ela se lia como legenda.
            icone: FFIcons.kproperty1FiRrCalendar,
            cor: vencido ? tema.error : tema.secondary,
            titulo: 'Válido até ${_dataCurta(validade)}',
            selo: vencido ? 'VENCIDO' : null,
            apoio: vencido
                ? 'O treino expirou, defina uma nova data'
                : (dias == 0
                    ? 'Expira hoje'
                    : '$dias ${dias == 1 ? 'dia' : 'dias'} até expirar'),
            aoTocar: _trocarValidade,
          ),
        ],
      ),
    );
  }

  String _dataCurta(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _trocarTreino() async {
    final trocou = await showModalBottomSheet<bool>(
      // No navegador raiz, como todas as outras folhas do app. Sem isto ela
      // subia no navegador da aba, e o seletor de data aberto por dentro
      // acabava na mesma pilha: fechar um deixava o outro em pe.
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: SelecionarTreinoAlunoWidget(
          alunoUuid: FFAppState().alunotemp.alunoUuid,
          grupoTreinoIdAtual: FFAppState().alunotemp.grupoTreino.grupoTreinoId,
          dataValidadeAtual: FFAppState().alunotemp.grupoTreino.dataValidade,
        ),
      ),
    );
    if (trocou == true && mounted) {
      await action_blocks.getPerfilAluno(context, alunoId: widget.alunoId);
      if (mounted) safeSetState(() {});
    }
  }

  Future<void> _trocarValidade() async {
    final escolhida = await custom_widgets.showCustomDatePicker(
      context,
      initialDate: () {
        final d = functions
            .formataData(FFAppState().alunotemp.grupoTreino.dataValidade);
        final agora = DateTime.now();
        return d.isBefore(agora) ? agora : d;
      }(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2099),
    );
    if (escolhida == null) return;

    final texto = '${escolhida.year.toString().padLeft(4, '0')}'
        '-${escolhida.month.toString().padLeft(2, '0')}'
        '-${escolhida.day.toString().padLeft(2, '0')}';

    await SupaFlow.client
        .from('TreinosExecucao')
        .update({'DataValidade': texto})
        .eq('ExecutorPerfisId', FFAppState().alunotemp.alunoUuid)
        .eq('Status', 'pendente')
        .or('IsDeleted.is.null,IsDeleted.eq.false');

    if (!mounted) return;
    FFAppState().alunotemp.grupoTreino.dataValidade = texto;
    safeSetState(() {});
  }

  /// Os blocos do treino, no mesmo baralho da tela inicial do aluno.
  ///
  /// Antes eram cartoes empilhados verticalmente com o nome do bloco em cinza
  /// por dentro e os grupos abrindo cartoes cinzas dentro do cartao branco.
  /// O baralho ja existia do outro lado do vinculo, com a mesma estrutura de
  /// dados: reaproveita-lo e o que faz o personal e o aluno olharem o mesmo
  /// treino com a mesma forma, em vez de duas telas que so coincidem no
  /// conteudo.
  Widget _blocosDeTreino(FlutterFlowTheme tema) {
    final blocos = FFAppState().alunotemp.grupoTreino.subagrupamentos.toList()
      ..sort((a, b) => a.ordem.compareTo(b.ordem));
    if (blocos.isEmpty) return const SizedBox.shrink();

    // Sem recuo lateral proprio: a aba ja abre com 16 de cada lado, e somar
    // o do baralho estreitava as cartas em 32.
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 36.0),
      child: BaralhoCartas(
        quantidade: blocos.length,
        altura: 210.0,
        construir: (context, i) {
          final bloco = blocos[i];
          return Container(
            decoration: BoxDecoration(
              color: tema.primaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [tema.designToken.shadow.lg],
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: () => _detalhesDoBloco(bloco),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _cartaDoBloco(tema, bloco),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// O que a carta mostra sem precisar abrir: o nome, os grupos e o tamanho.
  Widget _cartaDoBloco(FlutterFlowTheme tema, GruposStruct bloco) {
    final grupos = bloco.grupos.toList();
    final total = grupos.fold<int>(0, (soma, g) => soma + g.exercicios.length);
    final nomes = grupos.map((g) => g.subcategoria).where((n) => n.isNotEmpty);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bloco.nome.isEmpty ? 'Treino' : bloco.nome,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tema.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
            color: tema.primaryText,
            fontSize: 20.0,
            letterSpacing: -0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (nomes.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
            child: Text(
              nomes.join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                color: tema.secondaryText,
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        const Spacer(),
        // O tamanho do bloco e o convite a abrir, na mesma linha: e o que a
        // carta pode dizer sem virar a lista que ela justamente esconde.
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
              decoration: BoxDecoration(
                color: tema.accent1,
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Text(
                '$total ${total == 1 ? 'exercício' : 'exercícios'}',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: tema.primary,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Ver treino',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.primary,
                fontSize: 12.5,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: tema.primary, size: 16.0),
          ],
        ),
      ],
    );
  }

  /// A folha do bloco: os grupos e, dentro deles, os exercicios.
  ///
  /// A folha rola por dentro e chega ate 88% da tela. Um bloco com muitos
  /// grupos nao cabe em altura fixa, e cortar a lista aqui devolveria o
  /// problema que o baralho resolveu.
  Future<void> _detalhesDoBloco(GruposStruct bloco) async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (contexto) => WebViewAware(
        child: StatefulBuilder(
          builder: (contexto, refazer) {
            final tema = FlutterFlowTheme.of(contexto);

            // Relido do estado a cada quadro: editar ou incluir um exercicio
            // recarrega o perfil, e a folha precisa mostrar o resultado sem
            // pedir para fechar e abrir de novo.
            final atual = FFAppState()
                    .alunotemp
                    .grupoTreino
                    .subagrupamentos
                    .where((b) => b.treinoExecucaoId == bloco.treinoExecucaoId)
                    .firstOrNull ??
                bloco;

            final total = atual.grupos
                .fold<int>(0, (soma, g) => soma + g.exercicios.length);

            return FolhaPadrao(
              // Sem visto: cada edicao ja grava na propria folha. Aqui so se
              // le e se navega.
              fixos: [
                CabecaFolha(
                  titulo: atual.nome.isEmpty ? 'Treino' : atual.nome,
                  apoio: '$total ${total == 1 ? 'exercício' : 'exercícios'} '
                      'em ${atual.grupos.length} '
                      '${atual.grupos.length == 1 ? 'grupo' : 'grupos'}',
                  icone: FFIcons.kproperty1FiRrGym,
                ),
              ],
              filhos: [
                for (final grupo in atual.grupos)
                  _secaoDeGrupo(tema, atual, grupo,
                      aoMudar: () => refazer(() {})),
              ],
            );
          },
        ),
      ),
    );
    if (mounted) safeSetState(() {});
  }

  /// Um grupo muscular na folha: titulo azul com o "+" e o cartao da lista.
  Widget _secaoDeGrupo(
    FlutterFlowTheme tema,
    GruposStruct bloco,
    GrupossubcategoriasStruct grupo, {
    required VoidCallback aoMudar,
  }) {
    final exercicios = grupo.exercicios.toList()
      ..sort((a, b) => a.ordem.compareTo(b.ordem));

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, 0.0, MedidasFolha.lado, 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 10.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    grupo.subcategoria,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primary,
                      fontSize: 16.0,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                  child: Material(
                    color: tema.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () async {
                        await _novoExercicio(bloco, grupo);
                        aoMudar();
                      },
                      child: const SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: Icon(Icons.add_rounded,
                            color: Colors.white, size: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (exercicios.isEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
              child: Text(
                'Nenhum exercício neste grupo.',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                  color: tema.secondaryText,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: tema.primaryBackground,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [tema.designToken.shadow.lg],
              ),
              padding:
                  const EdgeInsetsDirectional.fromSTEB(14.0, 4.0, 14.0, 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var k = 0; k < exercicios.length; k++)
                    _linhaExercicio(tema, exercicios[k],
                        k == exercicios.length - 1, aoMudar),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _linhaExercicio(FlutterFlowTheme tema, ExerciciosStruct ex,
      bool ultimo, VoidCallback aoMudar) {
    // Serie, repeticao e descanso numa linha de apoio, e nao em dois chips: os
    // chips tinham o mesmo peso do nome e brigavam entre si.
    final apoio = '${ex.series} × ${ex.repeticoes}'
        '${ex.tempoDescansoSeg > 0 ? ' · ${ex.tempoDescansoSeg}s descanso' : ''}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {
            await _editarExercicio(ex);
            aoMudar();
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 11.0, 0.0, 11.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ex.nome.isEmpty ? '-' : ex.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          color: tema.primaryText,
                          fontSize: 13.5,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        apoio,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                          color: tema.secondaryText,
                          fontSize: 11.5,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(FFIcons.kproperty1FiRrEdit,
                    color: tema.primary, size: 15.0),
              ],
            ),
          ),
        ),
        if (!ultimo)
          Divider(height: 1.0, thickness: 1.0, color: tema.alternate),
      ],
    );
  }

  Future<void> _editarExercicio(ExerciciosStruct ex) async {
    final ok = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => WebViewAware(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: AlunosEditExercicioWidget(exercicio: ex),
          ),
        ),
      ),
    );
    if (ok == true && mounted) {
      await action_blocks.getPerfilAluno(context, alunoId: widget.alunoId);
    }
    if (mounted) safeSetState(() {});
  }

  Future<void> _novoExercicio(
      GruposStruct bloco, GrupossubcategoriasStruct grupo) async {
    final ok = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => WebViewAware(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: AlunosNovoExercicioWidget(
              grupo: grupo.subcategoriaId,
              treinoExecucaoId: bloco.treinoExecucaoId,
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) {
      await action_blocks.getPerfilAluno(context, alunoId: widget.alunoId);
    }
    if (mounted) safeSetState(() {});
  }

  /// A aba Pagamento, no mesmo desenho da ficha que o aluno ve do personal.
  ///
  /// Eram duas listas diferentes para o mesmo assunto: o aluno via cobrancas
  /// com selo colorido e valor a direita, o personal via um bloco proprio com
  /// etiqueta de status no meio do texto. Quem sustenta as duas telas e a
  /// mesma pessoa, e ela reaprendia a ler a cada troca de lado.
  Widget _abaPagamento(FlutterFlowTheme tema) {
    final pgtos = FFAppState().alunotemp.pagamentos.toList()
      ..sort((a, b) => (DateTime.tryParse(b.dataVencimento) ?? DateTime(1900))
          .compareTo(DateTime.tryParse(a.dataVencimento) ?? DateTime(1900)));

    if (pgtos.isEmpty) {
      return _avisoPgto(
        tema,
        FFIcons.kproperty1FiRrDollar,
        'Nenhuma cobrança ainda',
        'Quando você registrar uma cobrança para este aluno, ela aparece aqui.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CabecaSecao(titulo: 'Histórico de cobranças'),
        const SizedBox(height: 10.0),
        CartaoPerfil(
          divisoriaNoTexto: true,
          filhos: [for (final pg in pgtos) _linhaPagamento(tema, pg)],
        ),
      ],
    );
  }

  Widget _linhaPagamento(FlutterFlowTheme tema, PagamentosStruct pg) {
    final ({IconData icone, Color cor, Color fundo, String texto}) visual =
        switch (pg.status) {
      'pago' => (
          icone: Icons.check_rounded,
          cor: tema.success,
          fundo: tema.success.withValues(alpha: 0.13),
          texto: 'Pago',
        ),
      'atrasado' => (
          icone: Icons.priority_high_rounded,
          cor: tema.secondary,
          fundo: tema.secondary.withValues(alpha: 0.14),
          texto: 'Venceu ${_dataPgto(pg.dataVencimento)}',
        ),
      'aguardando' => (
          icone: Icons.hourglass_empty_rounded,
          cor: tema.primary,
          fundo: tema.accent1,
          texto: 'Aguardando confirmação',
        ),
      _ => (
          icone: Icons.schedule_rounded,
          cor: tema.secondaryText,
          fundo: tema.alternate.withValues(alpha: 0.4),
          texto: 'Vence ${_dataPgto(pg.dataVencimento)}',
        ),
    };

    // Do outro lado do vinculo a acao e informar que pagou; aqui e dar baixa.
    // Uma cobranca quitada nao tem o que registrar, e um alvo que abre folha
    // para nada ensina a nao tocar.
    final podeBaixar = pg.status != 'pago';

    return LinhaPerfil(
      icone: visual.icone,
      corIcone: visual.cor,
      fundoIcone: visual.fundo,
      titulo: pg.descricao.isEmpty ? 'Cobrança' : pg.descricao,
      subtitulo: visual.texto,
      valor: 'R\$ ${_valorPgto(pg.valor)}',
      mostraSeta: podeBaixar,
      aoTocar: podeBaixar ? () => _registrarRecebimento(pg) : null,
    );
  }

  Widget _avisoPgto(
      FlutterFlowTheme tema, IconData icone, String titulo, String texto) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: tema.accent1, shape: BoxShape.circle),
            child: Icon(icone, color: tema.primary, size: 24.0),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 4.0),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.primaryText,
                fontSize: 14.0,
                letterSpacing: -0.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w400),
              color: tema.secondaryText,
              fontSize: 12.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w400,
              lineHeight: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  /// "1.234,50": virgula decimal e ponto de milhar, como se le em portugues.
  String _valorPgto(double v) {
    final partes = v.toStringAsFixed(2).split('.');
    final inteiro = partes[0];
    final buffer = StringBuffer();
    for (var i = 0; i < inteiro.length; i++) {
      if (i > 0 && (inteiro.length - i) % 3 == 0) buffer.write('.');
      buffer.write(inteiro[i]);
    }
    return '$buffer,${partes[1]}';
  }

  String _dataPgto(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }

  /// Registra o recebimento a partir da ficha do aluno.
  ///
  /// A mesma folha e a mesma RPC da tela de cobranca: o personal esta olhando
  /// a ficha, ve a cobranca em aberto e nao deveria precisar sair dali para
  /// dar baixa: sair e voltar e onde ele desiste.
  Future<void> _registrarRecebimento(PagamentosStruct pgto) async {
    final forma = await confirmarRecebimento(
      context,
      descricao: pgto.descricao.isNotEmpty ? pgto.descricao : 'mensalidade',
      valor: pgto.valor.toStringAsFixed(2).replaceAll('.', ','),
      nomeAluno: FFAppState().alunotemp.nome,
      formaInformada: pgto.tipoPagamento.isNotEmpty ? pgto.tipoPagamento : null,
    );
    if (forma == null || !mounted) return;

    try {
      final resposta = await PersonalGroup.confirmarPagamentoCall.call(
        pPagamentoId: pgto.id,
        pPersonalUuid: currentUserUid,
        pTipoPagamento: forma,
      );
      if (!mounted) return;

      // O RPC responde 200 mesmo quando recusa: a negativa vem no corpo.
      final ok = resposta.succeeded &&
          getJsonField(resposta.jsonBody, r'$.sucesso') == true;

      if (ok) {
        await action_blocks.getPerfilAluno(context, alunoId: widget.alunoId);
        if (mounted) safeSetState(() {});
      }
      if (!mounted) return;
      await showModalBottomSheet<void>(
        useRootNavigator: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => WebViewAware(
          child: MensagemWidget(
            texto: ok
                ? 'Pagamento registrado!'
                : 'Não consegui registrar agora. Tente de novo.',
            tipo: ok ? '1' : '2',
            fechasozinho: ok,
            mostrabotoes: false,
            action: () async {},
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      await showModalBottomSheet<void>(
        useRootNavigator: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => WebViewAware(
          child: MensagemWidget(
            texto: 'Não consegui registrar agora. Tente de novo.',
            tipo: '2',
            fechasozinho: false,
            mostrabotoes: false,
            action: () async {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    context.watch<cupertino_time_picker_hiuzb7_app_state.FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        // Cabecalho flutuando sobre a rolagem, como nas outras fichas: a
        // capa passa por tras dele e sobe junto com o conteudo.
        body: Stack(
          children: [
            SafeArea(
              // `top: false`: a rolagem comeca no topo absoluto, senao a capa
              // pararia embaixo da barra de status.
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: _model.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary,
                              strokeWidth: 2.5,
                            ),
                          )
                        : SingleChildScrollView(
                            primary: false,
                            controller: _model.columnController1,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // A ficha do aluno no mesmo desenho das demais:
                                // capa, avatar cavalgando a borda, nome, vinculo e
                                // as acoes de contato na direita.
                                //
                                // Eram oitocentas linhas geradas montando avatar,
                                // trio de numeros, bio e botoes a mao. O que estava
                                // ali nao era diferente por necessidade: era
                                // diferente por ter sido escrito antes de existir
                                // um padrao.
                                Builder(builder: (context) {
                                  final a = FFAppState().alunotemp;
                                  final tema = FlutterFlowTheme.of(context);

                                  final forte = tema.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold),
                                    color: tema.primaryText,
                                    fontSize: 13.5,
                                    letterSpacing: -0.2,
                                    fontWeight: FontWeight.bold,
                                  );
                                  final fraco = tema.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400),
                                    color: tema.secondaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w400,
                                  );

                                  // Idade, altura e peso no formato de "x alunos x
                                  // treinos" da ficha publica: numero em negrito,
                                  // unidade em cinza. Cada um so aparece se houver
                                  // valor: "0 kg" e pior que nada.
                                  final medidas = <({String v, String r})>[
                                    if ('${a.idade}'.isNotEmpty &&
                                        '${a.idade}' != '0')
                                      (v: '${a.idade}', r: 'anos'),
                                    if ('${a.altura}'.isNotEmpty &&
                                        '${a.altura}' != '0' &&
                                        '${a.altura}' != '0.0')
                                      (
                                        v: '${a.altura}'.replaceAll('.', ','),
                                        r: 'de altura'
                                      ),
                                    if ('${a.pesoAtual}'.isNotEmpty &&
                                        '${a.pesoAtual}' != '0' &&
                                        '${a.pesoAtual}' != '0.0')
                                      (
                                        v: '${a.pesoAtual}'
                                            .replaceAll('.', ','),
                                        r: 'kg'
                                      ),
                                  ];

                                  final bio = a.bio;

                                  return CapaPerfil(
                                    // Cresce para tras da barra de status e do
                                    // cabecalho, e rola junto com o conteudo.
                                    alturaExtraTopo:
                                        MediaQuery.paddingOf(context).top +
                                            52.0,
                                    nome: a.nome.isEmpty ? '...' : a.nome,
                                    foto: a.fotoUrl,
                                    aoTocarFoto: a.fotoUrl.isEmpty
                                        ? null
                                        : () => mostrarFotoEmTelaCheia(
                                              context,
                                              url: a.fotoUrl,
                                              titulo: a.nome,
                                            ),
                                    // Vinculo e estado em texto puro. "Ativa" em
                                    // verde e "Inativa" em cinza: a cor faz o
                                    // trabalho que uma pilula faria, sem recortar
                                    // a linha da identidade.
                                    linha: TextSpan(children: [
                                      if (a.nickname.isNotEmpty)
                                        TextSpan(text: '@${a.nickname}  ·  '),
                                      TextSpan(
                                        text: a.ativo ? 'Ativo' : 'Inativo',
                                        style: TextStyle(
                                          color: a.ativo
                                              ? tema.success
                                              : tema.secondaryText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ]),
                                    // 'Preencha sua bio' era o texto que o cadastro
                                    // deixava; exibido, virava a bio do aluno.
                                    bio: (bio.isEmpty ||
                                            bio == '-' ||
                                            bio == 'Preencha sua bio')
                                        ? null
                                        : bio,
                                    extra: medidas.isEmpty
                                        ? null
                                        : Wrap(
                                            spacing: 14.0,
                                            runSpacing: 4.0,
                                            children: [
                                              for (final m in medidas)
                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text: m.v, style: forte),
                                                  TextSpan(
                                                      text: ' ${m.r}',
                                                      style: fraco),
                                                ])),
                                            ],
                                          ),
                                    acoes: [
                                      if (a.telefone.isNotEmpty) ...[
                                        AcaoIconePerfil(
                                          // O glifo oficial do WhatsApp: o balao generico nao
                                          // diz para onde o toque leva, e aqui ele
                                          // leva para fora do app.
                                          desenho: FaIcon(
                                              FontAwesomeIcons.whatsapp,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 15.0),
                                          aoTocar: () => launchURL(
                                              'https://wa.me/55${a.telefone}'),
                                        ),
                                        const SizedBox(width: 8.0),
                                      ],
                                      if (a.email.isNotEmpty)
                                        AcaoIconePerfil(
                                          icone: FFIcons
                                              .kproperty1FiRrEnvelopeOpen,
                                          aoTocar: () => launchUrl(Uri(
                                              scheme: 'mailto', path: a.email)),
                                        ),
                                    ],
                                  );
                                }),
                                // Abas no padrao de chips do app. Eram dois pares
                                // de FFButtonWidget com width fixo de 114: que
                                // nao comporta "Desenvolvimento".
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 0.0),
                                  child: LinhaChipsFiltro(
                                    chips: [
                                      ChipFiltro(
                                        texto: 'Treinos',
                                        selecionado: _model.menu == 0,
                                        onTap: () =>
                                            safeSetState(() => _model.menu = 0),
                                      ),
                                      ChipFiltro(
                                        texto: 'Desenvolvimento',
                                        selecionado: _model.menu == 1,
                                        onTap: () =>
                                            safeSetState(() => _model.menu = 1),
                                      ),
                                      // Metas em aba propria: elas nao sao
                                      // desenvolvimento medido, sao o combinado
                                      // entre os dois: e dentro daquela aba
                                      // dividiam espaco com numeros que respondem
                                      // outra pergunta.
                                      ChipFiltro(
                                        texto: 'Metas',
                                        selecionado: _model.menu == 3,
                                        onTap: () =>
                                            safeSetState(() => _model.menu = 3),
                                      ),
                                      ChipFiltro(
                                        texto: 'Pagamento',
                                        selecionado: _model.menu == 2,
                                        onTap: () =>
                                            safeSetState(() => _model.menu = 2),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_model.menu == 0)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 32.0;
                                            } else {
                                              return 32.0;
                                            }
                                          }(),
                                          0.0,
                                        ),
                                        16.0,
                                        valueOrDefault<double>(
                                          () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 16.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointLarge) {
                                              return 32.0;
                                            } else {
                                              return 32.0;
                                            }
                                          }(),
                                          0.0,
                                        ),
                                        0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        _blocosDeTreino(
                                            FlutterFlowTheme.of(context)),
                                        _atalhosDoTreino(
                                            FlutterFlowTheme.of(context)),
                                      ],
                                    ),
                                  ),
                                if (_model.menu == 2)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 0.0),
                                    child: _abaPagamento(
                                        FlutterFlowTheme.of(context)),
                                  ),
                                // O cartao inteiro so existe na aba Metas.
                                //
                                // Antes so o conteudo era escondido por
                                // `Visibility`: o cartao branco continuava
                                // sendo construido, e nas outras abas sobrava
                                // um bloco vazio empurrando tudo para baixo.
                                if (_model.menu == 3) ...[
                                  // Titulo, apoio e o "+" no mesmo desenho da
                                  // tela de Metas que o aluno ve.
                                  //
                                  // O botao morava tracejado dentro do cartao,
                                  // acima da lista: quem chegava na aba lia
                                  // primeiro um convite a criar, e so depois
                                  // descobria o que ja existia. Subindo para o
                                  // lado do titulo, ele volta a ser o que e —
                                  // uma acao sobre a lista, nao o assunto dela.
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            19.0, 26.0, 16.0, 22.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Onde ele quer chegar',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 16.0,
                                                      letterSpacing: -0.2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8.0, 0.0, 0.0, 0.0),
                                              // Laranja so aqui: nesta ficha o
                                              // azul ja e a cor das abas e dos
                                              // seletores, e mais um circulo
                                              // azul no meio do conteudo lia
                                              // como navegacao.
                                              child: Material(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                shape: const CircleBorder(),
                                                child: InkWell(
                                                  customBorder:
                                                      const CircleBorder(),
                                                  onTap: () async {
                                                    await showModalBottomSheet(
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return WebViewAware(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                            child: Padding(
                                                              padding: MediaQuery
                                                                  .viewInsetsOf(
                                                                      context),
                                                              child:
                                                                  AlunosNovoObjetivoWidget(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() => _model
                                                                .cadastroumeta =
                                                            value));

                                                    if (_model.cadastroumeta ==
                                                        true) {
                                                      await action_blocks
                                                          .getPerfilAluno(
                                                        context,
                                                        alunoId:
                                                            widget!.alunoId,
                                                      );
                                                      safeSetState(() {});
                                                    }

                                                    safeSetState(() {});
                                                  },
                                                  child: const SizedBox(
                                                    width: 24.0,
                                                    height: 24.0,
                                                    child: Icon(
                                                      Icons.add_rounded,
                                                      color: Colors.white,
                                                      size: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                          child: Text(
                                            'As metas deste aluno. Use o + para '
                                            'definir uma nova.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w400,
                                                  lineHeight: 1.35,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 16.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        boxShadow: [
                                          FlutterFlowTheme.of(context)
                                              .designToken
                                              .shadow
                                              .lg
                                        ],
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final metas = FFAppState()
                                              .alunotemp
                                              .metas
                                              .map((e) => e)
                                              .toList();

                                          if (metas.isEmpty) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Text(
                                                'Nenhuma meta definida ainda.',
                                                textAlign: TextAlign.center,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 12.5,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            );
                                          }

                                          return ListView.separated(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            // Sem rolagem propria: o cartao ja
                                            // vive dentro da rolagem da ficha,
                                            // e duas areas roláveis empilhadas
                                            // roubavam o gesto uma da outra.
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: metas.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(height: 6.0),
                                            itemBuilder: (context, metasIndex) {
                                              final metasItem =
                                                  metas[metasIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    useRootNavigator: true,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return WebViewAware(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                AlunosEditarObjetivoWidget(
                                                              metas: metasItem,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() =>
                                                          _model.editoumetas =
                                                              value));

                                                  if (_model.editoumetas ==
                                                      true) {
                                                    await action_blocks
                                                        .getPerfilAluno(
                                                      context,
                                                      alunoId: widget!.alunoId,
                                                    );
                                                    safeSetState(() {});
                                                  }

                                                  safeSetState(() {});
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  16.0),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: 44.0,
                                                                    height:
                                                                        44.0,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              CircularPercentIndicator(
                                                                            percent:
                                                                                metasItem.progresso.toDouble() / 100,
                                                                            radius:
                                                                                20.0,
                                                                            lineWidth:
                                                                                4.0,
                                                                            animation:
                                                                                true,
                                                                            animateFromLastPercent:
                                                                                true,
                                                                            progressColor:
                                                                                FlutterFlowTheme.of(context).secondary,
                                                                            backgroundColor:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                30.0,
                                                                            height:
                                                                                30.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).accent2,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Icon(
                                                                                Icons.emoji_flags,
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                size: 20.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                child: Text(
                                                                                  metasItem.titulo,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        font: GoogleFonts.inter(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Align(
                                                                              alignment: AlignmentDirectional(1.0, 0.0),
                                                                              child: Text(
                                                                                '${metasItem.progresso.toString()}%',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).secondary,
                                                                                      fontSize: 12.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
                                                                                child: Text(
                                                                                  valueOrDefault<String>(
                                                                                    metasItem.descricao,
                                                                                    '-',
                                                                                  ),
                                                                                  maxLines: 2,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        font: GoogleFonts.inter(
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 12.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        8.0)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // A ultima meta nao leva
                                                    // divisoria: dentro do
                                                    // cartao ela virava um
                                                    // risco solto antes da
                                                    // borda.
                                                    if (metasIndex <
                                                        metas.length - 1)
                                                      Divider(
                                                        height: 1.0,
                                                        thickness: 1.0,
                                                        indent: 68.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                                if (_model.menu == 1) ...[
                                  // ── METRICAS ──────────────────────────
                                  // A RPC sempre aceitou qualquer aluno; faltava a
                                  // tela do personal pedir as do aluno aberto.
                                  // Rotulo e seletor no mesmo cartao branco.
                                  //
                                  // Soltos sobre o cinza, os dois pareciam
                                  // sobras entre a barra de abas e os graficos.
                                  // Juntos num cartao, viram o controle do que
                                  // vem abaixo: que e o que eles sao.
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 14.0, 16.0, 10.0),
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 10.0, 12.0, 10.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        boxShadow: [
                                          FlutterFlowTheme.of(context)
                                              .designToken
                                              .shadow
                                              .lg
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 0.0, 4.0, 6.0),
                                            child: Text(
                                              'Tempo em análise',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          // O risco primary sob o campo, e nao
                                          // uma caixa em volta: o cartao ja e a
                                          // moldura, o campo so precisa marcar
                                          // onde se toca.
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: FlutterFlowDropDown<String>(
                                              controller: _periodoController,
                                              options: _periodos,
                                              onChanged: (val) async {
                                                if (val == null) return;
                                                safeSetState(
                                                    () => _periodo = val);
                                                await _carregarMetricas();
                                                if (mounted)
                                                  safeSetState(() {});
                                              },
                                              width: double.infinity,
                                              height: 40.0,
                                              maxHeight: 200.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                              hintText: 'Selecione...',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              elevation: 0.0,
                                              // Sem borda e sem elevacao propria: o
                                              // cartao em volta ja separa o bloco do
                                              // fundo, e o contorno virava uma segunda
                                              // moldura dentro da primeira.
                                              borderColor: Colors.transparent,
                                              borderWidth: 0.0,
                                              borderRadius: 0.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Os mesmos chips da tela de metricas, menos
                                  // o calendario: aqui o personal quer o retrato
                                  // do periodo, e nao o dia a dia.
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 4.0, 16.0, 12.0),
                                    child: ChipsPerfil(
                                      rotulos: const [
                                        'Métricas',
                                        'Cargas',
                                        'Corpo'
                                      ],
                                      selecionado: _subAba,
                                      aoSelecionar: (i) =>
                                          safeSetState(() => _subAba = i),
                                    ),
                                  ),
                                  // O painel inteiro das metricas do aluno.
                                  //
                                  // E o mesmo componente que o aluno ve na aba
                                  // Metricas: nao uma copia. O personal
                                  // acompanha exatamente os numeros que o aluno
                                  // acompanha, e ajustar o painel muda os dois.
                                  if (_subAba == 0)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 8.0),
                                      child: PainelMetricas(
                                        // `.dsMetricas`, e nao o struct inteiro:
                                        // `metricasTemp` e o envelope, e o painel
                                        // le o bloco de dados dentro dele.
                                        metricas: FFAppState()
                                            .metricasTemp
                                            .dsMetricas,
                                        periodoLabel: _periodo,
                                      ),
                                    ),
                                  // Composicao corporal acima do grafico.
                                  //
                                  // O grafico conta a trajetoria; estes contam
                                  // onde a pessoa esta hoje. Sem eles, "Corpo"
                                  // respondia so a segunda pergunta: e a
                                  // primeira e a que o personal faz antes.
                                  //
                                  // Peso e altura ja aparecem no topo da ficha,
                                  // mas aqui eles vem com a data da medicao e
                                  // ao lado do IMC, que e o que os torna
                                  // leitura clinica em vez de cadastro.
                                  if (_subAba == 2)
                                    Builder(builder: (context) {
                                      final c =
                                          FFAppState().metricasTemp.dsCabecalho;
                                      final tema = FlutterFlowTheme.of(context);

                                      String n(double v, int casas) => v
                                          .toStringAsFixed(casas)
                                          .replaceAll('.', ',');

                                      final itens = <({String r, String v})>[
                                        // Sem peso e altura: ja sao fixos no topo
                                        // da ficha, e repetir aqui gasta a
                                        // atencao que o IMC e a gordura pedem.
                                        if (c.imc > 0)
                                          (r: 'IMC', v: n(c.imc, 1)),
                                        if (c.gordura > 0)
                                          (
                                            r: 'Gordura',
                                            v: '${n(c.gordura, 1)}%'
                                          ),
                                      ];

                                      if (itens.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      final data =
                                          DateTime.tryParse(c.dataRegistro);

                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 0.0, 16.0, 10.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 10.0, 12.0, 10.0),
                                          decoration: BoxDecoration(
                                            color: tema.primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            boxShadow: [
                                              tema.designToken.shadow.lg
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        4.0, 0.0, 4.0, 6.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Composição corporal',
                                                        style: tema.bodyMedium
                                                            .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          color:
                                                              tema.primaryText,
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    // A data da medicao: um peso
                                                    // sem data envelhece sem
                                                    // avisar.
                                                    if (data != null)
                                                      Text(
                                                        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}',
                                                        style: tema.bodyMedium
                                                            .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          color: tema
                                                              .secondaryText,
                                                          fontSize: 11.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        4.0, 0.0, 4.0, 0.0),
                                                child: Wrap(
                                                  spacing: 18.0,
                                                  runSpacing: 10.0,
                                                  children: [
                                                    for (final i in itens)
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            i.v,
                                                            style: tema
                                                                .bodyMedium
                                                                .override(
                                                              font: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              color: tema
                                                                  .primaryText,
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  -0.3,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            i.r,
                                                            style: tema
                                                                .bodyMedium
                                                                .override(
                                                              font: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              color: tema
                                                                  .secondaryText,
                                                              fontSize: 10.5,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  if (_subAba == 2)
                                    _perimetrosDoAluno(
                                        FlutterFlowTheme.of(context)),
                                  if (_subAba == 2)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          boxShadow: [
                                            FlutterFlowTheme.of(context)
                                                .designToken
                                                .shadow
                                                .lg
                                          ],
                                        ),
                                        // Sem recuo proprio: o grafico ja
                                        // abre com 16 em volta do conteudo, e
                                        // somar o do cartao dobrava a folga.
                                        child:
                                            custom_widgets.GraficoEvolucaoPeso(
                                          width: double.infinity,
                                          height: 280.0,
                                          periodoLabel: _periodo,
                                          corPrimaria:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                        ),
                                      ),
                                    ),
                                  // O seletor de exercicio: sem ele o grafico
                                  // mostrava sempre o primeiro da lista, e a
                                  // aba nao tinha como responder "e o supino?".
                                  if (_subAba == 1 &&
                                      functions
                                          .listarExercicios(
                                              FFAppState().metricasTemp)
                                          .isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 10.0),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 10.0, 12.0, 10.0),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          boxShadow: [
                                            FlutterFlowTheme.of(context)
                                                .designToken
                                                .shadow
                                                .lg
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      4.0, 0.0, 4.0, 6.0),
                                              child: Text(
                                                'Exercício',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 13.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                            // O mesmo risco primary do campo
                                            // de periodo.
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                // Ordenado: a lista vem na ordem
                                                // do banco, e procurar um nome
                                                // numa lista sem ordem e pior
                                                // que rolar a lista inteira.
                                                options: (functions
                                                    .listarExercicios(
                                                        FFAppState()
                                                            .metricasTemp)
                                                    .toList()
                                                  ..sort((a, b) => a
                                                      .toLowerCase()
                                                      .compareTo(
                                                          b.toLowerCase()))),
                                                // `controller` com o valor da
                                                // vez: este dropdown nao aceita
                                                // valor inicial solto.
                                                controller:
                                                    FormFieldController<String>(
                                                        _exercicioDaVez()),
                                                onChanged: (val) =>
                                                    safeSetState(() =>
                                                        _exercicioCarga = val),
                                                width: double.infinity,
                                                height: 40.0,
                                                maxHeight: 260.0,
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 24.0,
                                                ),
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                elevation: 0.0,
                                                borderColor: Colors.transparent,
                                                borderWidth: 0.0,
                                                borderRadius: 0.0,
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        4.0, 0.0, 0.0, 0.0),
                                                hidesUnderline: true,
                                                isOverButton: false,
                                                isSearchable: false,
                                                isMultiSelect: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_subAba == 1 &&
                                      functions
                                          .listarExercicios(
                                              FFAppState().metricasTemp)
                                          .isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          boxShadow: [
                                            FlutterFlowTheme.of(context)
                                                .designToken
                                                .shadow
                                                .lg
                                          ],
                                        ),
                                        // Sem recuo proprio: o grafico ja
                                        // abre com 16 em volta do conteudo, e
                                        // somar o do cartao dobrava a folga.
                                        child:
                                            custom_widgets.GraficoEvolucaoCarga(
                                          width: double.infinity,
                                          height: 280.0,
                                          exercicioSelecionado:
                                              _exercicioDaVez(),
                                          periodoLabel: _periodo,
                                          corPrimaria:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                        ),
                                      ),
                                    ),
                                ],
                              ].addToEnd(SizedBox(height: 16.0)),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            // A barra por cima da rolagem, sem fundo: a capa passa por
            // baixo dela e some ao subir, como qualquer conteudo.
            // `Positioned` com as tres bordas, e `mainAxisSize.min` na coluna.
            //
            // Como filho solto do Stack, esta camada recebia restricoes
            // frouxas e a Column em `max` esticava ate o rodape: a barra
            // ocupava a tela inteira, transparente, e engolia todos os toques.
            // Dava a impressao de app travado: a tela aparecia e nada
            // respondia.
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: SafeArea(
                bottom: false,
                child: Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().alunotemp = PerfilAlunoStruct();
                                safeSetState(() {});
                                context.safePop();
                              },
                              // O voltar do kit: circulo branco com
                              // sombra, como nas demais fichas.
                              child: Container(
                                width: 36.0,
                                height: 36.0,
                                // Preto translucido, como nas outras fichas: a
                                // barra fica sobre a capa azul, e branco a 22%
                                // quase nao aparecia: o caminho de volta sumia
                                // junto com o botao.
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.28),
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    FFIcons.kproperty1FiRrArrowSmallLeft,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            // Sem o nick aqui: ele ja aparece sob
                            // o nome, na capa. Repetido no topo,
                            // ele dizia duas vezes a mesma coisa e
                            // ainda ocupava a barra que agora e
                            // transparente.
                            const Spacer(),
                            // O icone da Apple saiu: ele era um espacador
                            // invisivel, pintado da cor do fundo para equilibrar
                            // o titulo centralizado. Sem titulo e com a barra
                            // sobre a capa azul, ele deixou de ser invisivel e
                            // virou uma maca no canto.
                            //
                            // No lugar dele, o ajuste do vinculo: mesmo circulo
                            // preto translucido do voltar, na outra ponta da
                            // mesma barra.
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await showModalBottomSheet<void>(
                                  useRootNavigator: true,
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => WebViewAware(
                                    child: PerfilAlunoStatusWidget(),
                                  ),
                                );
                                if (mounted) safeSetState(() {});
                              },
                              child: Container(
                                width: 36.0,
                                height: 36.0,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.28),
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    FFIcons.kproperty1FiRrSettings,
                                    color: Colors.white,
                                    size: 20.0,
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
            ),
          ],
        ),
      ),
    );
  }
}

import '/components/campo_busca.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/df_estado_vazio.dart';
import '/components/aviso_plano_free.dart';
import '/components/perfil_kit.dart';
import '/backend/supabase/supabase.dart';
import '/components/lista_notificacoes.dart';
import '/components/foto_tela_cheia.dart';
import '/components/chip_filtro.dart';
import '/components/empty_aluno_widget.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/alunos/novo_aluno/novo_aluno_widget.dart';
import '/pages/components/navbar/navbar_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'aluno_model.dart';
export 'aluno_model.dart';

class AlunoWidget extends StatefulWidget {
  const AlunoWidget({super.key});

  static String routeName = 'aluno';
  static String routePath = '/aluno';

  @override
  State<AlunoWidget> createState() => _AlunoWidgetState();
}

class _AlunoWidgetState extends State<AlunoWidget> {
  late AlunoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlunoModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.menu = 0;
      safeSetState(() {});
      _model.alunospersonal =
          FFAppState().alunosdopersonal.toList().cast<PersonalalunosStruct>();
      safeSetState(() {});
      // Pinta o cache e busca de novo.
      //
      // A lista so era carregada no Loading, entao convite aceito depois disso
      // seguia aparecendo como pendente ate o app ser reaberto: quem aceita e o
      // aluno, do outro lado, e nao tem como avisar este cache. Vale para o
      // personal que se convida tambem, onde os dois lados sao a mesma pessoa e
      // a defasagem aparece na hora.
      await action_blocks.alunosdopersonal(
        context,
        uuidpersonal: currentUserUid,
      );
      if (!mounted) return;
      _model.alunospersonal =
          FFAppState().alunosdopersonal.toList().cast<PersonalalunosStruct>();
      safeSetState(() {});
      await action_blocks.loadingNotifica(context);
      safeSetState(() {});
      // A folha das nao lidas so aparece depois de a lista chegar do
      // servidor, senao ela abriria sempre vazia no primeiro acesso.
      if (!mounted) return;
      await mostrarNotificacoesNaoLidas(context);
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Abre a conversa do aluno no WhatsApp.
  ///
  /// A RPC ja devolve o telefone marcado como WhatsApp na frente
  /// (ORDER BY "IsWhatsApp" DESC), entao aqui basta normalizar. O wa.me exige
  /// so digitos com DDI; numero salvo sem o 55 recebe o prefixo.
  Future<void> _abrirWhatsApp(
    PersonalalunosStruct aluno, {
    String? mensagem,
  }) async {
    final digitos = aluno.telefone.replaceAll(RegExp(r'\D'), '');
    if (digitos.isEmpty) {
      if (!mounted) return;
      await showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => MensagemWidget(
            texto: 'Este aluno não tem telefone cadastrado.',
            tipo: '2',
            action: () async {},
            fechasozinho: true,
            mostrabotoes: false),
      );
      return;
    }
    final numero = digitos.startsWith('55') ? digitos : '55$digitos';
    final url = mensagem == null
        ? 'https://wa.me/$numero'
        : 'https://wa.me/$numero?text=$mensagem';
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  /// Cobra pelo app, com o valor no texto.
  ///
  /// Era um link de WhatsApp com a mensagem pronta. Cobranca por fora tira a
  /// conversa de dentro do produto: o valor vira texto solto, o aluno responde
  /// por la e nada volta para o historico. Como notificacao, ela chega pelo
  /// mesmo canal das outras e o push sai de graca — o gatilho ja existe.
  ///
  /// O valor e somado no banco, nao mandado daqui: esta lista pode estar
  /// desatualizada, e cobrar algo que ja foi pago e pior que nao cobrar.
  Future<void> _cobrarAluno(PersonalalunosStruct aluno) async {
    try {
      final r = await SupaFlow.client
          .rpc('cobrar_aluno', params: {'p_aluno_uuid': aluno.alunoUuid});
      final mapa = (r as Map?)?.cast<String, dynamic>() ?? {};
      if (!mounted) return;

      final ok = mapa['sucesso'] == true;
      final texto = !ok
          ? (mapa['erro'] == 'NADA_EM_ABERTO'
              ? 'Este aluno não tem nada em aberto.'
              : 'Não consegui enviar a cobrança agora.')
          : (mapa['jaCobrado'] == true
              // Silenciar o segundo toque sem dizer nada faria parecer que
              // nao funcionou.
              ? 'Você já cobrou este aluno hoje.'
              : 'Lembrete enviado.');

      await _avisar(texto, sucesso: ok);
    } catch (_) {
      if (!mounted) return;
      await _avisar('Não consegui enviar a cobrança agora.', sucesso: false);
    }
  }

  /// O aviso do app, e nao a barrinha do sistema.
  ///
  /// O `SnackBar` do Material nao tem nada do nosso desenho: cor, tipografia e
  /// animacao sao de outro produto, e ele aparece no rodape, longe de onde o
  /// dedo acabou de tocar.
  Future<void> _avisar(String texto, {required bool sucesso}) async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WebViewAware(
        child: MensagemWidget(
          texto: texto,
          tipo: sucesso ? '1' : '2',
          fechasozinho: sucesso,
          mostrabotoes: false,
          action: () async {},
        ),
      ),
    );
  }

  /// Ativa ou inativa o vinculo com o aluno.
  ///
  /// A RPC devolve o estado novo; a lista local e atualizada com ele em vez de
  /// assumir o oposto do atual, para a tela nao divergir do banco se a
  /// chamada falhar no meio.
  Future<void> _alternarAtivo(PersonalalunosStruct aluno) async {
    final novoEstado = await action_blocks.toggleAlunoAtivo(
      context,
      personalUuid: currentUserUid,
      alunoUuid: aluno.alunoUuid,
    );
    if (novoEstado == null || !mounted) return;

    final i =
        _model.alunospersonal.indexWhere((e) => e.alunoUuid == aluno.alunoUuid);
    if (i >= 0) {
      _model.alunospersonal[i].ativo = novoEstado;
    }
    safeSetState(() {});
  }

  /// Texto do ultimo treino concluido, para a segunda linha do card.
  ///
  /// `diasSemTreinar` nulo quer dizer que o aluno nunca concluiu um treino —
  /// que e diferente de 0 ("treinou hoje"). Por isso a checagem e
  /// `hasDiasSemTreinar()` e nao o getter, que devolveria 0 nos dois casos.
  String _ultimoTreinoTexto(PersonalalunosStruct aluno) {
    if (!aluno.hasDiasSemTreinar()) {
      return 'Nunca treinou';
    }
    final dias = aluno.diasSemTreinar;
    if (dias <= 0) {
      return 'Treinou hoje';
    }
    if (dias == 1) {
      return 'Treinou ontem';
    }
    return 'Sem treinar há $dias dias';
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
        // A lista e a mesma do perfil e a de Metas: ver
        // `lista_notificacoes.dart`. Antes cada tela tinha a propria copia do
        // cartao, e elas foram se afastando com o tempo.
        // `endDrawer`: a gaveta vem do lado do sino que a chamou. Como
        // `drawer` ela abria pelo lado oposto ao botao.
        endDrawer: Drawer(
          elevation: 16.0,
          width: MediaQuery.of(context).size.width * 0.88,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          child: WebViewAware(
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Notificações',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                  fontSize: 18.0,
                                  letterSpacing: -0.3,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Icon(
                          FFIcons.kproperty1FiRrBell,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: ListaNotificacoes()),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          // A navbar reserva o inset inferior por dentro, para o branco
          // dela chegar ate a borda da tela no iPhone.
          bottom: false,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                valueOrDefault<double>(
                                  () {
                                    if (MediaQuery.sizeOf(context).width <
                                        kBreakpointSmall) {
                                      return 16.0;
                                    } else if (MediaQuery.sizeOf(context)
                                            .width <
                                        kBreakpointMedium) {
                                      return 16.0;
                                    } else if (MediaQuery.sizeOf(context)
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
                                    if (MediaQuery.sizeOf(context).width <
                                        kBreakpointSmall) {
                                      return 16.0;
                                    } else if (MediaQuery.sizeOf(context)
                                            .width <
                                        kBreakpointMedium) {
                                      return 16.0;
                                    } else if (MediaQuery.sizeOf(context)
                                            .width <
                                        kBreakpointLarge) {
                                      return 32.0;
                                    } else {
                                      return 32.0;
                                    }
                                  }(),
                                  0.0,
                                ),
                                8.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // As notificacoes moram no perfil
                                      // agora. O quadrado vazio fica no
                                      // lugar do sino porque o titulo e
                                      // centralizado por estar entre dois
                                      // elementos: sem ele, "Meus alunos"
                                      // deslizaria para a esquerda.
                                      const SizedBox(width: 36.0, height: 36.0),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  'Meus alunos',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // O sino, a esquerda do "+": o personal tambem recebe
                                          // notificacao, e esta e a tela inicial dele — a gaveta
                                          // ja existia aqui, mas nada a abria.
                                          Builder(
                                            builder: (context) {
                                              final naoLidas = FFAppState()
                                                  .notificacoes
                                                  .where((e) => !e.lida)
                                                  .length;
                                              return Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: BotaoCirculoPerfil(
                                                  icone: FFIcons
                                                      .kproperty1FiRrBell,
                                                  badge: naoLidas,
                                                  // Azul e 18, como o sino da
                                                  // tela do aluno: e o mesmo
                                                  // botao, e o glifo desta
                                                  // familia pede um ponto a
                                                  // menos que os do Material.
                                                  cor: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  tamanhoIcone: 18.0,
                                                  aoTocar: () => scaffoldKey
                                                      .currentState
                                                      ?.openEndDrawer(),
                                                ),
                                              );
                                            },
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
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
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            NovoAlunoWidget(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) => safeSetState(
                                                  () => _model.adicionou =
                                                      value));

                                              if (_model.adicionou!) {
                                                await action_blocks
                                                    .alunosdopersonal(
                                                  context,
                                                  uuidpersonal: currentUserUid,
                                                  forcar: true,
                                                );
                                                safeSetState(() {});
                                                _model.alunospersonal = FFAppState()
                                                    .alunosdopersonal
                                                    .toList()
                                                    .cast<
                                                        PersonalalunosStruct>();
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: 36.0,
                                              height: 36.0,
                                              // Circular, como todos os botoes
                                              // de icone do app agora.
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  FlutterFlowTheme.of(context)
                                                      .designToken
                                                      .shadow
                                                      .sm
                                                ],
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.add_sharp,
                                                  color: Colors.white,
                                                  size: 18.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _model.columnController1,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            // Respiro menor embaixo: os chips vem logo em
                            // seguida e estavam soltos demais da busca.
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 4.0),
                            child: CampoBusca(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              onChanged: (value) {
                                final busca = value.trim().toLowerCase();
                                final todos = FFAppState()
                                    .alunosdopersonal
                                    .toList()
                                    .cast<PersonalalunosStruct>();
                                _model.alunospersonal = busca.isEmpty
                                    ? todos
                                    : todos
                                        .where((e) => e.nome
                                            .toLowerCase()
                                            .contains(busca))
                                        .toList();
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 8.0),
                            child: LinhaChipsFiltro(
                              chips: [
                                ChipFiltro(
                                  texto: 'Todos',
                                  selecionado: _model.menu == 0,
                                  onTap: () {
                                    _model.menu = 0;
                                    safeSetState(() {});
                                  },
                                ),
                                ChipFiltro(
                                  texto: 'Ativos',
                                  selecionado: _model.menu == 1,
                                  onTap: () {
                                    _model.menu = _model.menu == 1 ? 0 : 1;
                                    safeSetState(() {});
                                  },
                                ),
                                ChipFiltro(
                                  texto: 'Inativos',
                                  selecionado: _model.menu == 2,
                                  onTap: () {
                                    _model.menu = _model.menu == 2 ? 0 : 2;
                                    safeSetState(() {});
                                  },
                                ),
                                ChipFiltro(
                                  texto: 'Atrasados',
                                  selecionado: _model.menu == 3,
                                  onTap: () {
                                    _model.menu = _model.menu == 3 ? 0 : 3;
                                    safeSetState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            primary: false,
                            controller: _model.columnController2,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // O aviso mora AQUI DENTRO, e nao como irmao
                                // dos chips, por causa do `.divide` mais
                                // abaixo: ele insere 16 entre cada par de
                                // filhos, inclusive dos dois lados de um
                                // filho invisivel. Com o plano pago o aviso
                                // vira SizedBox.shrink e sobravam 32 de vao
                                // no lugar dele.
                                //
                                // Aqui ele traz o proprio respiro de cima
                                // quando aparece, e nao ocupa nada quando
                                // some.
                                const AvisoPlanoFree(),
                                Builder(
                                  builder: (context) {
                                    final alunos = _model.alunospersonal
                                        .where((e) => () {
                                              // Unico ponto de filtro por
                                              // categoria. A busca ja veio
                                              // aplicada em alunospersonal.
                                              if (_model.menu == 1) {
                                                return e.ativo;
                                              } else if (_model.menu == 2) {
                                                return !e.ativo;
                                              } else if (_model.menu == 3) {
                                                return e.atrasado;
                                              } else {
                                                return true;
                                              }
                                            }())
                                        .toList()
                                        .map((e) => e)
                                        .toList();
                                    if (alunos.isEmpty) {
                                      return Center(
                                        child: DfEstadoVazio(
                                          icone: FFIcons.kproperty1FiRrUserAdd,
                                          titulo: 'Nenhum aluno ainda',
                                          descricao:
                                              'Convide seu primeiro aluno pelo e-mail dele.',
                                        ),
                                      );
                                    }

                                    return ListView.separated(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: alunos.length,
                                      // Sem espaco entre itens: o respiro
                                      // agora e padding DENTRO do card, para
                                      // ele preencher a faixa inteira ate a
                                      // linha de cima.
                                      separatorBuilder: (_, __) =>
                                          SizedBox.shrink(),
                                      itemBuilder: (context, alunosIndex) {
                                        final alunosItem = alunos[alunosIndex];
                                        return Padding(
                                          // Sem respiro lateral aqui: ele
                                          // virou padding DENTRO do card,
                                          // para o fundo das acoes de
                                          // deslizar chegar ate a borda
                                          // da tela.
                                          padding: EdgeInsets.zero,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              _CardAlunoDeslizavel(
                                                ativo: alunosItem.ativo,
                                                // Convite ainda nao aceito: nao
                                                // ha vinculo, entao ativar ou
                                                // inativar nao tem o que mexer
                                                // — e cobrar ou chamar no zap e
                                                // falar com quem ainda nao
                                                // disse que quer ser aluno.
                                                //
                                                // As acoes somem em vez de
                                                // aparecerem desabilitadas: uma
                                                // acao cinza convida ao toque e
                                                // devolve nada.
                                                onWhatsApp: alunosItem.status ==
                                                        'aceito'
                                                    ? () => _abrirWhatsApp(
                                                        alunosItem)
                                                    : null,
                                                onCobrar: alunosItem.status ==
                                                            'aceito' &&
                                                        alunosItem.atrasado
                                                    ? () =>
                                                        _cobrarAluno(alunosItem)
                                                    : null,
                                                onToggleAtivo:
                                                    alunosItem.status ==
                                                            'aceito'
                                                        ? () => _alternarAtivo(
                                                            alunosItem)
                                                        : null,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 12.0, 0.0, 12.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      if (alunosItem.status ==
                                                              'pendente' ||
                                                          alunosItem.status ==
                                                              'recusado') {
                                                        await showModalBottomSheet(
                                                          useRootNavigator:
                                                              true,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          context: context,
                                                          builder: (context) {
                                                            return MensagemWidget(
                                                              texto: alunosItem
                                                                          .status ==
                                                                      'pendente'
                                                                  ? 'Aguardando o aluno aceitar o convite.'
                                                                  : 'O aluno recusou o convite.',
                                                              tipo: '3',
                                                              mostrabotoes:
                                                                  false,
                                                              action:
                                                                  () async {},
                                                            );
                                                          },
                                                        );
                                                        return;
                                                      }
                                                      context.pushNamed(
                                                        PerfilalunoWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'alunoId':
                                                              serializeParam(
                                                            alunosItem
                                                                .alunoUuid,
                                                            ParamType.String,
                                                          ),
                                                        }.withoutNulls,
                                                        extra: <String,
                                                            dynamic>{
                                                          '__transition_info__':
                                                              TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType:
                                                                PageTransitionType
                                                                    .fade,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    0),
                                                          ),
                                                        },
                                                      );
                                                    },
                                                    child: Opacity(
                                                      // Aluno inativo continua
                                                      // na lista, mas apagado —
                                                      // sem isso ele e
                                                      // indistinguivel de um
                                                      // ativo no filtro Todos.
                                                      opacity: alunosItem.ativo
                                                          ? 1.0
                                                          : 0.45,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Tocar na foto
                                                          // abre ela em
                                                          // tela cheia, como
                                                          // no WhatsApp. So
                                                          // quando existe
                                                          // foto: abrir o
                                                          // avatar generico
                                                          // em tamanho
                                                          // grande nao mostra
                                                          // nada a mais.
                                                          GestureDetector(
                                                            onTap: alunosItem
                                                                    .fotoUrl
                                                                    .isEmpty
                                                                ? null
                                                                : () =>
                                                                    mostrarFotoEmTelaCheia(
                                                                      context,
                                                                      url: alunosItem
                                                                          .fotoUrl,
                                                                      titulo: alunosItem
                                                                          .nome,
                                                                    ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.0),
                                                              child: Image(
                                                                // Decodifica em
                                                                // ~162px, e nao
                                                                // nos 4032 do
                                                                // arquivo: o
                                                                // avatar tem 54
                                                                // e uma foto de
                                                                // celular vira
                                                                // 36 MB de
                                                                // bitmap para
                                                                // caber num
                                                                // circulo.
                                                                image:
                                                                    ResizeImage(
                                                                  CachedNetworkImageProvider(
                                                                      valueOrDefault<
                                                                          String>(
                                                                    alunosItem
                                                                        .fotoUrl,
                                                                    'https://miro.medium.com/v2/resize:fit:1400/1*g09N-jl7JtVjVZGcd-vL2g.jpeg',
                                                                  )),
                                                                  width: 162,
                                                                  allowUpscaling:
                                                                      false,
                                                                ),
                                                                width: 54.0,
                                                                height: 54.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                alunosItem.nome,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontStyle: alunosItem.status == 'pendente' ||
                                                                                alunosItem.status == 'recusado'
                                                                            ? FontStyle.italic
                                                                            : FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                      ),
                                                                      color: alunosItem.status == 'pendente' ||
                                                                              alunosItem.status ==
                                                                                  'recusado'
                                                                          ? FlutterFlowTheme.of(context)
                                                                              .secondaryText
                                                                          : null,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontStyle: alunosItem.status == 'pendente' ||
                                                                              alunosItem.status ==
                                                                                  'recusado'
                                                                          ? FontStyle
                                                                              .italic
                                                                          : FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                    ),
                                                              ),
                                                              if (alunosItem
                                                                          .status ==
                                                                      'pendente' ||
                                                                  alunosItem
                                                                          .status ==
                                                                      'recusado')
                                                                Text(
                                                                  alunosItem.status ==
                                                                          'pendente'
                                                                      ? 'Aguardando aceite'
                                                                      : 'Convite recusado',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                        color: alunosItem.status ==
                                                                                'pendente'
                                                                            ? FlutterFlowTheme.of(context).warning
                                                                            : FlutterFlowTheme.of(context).error,
                                                                        fontSize:
                                                                            11.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                ),
                                                              if (alunosItem
                                                                      .status ==
                                                                  'aceito')
                                                                Text(
                                                                  _ultimoTreinoTexto(
                                                                      alunosItem),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                ),
                                                            ].divide(SizedBox(
                                                                height: 6.0)),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      1.0,
                                                                      -1.0),
                                                              // Este e o canto que o
                                                              // olho procura depois
                                                              // do nome. A cobranca
                                                              // vencida ganha o
                                                              // lugar; a data de
                                                              // vinculo so aparece
                                                              // quando nao ha nada
                                                              // a cobrar.
                                                              child: alunosItem
                                                                      .atrasado
                                                                  ? Container(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          8.0,
                                                                          3.0,
                                                                          8.0,
                                                                          3.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error
                                                                            .withValues(alpha: 0.12),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'Atrasado',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              fontSize: 11.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                      ),
                                                                    )
                                                                  : alunosItem.status ==
                                                                          'aceito'
                                                                      ? Text(
                                                                          functions
                                                                              .formatames(alunosItem.dataVinculo),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        )
                                                                      : SizedBox
                                                                          .shrink(),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 16.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                height: 1.0,
                                                thickness: 1.0,
                                                // 16 do padding do cartao +
                                                // 54 da foto + 16 do vao: o
                                                // traco comeca exatamente
                                                // onde o nome comeca. Faltava
                                                // contar o padding, que entrou
                                                // quando a margem virou
                                                // padding para o fundo das
                                                // acoes chegar na borda.
                                                indent: 86.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]
                            .divide(SizedBox(height: 16.0))
                            .addToEnd(SizedBox(height: 120.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card do aluno com acoes de deslizar dos dois lados.
///
/// Esquerda revela o que se faz COM o aluno (falar, cobrar); direita revela o
/// que se faz SOBRE o vinculo (ativar, inativar). Separar por lado evita a
/// fila de quatro botoes de um lado so, onde o destrutivo fica a um dedo de
/// distancia do corriqueiro.
///
/// O gesto e controlado na mao, sem pacote de slidable, para ficar igual ao
/// que o app ja faz em `_SwipeableGrupoRow` na tela de treinos.
class _CardAlunoDeslizavel extends StatefulWidget {
  const _CardAlunoDeslizavel({
    required this.child,
    this.onWhatsApp,
    this.onToggleAtivo,
    required this.ativo,
    this.onCobrar,
  });

  final Widget child;

  /// Nulos enquanto o convite nao foi aceito: sem vinculo nao ha o que ativar,
  /// nem com quem falar.
  final VoidCallback? onWhatsApp;
  final VoidCallback? onToggleAtivo;
  final bool ativo;

  /// Nulo quando o aluno esta em dia: sem divida, nao ha o que cobrar.
  final VoidCallback? onCobrar;

  @override
  State<_CardAlunoDeslizavel> createState() => _CardAlunoDeslizavelState();
}

class _CardAlunoDeslizavelState extends State<_CardAlunoDeslizavel> {
  static const double _larguraAcao = 88.0;

  /// Verde oficial do WhatsApp — nao sai do tema porque a cor e da marca.
  static const Color _verdeWhatsApp = Color(0xFF25D366);

  double _deslocamento = 0.0;

  double get _limiteEsquerda =>
      _larguraAcao * (widget.onCobrar != null ? 2 : 1);

  void _arrastando(DragUpdateDetails d) {
    setState(() {
      _deslocamento = (_deslocamento + d.delta.dx)
          .clamp(-_limiteEsquerda, _larguraAcao)
          .toDouble();
    });
  }

  void _soltou(DragEndDetails d) {
    setState(() {
      if (_deslocamento < -_limiteEsquerda / 2) {
        _deslocamento = -_limiteEsquerda;
      } else if (_deslocamento > _larguraAcao / 2) {
        _deslocamento = _larguraAcao;
      } else {
        _deslocamento = 0.0;
      }
    });
  }

  void _fechar() => setState(() => _deslocamento = 0.0);

  Widget _acao({
    required Color fundo,
    required Widget icone,
    required String rotulo,
    required VoidCallback aoTocar,
  }) {
    return SizedBox(
      width: _larguraAcao,
      child: GestureDetector(
        onTap: () {
          _fechar();
          aoTocar();
        },
        child: Container(
          color: fundo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icone,
              const SizedBox(height: 4.0),
              Text(
                rotulo,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      color: Colors.white,
                      fontSize: 11.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return GestureDetector(
      onHorizontalDragUpdate: _arrastando,
      onHorizontalDragEnd: _soltou,
      child: ClipRect(
        child: Stack(
          children: [
            // Acoes da direita, reveladas ao puxar o card para a esquerda.
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  if (widget.onCobrar != null)
                    _acao(
                      fundo: tema.error,
                      icone: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 22.0,
                      ),
                      rotulo: 'Cobrar',
                      aoTocar: widget.onCobrar!,
                    ),
                  if (widget.onWhatsApp != null)
                    _acao(
                      fundo: _verdeWhatsApp,
                      icone: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 22.0,
                      ),
                      rotulo: 'WhatsApp',
                      aoTocar: widget.onWhatsApp!,
                    ),
                ],
              ),
            ),
            // Acao da esquerda, revelada ao puxar o card para a direita.
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: widget.onToggleAtivo == null
                  ? const SizedBox.shrink()
                  : _acao(
                      fundo: widget.ativo ? tema.secondaryText : tema.success,
                      icone: Icon(
                        widget.ativo
                            ? Icons.person_off_rounded
                            : Icons.person_rounded,
                        color: Colors.white,
                        size: 22.0,
                      ),
                      rotulo: widget.ativo ? 'Inativar' : 'Ativar',
                      aoTocar: widget.onToggleAtivo!,
                    ),
            ),
            Transform.translate(
              offset: Offset(_deslocamento, 0.0),
              child: Container(
                color: tema.secondaryBackground,
                // Os 16 laterais eram margem do card. Como margem, o fundo
                // colorido das acoes parava antes da borda da tela; como
                // padding, o conteudo continua recuado e a cor vai ate o fim.
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

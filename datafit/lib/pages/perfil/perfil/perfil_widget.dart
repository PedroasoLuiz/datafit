import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/df_estado_vazio.dart';
import '/components/excluir_conta.dart';
import '/components/feedback_app.dart';
import '/components/preferencias_app.dart';
import '/components/lista_notificacoes.dart';
import '/components/avaliar_personal.dart';
import '/components/foto_tela_cheia.dart';
import '/components/folha_kit.dart';
import '/components/perfil_kit.dart';
import '/custom_code/functions/achatar_exercicios.dart';
import '/custom_code/functions/extrair_subcategorias.dart';
import '/backend/supabase/supabase.dart';
import '/backend/cache_curto.dart';
import 'package:flutter/gestures.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'perfil_model.dart';
export 'perfil_model.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  static String routeName = 'perfil';
  static String routePath = '/perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

/// A ficha do personal em miniatura.
///
/// Era uma linha de lista com as iniciais e o nome. Funcionava, mas não dizia
/// que atrás dela havia uma ficha — parecia um item de menu, e menu não se
/// visita, se usa.
///
/// Em miniatura, com a mesma faixa de cor e o mesmo avatar cavalgando a borda,
/// o cartão anuncia o que abre: quem já viu a ficha do personal reconhece o
/// desenho antes de ler o nome.
class _PreviaDoPersonal extends StatelessWidget {
  const _PreviaDoPersonal({
    required this.personal,
    required this.aoAbrir,
    required this.aoAvaliar,
  });

  final PerfilPersonalStruct personal;
  final VoidCallback aoAbrir;
  final VoidCallback aoAvaliar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      // `clipBehavior` para a faixa de cor respeitar o canto arredondado do
      // cartao: sem ele, o azul vaza pelos cantos de cima.
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: aoAbrir,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 78.0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        height: 46.0,
                        child: Container(color: tema.primary),
                      ),
                      Positioned(
                        top: 46.0 - 26.0,
                        left: 14.0,
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: tema.primaryBackground,
                            shape: BoxShape.circle,
                          ),
                          child: AvatarPerfil(
                            foto: personal.fotoUrl,
                            nome: personal.nome,
                            tamanho: 46.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 46.0 + 8.0,
                        right: 14.0,
                        child: Icon(FFIcons.kproperty1FiRrAngleSmallRight,
                            color: tema.alternate, size: 20.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      14.0, 0.0, 14.0, 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        personal.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: tema.primaryText,
                          fontSize: 15.0,
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (personal.cref.isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 2.0, 0.0, 0.0),
                          child: Text(
                            'CREF ${personal.cref}',
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: tema.primary,
                              fontSize: 11.5,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 8.0, 0.0, 0.0),
                        child: EstatisticasPerfil(
                          alunos: personal.totalAlunos,
                          treinos: personal.totalTreinos,
                          nota: personal.notaMedia,
                          avaliacoes: personal.totalAvaliacoes,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: tema.alternate.withValues(alpha: 0.45),
          ),
          // Avaliar fica fora do toque que abre a ficha: sao dois destinos, e
          // um cartao inteiro clicavel com um segundo alvo dentro e a receita
          // para tocar no lugar errado.
          InkWell(
            onTap: aoAvaliar,
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 12.0),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: corEstrela, size: 17.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      personal.minhaNota > 0
                          ? 'Sua avaliação: ${personal.minhaNota} de 5'
                          : 'Avaliar seu personal',
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: tema.primaryText,
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(FFIcons.kproperty1FiRrAngleSmallRight,
                      color: tema.alternate, size: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Editar perfil" na capa, no mesmo desenho do "Avaliar" da ficha pública.
class _BotaoEditar extends StatelessWidget {
  const _BotaoEditar({required this.aoTocar});

  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(999.0),
      child: Container(
        height: 34.0,
        padding: const EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tema.primaryBackground,
          borderRadius: BorderRadius.circular(999.0),
          boxShadow: [tema.designToken.shadow.sm],
        ),
        child: Text(
          'Editar perfil',
          style: tema.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            color: tema.primaryText,
            fontSize: 12.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Mesmo payload que o aluno recebe ao abrir o perfil deste personal.
  /// Usado para o grid de vídeos e para os contadores públicos.
  PerfilPersonalStruct? _meuPerfilPublico;

  /// A ficha do personal a que este aluno está vinculado.
  PerfilPersonalStruct? _meuPersonal;

  /// Média, distribuição e comentários. Buscados só quando a aba abre — quem
  /// nunca toca em Avaliações não paga por elas.
  Map<String, dynamic>? _avaliacoes;

  /// Conquistas do aluno, calculadas no banco.
  Map<String, dynamic>? _conquistas;

  /// 0 = vídeos, 1 = avaliações. Só o personal usa.
  int _aba = 0;

  /// Grupo muscular do filtro da grade.
  String _grupo = 'Todos';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());

    // Cada papel busca o que a própria ficha mostra. O personal não tem
    // conquistas e o aluno não tem biblioteca de vídeos — pedir os dois
    // sempre seria uma chamada jogada fora em toda abertura.
    if (FFAppState().perfil.tipoPerfilId == 2) {
      _carregarMeuPersonal();
      _carregarConquistas();
    } else {
      _carregarMeusVideos();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Abre a edição e recarrega a ficha ao voltar.
  ///
  /// Ao voltar, a foto e o nome podem ter mudado; e se o CREF acabou de ser
  /// preenchido, a linha de identidade precisa parar de convidar.
  Future<void> _abrirEdicao() async {
    await context.pushNamed(PerfilEditWidget.routeName);
    // Editar muda foto, nome e CREF: o que estava guardado deixou de valer.
    CacheCurto.invalidar('perfil:');
    if (!mounted) return;
    _carregarMeusVideos();
    safeSetState(() {});
  }

  Future<void> _carregarMeusVideos() async {
    try {
      final corpo = await CacheCurto.obter('perfil:meusVideos', () async {
        final r = await AlunoGroup.getPerfilPersonalCall.call(
          pPersonalUuid: currentUserUid,
          pAlunoUuid: currentUserUid,
        );
        return r.succeeded ? r.jsonBody : null;
      });
      if (!mounted || corpo == null) return;
      safeSetState(() {
        _meuPerfilPublico = PerfilPersonalStruct.maybeFromMap(corpo);
      });
    } catch (_) {
      // O grid é acessório: se falhar, fica vazio em vez de quebrar a tela.
    }
  }

  Future<void> _carregarMeuPersonal() async {
    final uuid = FFAppState().treinosTemp.personalUuid;
    if (uuid.isEmpty) return;
    try {
      final resposta = await CacheCurto.obter(
        'perfil:meuPersonal',
        () => SupaFlow.client.rpc('get_perfil_personal_publico', params: {
          'p_personal_uuid': uuid,
          'p_aluno_uuid': currentUserUid,
        }),
      );
      if (!mounted) return;
      safeSetState(
          () => _meuPersonal = PerfilPersonalStruct.maybeFromMap(resposta));
    } catch (_) {
      // Sem o cartão do personal a ficha continua de pé.
    }
  }

  Future<void> _carregarConquistas() async {
    try {
      final resposta = await CacheCurto.obter(
        'perfil:conquistas',
        () => SupaFlow.client.rpc('get_conquistas_aluno',
            params: {'p_aluno_uuid': currentUserUid}),
      );
      if (!mounted) return;
      safeSetState(
          () => _conquistas = (resposta as Map?)?.cast<String, dynamic>());
    } catch (_) {}
  }

  Future<void> _carregarAvaliacoes() async {
    if (_avaliacoes != null) return;
    try {
      final resposta = await SupaFlow.client.rpc('get_avaliacoes_personal',
          params: {'p_personal_uuid': currentUserUid});
      if (!mounted) return;
      safeSetState(
          () => _avaliacoes = (resposta as Map?)?.cast<String, dynamic>());
    } catch (_) {
      if (!mounted) return;
      // Mapa vazio em vez de nulo: nulo mantém o rodinha girando para sempre.
      safeSetState(() => _avaliacoes = <String, dynamic>{'total': 0});
    }
  }

  /// Folha do filtro por grupo muscular — a mesma ideia da ficha do personal:
  /// uma segunda fileira de chips faria navegação e filtro parecerem a mesma
  /// coisa.
  Future<void> _escolherGrupo(List<TreinoPersonalStruct> treinos) async {
    final grupos = ['Todos', ...extrairSubcategorias(treinos)];

    final escolhido = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (contexto) => WebViewAware(
        child: FolhaPadrao(
          // Sem visto: escolher o grupo ja e a resposta.
          fixos: const [
            CabecaFolha(
              titulo: 'Filtrar por grupo',
              apoio: 'Mostra só os vídeos daquele grupo muscular.',
              icone: Icons.filter_list_rounded,
            ),
          ],
          filhos: [
            for (final g in grupos)
              ItemFolha(
                titulo: g,
                icone: Icons.fitness_center_rounded,
                selecionado: g == _grupo,
                aoTocar: () => FolhaPadrao.fechar(contexto, g),
              ),
          ],
        ),
      ),
    );

    if (escolhido != null && mounted) safeSetState(() => _grupo = escolhido);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Blocos de configuracao do perfil. Ficavam soltos abaixo do card;
  /// agora moram no endDrawer, aberto pelo icone de menu do cabecalho,
  /// e o corpo do perfil exibe o grid de videos (padrao Instagram).
  Widget _blocosDeConfiguracao(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _grupoConfig(context, 'Geral', [
          // Primeiro item do grupo: e a unica entrada que muda como o app se
          // comporta no dia a dia — as outras abrem texto ou levam para fora.
          _itemConfig(
            context,
            icone: Icons.tune_rounded,
            texto: 'Preferências',
            onTap: () => abrirPreferencias(context),
          ),
          _itemConfig(
            context,
            icone: FFIcons.kproperty1FiRrShield,
            texto: 'Segurança e privacidade',
            onTap: () => context.pushNamed(
              SegurancaeprivacidadeWidget.routeName,
              extra: <String, dynamic>{
                '__transition_info__': TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            ),
          ),
          _itemConfig(
            context,
            icone: FFIcons.kproperty1FiRrDocument,
            texto: 'Termos de uso',
            onTap: () => context.pushNamed(
              TermosdeusoWidget.routeName,
              extra: <String, dynamic>{
                '__transition_info__': TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            ),
          ),
          _itemConfig(
            context,
            icone: FFIcons.kproperty1FiRrInterrogation,
            texto: 'Ajuda',
            onTap: () => context.pushNamed(
              AjudaWidget.routeName,
              extra: <String, dynamic>{
                '__transition_info__': TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                  duration: Duration(milliseconds: 0),
                ),
              },
            ),
          ),
          // Depois da Ajuda de proposito: quem tem duvida procura resposta
          // antes de escrever, e quem ja procurou e nao achou esta no lugar
          // certo para contar o que faltou.
          _itemConfig(
            context,
            icone: FFIcons.kproperty1FiRrComment,
            texto: 'Enviar feedback',
            onTap: () => abrirFeedbackApp(context),
          ),
        ]),
        _grupoConfig(context, 'Conta', [
          _itemConfig(
            context,
            icone: FFIcons.kproperty1FiRrSignOut,
            texto: 'Sair do aplicativo',
            destrutivo: true,
            onTap: () async {
              GoRouter.of(context).prepareAuthEvent();
              await authManager.signOut();
              GoRouter.of(context).clearRedirectLocation();

              context.goNamedAuth(StartWidget.routeName, context.mounted);
            },
          ),
          // Exclusao de conta — exigida pela Apple
          // (App Store Guideline 5.1.1(v)).
          _itemConfig(
            context,
            icone: Icons.delete_outline,
            texto: 'Excluir minha conta',
            destrutivo: true,
            onTap: () => confirmarExclusaoConta(context),
          ),
        ]),
      ],
    );
  }

  /// Um grupo de opcoes: rotulo pequeno em cinza e as linhas embaixo.
  ///
  /// O rotulo faz o papel que o cartao branco fazia — dizer onde um assunto
  /// comeca e o outro termina — sem gastar a largura da gaveta com margem.
  Widget _grupoConfig(BuildContext context, String titulo, List<Widget> itens) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 6.0),
            child: Text(
              titulo.toUpperCase(),
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.secondaryText,
                fontSize: 11.0,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...itens,
        ],
      ),
    );
  }

  /// Uma linha da gaveta: icone, texto e nada mais.
  ///
  /// Sem chevron de proposito — numa gaveta que ocupa a tela toda, a seta so
  /// repete o que o toque ja resolve. [destrutivo] pinta em vermelho.
  Widget _itemConfig(
    BuildContext context, {
    required IconData icone,
    required String texto,
    required Future<dynamic> Function() onTap,
    bool destrutivo = false,
  }) {
    final tema = FlutterFlowTheme.of(context);
    final cor = destrutivo ? tema.error : tema.primaryText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async => onTap(),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 14.0, 20.0, 14.0),
          child: Row(
            children: [
              Icon(
                icone,
                color: destrutivo ? tema.error : tema.primaryText,
                size: 20.0,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  texto,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: cor,
                    fontSize: 14.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _ehAluno => FFAppState().perfil.tipoPerfilId == 2;

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    context.watch<cupertino_time_picker_hiuzb7_app_state.FFAppState>();

    final tema = FlutterFlowTheme.of(context);
    final perfil = FFAppState().perfil;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: tema.secondaryBackground,
        // O drawer de configuração fica onde estava. Configuração não é
        // conteúdo: misturada aos chips, ela disputa atenção com o que a
        // pessoa veio ver, e todo mundo passa a ter uma aba a mais para
        // ignorar.
        drawer: Drawer(
          elevation: 16.0,
          width: MediaQuery.sizeOf(context).width * 0.88,
          backgroundColor: tema.secondaryBackground,
          child: SafeArea(
            // Sem padding aqui: o recuo dos cartoes e da lista, que ja aplica
            // 16 nas laterais e 24 no fim.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 16.0, 16.0, 12.0),
                  child: Text(
                    'Notificações',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primaryText,
                      fontSize: 18.0,
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Expanded(child: ListaNotificacoes()),
              ],
            ),
          ),
        ),
        endDrawer: Drawer(
          elevation: 16.0,
          width: MediaQuery.sizeOf(context).width * 0.88,
          backgroundColor: tema.secondaryBackground,
          child: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 32.0),
              child: _blocosDeConfiguracao(context),
            ),
          ),
        ),
        // Cabecalho flutuando sobre a rolagem, como na ficha do personal: a
        // faixa fixa nao rolava e deixava um azul parado atras da barra.
        body: Stack(
          children: [
            // `top: false`: a rolagem comeca no topo absoluto, senao a capa
            // pararia embaixo da barra de status.
            SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      // Sem recuo lateral: e o que deixa a capa e a grade de
                      // videos encostarem na borda. Cada secao aplica o seu.
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 140.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CapaPerfil(
                            // Cresce para tras da barra e do cabecalho, e rola
                            // junto com o conteudo.
                            alturaExtraTopo:
                                MediaQuery.paddingOf(context).top + 52.0,
                            // Trocar a foto de capa. Comentado ate existir
                            // capa de verdade: hoje a faixa e cor solida, e um
                            // botao de camera sobre cor prometia uma troca que
                            // nao acontece. Volta junto com a coluna no banco.
                            //
                            // acaoCapa: BotaoCirculoPerfil(
                            //   claro: true,
                            //   icone: FFIcons.kproperty1FiRrCamera,
                            //   aoTocar: _abrirEdicao,
                            // ),
                            // Mesmo desenho e mesma posicao do "Avaliar" na
                            // ficha do personal: e a acao principal da ficha, e
                            // duas fichas irmas nao deveriam colocar a acao
                            // principal em lugares diferentes.
                            acoes: [
                              _BotaoEditar(aoTocar: _abrirEdicao),
                            ],
                            nome: perfil.nome,
                            foto: perfil.fotoUrl,
                            linha: _linhaDeIdentidade(tema, perfil),
                            extra: _blocoDeApoio(tema, perfil),
                            // 'Preencha sua bio' era o texto que o cadastro
                            // deixava; exibido, virava a bio da pessoa.
                            bio: (perfil.bio.isEmpty ||
                                    perfil.bio == '-' ||
                                    perfil.bio == 'Preencha sua bio')
                                ? null
                                : perfil.bio,
                            aoTocarFoto: perfil.fotoUrl.isEmpty
                                ? null
                                : () => mostrarFotoEmTelaCheia(
                                      context,
                                      url: perfil.fotoUrl,
                                      titulo: perfil.nome,
                                    ),
                          ),
                          const SizedBox(height: 14.0),
                          if (!_ehAluno) ...[
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: _trioDoPersonal(),
                            ),
                          ],
                          // Um espaco so acima dos chips, igual ao de baixo.
                          // Eram dois somando 28 de um lado contra 14 do
                          // outro — o botao de editar ficava entre eles e, ao
                          // sair para a capa, deixou o vao dele para tras.
                          const SizedBox(height: 16.0),
                          // O corpo do personal traz a grade sangrada e recua
                          // por dentro; o do aluno e todo cartao.
                          if (_ehAluno)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: _corpoDoAluno(tema),
                            )
                          else
                            _corpoDoPersonal(tema),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // `Positioned` com as tres bordas, e nao um filho solto do
            // Stack: sem elas a barra recebia restricoes frouxas, encolhia ate
            // o tamanho dos botoes e ficava boiando no meio da tela.
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: SafeArea(
                bottom: false,
                child: CabecalhoPerfil(
                  sobreCapa: true,
                  // O sino saiu daqui: notificacao ja mora na tela inicial de
                  // cada papel, e ter dois caminhos para a mesma caixa faz a
                  // pessoa conferir duas vezes achando que sao coisas
                  // diferentes.
                  direita: BotaoCirculoPerfil(
                    claro: true,
                    icone: FFIcons.kproperty1FiRrMenuBurger,
                    aoTocar: () => scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A linha sob o nome.
  ///
  /// No personal é o CREF, em texto puro. Quando ele está vazio, esta é a
  /// única das fichas que convida a preencher — ver a própria credencial em
  /// falta é o que faz alguém ir atrás dela; na ficha que os outros veem, um
  /// convite desses seria só um buraco à mostra.
  /// A linha sob o nome: o nick, e no personal a credencial junto.
  ///
  /// Idade e altura sairam daqui. Elas sao medida, nao identidade — e no
  /// formato de "x anos · y m" competiam com o nick pela mesma linha. Foram
  /// para o bloco de baixo, no mesmo desenho de "x alunos x treinos" da ficha
  /// publica: numero em negrito, unidade em cinza.
  InlineSpan? _linhaDeIdentidade(FlutterFlowTheme tema, PerfilStruct perfil) {
    final nick = perfil.nickName.isEmpty ? null : '@${perfil.nickName}';

    if (_ehAluno) {
      return nick == null ? null : TextSpan(text: nick);
    }

    if (perfil.cref.isNotEmpty) {
      return TextSpan(children: [
        if (nick != null) TextSpan(text: '$nick  ·  '),
        TextSpan(
          text: 'CREF ${perfil.cref}',
          style: TextStyle(color: tema.primary, fontWeight: FontWeight.w600),
        ),
      ]);
    }

    // Sem CREF, esta e a unica ficha que convida a preencher: ver a propria
    // credencial em falta e o que faz alguem ir atras dela.
    return TextSpan(children: [
      if (nick != null) TextSpan(text: '$nick  ·  '),
      TextSpan(
        text: 'Adicionar seu CREF',
        style: TextStyle(color: tema.primary, fontWeight: FontWeight.w600),
        recognizer: TapGestureRecognizer()..onTap = _abrirEdicao,
      ),
    ]);
  }

  /// "Ativo desde 03/2026" e, no aluno, idade e altura.
  Widget? _blocoDeApoio(FlutterFlowTheme tema, PerfilStruct perfil) {
    final desde = DateTime.tryParse(perfil.createdAt)?.toLocal();
    final idade = functions.calcIdade(perfil.dataNascimento);

    // Idade e altura so no aluno. No personal elas nao dizem nada sobre o
    // trabalho dele — quem contrata quer credencial e nota, nao a altura de
    // quem vai treinar.
    final medidas = <({String valor, String rotulo})>[
      if (_ehAluno && idade.isNotEmpty && idade != '0')
        (valor: idade, rotulo: 'anos'),
      if (_ehAluno && perfil.altura > 0)
        (
          valor: perfil.altura.toStringAsFixed(2).replaceAll('.', ','),
          // "de altura", e nao "m": ao lado de "28 anos", um "m" solto
          // pede que a pessoa deduza a unidade em vez de ler o dado.
          rotulo: 'de altura'
        ),
    ];

    if (desde == null && medidas.isEmpty) return null;

    final forte = tema.bodyMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
      color: tema.primaryText,
      fontSize: 13.5,
      letterSpacing: -0.2,
      fontWeight: FontWeight.bold,
    );
    final fraco = tema.bodyMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w400),
      color: tema.secondaryText,
      fontSize: 12.0,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w400,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (desde != null)
          Row(
            children: [
              Icon(FFIcons.kproperty1FiRrClock,
                  color: tema.secondaryText, size: 12.0),
              const SizedBox(width: 5.0),
              Text(
                'Ativo desde ${desde.month.toString().padLeft(2, '0')}/${desde.year}',
                style: fraco,
              ),
            ],
          ),
        if (medidas.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0.0, desde == null ? 0.0 : 6.0, 0.0, 0.0),
            child: Wrap(
              spacing: 14.0,
              runSpacing: 4.0,
              children: [
                for (final m in medidas)
                  Text.rich(TextSpan(children: [
                    TextSpan(text: m.valor, style: forte),
                    TextSpan(text: ' ${m.rotulo}', style: fraco),
                  ])),
              ],
            ),
          ),
      ],
    );
  }

  Widget _trioDoPersonal() {
    final p = _meuPerfilPublico;
    // Mesma linha de texto da ficha publica: era o cartao de tres colunas, que
    // dava a esses numeros peso de secao quando sao legenda da identidade — e
    // fazia a propria ficha nao se parecer com a que os alunos veem.
    return EstatisticasPerfil(
      alunos: p?.totalAlunos ?? 0,
      treinos: p?.totalTreinos ?? 0,
      nota: p?.notaMedia ?? 0.0,
      avaliacoes: p?.totalAvaliacoes ?? 0,
    );
  }

  // ─────────────────────────── personal ───────────────────────────

  Widget _corpoDoPersonal(FlutterFlowTheme tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: ChipsPerfil(
            rotulos: const ['Vídeos', 'Avaliações'],
            selecionado: _aba,
            aoSelecionar: (i) {
              safeSetState(() => _aba = i);
              if (i == 1) _carregarAvaliacoes();
            },
          ),
        ),
        const SizedBox(height: 16.0),
        if (_aba == 0)
          _abaVideos(tema)
        else
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: _abaAvaliacoes(tema),
          ),
      ],
    );
  }

  /// Altura exata de uma grade de tres colunas em 9:16.
  ///
  /// Calculada para a grade nao precisar rolar por dentro: com altura menor
  /// que o conteudo, ela vira uma segunda area rolavel dentro da pagina.
  double _alturaDaGrade(int quantos) {
    if (quantos == 0) return 0.0;
    final largura = MediaQuery.sizeOf(context).width;
    final ladoItem = (largura - 4.0) / 3.0;
    final linhas = (quantos / 3).ceil();
    return linhas * (ladoItem * 16 / 9) + (linhas - 1) * 2.0;
  }

  Widget _abaVideos(FlutterFlowTheme tema) {
    final treinos = _meuPerfilPublico?.treinos.toList() ?? [];
    final exercicios = achatarExercicios(treinos, _grupo);
    final grupos = extrairSubcategorias(treinos);

    if (exercicios.isEmpty) {
      return DfEstadoVazio(
        icone: FFIcons.kproperty1FiRrPlay,
        titulo: _grupo == 'Todos'
            ? 'Nenhum vídeo por aqui'
            : 'Nenhum vídeo em $_grupo',
        descricao: _grupo == 'Todos'
            ? 'Adicione o link de um vídeo aos seus exercícios e eles aparecem aqui para os seus alunos.'
            : 'Experimente outro grupo muscular.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: CabecaSecao(
            titulo:
                '${exercicios.length} ${exercicios.length == 1 ? 'vídeo' : 'vídeos'}',
            filtro: grupos.length > 1 ? _grupo : null,
            aoTocarFiltro: () => _escolherGrupo(treinos),
          ),
        ),
        const SizedBox(height: 10.0),
        // Sem OverflowBox: ele deixa o filho transbordar mas nao cresce com
        // ele, entao a coluna media a grade como se fosse pequena — a pagina
        // parava de rolar e a grade pintava por cima do resto. Agora a grade
        // ocupa a largura real porque quem recua sao as outras secoes, nao a
        // rolagem inteira.
        SizedBox(
          width: double.infinity,
          height: _alturaDaGrade(exercicios.length),
          child: custom_widgets.ReelsVideoGrid(
            width: MediaQuery.sizeOf(context).width,
            height: _alturaDaGrade(exercicios.length),
            exercicios: exercicios,
          ),
        ),
      ],
    );
  }

  Widget _abaAvaliacoes(FlutterFlowTheme tema) {
    if (_avaliacoes == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }

    final total = (_avaliacoes!['total'] as num?)?.toInt() ?? 0;
    if (total == 0) {
      return DfEstadoVazio(
        icone: Icons.star_border_rounded,
        titulo: 'Ainda sem avaliações',
        descricao:
            'Quando seus alunos avaliarem seu trabalho, a nota e os comentários aparecem aqui.',
      );
    }

    final media = (_avaliacoes!['media'] as num?)?.toDouble() ?? 0.0;
    final dist =
        (_avaliacoes!['distribuicao'] as Map?)?.cast<String, dynamic>() ??
            const {};
    final comentarios = (_avaliacoes!['comentarios'] as List? ?? [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: tema.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [tema.designToken.shadow.lg],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    media.toStringAsFixed(1).replaceAll('.', ','),
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primaryText,
                      fontSize: 34.0,
                      letterSpacing: -1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EstrelasPerfil(nota: media.round(), tamanho: 17.0),
                      Text(
                        '$total ${total == 1 ? 'avaliação' : 'avaliações'}',
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: tema.secondaryText,
                          fontSize: 11.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              // A distribuição, e não só a média: 4,8 uniforme e 4,8 com três
              // notas 1 são situações bem diferentes, e é a segunda que o
              // personal precisa enxergar para fazer algo a respeito.
              for (var estrela = 5; estrela >= 1; estrela--)
                _barraDaNota(
                  tema,
                  estrela,
                  (dist['$estrela'] as num?)?.toInt() ?? 0,
                  total,
                ),
            ],
          ),
        ),
        if (comentarios.isNotEmpty) ...[
          const SizedBox(height: 16.0),
          const CabecaSecao(titulo: 'O que seus alunos disseram'),
          const SizedBox(height: 10.0),
          CartaoPerfil(
            filhos: [
              for (final c in comentarios)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      14.0, 12.0, 14.0, 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarPerfil(
                        foto: '${c['foto'] ?? ''}',
                        nome: '${c['nome'] ?? ''}',
                        tamanho: 34.0,
                      ),
                      const SizedBox(width: 11.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${c['nome'] ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: tema.bodyMedium.override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600),
                                      color: tema.primaryText,
                                      fontSize: 12.5,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                EstrelasPerfil(
                                  nota: (c['nota'] as num?)?.toInt() ?? 0,
                                  tamanho: 13.0,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 2.0, 0.0, 0.0),
                              child: Text(
                                '${c['comentario'] ?? ''}',
                                style: tema.bodyMedium.override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400),
                                  color: tema.secondaryText,
                                  fontSize: 11.5,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w400,
                                  lineHeight: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _barraDaNota(
      FlutterFlowTheme tema, int estrela, int quantas, int total) {
    final fracao = total == 0 ? 0.0 : quantas / total;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 26.0,
            child: Text(
              '$estrela',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 11.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999.0),
              child: LinearProgressIndicator(
                value: fracao,
                minHeight: 6.0,
                backgroundColor: tema.alternate.withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(tema.secondary),
              ),
            ),
          ),
          SizedBox(
            width: 26.0,
            child: Text(
              '$quantas',
              textAlign: TextAlign.end,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 11.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────── aluno ─────────────────────────────

  /// A ficha do aluno mostra o que só existe aqui.
  ///
  /// Evolução saiu porque a tela de Métricas inteira já é isso; a sequência
  /// saiu porque aparece na home e nas métricas. O que sobra — e não está em
  /// nenhuma outra tela — é a relação com o personal e o histórico acumulado.
  /// Conquistas não competem com a sequência: sequência é presente e some
  /// quando se falha; conquista é passado e não some nunca.
  Widget _corpoDoAluno(FlutterFlowTheme tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_meuPersonal != null) ...[
          const CabecaSecao(titulo: 'Seu personal'),
          const SizedBox(height: 10.0),
          _PreviaDoPersonal(
            personal: _meuPersonal!,
            aoAbrir: () => context.pushNamed(
              PerfilpersonalWidget.routeName,
              queryParameters: {
                'perosnal': serializeParam(_meuPersonal, ParamType.DataStruct),
              }.withoutNulls,
            ),
            aoAvaliar: () async {
              final nota = await avaliarPersonal(
                context,
                personalUuid: _meuPersonal!.id,
                personalNome: _meuPersonal!.nome,
                notaAtual: _meuPersonal!.minhaNota,
              );
              if (nota != null) {
                CacheCurto.invalidar('perfil:meuPersonal');
                await _carregarMeuPersonal();
              }
            },
          ),
          // Mais ar antes das conquistas: sao dois assuntos diferentes — quem
          // te treina e o que voce acumulou —, e colados pareciam a mesma
          // secao continuando.
          const SizedBox(height: 28.0),
        ],
        if (_conquistas != null) _blocoConquistas(tema),
      ],
    );
  }

  Widget _blocoConquistas(FlutterFlowTheme tema) {
    final itens = (_conquistas!['itens'] as List? ?? [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
    if (itens.isEmpty) return const SizedBox.shrink();

    final ganhas = (_conquistas!['conquistadas'] as num?)?.toInt() ?? 0;
    final total = (_conquistas!['total'] as num?)?.toInt() ?? itens.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CabecaSecao(titulo: 'Conquistas', filtro: '$ganhas de $total'),
        const SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: tema.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [tema.designToken.shadow.lg],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Wrap(
            spacing: 4.0,
            runSpacing: 16.0,
            children: [
              for (final item in itens)
                SizedBox(
                  // Quatro por linha, com a largura dividida pelo pai: em
                  // grade fixa os títulos longos quebravam sobre o vizinho.
                  // Tres por linha, e nao quatro: com quatro o selo ficava
                  // em 46px e o titulo em corpo 9,5 — pequeno demais para um
                  // premio, que precisa dar vontade de ser visto.
                  width:
                      (MediaQuery.sizeOf(context).width - 32.0 - 24.0 - 16.0) /
                          3,
                  child: _selo(tema, item),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _selo(FlutterFlowTheme tema, Map<String, dynamic> item) {
    final conquistada = item['conquistada'] == true;
    final tipo = '${item['tipo']}';

    // Emoji, e nao icone de contorno.
    //
    // A regra do app e icone vazado, e ela vale para navegacao e acao — onde o
    // simbolo precisa sumir para o texto aparecer. Conquista e o oposto: e um
    // premio, e premio quer ser visto. O emoji tambem diz o tipo sem precisar
    // de legenda, que e o que permite o selo caber em 46px.
    final emoji = !conquistada
        ? '🔒'
        : switch (tipo) {
            'sequencia' => '🔥',
            'meses' => '📅',
            _ => item['codigo'] == 'primeiro_treino' ? '🏅' : '💪',
          };

    final fundo = !conquistada
        ? tema.alternate.withValues(alpha: 0.35)
        : (tipo == 'sequencia'
            ? tema.secondary.withValues(alpha: 0.14)
            : tema.accent1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 58.0,
          height: 58.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: fundo, shape: BoxShape.circle),
          child: Opacity(
            // Bloqueado nao muda de simbolo por acaso: o cadeado ja diz o
            // estado, e a opacidade evita que ele chame tanta atencao quanto
            // os que foram conquistados.
            opacity: conquistada ? 1.0 : 0.55,
            child: Text(emoji, style: const TextStyle(fontSize: 26.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(2.0, 6.0, 2.0, 0.0),
          child: Text(
            '${item['titulo']}',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: conquistada
                  ? tema.primaryText
                  : tema.secondaryText.withValues(alpha: 0.7),
              fontSize: 11.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
              lineHeight: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

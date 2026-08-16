import '/actions/actions.dart' as action_blocks;
import 'package:cached_network_image/cached_network_image.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/cache_curto.dart';
import '/components/lista_notificacoes.dart';
import '/components/calendario_treinos.dart';
import '/components/mensagem_widget.dart';
import '/components/acesso_bloqueado_widget.dart';
import '/components/convite_personal_widget.dart';
import '/components/chama_sequencia.dart';
import '/components/dias_treinados.dart';
import '/components/esqueleto.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/navbar/navbar_widget.dart';
import 'dart:convert';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'treinos_model.dart';
export 'treinos_model.dart';

class TreinosWidget extends StatefulWidget {
  const TreinosWidget({super.key});

  static String routeName = 'treinos';
  static String routePath = '/treinos';

  @override
  State<TreinosWidget> createState() => _TreinosWidgetState();
}

class _TreinosWidgetState extends State<TreinosWidget> {
  late TreinosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Verdadeiro só até a primeira carga voltar, e só quando não havia treino
  /// guardado. Quem já usou o app tem o treino em disco: mostrar esqueleto
  /// por cima de dado que existe seria esconder conteúdo para anunciar que
  /// ele está sendo conferido.
  bool _carregandoPrimeiraVez = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosModel());
    _carregandoPrimeiraVez = FFAppState().treinosTemp.subagrupamentos.isEmpty;

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Antes esta linha era `treinosTemp = treinosTemp` — nao fazia nada.
      // Como `treinosTemp` e persistido em disco e so era recarregado no
      // /loading do login, o aluno seguia vendo o treino antigo depois de o
      // personal editar: fechar e reabrir o app nao adiantava, so deslogar.
      await action_blocks.getTreinosAluno(context, silencioso: true);
      if (!mounted) return;
      _carregandoPrimeiraVez = false;
      safeSetState(() {});
      await _verificarConvitesEPerfil();
      // Depois dos bloqueios: nao faz sentido mostrar novidades para quem
      // acabou de cair na tela de "aguardando convite".
      if (!mounted) return;
      await mostrarNotificacoesNaoLidas(context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _verificarConvitesEPerfil() async {
    await action_blocks.getConvitesPendentes(context);

    while (FFAppState().convitesPendentes.isNotEmpty) {
      if (!mounted) return;
      final convite = FFAppState().convitesPendentes.first;
      await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        builder: (context) => ConvitePersonalWidget(convite: convite),
      );
    }

    if (!mounted) return;

    final acesso = await action_blocks.verificarAcessoAluno(
      context,
      alunoUuid: currentUserUid,
    );
    if (acesso != null) {
      final temPersonal = acesso['temPersonal'] as bool? ?? false;
      final assinaturaValida = acesso['assinaturaValida'] as bool? ?? true;
      final alunoAtivo = acesso['alunoAtivo'] as bool? ?? true;

      if (!temPersonal) {
        if (!mounted) return;
        // Navigator raiz: dentro do ShellRoute o padrao e o navegador do
        // shell, e a navbar ficaria por cima do aviso.
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) =>
                const AcessoBloqueadoWidget(tipo: TipoBloqueio.semPersonal),
          ),
        );
        return;
      }
      if (!assinaturaValida) {
        if (!mounted) return;
        // Navigator raiz: dentro do ShellRoute o padrao e o navegador do
        // shell, e a navbar ficaria por cima do aviso.
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => const AcessoBloqueadoWidget(
                tipo: TipoBloqueio.assinaturaVencida),
          ),
        );
        return;
      }
      if (!alunoAtivo) {
        if (!mounted) return;
        // Navigator raiz: dentro do ShellRoute o padrao e o navegador do
        // shell, e a navbar ficaria por cima do aviso.
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) =>
                const AcessoBloqueadoWidget(tipo: TipoBloqueio.alunoInativo),
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    final perfil = FFAppState().perfil;
    final perfilIncompleto = !perfil.hasDataNascimento() ||
        !perfil.hasTelefones() ||
        !perfil.hasPesoAtual() ||
        !perfil.hasAltura() ||
        !perfil.hasCpf();
    if (perfilIncompleto) {
      context.goNamed(CompletarPerfilWidget.routeName);
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
        // Gaveta a direita, e nao folha por baixo. Notificacao e um painel que
        // se puxa e se fecha, nao um conteudo que interrompe a tela — e e
        // assim que ela ja se comporta no perfil. Duas apresentacoes para a
        // mesma lista fariam parecer duas coisas diferentes.
        //
        // `endDrawer` porque o sino esta a direita: a gaveta vem do lado do
        // botao que a chamou.
        endDrawer: Drawer(
          elevation: 16.0,
          width: MediaQuery.sizeOf(context).width * 0.88,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          child: SafeArea(
            // Sem padding aqui. O recuo dos cartoes e responsabilidade da
            // lista, que ja aplica 16 nas laterais e 24 no fim — somando o
            // desta gaveta, as notificacoes ficavam com 32 de cada lado.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 16.0, 16.0, 12.0),
                  child: Text(
                    'Notificações',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: FlutterFlowTheme.of(context).primaryText,
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
                  Expanded(
                    child: SingleChildScrollView(
                      primary: false,
                      controller: _model.columnController,
                      child: Column(
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
                                        // 8 embaixo: o cartao do personal vem
                                        // logo em seguida e os dois se leem
                                        // como um bloco so. O respiro maior
                                        // fica entre ele e as cartas.
                                        8.0),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 768.0,
                                      ),
                                      decoration: BoxDecoration(),
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // A marca, alinhada a
                                              // esquerda. Antes havia aqui um
                                              // botao de voltar invisivel
                                              // (icone pintado da cor do
                                              // fundo) e o titulo "Seus
                                              // exercicios" centralizado — um
                                              // rotulo que descrevia a aba em
                                              // que a pessoa ja esta.
                                              Image.asset(
                                                'assets/images/marca_datafit.png',
                                                height: 30.0,
                                                fit: BoxFit.contain,
                                              ),
                                              // O sino ocupa o canto onde
                                              // havia um icone da Apple
                                              // pintado da cor do fundo —
                                              // invisivel, so para equilibrar
                                              // a linha. Aqui a pessoa passa
                                              // mais tempo que em qualquer
                                              // outra tela, e era o unico
                                              // lugar sem acesso as
                                              // notificacoes.
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  _BotaoSequencia(),
                                                  SizedBox(width: 8.0),
                                                  _SinoNotificacoes(),
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
                          // Esqueleto enquanto a primeira carga nao volta: antes a tela abria
                          // vazia e quem esperava nao sabia se estava carregando ou travado.
                          // So na primeira vez — havendo treino em cache, ele aparece na hora e
                          // a atualizacao acontece por baixo.
                          if (_carregandoPrimeiraVez)
                            const EsqueletoTreinos()
                          else ...[
                            Padding(
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
                                  14.0,
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
                                  24.0),
                              child: _SaudacaoDoDia(),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView(
                                  // O baralho tem sombra e cartas assomando dos
                                  // lados; encostado no card do personal os dois
                                  // blocos se liam como um so.
                                  padding: const EdgeInsets.only(top: 16.0),
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
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
                                          0.0,
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
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        // Sem fundo: o card branco agora e de
                                        // cada item, nao do conjunto.
                                        decoration: BoxDecoration(),
                                        child: Builder(
                                          builder: (context) {
                                            final treinos = FFAppState()
                                                .treinosTemp
                                                .subagrupamentos
                                                .map((e) => e)
                                                .toList()
                                                .sortedList(
                                                    keyOf: (e) => e.ordem,
                                                    desc: false)
                                                .toList();

                                            // "Proximo" e o primeiro que ainda
                                            // nao foi feito. Se algum estiver em
                                            // andamento, ele manda: nao existe
                                            // "proximo" enquanto ha um aberto.
                                            final emAndamento =
                                                treinos.indexWhere((e) =>
                                                    e.status == 'em_andamento');
                                            final proximo = emAndamento >= 0
                                                ? -1
                                                : treinos.indexWhere((e) =>
                                                    e.status != 'concluido' &&
                                                    e.status != 'pulado');

                                            return _CarrosselLeque(
                                              quantidade: treinos.length,
                                              construir:
                                                  (context, treinosIndex) {
                                                final treinosItem =
                                                    treinos[treinosIndex];
                                                final bandeira = treinosIndex ==
                                                        emAndamento
                                                    ? 'Executando'
                                                    : (treinosIndex == proximo
                                                        ? 'Próximo treino'
                                                        : null);
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    boxShadow: [
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .designToken
                                                          .shadow
                                                          .lg
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      onTap: () async {
                                                        context.pushNamed(
                                                          TreinosDetalhesWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'indexGrupo':
                                                                serializeParam(
                                                              treinosIndex,
                                                              ParamType.int,
                                                            ),
                                                          }.withoutNulls,
                                                          extra: <String,
                                                              dynamic>{
                                                            '__transition_info__':
                                                                TransitionInfo(
                                                              hasTransition:
                                                                  true,
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
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child:
                                                            _ConteudoCardTreino(
                                                          treino: treinosItem,
                                                          bandeira: bandeira,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                            // Os atalhos, depois do baralho: seguem o desenho
                            // de referencia, onde o cartao do dia vem primeiro e
                            // a lista de acessos vem abaixo. Antes o treino, o
                            // personal e a validade disputavam o topo com o
                            // proprio treino do dia — tres cartoes antes de a
                            // pessoa ver o que tinha para fazer.
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 24.0, 16.0, 0.0),
                              child: _AtalhosDoTreino(),
                            ),
                          ],
                        ].addToEnd(SizedBox(height: 120.0)),
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

/// A frase que abre o dia, com o número em destaque.
///
/// Substitui o cartão "Seu treino" no topo. O cartão dizia o nome do treino
/// antes de dizer o que havia para fazer — e o nome do treino é a informação
/// menos urgente da tela, já que ele não muda de um dia para o outro.
///
/// O número vem realçado por fundo, e não por cor: uma palavra colorida no
/// meio de uma frase preta some na leitura rápida; o bloco azul é lido antes
/// da frase inteira, que é exatamente a ordem desejada.
class _SaudacaoDoDia extends StatelessWidget {
  const _SaudacaoDoDia();

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    // Frase fixa. Nao muda com o dia, com o progresso nem com o estado do
    // treino: e a assinatura do app naquela tela, e assinatura que muda deixa
    // de ser assinatura.
    //
    // Largura cheia, e nao so o texto: a coluna que envolve esta tela alinha
    // os filhos pelo centro, entao um Text do tamanho do proprio conteudo
    // nascia centralizado por mais que o `textAlign` dissesse o contrario. Com
    // a largura toda, o alinhamento passa a ser decidido pelo `textAlign`.
    return SizedBox(
      width: double.infinity,
      child: Text.rich(
        TextSpan(children: [
          // Quebra escrita, e nao deixada ao acaso: assim a pilula fica sempre
          // no fim da segunda linha, e nunca desce sozinha por nao caber.
          const TextSpan(text: 'Não precisa ser perfeito.\nSó precisa ser '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(9.0, 2.0, 9.0, 4.0),
              decoration: BoxDecoration(
                color: tema.primary,
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Text(
                'hoje',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const TextSpan(text: '.'),
        ]),
        textAlign: TextAlign.start,
        style: tema.bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
          color: tema.primaryText,
          fontSize: 22.0,
          letterSpacing: -0.6,
          fontWeight: FontWeight.bold,
          lineHeight: 1.5,
        ),
      ),
    );
  }
}

/// O foguinho da sequência, como botão de barra.
///
/// Mesmo desenho do sino ao lado — quadrado claro com sombra —, para os dois
/// se lerem como um par de controles e não como um enfeite ao lado de um
/// botão. Dentro dele a mesma chama animada dos cartões de métrica, com os
/// mesmos degraus, e o mesmo toque que abre a lista de dias treinados.
///
/// O selo traz os dias seguidos. Some quando a sequência é zero: um selo com
/// "0" anunciaria a ausência, e sequência quebrada não é notícia que a barra
/// precise dar.
class _BotaoSequencia extends StatefulWidget {
  const _BotaoSequencia();

  @override
  State<_BotaoSequencia> createState() => _BotaoSequenciaState();
}

class _BotaoSequenciaState extends State<_BotaoSequencia> {
  int _sequencia = 0;
  int _sequenciaMaxima = 0;

  /// Onde a chama está na tela, para a lista de dias nascer dali.
  final GlobalKey _chave = GlobalKey();

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  /// Uma chamada pequena e propria, em vez das metricas inteiras: a barra
  /// precisa de dois numeros, e puxar o painel todo por causa deles seria
  /// trocar uma consulta de duas colunas por uma de dezenas.
  Future<void> _buscar() async {
    try {
      final r = await CacheCurto.obter(
        // Mesma chave da data de definicao: os dois widgets pedem juntos, e o
        // cache serve os dois com uma ida so ao banco.
        'treinos:extras',
        () => SupaFlow.client
            .rpc('get_extras_treino', params: {'p_aluno_uuid': currentUserUid}),
      );
      if (!mounted) return;
      final m = (r as Map?)?.cast<String, dynamic>() ?? {};
      setState(() {
        _sequencia = (m['sequenciaAtualDias'] as num?)?.toInt() ?? 0;
        _sequenciaMaxima = (m['sequenciaMaxDias'] as num?)?.toInt() ?? 0;
      });
    } catch (_) {
      // Sem o numero o botao continua ali, so sem selo.
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      key: _chave,
      borderRadius: BorderRadius.circular(999.0),
      onTap: () {
        final caixa = _chave.currentContext?.findRenderObject() as RenderBox?;
        mostrarDiasTreinados(
          context,
          sequenciaAtual: _sequencia,
          sequenciaMaxima: _sequenciaMaxima,
          origem: (caixa != null && caixa.hasSize)
              ? caixa.localToGlobal(caixa.size.center(Offset.zero))
              : null,
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tema.primaryBackground,
              // Circulo, como os botoes das fichas de perfil: a barra
              // inteira do app passa a falar a mesma lingua.
              shape: BoxShape.circle,
              boxShadow: [tema.designToken.shadow.sm],
            ),
            // A chama de sempre, no tamanho que cabe no botao. Apagada quando
            // a sequencia e zero — e ela mesma quem decide isso.
            child: ChamaSequencia(dias: _sequencia, tamanhoBase: 19.0),
          ),
          if (_sequencia > 0)
            Positioned(
              top: -3.0,
              right: -3.0,
              child: Container(
                width: 18.0,
                height: 18.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // Laranja, e nao o azul do sino: o selo pertence a chama, e
                  // dois selos azuis lado a lado se somariam num numero so.
                  color: tema.secondary,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: tema.secondaryBackground, width: 1.5),
                ),
                child: Text(
                  _sequencia > 99 ? '99' : '$_sequencia',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    color: Colors.white,
                    fontSize: 9.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// O sino, com o contador de não lidas.
class _SinoNotificacoes extends StatelessWidget {
  const _SinoNotificacoes();

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final naoLidas = FFAppState().notificacoes.where((e) => !e.lida).length;

    return InkWell(
      borderRadius: BorderRadius.circular(999.0),
      onTap: () => Scaffold.of(context).openEndDrawer(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tema.primaryBackground,
              // Circulo, como os botoes das fichas de perfil: a barra
              // inteira do app passa a falar a mesma lingua.
              shape: BoxShape.circle,
              boxShadow: [tema.designToken.shadow.sm],
            ),
            // O sino da familia FFIcons, a mesma do resto do app: o do
            // Material tem outro peso de traco e destoa dos vizinhos.
            child: Icon(FFIcons.kproperty1FiRrBell,
                color: tema.primary, size: 18.0),
          ),
          if (naoLidas > 0)
            Positioned(
              top: -3.0,
              right: -3.0,
              // Lado fixo, e nao padding: com o padding o selo esticava a
              // cada digito e virava uma capsula. Circulo certo, e acima de
              // nove o texto vira '9+' para caber.
              child: Container(
                width: 18.0,
                height: 18.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // Vermelho, como o selo do perfil: contagem de nao
                  // lidas e aviso, e aviso no app e vermelho.
                  color: tema.error,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: tema.secondaryBackground, width: 1.5),
                ),
                child: Text(
                  naoLidas > 9 ? '9+' : '$naoLidas',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    color: Colors.white,
                    fontSize: 9.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Os acessos que ficam abaixo do baralho.
///
/// Seguem o desenho da referência: um quadrado colorido com o ícone, o título
/// com um selo à direita quando há número, e uma linha de apoio explicando o
/// que se encontra ali. Cada um com sua cor, porque são assuntos diferentes —
/// e é a cor que faz a lista ser varrida de relance em vez de lida.
///
/// Antes estes três eram cartões acima do baralho, e a pessoa passava por
/// treino, personal e validade antes de ver o que tinha para fazer no dia.
class _AtalhosDoTreino extends StatefulWidget {
  const _AtalhosDoTreino();

  @override
  State<_AtalhosDoTreino> createState() => _AtalhosDoTreinoState();
}

class _AtalhosDoTreinoState extends State<_AtalhosDoTreino> {
  bool _abrindoPersonal = false;

  /// Quando o personal montou este treino, em dd/MM/aaaa.
  String? _definidoEm;

  @override
  void initState() {
    super.initState();
    _carregarDataDefinicao();
  }

  Future<void> _carregarDataDefinicao() async {
    try {
      final resposta = await CacheCurto.obter(
        'treinos:extras',
        () => SupaFlow.client
            .rpc('get_extras_treino', params: {'p_aluno_uuid': currentUserUid}),
      );
      final iso = (resposta as Map?)?['definidoEm'];
      final data = DateTime.tryParse('$iso')?.toLocal();
      if (!mounted || data == null) return;
      setState(() => _definidoEm =
          '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}');
    } catch (_) {
      // Sem a data o atalho cai no texto neutro.
    }
  }

  Future<void> _abrirPersonal() async {
    if (_abrindoPersonal) return;
    setState(() => _abrindoPersonal = true);
    try {
      final resposta = await AlunoGroup.getPerfilPersonalCall.call(
        pAlunoUuid: currentUserUid,
        pPersonalUuid: FFAppState().treinosTemp.personalUuid,
      );
      if (!mounted) return;
      if (resposta.succeeded) {
        context.pushNamed(
          PerfilpersonalWidget.routeName,
          queryParameters: {
            'perosnal': serializeParam(
              PerfilPersonalStruct.maybeFromMap(resposta.jsonBody),
              ParamType.DataStruct,
            ),
          }.withoutNulls,
        );
      }
    } catch (_) {
      // Falhar aqui não pode derrubar a tela: o atalho volta ao normal e a
      // pessoa tenta de novo.
    } finally {
      if (mounted) setState(() => _abrindoPersonal = false);
    }
  }

  /// O calendário do plano: em que dias houve treino.
  ///
  /// Sem filtro por treino, e o motivo importa: este atalho mostra o *grupo*
  /// ("Hipertrofia"), enquanto o calendário guarda o nome de cada treino
  /// ("Treino A"). Filtrar um pelo outro nunca casa — e foi o que fez o
  /// calendário abrir vazio. Um recorte por treino cabe nas cartas do
  /// baralho, onde o A e o B existem separados.
  Future<void> _abrirCalendario(String nome) async {
    final tema = FlutterFlowTheme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.sizeOf(context).height * 0.8,
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: tema.alternate,
                      borderRadius: BorderRadius.circular(999.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      2.0, 18.0, 2.0, 12.0),
                  child: Text(
                    nome,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primaryText,
                      fontSize: 17.0,
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: const CalendarioTreinos(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Pergunta antes de cutucar o personal.
  ///
  /// Sem a pergunta, um toque curioso viraria uma cobrança no celular de outra
  /// pessoa — e cobrança disparada sem querer é o tipo de coisa que faz alguém
  /// parar de tocar em tudo.
  Future<void> _pedirRenovacao() async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WebViewAware(
        child: MensagemWidget(
          texto: 'Avisar seu personal que o treino venceu e pedir a renovação?',
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: true,
          action: () async {
            try {
              final r = await SupaFlow.client.rpc('pedir_renovacao_treino');
              final mapa = (r as Map?)?.cast<String, dynamic>() ?? {};
              if (!mounted) return;
              await _avisar(
                mapa['sucesso'] == true
                    ? (mapa['jaAvisado'] == true
                        // Silenciar o segundo pedido sem dizer nada faria
                        // parecer que o toque nao funcionou.
                        ? 'Seu personal já foi avisado hoje.'
                        : 'Pedido enviado ao seu personal.')
                    : 'Não consegui avisar agora. Tente de novo.',
              );
            } catch (_) {
              if (mounted) {
                await _avisar('Não consegui avisar agora. Tente de novo.',
                    sucesso: false);
              }
            }
          },
        ),
      ),
    );
  }

  /// O aviso do app, e nao a barrinha do sistema.
  ///
  /// O `SnackBar` do Material nao tem nada do nosso desenho — cor, tipografia
  /// e animacao sao de outro produto — e aparece no rodape, longe de onde o
  /// dedo acabou de tocar.
  Future<void> _avisar(String texto, {bool sucesso = true}) async {
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

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final t = FFAppState().treinosTemp;

    // Os exercicios vivem dois niveis abaixo: subagrupamento -> grupo ->
    // exercicios. Somar so o primeiro nivel devolvia zero sempre.
    final exercicios = t.subagrupamentos.fold<int>(
      0,
      (soma, sub) =>
          soma + sub.grupos.fold<int>(0, (s2, g) => s2 + g.exercicios.length),
    );

    // Dias até a validade. Negativo já venceu.
    final validade = DateTime.tryParse(t.dataValidade);
    final dias = validade == null
        ? null
        : DateTime(validade.year, validade.month, validade.day)
            .difference(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day))
            .inDays;
    final vencido = dias != null && dias < 0;
    final urgente = dias != null && dias >= 0 && dias <= 7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 2.0, 12.0),
          child: Text(
            'Seu treino',
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: tema.primaryText,
              fontSize: 15.0,
              letterSpacing: -0.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _Atalho(
          icone: Icons.fitness_center_outlined,
          cor: tema.primary,
          titulo: t.nome.isEmpty ? 'Seu treino' : t.nome,
          // A data em que foi montado, e nao um convite para tocar: sem acao
          // atras dele, um texto no imperativo promete uma tela que nao existe.
          // Enquanto a data nao chega, nada no lugar — inventar outra legenda
          // so para preencher faria a linha mudar de assunto por um instante.
          apoio:
              _definidoEm == null ? null : 'Definido para você em $_definidoEm',
          aoTocar: t.nome.isEmpty ? null : () => _abrirCalendario(t.nome),
        ),
        const SizedBox(height: 10.0),
        _Atalho(
          icone: Icons.person_outline_rounded,
          // Mesmo azul do primeiro: os tres sao atalhos comuns, e uma cor por
          // linha fazia a lista parecer um semaforo. A cor fica reservada para
          // quando ela significa alguma coisa — e so a validade tem estado.
          cor: tema.primary,
          titulo: t.personalNome.isEmpty ? 'Seu personal' : t.personalNome,
          apoio: 'Perfil, vídeos dos exercícios e cobranças',
          carregando: _abrindoPersonal,
          aoTocar: _abrirPersonal,
        ),
        const SizedBox(height: 10.0),
        _Atalho(
          icone: Icons.event_available_outlined,
          // Vermelho so quando venceu. Antes o laranja tambem entrava perto
          // do vencimento, mas isso dava alarme de tres em tres dias para uma
          // coisa que so tem uma consequencia real: ter vencido.
          cor: vencido ? tema.error : tema.primary,
          titulo: dias == null
              ? 'Sem prazo definido'
              : (vencido
                  ? 'Seu treino venceu'
                  : '$dias ${dias == 1 ? 'dia' : 'dias'} até expirar'),
          apoio: vencido
              ? 'Toque para pedir a renovação'
              : 'Depois disso, seu personal precisa renovar',
          // So o vencido responde ao toque: antes do vencimento nao ha o que
          // pedir, e um atalho que abre uma pergunta sem motivo ensina a
          // ignorar o proximo.
          aoTocar: vencido ? _pedirRenovacao : null,
        ),
      ],
    );
  }
}

/// Uma linha da lista de atalhos.
class _Atalho extends StatelessWidget {
  const _Atalho({
    required this.icone,
    required this.cor,
    required this.titulo,
    this.apoio,
    this.selo,
    this.aoTocar,
    this.carregando = false,
  });

  final IconData icone;
  final Color cor;
  final String titulo;
  final String? apoio;
  final String? selo;
  final VoidCallback? aoTocar;
  final bool carregando;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: aoTocar,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            // Branco com sombra, como todo cartao do app. A cor fica so no
            // quadrado do icone: tingir o cartao inteiro dava a cada linha o
            // peso de um alerta, e sao tres atalhos comuns.
            color: tema.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [tema.designToken.shadow.lg],
          ),
          child: Row(
            children: [
              Container(
                width: 42.0,
                height: 42.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13.0),
                ),
                child: carregando
                    ? SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(cor),
                        ),
                      )
                    : Icon(icone, color: cor, size: 21.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            titulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: tema.primaryText,
                              fontSize: 14.0,
                              letterSpacing: -0.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (selo != null) ...[
                          const SizedBox(width: 7.0),
                          Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                7.0, 1.0, 7.0, 2.0),
                            decoration: BoxDecoration(
                              color: cor.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                            child: Text(
                              selo!,
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700),
                                color: cor,
                                fontSize: 10.5,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if ((apoio ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 2.0, 0.0, 0.0),
                        child: Text(
                          apoio!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tema.bodyMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w400),
                            color: tema.secondaryText,
                            fontSize: 11.5,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (aoTocar != null) ...[
                const SizedBox(width: 6.0),
                Icon(Icons.chevron_right_rounded,
                    color: tema.secondaryText, size: 20.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Progresso do dia, em anel, no canto do cartão.
///
/// Era uma pilha de barrinhas crescendo de baixo para cima — um degrau por
/// treino do dia. Contar degraus funciona com dois ou três, mas exige
/// decifrar: quantos são ao todo, qual está cheio, o que significa a altura.
/// O anel responde com a forma que o painel de métricas já usa para "quanto
/// do combinado saiu", e o número no meio dispensa a conta.
class _AnelDoDia extends StatelessWidget {
  const _AnelDoDia();

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final treinos = FFAppState().treinosTemp.subagrupamentos;
    final total = treinos.length;
    if (total == 0) return const SizedBox.shrink();

    // Pulado nao conta como feito: o anel cheio tem que querer dizer que o dia
    // foi cumprido, nao que ele acabou.
    final feitos = treinos.where((e) => e.status == 'concluido').length;
    final completo = feitos == total;

    return SizedBox(
      width: 54.0,
      height: 54.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 54.0,
            height: 54.0,
            child: CircularProgressIndicator(
              value: total == 0 ? 0.0 : feitos / total,
              strokeWidth: 5.0,
              strokeCap: StrokeCap.round,
              backgroundColor: tema.alternate,
              valueColor: AlwaysStoppedAnimation<Color>(
                completo ? tema.success : tema.primary,
              ),
            ),
          ),
          // Cheio, o numero da lugar ao visto: "3 de 3" e a mesma informacao
          // que o anel fechado ja deu, e o visto fecha o assunto.
          if (completo)
            Icon(Icons.check_rounded, color: tema.success, size: 24.0)
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$feitos',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: tema.primaryText,
                    fontSize: 17.0,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '/$total',
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
    );
  }
}

/// Validade do treino, sob o nome no cabecalho.
///
/// Antes esta linha contava "x de x treinos hoje" e a validade so assomava na
/// ultima semana. A contagem do dia ja esta na pilha ao lado — repetir em
/// numero o que o desenho diz nao acrescenta —, entao a linha ficou so para a
/// validade, que nao tem outro lugar onde aparecer e some justamente quando
/// esta longe, que e quando da tempo de renovar sem correria.
class _ResumoDoDia extends StatefulWidget {
  const _ResumoDoDia();

  @override
  State<_ResumoDoDia> createState() => _ResumoDoDiaState();
}

class _ResumoDoDiaState extends State<_ResumoDoDia> {
  /// Dias seguidos treinando. Nulo enquanto a busca nao volta.
  int? _sequencia;
  int _sequenciaMaxima = 0;

  /// Onde a chama esta na tela, para a lista de dias nascer dali.
  final GlobalKey _chaveChama = GlobalKey();

  @override
  void initState() {
    super.initState();
    _buscarSequencia();
  }

  /// Uma chamada pequena e propria, em vez de carregar as metricas inteiras:
  /// esta tela nao precisa de mais nada do painel, e puxar tudo por causa de
  /// um numero seria trocar uma consulta de duas colunas por uma de dezenas.
  Future<void> _buscarSequencia() async {
    try {
      final r = await CacheCurto.obter(
        // Mesma chave da data de definicao: os dois widgets pedem juntos, e o
        // cache serve os dois com uma ida so ao banco.
        'treinos:extras',
        () => SupaFlow.client
            .rpc('get_extras_treino', params: {'p_aluno_uuid': currentUserUid}),
      );
      if (!mounted) return;
      final m = (r as Map?)?.cast<String, dynamic>() ?? {};
      setState(() {
        _sequencia = (m['sequenciaAtualDias'] as num?)?.toInt() ?? 0;
        _sequenciaMaxima = (m['sequenciaMaxDias'] as num?)?.toInt() ?? 0;
      });
    } catch (_) {
      // Sem sequencia a linha simplesmente nao aparece: e um reforco, nao
      // uma informacao que a tela deva a alguem.
      if (mounted) setState(() => _sequencia = 0);
    }
  }

  /// Dias que faltam para o plano vencer. Nulo quando nao da para saber.
  int? _diasParaVencer() {
    final bruto = FFAppState().treinosTemp.dataValidade;
    if (bruto.isEmpty) return null;
    final validade = DateTime.tryParse(bruto);
    if (validade == null) return null;
    final hoje = DateTime.now();
    return DateTime(validade.year, validade.month, validade.day)
        .difference(DateTime(hoje.year, hoje.month, hoje.day))
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final dias = _diasParaVencer();
    // Sem data de validade nao ha o que dizer, e uma linha vazia deslocaria o
    // nome do treino para cima.
    if (dias == null) return const SizedBox.shrink();

    // Vencido e o unico estado que muda a frase: nao ha prazo para contar, o
    // treino simplesmente acabou.
    final expirado = dias <= 0;
    final urgente = dias <= 7;

    final seq = _sequencia ?? 0;

    // Mesmo desenho dos cartoes do painel de metricas: rotulo pequeno em
    // cima, o numero grande no meio, a leitura embaixo. Antes estes dois
    // tinham icone e valor coloridos na mesma linha e o rotulo por baixo —
    // outro cartao, na mesma familia de telas.
    Widget cartao({
      required String rotulo,
      required String valor,
      required String leitura,
      Widget? sufixo,
      // O disco da chama vai para a borda; o alerta de validade fica colado no
      // numero, porque ali o icone qualifica o numero em vez de contar outra
      // coisa sobre o cartao.
      bool sufixoNaDireita = false,
      VoidCallback? aoTocar,
      int realce = 0,
    }) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: aoTocar,
          child: Container(
            height: 100.0,
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              // So aos 30 dias o cartao inteiro puxa para o laranja.
              color: realce >= 3
                  ? Color.alphaBlend(tema.secondary.withValues(alpha: 0.12),
                      tema.primaryBackground)
                  : tema.primaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [tema.designToken.shadow.lg],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rotulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 11.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  // `center`, e nao `baseline`: alinhar pela linha de base
                  // obriga cada filho a informar a propria baseline, e a chama
                  // e um Transform animado que nao tem uma. Pedir a baseline
                  // dela no meio do layout dispara outro layout ali dentro —
                  // era isso que travava a tela ao trocar o periodo.
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Ver painel_metricas: com um Spacer o disco parava no meio,
                  // porque texto e Spacer dividiam a folga meio a meio.
                  mainAxisAlignment: sufixoNaDireita
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        valor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          // A partir de 15 dias o numero vai para o laranja.
                          color:
                              realce >= 2 ? tema.secondary : tema.primaryText,
                          fontSize: 26.0,
                          letterSpacing: -0.8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (sufixo != null) ...[
                      SizedBox(width: sufixoNaDireita ? 6.0 : 2.0),
                      sufixo,
                    ],
                  ],
                ),
                SizedBox(
                  height: 15.0,
                  child: Text(
                    leitura,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: tema.secondaryText,
                      fontSize: 10.5,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      key: _chaveChama,
      children: [
        // A sequência no cartão dela, em laranja sobre branco: no bloco azul
        // de antes a cor brigava com o fundo, e não era a chama que estava
        // errada — era uma foto tentando ser suporte de texto.
        if (seq > 0) ...[
          cartao(
            rotulo: 'Sequência',
            valor: '$seq',
            leitura: seq == 1 ? 'dia seguido' : 'dias seguidos',
            // A mesma chama do painel de metricas, com os mesmos degraus: em
            // 10 dias ela cresce, e a partir de 15 o numero acompanha. Ter
            // duas chamas diferentes no app faria a de ca parecer enfeite e a
            // de la, dado.
            sufixo: ChamaEmCirculo(dias: seq, tamanhoBase: 20.0),
            sufixoNaDireita: true,
            realce: nivelDaSequencia(seq),
            aoTocar: () {
              final caixa =
                  _chaveChama.currentContext?.findRenderObject() as RenderBox?;
              mostrarDiasTreinados(
                context,
                sequenciaAtual: seq,
                sequenciaMaxima: _sequenciaMaxima,
                origem: (caixa != null && caixa.hasSize)
                    ? caixa.localToGlobal(caixa.size.center(Offset.zero))
                    : null,
              );
            },
          ),
          const SizedBox(width: 12.0),
        ],
        cartao(
          rotulo: 'Validade',
          // Vencido troca o numero pela palavra: "0 dias" e uma contagem que
          // chegou ao fim, e ler zero exige a conta que a palavra ja entrega.
          valor: expirado ? 'Vencido' : '$dias',
          leitura: expirado
              ? 'renove com seu personal'
              : (dias == 1 ? 'dia até expirar' : 'dias até expirar'),
          sufixo: urgente && !expirado
              ? Icon(Icons.error_outline_rounded, color: tema.error, size: 18.0)
              : null,
        ),
      ],
    );
  }
}

/// Baralho dos treinos do dia.
///
/// A versao anterior era um leque: os vizinhos ficavam ao lado, inclinados.
/// Aqui eles ficam ATRAS do card da frente, com as pontas assomando dos dois
/// lados, como uma pilha de cartas.
///
/// Arrastar para qualquer um dos lados manda a carta da frente para o fim da
/// pilha. Nao existe descartar: e uma fila circular, entao a mesma carta
/// sempre volta depois de dar a volta.
class _CarrosselLeque extends StatefulWidget {
  const _CarrosselLeque({
    required this.quantidade,
    required this.construir,
  });

  final int quantidade;
  final Widget Function(BuildContext, int) construir;

  @override
  State<_CarrosselLeque> createState() => _CarrosselLequeState();
}

class _CarrosselLequeState extends State<_CarrosselLeque>
    with TickerProviderStateMixin {
  static const double _altura = 250.0;

  /// Quanto cada carta de tras assoma para o lado, e quanto ela encolhe.
  static const double _passoLateral = 26.0;
  static const double _passoEscala = 0.06;

  /// Giro das cartas de tras, em radianos (~8 graus). A da esquerda gira para
  /// um lado e a da direita para o outro, abrindo o leque.
  ///
  /// Comecou em 30 graus e ficou deitado demais: a carta de tras virava um
  /// losango e competia com a da frente em vez de so sugerir profundidade.
  static const double _giroFundo = 0.14;

  /// A carta da frente nao ocupa a largura toda: e a sobra que deixa as
  /// pontas das de tras aparecerem sem precisar empurra-las para fora.
  static const double _larguraFrente = 0.86;

  /// Cartas de tras visiveis. Acima disso a pilha vira sujeira visual.
  static const int _visiveis = 2;

  /// Onde cada assento da pilha fica: 0 = frente, 1 = segunda, 2 = terceira.
  ///
  /// Existe como lista, e nao como conta em cima da camada, porque a posicao
  /// nao e uma progressao — a segunda vai para a direita e a terceira para a
  /// esquerda, e a terceira ainda leva 2px a mais.
  static const List<double> _deslocDoAssento = [
    0.0,
    _passoLateral,
    -(_passoLateral + 2.0),
  ];

  static const List<double> _giroDoAssento = [0.0, _giroFundo, -_giroFundo];

  /// Le a lista num ponto continuo entre dois assentos.
  ///
  /// E o que transforma a troca de lugar em movimento: com `p = 1.4` a carta
  /// esta 40% do caminho entre o segundo assento e o primeiro, em vez de estar
  /// num ou noutro.
  static double _entreAssentos(List<double> assentos, double p) {
    if (p <= 0) return assentos.first;
    if (p >= assentos.length - 1) return assentos.last;
    final anterior = p.floor();
    final fracao = p - anterior;
    return assentos[anterior] +
        (assentos[anterior + 1] - assentos[anterior]) * fracao;
  }

  /// Indice da carta que esta na frente.
  int _topo = 0;

  /// Deslocamento horizontal do arraste em andamento.
  double _arraste = 0.0;

  late final AnimationController _controle;

  /// Entrada da carta que volta para o fundo da pilha.
  ///
  /// Quando a da frente sai, ela reaparece no ultimo assento — e aparecia
  /// pronta, do nada. Comeca em 1 para a pilha parada ja nascer visivel; so
  /// as trocas rodam a animacao.
  late final AnimationController _controleEntrada;

  @override
  void initState() {
    super.initState();
    _controle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(() => setState(() {}));
    _controleEntrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controle.dispose();
    _controleEntrada.dispose();
    super.dispose();
  }

  void _aoArrastar(DragUpdateDetails d) {
    if (widget.quantidade < 2) return;
    setState(() => _arraste += d.delta.dx);
  }

  void _aoSoltar(DragEndDetails d, double largura) {
    if (widget.quantidade < 2) {
      _animarAte(0.0);
      return;
    }

    // Passou de um terco da largura, ou saiu com velocidade: vai para o fim.
    final velocidade = d.velocity.pixelsPerSecond.dx;
    final passou = _arraste.abs() > largura / 3 || velocidade.abs() > 700;

    if (!passou) {
      _animarAte(0.0, curva: Curves.easeOutBack);
      return;
    }

    final destino = _arraste.isNegative ? -largura * 1.3 : largura * 1.3;
    _animarAte(destino, aoTerminar: () {
      setState(() {
        _topo = (_topo + 1) % widget.quantidade;
        _arraste = 0.0;
      });
      // A carta que acabou de sair reentra no fundo: sem isto ela pisca de
      // volta ja pronta, no mesmo quadro em que a pilha se reorganiza.
      _controleEntrada.forward(from: 0.0);
    });
  }

  void _animarAte(
    double destino, {
    Curve curva = Curves.easeOut,
    VoidCallback? aoTerminar,
  }) {
    final anim = Tween<double>(begin: _arraste, end: destino).animate(
      CurvedAnimation(parent: _controle, curve: curva),
    );
    void ouvir() => _arraste = anim.value;

    _controle.reset();
    _controle.addListener(ouvir);
    _controle.forward().whenComplete(() {
      _controle.removeListener(ouvir);
      if (aoTerminar != null) {
        aoTerminar();
      } else {
        _arraste = destino;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quantidade == 0) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, restricoes) {
        final largura = restricoes.maxWidth;

        // A da frente mais as de tras visiveis, nunca mais do que existem.
        final qtd = widget.quantidade < _visiveis + 1
            ? widget.quantidade
            : _visiveis + 1;

        final cartas = <Widget>[];
        // De tras para frente, para a da frente terminar por cima na Stack.
        for (var camada = qtd - 1; camada >= 0; camada--) {
          final indice = (_topo + camada) % widget.quantidade;
          cartas.add(_carta(context, camada, indice, largura,
              ultima: camada == qtd - 1));
        }

        return SizedBox(
          height: _altura,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: cartas,
          ),
        );
      },
    );
  }

  Widget _carta(
    BuildContext context,
    int camada,
    int indice,
    double largura, {
    required bool ultima,
  }) {
    final daFrente = camada == 0;

    // Enquanto a da frente e arrastada, as de tras se adiantam. Sem isso so a
    // de cima se mexeria e a pilha pareceria congelada.
    final progresso =
        largura == 0 ? 0.0 : (_arraste.abs() / largura).clamp(0.0, 1.0);
    final camadaEfetiva = daFrente ? 0.0 : camada - progresso;

    final escala = 1.0 - (_passoEscala * camadaEfetiva);

    // As de tras caminham para o assento da frente conforme o arraste avanca,
    // em vez de ficarem paradas e trocarem de lugar de uma vez no fim. Era
    // esse salto — de +26 para 0, desendireitando junto — que fazia a troca
    // parecer um corte em vez de um movimento.
    final desloc =
        daFrente ? _arraste : _entreAssentos(_deslocDoAssento, camadaEfetiva);

    // Frente: gira conforme o arraste. Fundo: acompanha o assento.
    final giro = daFrente
        ? (largura > 0 ? (_arraste / largura) * 0.22 : 0.0)
        : _entreAssentos(_giroDoAssento, camadaEfetiva);

    final carta = Transform.translate(
      offset: Offset(desloc, 0.0),
      child: Transform.rotate(
        angle: giro,
        child: Transform.scale(
          scale: escala,
          child: Opacity(
            // A ultima da pilha entra clareando: e o assento que recebe a
            // carta recem-descartada, o unico que troca de conteudo de um
            // quadro para o outro.
            opacity: daFrente
                ? 1.0
                : (1.0 - 0.2 * camadaEfetiva) *
                    (ultima ? _controleEntrada.value : 1.0),
            child: FractionallySizedBox(
              widthFactor: _larguraFrente,
              child: widget.construir(context, indice),
            ),
          ),
        ),
      ),
    );

    // So a da frente responde ao gesto.
    if (!daFrente) {
      return IgnorePointer(child: carta);
    }

    return GestureDetector(
      onHorizontalDragUpdate: _aoArrastar,
      onHorizontalDragEnd: (d) => _aoSoltar(d, largura),
      child: carta,
    );
  }
}

/// Conteudo do card de treino no baralho.
///
/// Antes o card trazia so o nome e a lista de subcategorias. Faltava o que a
/// pessoa precisa para decidir se abre: em que pe esta o treino, quanto falta
/// e qual e o proximo exercicio.
class _ConteudoCardTreino extends StatelessWidget {
  const _ConteudoCardTreino({required this.treino, this.bandeira});

  final GruposStruct treino;

  /// "Executando" ou "Próximo treino", quando este e o card em questao.
  ///
  /// Nulo nos demais: se toda carta tivesse bandeira, nenhuma se destacaria.
  final String? bandeira;

  /// Todos os exercicios do treino, achatados das subcategorias.
  List<ExerciciosStruct> get _exercicios =>
      treino.grupos.expand((g) => g.exercicios).toList();

  /// Proximo a fazer: o primeiro que nao foi concluido nem pulado, na ordem.
  /// `null` quando nao sobrou nenhum.
  ExerciciosStruct? get _proximo {
    final pendentes = _exercicios
        .where((e) => !e.isConcluido && !e.isPulado)
        .toList()
      ..sort((a, b) => a.ordem.compareTo(b.ordem));
    return pendentes.isEmpty ? null : pendentes.first;
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final exercicios = _exercicios;
    final total = exercicios.length;
    final feitos = exercicios.where((e) => e.isConcluido || e.isPulado).length;
    final proximo = _proximo;

    final subcategorias =
        treino.grupos.map((g) => g.subcategoria).where((s) => s.isNotEmpty);

    // So os estados que acrescentam algo ganham selo.
    //
    // "A fazer" e "Em andamento" sairam: o primeiro era o padrao — quase todo
    // card tinha — e o segundo ja e dito pela bandeira "Executando" e pela
    // barra de progresso preenchida pela metade. Tres avisos da mesma coisa
    // no mesmo cartao.
    // Concluido nao ganha bandeira: ganha um visto. A palavra repetia o que a
    // barra cheia ja diz, e ocupava a largura que o nome do treino precisa.
    final concluido = treino.status == 'concluido';

    String? rotulo;
    Color corEstado = tema.secondaryText;
    if (treino.status == 'pulado') {
      rotulo = 'Pulado';
      corEstado = tema.secondaryText;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                treino.nome,
                overflow: TextOverflow.ellipsis,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: tema.primaryText,
                  fontSize: 20.0,
                  letterSpacing: -0.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (concluido)
              Icon(Icons.check_circle_rounded, color: tema.primary, size: 22.0)
            else if (rotulo != null)
              Container(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
                decoration: BoxDecoration(
                  color: corEstado.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                child: Text(
                  rotulo,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: corEstado,
                    fontSize: 10.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        if (subcategorias.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
            child: Text(
              subcategorias.join(' · '),
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
        // Bandeira flutuante: sombra e cor cheia para ela ler como uma
        // etiqueta colada por cima do card, nao como mais uma linha dele.
        //
        // Abaixo do nome e da descricao, e nao acima: primeiro se le que
        // treino e este, depois em que pe ele esta. No topo ela era a primeira
        // coisa a aparecer e empurrava o nome para baixo.
        if (bandeira != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: Container(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
              decoration: BoxDecoration(
                color: treino.status == 'em_andamento'
                    ? tema.primary
                    : tema.primaryText,
                borderRadius: BorderRadius.circular(999.0),
                boxShadow: [tema.designToken.shadow.sm],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    treino.status == 'em_andamento'
                        ? Icons.bolt_rounded
                        : Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 13.0,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    bandeira!,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: Colors.white,
                      fontSize: 10.5,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Spacer(),
        // O proximo exercicio e a informacao que responde "e agora?".
        if (proximo != null)
          SizedBox(
            width: double.infinity,
            // Sem fundo: so o icone e o texto em azul. A caixa colorida
            // competia com a barra de progresso logo abaixo, e o cartao ficava
            // com dois blocos disputando a mesma parte de baixo.
            child: Row(
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  color: tema.primary,
                  size: 16.0,
                ),
                const SizedBox(width: 6.0),
                Expanded(
                  child: Text(
                    proximo.nome,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: tema.primary,
                      fontSize: 12.5,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (total > 0)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999.0),
                  child: LinearProgressIndicator(
                    value: feitos / total,
                    minHeight: 5.0,
                    backgroundColor: tema.alternate,
                    // Sempre primary: o verde no fim dizia "concluido" pela
                    // terceira vez no mesmo cartao — barra cheia e visto ja
                    // dizem, e a troca de cor so fazia a barra mudar de
                    // significado no ultimo passo.
                    valueColor: AlwaysStoppedAnimation<Color>(tema.primary),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: Text(
                    '$feitos de $total exercícios',
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
          ),
      ],
    );
  }
}

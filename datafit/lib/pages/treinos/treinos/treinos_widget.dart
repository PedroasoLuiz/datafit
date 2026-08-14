import '/actions/actions.dart' as action_blocks;
import 'package:cached_network_image/cached_network_image.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/lista_notificacoes.dart';
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
    _carregandoPrimeiraVez =
        FFAppState().treinosTemp.subagrupamentos.isEmpty;

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
                                              Container(
                                                width: 36.0,
                                                height: 36.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Icon(
                                                    Icons
                                                        .navigate_before_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    size: 20.0,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          'Seus exercícios',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
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
                                                  Container(
                                                    width: 36.0,
                                                    height: 36.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Icon(
                                                        FFIcons
                                                            .kproperty1FiRrApple,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        size: 18.0,
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
                                0.0,
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
                                16.0),
                            child: _CabecalhoDoDia(),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          // Faixa do personal, entre o cabecalho e as cartas:
                          // dentro do cabecalho ela disputava espaco com o
                          // nome do plano e o progresso. Aqui ela e o que de
                          // fato e — um atalho, e nao parte do resumo do dia.
                          //
                          // Colada no cartao de cima (8) e afastada das cartas
                          // (16, do padding da ListView): o agrupamento diz que
                          // ela pertence ao cabecalho, nao ao baralho.
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Material(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius:
                                  BorderRadius.circular(14.0),
                              elevation: 2.0,
                              shadowColor: Colors.black26,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(14.0),
                                onTap: () async {
                                  _model.result = await AlunoGroup
                                      .getPerfilPersonalCall
                                      .call(
                                    pAlunoUuid: currentUserUid,
                                    pPersonalUuid: FFAppState()
                                        .treinosTemp
                                        .personalUuid,
                                  );

                                  if ((_model.result?.succeeded ??
                                      true)) {
                                    context.pushNamed(
                                      PerfilpersonalWidget.routeName,
                                      queryParameters: {
                                        'perosnal': serializeParam(
                                          PerfilPersonalStruct
                                              .maybeFromMap((_model
                                                      .result
                                                      ?.jsonBody ??
                                                  '')),
                                          ParamType.DataStruct,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        '__transition_info__':
                                            TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                          duration: Duration(
                                              milliseconds: 0),
                                        ),
                                      },
                                    );
                                  } else {
                                    await showDialog(
                                      useRootNavigator: true,
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return WebViewAware(
                                          child: AlertDialog(
                                            content: Text((_model
                                                        .result
                                                        ?.jsonBody ??
                                                    '')
                                                .toString()),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        alertDialogContext),
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          10.0, 10.0, 14.0, 10.0),
                                  // Largura cheia: como cartao proprio abaixo
                                  // do baralho, encolher ate o conteudo o
                                  // deixaria desalinhado das cartas.
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                                100.0),
                                        child: FFAppState()
                                                    .treinosTemp
                                                    .hasPersonalFotoUrl() &&
                                                FFAppState()
                                                    .treinosTemp
                                                    .personalFotoUrl
                                                    .isNotEmpty
                                            ? Image(
                                                image: CachedNetworkImageProvider(
                                                    FFAppState()
                                                        .treinosTemp
                                                        .personalFotoUrl),
                                                width: 38.0,
                                                height: 38.0,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context,
                                                        error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                  'assets/images/Profile_Image.png',
                                                  width: 38.0,
                                                  height: 38.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Image.asset(
                                                'assets/images/Profile_Image.png',
                                                width: 38.0,
                                                height: 38.0,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      // Expanded empurra o chevron para a
                                      // borda direita do cartao, em vez de
                                      // deixa-lo colado no nome.
                                      Expanded(
                                        child: Padding(
                                        padding: EdgeInsetsDirectional
                                            .fromSTEB(
                                                10.0, 0.0, 8.0, 0.0),
                                        child: Column(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              'Seu personal',
                                              style: FlutterFlowTheme
                                                      .of(context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts
                                                        .inter(
                                                      fontWeight:
                                                          FontWeight
                                                              .w500,
                                                    ),
                                                    color: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryText,
                                                    fontSize: 10.5,
                                                    letterSpacing:
                                                        0.0,
                                                    fontWeight:
                                                        FontWeight
                                                            .w500,
                                                  ),
                                            ),
                                            Text(
                                              FFAppState()
                                                      .treinosTemp
                                                      .personalNome
                                                      .isNotEmpty
                                                  ? FFAppState()
                                                      .treinosTemp
                                                      .personalNome
                                                  : 'Ver perfil',
                                              style: FlutterFlowTheme
                                                      .of(context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts
                                                        .inter(
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                    ),
                                                    color: FlutterFlowTheme
                                                            .of(context)
                                                        .primaryText,
                                                    fontSize: 13.0,
                                                    letterSpacing:
                                                        0.0,
                                                    fontWeight:
                                                        FontWeight
                                                            .w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: FlutterFlowTheme.of(
                                                context)
                                            .secondaryText,
                                        size: 18.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

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
                                      width: MediaQuery.sizeOf(context).width *
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
                                          final emAndamento = treinos.indexWhere(
                                              (e) => e.status == 'em_andamento');
                                          final proximo = emAndamento >= 0
                                              ? -1
                                              : treinos.indexWhere((e) =>
                                                  e.status != 'concluido' &&
                                                  e.status != 'pulado');

                                          return _CarrosselLeque(
                                            quantidade: treinos.length,
                                            construir: (context, treinosIndex) {
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
                                                    FlutterFlowTheme.of(context)
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
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
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
      final r = await SupaFlow.client.rpc('metricas_sequencia',
          params: {'p_aluno_uuid': currentUserUid});
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
                  children: [
                    Flexible(
                      child: Text(
                        valor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          // A partir de 15 dias o numero vai para o laranja.
                          color: realce >= 2
                              ? tema.secondary
                              : tema.primaryText,
                          fontSize: 26.0,
                          letterSpacing: -0.8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (sufixo != null) ...[
                      const SizedBox(width: 2.0),
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
            sufixo: ChamaSequencia(dias: seq, tamanhoBase: 20.0),
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
              ? Icon(Icons.error_outline_rounded,
                  color: tema.error, size: 18.0)
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
    String? rotulo;
    Color corEstado = tema.secondaryText;
    if (treino.status == 'concluido') {
      rotulo = 'Concluído';
      corEstado = tema.success;
    } else if (treino.status == 'pulado') {
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
            if (rotulo != null)
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                      treino.status == 'concluido'
                          ? tema.success
                          : tema.primary,
                    ),
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

/// Cabeçalho da home do aluno: o que ele tem para hoje, em cartões.
///
/// Era um bloco só, com foto de academia ao fundo e três informações
/// empilhadas por cima dela — nome do treino, progresso do dia e validade.
/// Funcionava enquanto tudo ali era azul; ao entrar a sequência em laranja, a
/// cor brigou com a imagem e ficou claro que o problema não era a chama: era
/// um fundo fotográfico tentando ser suporte de texto.
///
/// Aqui a informação se divide como no painel de métricas — cada coisa no seu
/// cartão, sobre o fundo da página. Menos cartões que lá, porque são menos
/// perguntas: o que treinar hoje, quanto já saiu, e até quando vale.
class _CabecalhoDoDia extends StatelessWidget {
  const _CabecalhoDoDia();

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // O treino do dia e o quanto dele já foi: é a resposta que a pessoa
        // abre o app para ter, então ocupa a largura toda.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: tema.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [tema.designToken.shadow.lg],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 14.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seu treino',
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: tema.secondaryText,
                          fontSize: 11.5,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        FFAppState().treinosTemp.nome,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: tema.primaryText,
                          fontSize: 17.0,
                          letterSpacing: -0.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // O progresso do dia como anel, no canto direito: a pilha de
              // barrinhas a esquerda pedia decifracao — quantos degraus sao,
              // qual esta cheio — e o anel diz a mesma coisa com a forma que o
              // painel de metricas ja usa para "quanto do combinado saiu".
              _AnelDoDia(),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        // Sequência e validade lado a lado: as duas dizem "quanto tempo", uma
        // olhando para trás e outra para a frente.
        _ResumoDoDia(),
      ],
    );
  }
}

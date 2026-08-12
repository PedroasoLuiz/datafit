import '/components/campo_busca.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/df_estado_vazio.dart';
import '/components/aviso_plano_free.dart';
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
      await action_blocks.loadingNotifica(context);
      safeSetState(() {});
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
  Future<void> _abrirWhatsApp(PersonalalunosStruct aluno) async {
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
    await launchUrl(
      Uri.parse('https://wa.me/$numero'),
      mode: LaunchMode.externalApplication,
    );
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
        drawer: Drawer(
          elevation: 16.0,
          width: MediaQuery.of(context).size.width * 0.88,
          child: WebViewAware(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 60.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Notificações',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              FFIcons.kproperty1FiRrBell,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 16.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final notis = FFAppState()
                                .notificacoes
                                .map((e) => e)
                                .toList();
                            if (notis.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.0),
                                child: Center(
                                  child: Text(
                                    'Sem notificações',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              controller: _model.columnController2,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children:
                                    List.generate(notis.length, (notisIndex) {
                                  final notisItem = notis[notisIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 2.0, 16.0, 2.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!notisItem.lida &&
                                            notisItem.tag != 'pagamento') {
                                          final res = await PerfilGroup
                                              .marcarNotiComoLidaCall
                                              .call(
                                            notificacaoId: notisItem.id,
                                            user: currentUserUid,
                                          );
                                          if (res?.succeeded ?? false) {
                                            FFAppState()
                                                .updateNotificacoesAtIndex(
                                              notisIndex,
                                              (e) => e
                                                ..lida = getJsonField(
                                                    (res?.jsonBody ?? ''),
                                                    r'''$.lida'''),
                                            );
                                            safeSetState(() {});
                                          }
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 42.0,
                                                  height: 42.0,
                                                  decoration: BoxDecoration(
                                                    color: notisItem.tag ==
                                                            'pagamento'
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .accent1
                                                        : notisItem.tag ==
                                                                'convite'
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .accent1
                                                            : notisItem.tag ==
                                                                    'treino'
                                                                ? Color(
                                                                    0xFFE8F5E9)
                                                                : notisItem.tag ==
                                                                        'meta'
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .accent2
                                                                    : Color(
                                                                        0xFFF3E5F5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    notisItem.tag == 'pagamento'
                                                        ? Icons.payments_rounded
                                                        : notisItem.tag ==
                                                                'convite'
                                                            ? Icons
                                                                .person_add_rounded
                                                            : notisItem.tag ==
                                                                    'treino'
                                                                ? Icons
                                                                    .fitness_center_rounded
                                                                : notisItem.tag ==
                                                                        'meta'
                                                                    ? Icons
                                                                        .flag_rounded
                                                                    : FFIcons
                                                                        .kproperty1FiRrBell,
                                                    color: notisItem.tag ==
                                                            'pagamento'
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primary
                                                        : notisItem.tag ==
                                                                'convite'
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .primary
                                                            : notisItem.tag ==
                                                                    'treino'
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .success
                                                                : notisItem.tag ==
                                                                        'meta'
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary
                                                                    : Color(
                                                                        0xFF7C3AED),
                                                    size: 18.0,
                                                  ),
                                                ),
                                                SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              notisItem.titulo,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts.inter(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                    color: notisItem.lida
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .primaryText
                                                                        : FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                    fontSize:
                                                                        13.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 6.0),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              dateTimeFormat(
                                                                "relative",
                                                                functions.formataData(
                                                                    notisItem
                                                                        .criadoEm),
                                                                locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageShortCode ??
                                                                    FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                              ),
                                                              '',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .inter(),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                          if (!notisItem
                                                              .lida) ...[
                                                            SizedBox(
                                                                width: 6.0),
                                                            Container(
                                                              width: 8.0,
                                                              height: 8.0,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 3.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                      if (notisItem.descricao
                                                          .isNotEmpty) ...[
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                          notisItem.descricao,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .inter(),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ],
                                                      if (notisItem.tag ==
                                                              'pagamento' &&
                                                          !notisItem.lida &&
                                                          notisItem
                                                                  .referenciaId >
                                                              0) ...[
                                                        SizedBox(height: 10.0),
                                                        Builder(
                                                          builder: (context) {
                                                            bool _confirming =
                                                                false;
                                                            return StatefulBuilder(
                                                              builder: (context,
                                                                  setLocalState) {
                                                                return SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        _confirming
                                                                            ? null
                                                                            : () async {
                                                                                setLocalState(() => _confirming = true);
                                                                                final res = await PersonalGroup.confirmarPagamentoCall.call(
                                                                                  pPagamentoId: notisItem.referenciaId,
                                                                                  pPersonalUuid: currentUserUid,
                                                                                );
                                                                                if (!mounted) return;
                                                                                setLocalState(() => _confirming = false);
                                                                                if (res.succeeded) {
                                                                                  FFAppState().updateNotificacoesAtIndex(notisIndex, (e) => e..lida = true);
                                                                                  await action_blocks.pagamentos(context, uuidpersonal: currentUserUid);
                                                                                  safeSetState(() {});
                                                                                  await showModalBottomSheet(
                                                                                    useRootNavigator: true,
                                                                                    isScrollControlled: true,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    context: context,
                                                                                    builder: (context) => MensagemWidget(texto: 'Pagamento confirmado como recebido!', tipo: '1', action: () async {}, fechasozinho: true, mostrabotoes: false),
                                                                                  );
                                                                                } else {
                                                                                  await showModalBottomSheet(
                                                                                    useRootNavigator: true,
                                                                                    isScrollControlled: true,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    context: context,
                                                                                    builder: (context) => MensagemWidget(texto: 'Não foi possível confirmar. Tente novamente.', tipo: '2', action: () async {}, fechasozinho: true, mostrabotoes: false),
                                                                                  );
                                                                                }
                                                                              },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0)),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              8.0),
                                                                    ),
                                                                    child: _confirming
                                                                        ? SizedBox(
                                                                            width:
                                                                                16.0,
                                                                            height:
                                                                                16.0,
                                                                            child: CircularProgressIndicator(
                                                                                strokeWidth:
                                                                                    2.0,
                                                                                color: Colors
                                                                                    .white))
                                                                        : Text(
                                                                            'Confirmar recebimento',
                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                                                color: Colors.white,
                                                                                letterSpacing: 0.0)),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                      if (notisItem.tag ==
                                                              'convite' &&
                                                          !notisItem.lida) ...[
                                                        SizedBox(height: 10.0),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  OutlinedButton(
                                                                onPressed:
                                                                    () async {
                                                                  final convite = FFAppState()
                                                                      .convitesPendentes
                                                                      .where((c) =>
                                                                          c.personalNome ==
                                                                          notisItem
                                                                              .remetente)
                                                                      .firstOrNull;
                                                                  if (convite !=
                                                                      null) {
                                                                    await action_blocks.responderConvite(
                                                                        context,
                                                                        personalUuid:
                                                                            convite
                                                                                .personalUuid,
                                                                        aceitar:
                                                                            false);
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                },
                                                                style: OutlinedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                  side: BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0)),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8.0),
                                                                ),
                                                                child: Text(
                                                                    'Recusar',
                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                        font: GoogleFonts.inter(
                                                                            fontWeight: FontWeight
                                                                                .w600),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        letterSpacing:
                                                                            0.0)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 8.0),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  final convite = FFAppState()
                                                                      .convitesPendentes
                                                                      .where((c) =>
                                                                          c.personalNome ==
                                                                          notisItem
                                                                              .remetente)
                                                                      .firstOrNull;
                                                                  if (convite !=
                                                                      null) {
                                                                    await action_blocks.responderConvite(
                                                                        context,
                                                                        personalUuid:
                                                                            convite
                                                                                .personalUuid,
                                                                        aceitar:
                                                                            true);
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0)),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8.0),
                                                                ),
                                                                child: Text(
                                                                    'Aceitar',
                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                        font: GoogleFonts.inter(
                                                                            fontWeight: FontWeight
                                                                                .w600),
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            0.0)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                              height: 1.0,
                                              thickness: 1.0,
                                              indent: 52.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                                      badges.Badge(
                                        badgeContent: Text(
                                          FFAppState()
                                              .notificacoes
                                              .where((e) => !e.lida)
                                              .length
                                              .toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        showBadge: FFAppState()
                                            .notificacoes
                                            .any((e) => !e.lida),
                                        shape: badges.BadgeShape.circle,
                                        badgeColor: FlutterFlowTheme.of(context)
                                            .primary,
                                        elevation: 4.0,
                                        padding: EdgeInsets.all(6.0),
                                        position: badges.BadgePosition.topEnd(),
                                        animationType:
                                            badges.BadgeAnimationType.scale,
                                        toAnimate: true,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            scaffoldKey.currentState!
                                                .openDrawer();
                                          },
                                          child: Container(
                                            width: 36.0,
                                            height: 36.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                FFIcons.kproperty1FiRrBell,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                  'Seus alunos',
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
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.add_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 12.0),
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
                          // Some sozinho se o plano não for free (e no iOS).
                          const AvisoPlanoFree(),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 4.0),
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  valueOrDefault<double>(
                                                    () {
                                                      if (MediaQuery.sizeOf(
                                                                  context)
                                                              .width <
                                                          kBreakpointSmall) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width <
                                                          kBreakpointMedium) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
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
                                                      if (MediaQuery.sizeOf(
                                                                  context)
                                                              .width <
                                                          kBreakpointSmall) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width <
                                                          kBreakpointMedium) {
                                                        return 16.0;
                                                      } else if (MediaQuery
                                                                  .sizeOf(
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
                                              _SwipeableWhatsApp(
                                                onWhatsApp: () =>
                                                    _abrirWhatsApp(alunosItem),
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
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0),
                                                            child:
                                                                Image.network(
                                                              valueOrDefault<
                                                                  String>(
                                                                alunosItem
                                                                    .fotoUrl,
                                                                'https://miro.medium.com/v2/resize:fit:1400/1*g09N-jl7JtVjVZGcd-vL2g.jpeg',
                                                              ),
                                                              width: 46.0,
                                                              height: 46.0,
                                                              fit: BoxFit.cover,
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
                                                indent: 62.0,
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

/// Card que desliza para a esquerda revelando o atalho do WhatsApp.
///
/// Mesmo desenho de `_SwipeableGrupoRow` na tela de treinos: o deslocamento e
/// controlado na mao com GestureDetector, sem pacote de slidable, para o gesto
/// ficar igual ao que o app ja faz nas outras listas.
class _SwipeableWhatsApp extends StatefulWidget {
  const _SwipeableWhatsApp({
    required this.child,
    required this.onWhatsApp,
  });

  final Widget child;
  final VoidCallback onWhatsApp;

  @override
  State<_SwipeableWhatsApp> createState() => _SwipeableWhatsAppState();
}

class _SwipeableWhatsAppState extends State<_SwipeableWhatsApp> {
  static const double _larguraAcao = 88.0;

  /// Verde oficial do WhatsApp — nao sai do tema porque a cor e da marca.
  static const Color _verdeWhatsApp = Color(0xFF25D366);

  double _deslocamento = 0.0;

  void _arrastando(DragUpdateDetails d) {
    setState(() {
      _deslocamento =
          (_deslocamento + d.delta.dx).clamp(-_larguraAcao, 0.0).toDouble();
    });
  }

  void _soltou(DragEndDetails d) {
    setState(() {
      _deslocamento = _deslocamento < -_larguraAcao / 2 ? -_larguraAcao : 0.0;
    });
  }

  void _fechar() => setState(() => _deslocamento = 0.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _arrastando,
      onHorizontalDragEnd: _soltou,
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: _larguraAcao,
                child: GestureDetector(
                  onTap: () {
                    _fechar();
                    widget.onWhatsApp();
                  },
                  child: Container(
                    color: _verdeWhatsApp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 22.0,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'WhatsApp',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                    ),
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
              ),
            ),
            Transform.translate(
              offset: Offset(_deslocamento, 0.0),
              child: Container(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

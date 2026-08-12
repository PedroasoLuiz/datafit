import '/components/chip_filtro.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/components/df_estado_vazio.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/navbar/navbar_widget.dart';
import '/pages/pagamentos/notificacaoalunos/notificacaoalunos_widget.dart';
import '/pages/pagamentos/pagamentos_novo/pagamentos_novo_widget.dart';
import '/pages/pagamentos/pagamentos_edit/pagamentos_edit_widget.dart';
import '/components/mensagem_widget.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'pagamentos_model.dart';
export 'pagamentos_model.dart';

class PagamentosWidget extends StatefulWidget {
  const PagamentosWidget({super.key});

  static String routeName = 'pagamentos';
  static String routePath = '/pagamentos';

  @override
  State<PagamentosWidget> createState() => _PagamentosWidgetState();
}

class _PagamentosWidgetState extends State<PagamentosWidget> {
  late PagamentosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagamentosModel());

    _carregarKpis();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Numeros do topo da tela.
  ///
  /// Vem prontos do banco porque `PagamentosAlunos` nao tem coluna de status:
  /// pago, atrasado e em aberto sao sempre derivados de DataPagamento x
  /// DataVencimento, e refazer essa conta no cliente sairia diferente conforme
  /// o fuso do aparelho.
  Map<String, dynamic>? _kpis;

  /// Recarrega a lista depois de qualquer acao que a altere.
  Future<void> _recarregar() async {
    await action_blocks.pagamentos(context, uuidpersonal: currentUserUid);
    if (!mounted) return;
    await _carregarKpis();
    if (!mounted) return;
    safeSetState(() {});
  }

  Future<void> _editarPagamento(PersonalpagamentosStruct pgto) async {
    final editou = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (ctx) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(ctx),
          child: PagamentosEditWidget(pgto: pgto),
        ),
      ),
    );
    if (editou == true && mounted) await _recarregar();
  }

  /// Inativa (ou reativa) o vinculo com o aluno.
  ///
  /// E a mesma acao da lista de alunos: aqui ela existe porque cobranca em
  /// aberto e justamente quando se pensa em cortar o acesso.
  Future<void> _bloquearAcesso(PersonalpagamentosStruct pgto) async {
    if (pgto.alunoUuid.isEmpty) return;
    final novoEstado = await action_blocks.toggleAlunoAtivo(
      context,
      personalUuid: currentUserUid,
      alunoUuid: pgto.alunoUuid,
    );
    if (novoEstado == null || !mounted) return;
    await _recarregar();
  }

  /// Apaga a cobranca, com confirmacao.
  ///
  /// `PagamentosAlunos` nao tem exclusao logica, entao isto remove a linha de
  /// vez — dai a pergunta antes, e nao um desfazer depois.
  Future<void> _excluirPagamento(PersonalpagamentosStruct pgto) async {
    final confirmou = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => MensagemWidget(
        texto: 'Excluir a cobranca de ' + pgto.nome + '? Nao da para desfazer.',
        tipo: '2',
        mostrabotoes: true,
        action: () async => Navigator.pop(ctx, true),
      ),
    );
    if (confirmou != true || !mounted) return;

    try {
      await SupaFlow.client.from('PagamentosAlunos').delete().eq('Id', pgto.id);
      if (!mounted) return;
      await _recarregar();
    } catch (_) {
      if (!mounted) return;
      await showModalBottomSheet<void>(
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) => MensagemWidget(
          texto: 'Nao consegui excluir esta cobranca.',
          tipo: '2',
          fechasozinho: true,
          mostrabotoes: false,
          action: () async {},
        ),
      );
    }
  }

  Future<void> _carregarKpis() async {
    try {
      final r = await SupaFlow.client.rpc(
        'get_kpis_pagamentos_personal',
        params: {'p_personal_uuid': currentUserUid},
      );
      if (!mounted || r is! Map) return;
      safeSetState(() => _kpis = Map<String, dynamic>.from(r));
    } catch (_) {
      // O topo e acessorio: sem ele a lista continua funcionando.
    }
  }

  /// 1 quando entrou dinheiro, 0 quando o mes fechou zerado.
  ///
  /// Receita nunca fica negativa, mas o -1 existe para as linhas de pendencia,
  /// onde valor em aberto e sempre leitura ruim.
  int _sinal(dynamic v) => (v is num && v > 0) ? 1 : 0;

  /// Moeda no formato brasileiro: R$ 1.000,00.
  ///
  /// `formatNumber` do FlutterFlow usa a convencao do ingles — ponto no
  /// decimal e virgula no milhar — e sai "R$ 1,000.00". O `NumberFormat` com
  /// locale pt_BR e quem sabe a ordem certa.
  String _moeda(num? v) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: r'R$ ')
          .format((v ?? 0).toDouble());

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
                                      Container(
                                        width: 36.0,
                                        height: 36.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Icon(
                                            Icons.navigate_before_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            size: 20.0,
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
                                                  'Histórico de pagamento',
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
                                                            PagamentosNovoWidget(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) => safeSetState(
                                                  () => _model.cadastrou =
                                                      value));

                                              if (_model.cadastrou!) {
                                                await action_blocks.pagamentos(
                                                  context,
                                                  uuidpersonal: currentUserUid,
                                                );
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: 36.0,
                                              height: 36.0,
                                              // Branco com sombra, como os
                                              // demais botoes de icone do kit.
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                boxShadow: [
                                                  FlutterFlowTheme.of(context)
                                                      .designToken
                                                      .shadow
                                                      .sm
                                                ],
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.add_rounded,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (_kpis != null)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: _CardKpi(
                                      titulo: 'Receita',
                                      rotuloDestaque: 'Este mês',
                                      valorDestaque:
                                          _moeda(_kpis!['recebidoMes']),
                                      linhas: [
                                        _LinhaKpi(
                                          rotulo: _kpis!['anterior1Nome']
                                                  ?.toString() ??
                                              '',
                                          valor:
                                              _moeda(_kpis!['anterior1Valor']),
                                          sinal:
                                              _sinal(_kpis!['anterior1Valor']),
                                        ),
                                        _LinhaKpi(
                                          rotulo: _kpis!['anterior2Nome']
                                                  ?.toString() ??
                                              '',
                                          valor:
                                              _moeda(_kpis!['anterior2Valor']),
                                          sinal:
                                              _sinal(_kpis!['anterior2Valor']),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Expanded(
                                    child: _CardKpi(
                                      titulo: 'Pendências',
                                      rotuloDestaque: 'Total',
                                      valorDestaque:
                                          _moeda(_kpis!['pendenteTotal']),
                                      corDestaque:
                                          (_kpis!['pendenteTotal'] as num) > 0
                                              ? FlutterFlowTheme.of(context)
                                                  .error
                                              : null,
                                      linhas: [
                                        _LinhaKpi(
                                          rotulo: 'Atrasadas',
                                          valor:
                                              _moeda(_kpis!['atrasadoValor']),
                                          sinal:
                                              (_kpis!['atrasadoValor'] as num) >
                                                      0
                                                  ? -1
                                                  : 0,
                                        ),
                                        _LinhaKpi(
                                          rotulo: 'A vencer',
                                          valor: _moeda(_kpis!['abertoValor']),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: LinhaChipsFiltro(
                            chips: [
                              ChipFiltro(
                                texto: 'Todos',
                                selecionado: _model.menu == 2,
                                onTap: () {
                                  _model.menu = 2;
                                  safeSetState(() {});
                                },
                              ),
                              ChipFiltro(
                                texto: 'Atrasado',
                                selecionado: _model.menu == 0,
                                onTap: () {
                                  _model.menu = 0;
                                  safeSetState(() {});
                                },
                              ),
                              ChipFiltro(
                                texto: 'Pago',
                                selecionado: _model.menu == 1,
                                onTap: () {
                                  _model.menu = 1;
                                  safeSetState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final pgtos = FFAppState()
                                  .pagamentos
                                  .where((e) => () {
                                        if (_model.menu == 0) {
                                          return (e.status == 'atrasado');
                                        } else if (_model.menu == 1) {
                                          return (e.status == 'pago');
                                        } else {
                                          return true;
                                        }
                                      }())
                                  .toList()
                                  .map((e) => e)
                                  .toList()
                                  .sortedList(
                                      keyOf: (e) => functions
                                          .formataData(e.dataVencimento),
                                      desc: true)
                                  .toList()
                                  .take(100)
                                  .toList();

                              if (pgtos.isEmpty) {
                                return Center(
                                  child: SingleChildScrollView(
                                    child: DfEstadoVazio(
                                      icone: FFIcons.kproperty1FiRrReceipt,
                                      titulo: _model.menu == 0
                                          ? 'Nenhum pagamento atrasado'
                                          : _model.menu == 1
                                              ? 'Nenhum pagamento recebido'
                                              : 'Nenhum pagamento por aqui',
                                      descricao: _model.menu == 0
                                          ? 'Seus alunos estão todos em dia.'
                                          : _model.menu == 1
                                              ? 'Os pagamentos confirmados aparecem aqui.'
                                              : 'Cadastre uma cobrança para começar a acompanhar.',
                                    ),
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                controller: _model.columnController,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children:
                                      List.generate(pgtos.length, (pgtosIndex) {
                                    final pgtosItem = pgtos[pgtosIndex];
                                    return _CardPagamentoDeslizavel(
                                      aoEditar: () => _editarPagamento(
                                          pgtosItem),
                                      aoBloquear: () => _bloquearAcesso(
                                          pgtosItem),
                                      aoExcluir: () => _excluirPagamento(
                                          pgtosItem),
                                      child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          useRootNavigator: true,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return WebViewAware(
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child:
                                                      NotificacaoalunosWidget(
                                                    pgtos: pgtosItem,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(
                                            () => _model.sim = value));

                                        if (_model.sim!) {
                                          await action_blocks.pagamentos(
                                            context,
                                            uuidpersonal: currentUserUid,
                                          );
                                          safeSetState(() {});
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
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
                                                    // Mesmo respiro em cima e
                                                    // embaixo: com 0 no topo o
                                                    // conteudo colava na borda
                                                    // do cartao.
                                                    8.0,
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
                                                    8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 46.0,
                                                  height: 46.0,
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      if (pgtosItem.status ==
                                                          'atrasado') {
                                                        return FlutterFlowTheme
                                                                .of(context)
                                                            .accent3;
                                                      } else if (pgtosItem
                                                              .status ==
                                                          'pago') {
                                                        return Color(
                                                            0x38009663);
                                                      } else {
                                                        return FlutterFlowTheme
                                                                .of(context)
                                                            .alternate;
                                                      }
                                                    }(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (pgtosItem.status ==
                                                            'atrasado')
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Icon(
                                                              FFIcons
                                                                  .kproperty1FiRrShieldExclamation,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .warning,
                                                              size: 18.0,
                                                            ),
                                                          ),
                                                        if (pgtosItem.status ==
                                                            'pago')
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .check_rounded,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .success,
                                                              size: 18.0,
                                                            ),
                                                          ),
                                                        if (pgtosItem.status ==
                                                            'pendente')
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Icon(
                                                              FFIcons
                                                                  .kproperty1FiRrClock,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 18.0,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      pgtosItem.nome,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                    Text(
                                                      pgtosItem.tipoPagamento,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 4.0)),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            1.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'R\$ ',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  _moeda(pgtosItem
                                                                      .valor),
                                                                  '0',
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            dateTimeFormat(
                                                              "dd/MM/yyyy",
                                                              functions.formataData(
                                                                  valueOrDefault<
                                                                      String>(
                                                                pgtosItem
                                                                    .dataVencimento,
                                                                'x',
                                                              )),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ),
                                                            'x',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 4.0)),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                          ),
                                          Divider(
                                            height: 1.0,
                                            thickness: 1.0,
                                            indent: 78.0,
                                            endIndent: 16.0,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                        ],
                                      ),
                                      ),
                                    );
                                  })
                                          .divide(SizedBox(height: 16.0))
                                          .addToStart(SizedBox(height: 32.0))
                                          .addToEnd(SizedBox(height: 120.0)),
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Uma linha de detalhe do card de KPI: rotulo a esquerda, valor na direita.
///
/// [sinal] pinta o valor: 1 verde, -1 vermelho, 0 cinza. Zero fica neutro de
/// proposito — mes sem receita nao e erro, e so mes sem receita.
class _LinhaKpi {
  const _LinhaKpi({
    required this.rotulo,
    required this.valor,
    this.sinal = 0,
  });

  final String rotulo;
  final String valor;
  final int sinal;
}

/// Card de numero do topo de Pagamentos.
///
/// Um valor grande em cima responde a pergunta principal; as linhas embaixo
/// mostram de que ele se compoe ou com o que se compara. Alinhados a direita,
/// os valores podem ser lidos em coluna.
class _CardKpi extends StatelessWidget {
  const _CardKpi({
    required this.titulo,
    required this.rotuloDestaque,
    required this.valorDestaque,
    required this.linhas,
    this.corDestaque,
  });

  final String titulo;
  final String rotuloDestaque;
  final String valorDestaque;
  final List<_LinhaKpi> linhas;
  final Color? corDestaque;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    Color corDoSinal(int s) =>
        s > 0 ? tema.success : (s < 0 ? tema.error : tema.secondaryText);

    return Container(
      padding: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: tema.secondaryText,
              fontSize: 11.5,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            rotuloDestaque,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 11.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            valorDestaque,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: corDestaque ?? tema.primaryText,
              fontSize: 20.0,
              letterSpacing: -0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Separa o numero de destaque das linhas que o detalham: sem o
          // traco os dois blocos se liam como uma lista so.
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 8.0),
            child: Divider(
              height: 1.0,
              thickness: 1.0,
              color: tema.alternate,
            ),
          ),
          for (final l in linhas)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.rotulo,
                      overflow: TextOverflow.ellipsis,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                        color: tema.secondaryText,
                        fontSize: 11.5,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    l.valor,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: corDoSinal(l.sinal),
                      fontSize: 12.0,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


/// Card de cobranca com acoes de deslizar dos dois lados.
///
/// Direita revela o que mexe no aluno (bloquear) e o que e destrutivo
/// (excluir); esquerda revela editar. Separar por lado mantem o destrutivo
/// longe do corriqueiro, como na lista de alunos.
class _CardPagamentoDeslizavel extends StatefulWidget {
  const _CardPagamentoDeslizavel({
    required this.child,
    required this.aoEditar,
    required this.aoBloquear,
    required this.aoExcluir,
  });

  final Widget child;
  final VoidCallback aoEditar;
  final VoidCallback aoBloquear;
  final VoidCallback aoExcluir;

  @override
  State<_CardPagamentoDeslizavel> createState() =>
      _CardPagamentoDeslizavelState();
}

class _CardPagamentoDeslizavelState extends State<_CardPagamentoDeslizavel> {
  static const double _larguraAcao = 88.0;

  double _deslocamento = 0.0;

  double get _limiteEsquerda => _larguraAcao * 2;

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
    required IconData icone,
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
              Icon(icone, color: Colors.white, size: 22.0),
              const SizedBox(height: 4.0),
              Text(
                rotulo,
                textAlign: TextAlign.center,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  _acao(
                    fundo: tema.secondaryText,
                    icone: Icons.lock_outline_rounded,
                    rotulo: 'Bloquear',
                    aoTocar: widget.aoBloquear,
                  ),
                  _acao(
                    fundo: tema.error,
                    icone: Icons.delete_outline_rounded,
                    rotulo: 'Excluir',
                    aoTocar: widget.aoExcluir,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _acao(
                fundo: tema.primary,
                icone: Icons.edit_outlined,
                rotulo: 'Editar',
                aoTocar: widget.aoEditar,
              ),
            ),
            Transform.translate(
              offset: Offset(_deslocamento, 0.0),
              child: Container(
                // Superficie propria, e nao a cor da pagina: sem ela a linha
                // nao lia como cartao, e o arredondamento do ClipRRect nao
                // aparecia contra um fundo da mesma cor.
                decoration: BoxDecoration(
                  color: tema.primaryBackground,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [tema.designToken.shadow.sm],
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import '/components/chip_filtro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/backend/schema/structs/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/components/perfil_kit.dart';
import '/components/foto_tela_cheia.dart';
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
                                // ali nao era diferente por necessidade — era
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
                                  // valor — "0 kg" e pior que nada.
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
                                      if (a.email.isNotEmpty) ...[
                                        AcaoIconePerfil(
                                          icone: FFIcons.kproperty1FiRrEnvelope,
                                          aoTocar: () => launchUrl(Uri(
                                              scheme: 'mailto', path: a.email)),
                                        ),
                                        const SizedBox(width: 8.0),
                                      ],
                                      // O estado do vinculo: era um botao com
                                      // icone de flor, que nao sugeria nada.
                                      AcaoIconePerfil(
                                        icone: FFIcons.kproperty1FiRrSettings,
                                        aoTocar: () async {
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
                                      ),
                                    ],
                                  );
                                }),
                                // Abas no padrao de chips do app. Eram dois pares
                                // de FFButtonWidget com width fixo de 114 — que
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
                                      // entre os dois — e dentro daquela aba
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            boxShadow: [
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .shadow
                                                  .lg
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    8.0),
                                                        child: Text(
                                                          'Treino deste aluno',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              final trocou =
                                                                  await showModalBottomSheet<
                                                                      bool>(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                enableDrag:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      SelecionarTreinoAlunoWidget(
                                                                    alunoUuid: FFAppState()
                                                                        .alunotemp
                                                                        .alunoUuid,
                                                                    grupoTreinoIdAtual: FFAppState()
                                                                        .alunotemp
                                                                        .grupoTreino
                                                                        .grupoTreinoId,
                                                                    dataValidadeAtual: FFAppState()
                                                                        .alunotemp
                                                                        .grupoTreino
                                                                        .dataValidade,
                                                                  ),
                                                                ),
                                                              );
                                                              if (trocou ==
                                                                      true &&
                                                                  mounted) {
                                                                await action_blocks
                                                                    .getPerfilAluno(
                                                                        context,
                                                                        alunoId:
                                                                            widget.alunoId);
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    FFAppState()
                                                                        .alunotemp
                                                                        .grupoTreino
                                                                        .nome,
                                                                    'Adicionar',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            18.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .unfold_more,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  size: 16.0,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              final picked =
                                                                  await custom_widgets
                                                                      .showCustomDatePicker(
                                                                context,
                                                                initialDate:
                                                                    () {
                                                                  final d = functions.formataData(FFAppState()
                                                                      .alunotemp
                                                                      .grupoTreino
                                                                      .dataValidade);
                                                                  final now =
                                                                      DateTime
                                                                          .now();
                                                                  return d.isBefore(
                                                                          now)
                                                                      ? now
                                                                      : d;
                                                                }(),
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate:
                                                                    DateTime(
                                                                        2099),
                                                              );
                                                              if (picked ==
                                                                  null) return;
                                                              final dateStr =
                                                                  '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                                              await SupaFlow
                                                                  .client
                                                                  .from(
                                                                      'TreinosExecucao')
                                                                  .update({
                                                                    'DataValidade':
                                                                        dateStr,
                                                                  })
                                                                  .eq(
                                                                      'ExecutorPerfisId',
                                                                      FFAppState()
                                                                          .alunotemp
                                                                          .alunoUuid)
                                                                  .eq('Status',
                                                                      'pendente')
                                                                  .or('IsDeleted.is.null,IsDeleted.eq.false');
                                                              if (!mounted)
                                                                return;
                                                              FFAppState()
                                                                      .alunotemp
                                                                      .grupoTreino
                                                                      .dataValidade =
                                                                  dateStr;
                                                              safeSetState(
                                                                  () {});
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Icon(
                                                                  FFIcons
                                                                      .kproperty1FiRrCalendar,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  size: 12.0,
                                                                ),
                                                                Text(
                                                                  'Válido até ${valueOrDefault<String>(
                                                                    dateTimeFormat(
                                                                      "dd/MM/yy",
                                                                      functions.formataData(FFAppState()
                                                                          .alunotemp
                                                                          .grupoTreino
                                                                          .dataValidade),
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    '-',
                                                                  )}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  width: 4.0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 4.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final subagrupamentos = FFAppState()
                                                .alunotemp
                                                .grupoTreino
                                                .subagrupamentos
                                                .toList();

                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  subagrupamentos.length,
                                                  (subagrupamentosIndex) {
                                                final subagrupamentosItem =
                                                    subagrupamentos[
                                                        subagrupamentosIndex];
                                                return Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 16.0, 0.0, 0.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      boxShadow: [
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .designToken
                                                            .shadow
                                                            .lg
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                16.0),
                                                        topRight:
                                                            Radius.circular(
                                                                16.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                16.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                16.0),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        16.0,
                                                                        0.0,
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          40.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    subagrupamentosItem
                                                                        .nome,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      16.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      16.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          16.0),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  final exercicio =
                                                                      subagrupamentosItem
                                                                          .grupos
                                                                          .map((e) =>
                                                                              e)
                                                                          .toList();

                                                                  return ListView
                                                                      .separated(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    primary:
                                                                        false,
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount:
                                                                        exercicio
                                                                            .length,
                                                                    separatorBuilder: (_,
                                                                            __) =>
                                                                        SizedBox(
                                                                            height:
                                                                                4.0),
                                                                    itemBuilder:
                                                                        (context,
                                                                            exercicioIndex) {
                                                                      final exercicioItem =
                                                                          exercicio[
                                                                              exercicioIndex];
                                                                      return Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          InkWell(
                                                                            splashColor:
                                                                                Colors.transparent,
                                                                            focusColor:
                                                                                Colors.transparent,
                                                                            hoverColor:
                                                                                Colors.transparent,
                                                                            highlightColor:
                                                                                Colors.transparent,
                                                                            onTap:
                                                                                () async {
                                                                              final _key = '$subagrupamentosIndex-$exercicioIndex';
                                                                              if (_key == _model.indexexercicios) {
                                                                                _model.indexexercicios = null;
                                                                                safeSetState(() {});
                                                                              } else {
                                                                                _model.indexexercicios = _key;
                                                                                safeSetState(() {});
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.sizeOf(context).width * 1.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                borderRadius: BorderRadius.circular(16.0),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                                                                          child: Container(
                                                                                            width: 32.0,
                                                                                            height: 32.0,
                                                                                            decoration: BoxDecoration(
                                                                                              color: FlutterFlowTheme.of(context).accent1,
                                                                                              shape: BoxShape.circle,
                                                                                            ),
                                                                                            child: Align(
                                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  exercicioItem.exercicios.length.toString(),
                                                                                                  '0',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                                      fontSize: 12.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            exercicioItem.subcategoria,
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  font: GoogleFonts.inter(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                        if ('$subagrupamentosIndex-$exercicioIndex' == _model.indexexercicios)
                                                                                          Icon(
                                                                                            Icons.keyboard_arrow_down_rounded,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            size: 24.0,
                                                                                          ),
                                                                                        if ('$subagrupamentosIndex-$exercicioIndex' != _model.indexexercicios)
                                                                                          Icon(
                                                                                            Icons.keyboard_arrow_right_rounded,
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            size: 24.0,
                                                                                          ),
                                                                                      ].addToStart(SizedBox(width: 16.0)).addToEnd(SizedBox(width: 10.0)),
                                                                                    ),
                                                                                    if ('$subagrupamentosIndex-$exercicioIndex' == _model.indexexercicios)
                                                                                      SingleChildScrollView(
                                                                                        primary: false,
                                                                                        controller: _model.columnController2,
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Builder(
                                                                                              builder: (context) {
                                                                                                final subexercicios = exercicioItem.exercicios.map((e) => e).toList().sortedList(keyOf: (e) => e.ordem, desc: false).toList();

                                                                                                return ListView.separated(
                                                                                                  padding: EdgeInsets.zero,
                                                                                                  primary: false,
                                                                                                  shrinkWrap: true,
                                                                                                  scrollDirection: Axis.vertical,
                                                                                                  itemCount: subexercicios.length,
                                                                                                  separatorBuilder: (_, __) => SizedBox(height: 4.0),
                                                                                                  itemBuilder: (context, subexerciciosIndex) {
                                                                                                    final subexerciciosItem = subexercicios[subexerciciosIndex];
                                                                                                    return Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          decoration: BoxDecoration(),
                                                                                                          child: Padding(
                                                                                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                                            child: Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                borderRadius: BorderRadius.circular(14.0),
                                                                                                              ),
                                                                                                              child: Padding(
                                                                                                                padding: EdgeInsets.all(16.0),
                                                                                                                child: Row(
                                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    Column(
                                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                      children: [
                                                                                                                        Row(
                                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                                          children: [
                                                                                                                            RichText(
                                                                                                                              textScaler: MediaQuery.of(context).textScaler,
                                                                                                                              text: TextSpan(
                                                                                                                                children: [
                                                                                                                                  TextSpan(
                                                                                                                                    text: valueOrDefault<String>(
                                                                                                                                      subexerciciosItem.nome,
                                                                                                                                      '-',
                                                                                                                                    ),
                                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                          font: GoogleFonts.inter(
                                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                          ),
                                                                                                                                          fontSize: 13.0,
                                                                                                                                          letterSpacing: 0.0,
                                                                                                                                          fontWeight: FontWeight.bold,
                                                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                        ),
                                                                                                                                  )
                                                                                                                                ],
                                                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                      font: GoogleFonts.inter(
                                                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                      ),
                                                                                                                                      letterSpacing: 0.0,
                                                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                    ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                        Row(
                                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                                          children: [
                                                                                                                            Container(
                                                                                                                              decoration: BoxDecoration(
                                                                                                                                color: FlutterFlowTheme.of(context).accent2,
                                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                                              ),
                                                                                                                              child: Padding(
                                                                                                                                padding: EdgeInsetsDirectional.fromSTEB(6.0, 2.0, 6.0, 2.0),
                                                                                                                                child: Row(
                                                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                                                  children: [
                                                                                                                                    Text(
                                                                                                                                      '${subexerciciosItem.series.toString()} x ${subexerciciosItem.repeticoes.toString()}',
                                                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                            font: GoogleFonts.inter(
                                                                                                                                              fontWeight: FontWeight.normal,
                                                                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                            ),
                                                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                                            fontSize: 12.0,
                                                                                                                                            letterSpacing: 0.0,
                                                                                                                                            fontWeight: FontWeight.normal,
                                                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                          ),
                                                                                                                                    ),
                                                                                                                                  ],
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            Container(
                                                                                                                              decoration: BoxDecoration(
                                                                                                                                color: FlutterFlowTheme.of(context).accent2,
                                                                                                                                borderRadius: BorderRadius.circular(60.0),
                                                                                                                              ),
                                                                                                                              child: Padding(
                                                                                                                                padding: EdgeInsetsDirectional.fromSTEB(4.0, 2.0, 6.0, 2.0),
                                                                                                                                child: Row(
                                                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                                                  children: [
                                                                                                                                    Padding(
                                                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                                                                                                      child: Icon(
                                                                                                                                        FFIcons.kproperty1FiRrTimeQuarterPast,
                                                                                                                                        color: FlutterFlowTheme.of(context).secondary,
                                                                                                                                        size: 12.0,
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    Text(
                                                                                                                                      '${subexerciciosItem.tempoDescansoSeg.toString()}s descanso',
                                                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                            font: GoogleFonts.inter(
                                                                                                                                              fontWeight: FontWeight.normal,
                                                                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                            ),
                                                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                                            fontSize: 12.0,
                                                                                                                                            letterSpacing: 0.0,
                                                                                                                                            fontWeight: FontWeight.normal,
                                                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                                          ),
                                                                                                                                    ),
                                                                                                                                  ],
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ].divide(SizedBox(width: 6.0)),
                                                                                                                        ),
                                                                                                                      ].divide(SizedBox(height: 8.0)),
                                                                                                                    ),
                                                                                                                    Expanded(
                                                                                                                      child: Align(
                                                                                                                        alignment: AlignmentDirectional(1.0, 0.0),
                                                                                                                        child: Container(
                                                                                                                          width: 26.7,
                                                                                                                          height: 26.7,
                                                                                                                          decoration: BoxDecoration(
                                                                                                                            borderRadius: BorderRadius.circular(100.0),
                                                                                                                            shape: BoxShape.rectangle,
                                                                                                                          ),
                                                                                                                          child: Align(
                                                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
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
                                                                                                                                          FocusScope.of(context).unfocus();
                                                                                                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                                                                                                        },
                                                                                                                                        child: Padding(
                                                                                                                                          padding: MediaQuery.viewInsetsOf(context),
                                                                                                                                          child: AlunosEditExercicioWidget(
                                                                                                                                            exercicio: subexerciciosItem,
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    );
                                                                                                                                  },
                                                                                                                                ).then((value) => safeSetState(() => _model.editou = value));

                                                                                                                                if (_model.editou == true) {
                                                                                                                                  await action_blocks.getPerfilAluno(
                                                                                                                                    context,
                                                                                                                                    alunoId: widget!.alunoId,
                                                                                                                                  );
                                                                                                                                  safeSetState(() {});
                                                                                                                                }

                                                                                                                                safeSetState(() {});
                                                                                                                              },
                                                                                                                              child: Icon(
                                                                                                                                FFIcons.kproperty1FiRrEdit,
                                                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                                                size: 16.0,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ].divide(SizedBox(width: 12.0)),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                                                                              child: Container(
                                                                                                width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                                height: 38.0,
                                                                                                child: custom_widgets.DashedButton(
                                                                                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                                  height: 38.0,
                                                                                                  label: 'Adicionar exercícios',
                                                                                                  labelSize: 14.0,
                                                                                                  labelColor: FlutterFlowTheme.of(context).primary,
                                                                                                  icon: Icon(
                                                                                                    Icons.add,
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    size: 18.0,
                                                                                                  ),
                                                                                                  iconColor: FlutterFlowTheme.of(context).primary,
                                                                                                  iconGap: 4.0,
                                                                                                  borderColor: FlutterFlowTheme.of(context).primary,
                                                                                                  borderRadius: 10.0,
                                                                                                  borderWidth: 1.0,
                                                                                                  dashWidth: 4.0,
                                                                                                  dashGap: 4.0,
                                                                                                  onPressed: () async {
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
                                                                                                              FocusScope.of(context).unfocus();
                                                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                                                            },
                                                                                                            child: Padding(
                                                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                                                              child: AlunosNovoExercicioWidget(
                                                                                                                grupo: exercicioItem.subcategoriaId,
                                                                                                                treinoExecucaoId: subagrupamentosItem.treinoExecucaoId,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        );
                                                                                                      },
                                                                                                    ).then((value) => safeSetState(() => _model.editou1 = value));

                                                                                                    if (_model.editou1 == true) {
                                                                                                      await action_blocks.getPerfilAluno(
                                                                                                        context,
                                                                                                        alunoId: widget!.alunoId,
                                                                                                      );
                                                                                                      safeSetState(() {});
                                                                                                    }

                                                                                                    safeSetState(() {});
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].addToStart(SizedBox(height: 16.0)),
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            height:
                                                                                1.0,
                                                                            thickness:
                                                                                1.0,
                                                                            indent:
                                                                                68.0,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).alternate,
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                if (_model.menu == 2)
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
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
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            boxShadow: [
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .shadow
                                                  .lg
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if (_model.menu == 2)
                                                Builder(
                                                  builder: (context) {
                                                    final pgtos = FFAppState()
                                                        .alunotemp
                                                        .pagamentos
                                                        .sortedList(
                                                            keyOf: (e) => functions
                                                                .formataData(e
                                                                    .dataVencimento),
                                                            desc: true)
                                                        .toList();

                                                    if (pgtos.isEmpty) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(24.0),
                                                        child: Center(
                                                          child: Text(
                                                            'Nenhum registro ainda.',
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: List.generate(
                                                          pgtos.length,
                                                          (pgtosIndex) {
                                                        final pgtosItem =
                                                            pgtos[pgtosIndex];
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child:
                                                              SingleChildScrollView(
                                                            primary: false,
                                                            controller: _model
                                                                .columnController3,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                ListView(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              16.0,
                                                                              0.0,
                                                                              16.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                MediaQuery.sizeOf(context).width * 1.0,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    width: 38.0,
                                                                                    height: 38.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: () {
                                                                                        if (pgtosItem.status == 'pago') {
                                                                                          return Color(0x2F009663);
                                                                                        } else if (pgtosItem.status == 'atrasado') {
                                                                                          return Color(0x2FFF1D29);
                                                                                        } else {
                                                                                          return FlutterFlowTheme.of(context).accent3;
                                                                                        }
                                                                                      }(),
                                                                                      borderRadius: BorderRadius.circular(100.0),
                                                                                    ),
                                                                                    child: Align(
                                                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                                                      child: Icon(
                                                                                        Icons.add_card_rounded,
                                                                                        color: () {
                                                                                          if (pgtosItem.status == 'pago') {
                                                                                            return FlutterFlowTheme.of(context).success;
                                                                                          } else if (pgtosItem.status == 'atrasado') {
                                                                                            return FlutterFlowTheme.of(context).error;
                                                                                          } else {
                                                                                            return FlutterFlowTheme.of(context).warning;
                                                                                          }
                                                                                        }(),
                                                                                        size: 18.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              (String var1) {
                                                                                                return var1.isNotEmpty ? var1[0].toUpperCase() + var1.substring(1).toLowerCase() : '';
                                                                                              }(valueOrDefault<String>(
                                                                                                pgtosItem.tipoPagamento,
                                                                                                '-',
                                                                                              )),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                    fontSize: 14.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Container(
                                                                                              width: 4.0,
                                                                                              height: 4.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                shape: BoxShape.circle,
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              decoration: BoxDecoration(),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  pgtosItem.status,
                                                                                                  '-',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                                      fontSize: 12.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.normal,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(SizedBox(width: 6.0)),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  pgtosItem.descricao,
                                                                                                  'desc',
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
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ].divide(SizedBox(height: 4.0)),
                                                                                    ),
                                                                                  ),
                                                                                  Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      RichText(
                                                                                        textScaler: MediaQuery.of(context).textScaler,
                                                                                        text: TextSpan(
                                                                                          children: [
                                                                                            TextSpan(
                                                                                              text: 'R\$ ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                    fontSize: 10.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: valueOrDefault<String>(
                                                                                                formatNumber(
                                                                                                  pgtosItem.valor,
                                                                                                  formatType: FormatType.decimal,
                                                                                                  decimalType: DecimalType.commaDecimal,
                                                                                                ),
                                                                                                '0,00',
                                                                                              ),
                                                                                              style: GoogleFonts.inter(
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                fontWeight: FontWeight.w600,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                font: GoogleFonts.inter(
                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                        textAlign: TextAlign.end,
                                                                                      ),
                                                                                      Text(
                                                                                        valueOrDefault<String>(
                                                                                          dateTimeFormat(
                                                                                            "dd/MM/yyyy",
                                                                                            functions.formataData(pgtosItem.dataVencimento),
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          ),
                                                                                          '-',
                                                                                        ),
                                                                                        textAlign: TextAlign.end,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              font: GoogleFonts.inter(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                              ),
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 12.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                    ].divide(SizedBox(height: 4.0)),
                                                                                  ),
                                                                                ].divide(SizedBox(width: 16.0)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          height:
                                                                              1.0,
                                                                          thickness:
                                                                              1.0,
                                                                          indent:
                                                                              68.0,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          40.0)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                      16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      boxShadow: [
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .shadow
                                            .lg
                                      ],
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Visibility(
                                      visible: _model.menu == 3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    height: 38.0,
                                                    child: custom_widgets
                                                        .DashedButton(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      height: 38.0,
                                                      label:
                                                          'Adicionar objetivo',
                                                      labelSize: 14.0,
                                                      labelColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      icon: Icon(
                                                        Icons.add,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 18.0,
                                                      ),
                                                      iconColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      iconGap: 4.0,
                                                      borderColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      borderRadius: 10.0,
                                                      borderWidth: 1.0,
                                                      dashWidth: 4.0,
                                                      dashGap: 4.0,
                                                      onPressed: () async {
                                                        await showModalBottomSheet(
                                                          useRootNavigator:
                                                              true,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
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
                                                            safeSetState(() =>
                                                                _model.cadastroumeta =
                                                                    value));

                                                        if (_model
                                                                .cadastroumeta ==
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
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]
                                                .addToStart(
                                                    SizedBox(width: 1.0))
                                                .addToEnd(SizedBox(width: 1.0)),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            decoration: BoxDecoration(),
                                            child: Builder(
                                              builder: (context) {
                                                final metas = FFAppState()
                                                    .alunotemp
                                                    .metas
                                                    .map((e) => e)
                                                    .toList();

                                                return ListView.separated(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: metas.length,
                                                  separatorBuilder: (_, __) =>
                                                      SizedBox(height: 6.0),
                                                  itemBuilder:
                                                      (context, metasIndex) {
                                                    final metasItem =
                                                        metas[metasIndex];
                                                    return InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        await showModalBottomSheet(
                                                          useRootNavigator:
                                                              true,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
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
                                                                      AlunosEditarObjetivoWidget(
                                                                    metas:
                                                                        metasItem,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(() =>
                                                                _model.editoumetas =
                                                                    value));

                                                        if (_model
                                                                .editoumetas ==
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
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  1.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
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
                                                                      children:
                                                                          [
                                                                        Container(
                                                                          width:
                                                                              44.0,
                                                                          height:
                                                                              44.0,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Align(
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                child: CircularPercentIndicator(
                                                                                  percent: metasItem.progresso.toDouble() / 100,
                                                                                  radius: 20.0,
                                                                                  lineWidth: 4.0,
                                                                                  animation: true,
                                                                                  animateFromLastPercent: true,
                                                                                  progressColor: FlutterFlowTheme.of(context).secondary,
                                                                                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                ),
                                                                              ),
                                                                              Align(
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                child: Container(
                                                                                  width: 30.0,
                                                                                  height: 30.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).accent2,
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Align(
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
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                mainAxisSize: MainAxisSize.max,
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
                                                                              width: 8.0)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 1.0,
                                                            thickness: 1.0,
                                                            indent: 68.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (_model.menu == 1) ...[
                                  // ── METRICAS ──────────────────────────
                                  // A RPC sempre aceitou qualquer aluno; faltava a
                                  // tela do personal pedir as do aluno aberto.
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 24.0, 16.0, 8.0),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Evolução',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 4.0),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Tempo em análise:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 12.0),
                                    child: FlutterFlowDropDown<String>(
                                      controller: _periodoController,
                                      options: _periodos,
                                      onChanged: (val) async {
                                        if (val == null) return;
                                        safeSetState(() => _periodo = val);
                                        await _carregarMetricas();
                                        if (mounted) safeSetState(() {});
                                      },
                                      width: double.infinity,
                                      height: 40.0,
                                      maxHeight: 200.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      hintText: 'Selecione...',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24.0,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      elevation: 2.0,
                                      borderColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderWidth: 1.0,
                                      borderRadius: 12.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      hidesUnderline: true,
                                      isOverButton: false,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      padding: EdgeInsets.all(12.0),
                                      child: custom_widgets.GraficoEvolucaoPeso(
                                        width: double.infinity,
                                        height: 280.0,
                                        periodoLabel: _periodo,
                                        corPrimaria:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                      ),
                                    ),
                                  ),
                                  if (functions
                                      .listarExercicios(
                                          FFAppState().metricasTemp)
                                      .isNotEmpty)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        padding: EdgeInsets.all(12.0),
                                        child:
                                            custom_widgets.GraficoEvolucaoCarga(
                                          width: double.infinity,
                                          height: 280.0,
                                          exercicioSelecionado: functions
                                              .listarExercicios(
                                                  FFAppState().metricasTemp)
                                              .first,
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
            // Dava a impressao de app travado — a tela aparecia e nada
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
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    FlutterFlowTheme.of(context)
                                        .designToken
                                        .shadow
                                        .sm
                                  ],
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    FFIcons.kproperty1FiRrArrowSmallLeft,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
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

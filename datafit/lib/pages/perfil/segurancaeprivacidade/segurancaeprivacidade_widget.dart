import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'segurancaeprivacidade_model.dart';
export 'segurancaeprivacidade_model.dart';

class SegurancaeprivacidadeWidget extends StatefulWidget {
  const SegurancaeprivacidadeWidget({super.key});

  static String routeName = 'segurancaeprivacidade';
  static String routePath = '/segurancaeprivacidade';

  @override
  State<SegurancaeprivacidadeWidget> createState() =>
      _SegurancaeprivacidadeWidgetState();
}

class _SegurancaeprivacidadeWidgetState
    extends State<SegurancaeprivacidadeWidget> {
  late SegurancaeprivacidadeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SegurancaeprivacidadeModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 768.0,
                      ),
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
                                constraints: BoxConstraints(
                                  maxWidth: 768.0,
                                ),
                                decoration: BoxDecoration(),
                                child: Stack(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.safePop();
                                          },
                                          child: Container(
                                            width: 36.0,
                                            height: 36.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.navigate_before_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 20.0,
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
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    'Segurança e Privacidade',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
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
                                            Container(
                                              width: 36.0,
                                              height: 36.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  FFIcons.kproperty1FiRrApple,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
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
                          Container(
                            decoration: BoxDecoration(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: FlutterFlowWebView(
                                      content:
                                          '<!DOCTYPE html>\n<html lang=\"pt-br\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\">\n<title>Política de Privacidade e Segurança — DATAFIT</title>\n<link href=\"https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap\" rel=\"stylesheet\">\n<style>\n  a { pointer-events: none; cursor: default; }\n  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }\n\n  body {\n    background: #fdfdfd;\n    color: #181818;\n    font-family: \'DM Sans\', sans-serif;\n    font-size: 15px;\n    line-height: 1.7;\n    -webkit-font-smoothing: antialiased;\n    min-height: 100vh;\n  }\n\n  .page {\n    max-width: 680px;\n    margin: 0 auto;\n    padding: 32px 20px 60px;\n  }\n\n  .header {\n    margin-bottom: 32px;\n    padding-bottom: 24px;\n    border-bottom: 1px solid #e4e4e4;\n  }\n\n  .badge {\n    display: inline-flex;\n    align-items: center;\n    gap: 6px;\n    font-size: 11px;\n    font-weight: 500;\n    letter-spacing: 0.06em;\n    text-transform: uppercase;\n    padding: 4px 12px;\n    border-radius: 99px;\n    background: #eaf4fc;\n    color: #1b98e0;\n    border: 1px solid #c2e0f5;\n    margin-bottom: 14px;\n  }\n\n  .badge-dot {\n    width: 6px;\n    height: 6px;\n    border-radius: 50%;\n    background: #1b98e0;\n  }\n\n  h1 {\n    font-size: 26px;\n    font-weight: 600;\n    color: #181818;\n    letter-spacing: -0.5px;\n    margin-bottom: 10px;\n    line-height: 1.2;\n  }\n\n  .header-desc {\n    font-size: 13px;\n    color: #828282;\n    line-height: 1.65;\n    max-width: 560px;\n  }\n\n  .meta-row {\n    display: flex;\n    flex-wrap: wrap;\n    gap: 16px 28px;\n    margin-top: 18px;\n  }\n\n  .meta-item {\n    font-size: 12px;\n    color: #828282;\n    font-family: \'DM Mono\', monospace;\n  }\n\n  .meta-item span { color: #181818; }\n\n  .toc {\n    background: #f2f4f7;\n    border: 1px solid #e4e4e4;\n    border-radius: 14px;\n    padding: 18px 20px;\n    margin-bottom: 32px;\n  }\n\n  .toc-label {\n    font-size: 11px;\n    font-weight: 500;\n    letter-spacing: 0.08em;\n    text-transform: uppercase;\n    color: #828282;\n    margin-bottom: 12px;\n  }\n\n  .toc-list {\n    list-style: none;\n    display: flex;\n    flex-direction: column;\n    gap: 2px;\n  }\n\n  .toc-list li a {\n    display: flex;\n    align-items: center;\n    gap: 10px;\n    font-size: 13px;\n    color: #828282;\n    text-decoration: none;\n    padding: 5px 0;\n  }\n\n  .toc-num {\n    font-family: \'DM Mono\', monospace;\n    font-size: 11px;\n    color: #e4e4e4;\n    min-width: 20px;\n  }\n\n  .section {\n    margin-bottom: 24px;\n    scroll-margin-top: 20px;\n  }\n\n  .section-header {\n    display: flex;\n    align-items: center;\n    gap: 10px;\n    margin-bottom: 10px;\n  }\n\n  .section-num-badge {\n    width: 26px;\n    height: 26px;\n    border-radius: 8px;\n    background: #f2f4f7;\n    border: 1px solid #e4e4e4;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    font-family: \'DM Mono\', monospace;\n    font-size: 11px;\n    color: #828282;\n    flex-shrink: 0;\n  }\n\n  h2 {\n    font-size: 15px;\n    font-weight: 600;\n    color: #181818;\n    letter-spacing: -0.2px;\n  }\n\n  .section-tag {\n    display: inline-flex;\n    align-items: center;\n    font-size: 10px;\n    font-weight: 500;\n    letter-spacing: 0.05em;\n    text-transform: uppercase;\n    padding: 2px 8px;\n    border-radius: 99px;\n    margin-left: 6px;\n    vertical-align: middle;\n  }\n\n  .tag-lgpd {\n    background: #eafaf3;\n    color: #2a9c6b;\n    border: 1px solid #b5e8d0;\n  }\n\n  .tag-imp {\n    background: #fff7ec;\n    color: #c47a10;\n    border: 1px solid #f5d9a0;\n  }\n\n  .tag-seg {\n    background: #eaf4fc;\n    color: #1b98e0;\n    border: 1px solid #c2e0f5;\n  }\n\n  .card {\n    background: #ffffff;\n    border: 1px solid #e4e4e4;\n    border-radius: 14px;\n    padding: 18px 20px;\n    font-size: 13.5px;\n    color: #828282;\n    line-height: 1.75;\n  }\n\n  .card p { margin-bottom: 12px; }\n  .card p:last-child { margin-bottom: 0; }\n\n  .card ul {\n    padding-left: 0;\n    list-style: none;\n    margin: 10px 0;\n    display: flex;\n    flex-direction: column;\n    gap: 6px;\n  }\n\n  .card ul li {\n    display: flex;\n    align-items: flex-start;\n    gap: 10px;\n    font-size: 13px;\n  }\n\n  .card ul li::before {\n    content: \'\';\n    display: inline-block;\n    width: 5px;\n    height: 5px;\n    border-radius: 50%;\n    background: #e4e4e4;\n    flex-shrink: 0;\n    margin-top: 9px;\n  }\n\n  .card strong { color: #181818; font-weight: 500; }\n\n  .box {\n    border-radius: 10px;\n    padding: 12px 16px;\n    font-size: 13px;\n    line-height: 1.6;\n    margin: 12px 0;\n  }\n\n  .box-info {\n    background: #eaf4fc;\n    border: 1px solid #c2e0f5;\n    color: #1b98e0;\n  }\n\n  .box-success {\n    background: #eafaf3;\n    border: 1px solid #b5e8d0;\n    color: #2a9c6b;\n  }\n\n  .box-warn {\n    background: #fff7ec;\n    border: 1px solid #f5d9a0;\n    color: #c47a10;\n  }\n\n  /* tabela de dados coletados */\n  .data-table {\n    width: 100%;\n    border-collapse: collapse;\n    font-size: 13px;\n    margin: 12px 0;\n  }\n\n  .data-table th {\n    text-align: left;\n    font-weight: 500;\n    color: #828282;\n    font-size: 11px;\n    text-transform: uppercase;\n    letter-spacing: 0.06em;\n    padding: 0 8px 10px 0;\n    border-bottom: 1px solid #e4e4e4;\n  }\n\n  .data-table td {\n    padding: 10px 8px 10px 0;\n    color: #828282;\n    border-bottom: 1px solid #f2f4f7;\n    vertical-align: top;\n    line-height: 1.5;\n  }\n\n  .data-table tr:last-child td { border-bottom: none; }\n  .data-table td:first-child { color: #181818; font-weight: 500; width: 32%; }\n\n  /* grade de medidas de segurança */\n  .security-grid {\n    display: grid;\n    grid-template-columns: 1fr 1fr;\n    gap: 10px;\n    margin: 12px 0;\n  }\n\n  .security-item {\n    background: #f2f4f7;\n    border: 1px solid #e4e4e4;\n    border-radius: 10px;\n    padding: 12px 14px;\n  }\n\n  .security-item-title {\n    font-size: 12px;\n    font-weight: 600;\n    color: #181818;\n    margin-bottom: 4px;\n  }\n\n  .security-item-desc {\n    font-size: 12px;\n    color: #828282;\n    line-height: 1.5;\n  }\n\n  .divider {\n    height: 1px;\n    background: #e4e4e4;\n    margin: 32px 0;\n  }\n\n  .footer {\n    text-align: center;\n    font-size: 12px;\n    color: #828282;\n    line-height: 1.9;\n  }\n\n  .footer strong { color: #181818; font-weight: 500; }\n\n  @media (max-width: 480px) {\n    .security-grid { grid-template-columns: 1fr; }\n  }\n</style>\n</head>\n<body>\n<div class=\"page\">\n\n  <!-- HEADER -->\n  <div class=\"header\">\n    <div class=\"badge\">\n      <span class=\"badge-dot\"></span>\n      Em vigor\n    </div>\n    <h1>Política de Privacidade e Segurança</h1>\n    <p class=\"header-desc\">\n      Este documento descreve como a <strong>DATAFIT</strong> coleta, usa, armazena, compartilha e protege seus dados pessoais, em plena conformidade com a Lei Geral de Proteção de Dados (LGPD — Lei 13.709/2018) e demais legislações aplicáveis no Brasil.\n    </p>\n    <div class=\"meta-row\">\n      <div class=\"meta-item\">Versão <span>1.0</span></div>\n      <div class=\"meta-item\">Vigência <span>29/04/2026</span></div>\n      <div class=\"meta-item\">Atualização <span>29/04/2026</span></div>\n    </div>\n  </div>\n\n  <!-- SUMARIO -->\n  <div class=\"toc\">\n    <div class=\"toc-label\">Sumário</div>\n    <ul class=\"toc-list\">\n      <li><a href=\"#s1\"><span class=\"toc-num\">01</span> Quem Somos e Papel na LGPD</a></li>\n      <li><a href=\"#s2\"><span class=\"toc-num\">02</span> Quais Dados Coletamos</a></li>\n      <li><a href=\"#s3\"><span class=\"toc-num\">03</span> Como e Por Que Usamos Seus Dados</a></li>\n      <li><a href=\"#s4\"><span class=\"toc-num\">04</span> Dados Sensíveis de Saúde</a></li>\n      <li><a href=\"#s5\"><span class=\"toc-num\">05</span> Bases Legais para o Tratamento</a></li>\n      <li><a href=\"#s6\"><span class=\"toc-num\">06</span> Compartilhamento de Dados</a></li>\n      <li><a href=\"#s7\"><span class=\"toc-num\">07</span> Transferência Internacional de Dados</a></li>\n      <li><a href=\"#s8\"><span class=\"toc-num\">08</span> Retenção e Exclusão de Dados</a></li>\n      <li><a href=\"#s9\"><span class=\"toc-num\">09</span> Medidas de Segurança</a></li>\n      <li><a href=\"#s10\"><span class=\"toc-num\">10</span> Cookies e Tecnologias de Rastreamento</a></li>\n      <li><a href=\"#s11\"><span class=\"toc-num\">11</span> Seus Direitos como Titular</a></li>\n      <li><a href=\"#s12\"><span class=\"toc-num\">12</span> Menores de Idade</a></li>\n      <li><a href=\"#s13\"><span class=\"toc-num\">13</span> Incidentes de Segurança</a></li>\n      <li><a href=\"#s14\"><span class=\"toc-num\">14</span> Alterações nesta Política</a></li>\n      <li><a href=\"#s15\"><span class=\"toc-num\">15</span> Encarregado de Dados (DPO) e Contato</a></li>\n    </ul>\n  </div>\n\n  <!-- S1 -->\n  <div class=\"section\" id=\"s1\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">01</div>\n      <h2>Quem Somos e Papel na LGPD <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>A <strong>DATAFIT</strong> é uma plataforma digital de gestão de dados corporativos e fitness, responsável pelo desenvolvimento e operação do aplicativo DATAFIT.</p>\n      <p>Para fins da LGPD (Lei 13.709/2018), a DATAFIT atua como <strong>Controladora</strong> dos dados pessoais dos Usuários (art. 5.º, VI), sendo responsável pelas decisões referentes ao tratamento desses dados.</p>\n      <p>Quando contratamos prestadores de serviço que processam dados em nosso nome (ex.: servidores em nuvem, gateways de pagamento), esses prestadores atuam como <strong>Operadores</strong> (art. 5.º, VII), e são contratualmente obrigados a tratar os dados conforme nossas instruções e em observância à LGPD.</p>\n    </div>\n  </div>\n\n  <!-- S2 -->\n  <div class=\"section\" id=\"s2\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">02</div>\n      <h2>Quais Dados Coletamos</h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT coleta dados nas seguintes categorias:</p>\n      <table class=\"data-table\">\n        <tr>\n          <th>Categoria</th>\n          <th>Exemplos</th>\n          <th>Quando</th>\n        </tr>\n        <tr>\n          <td>Cadastro</td>\n          <td>Nome, e-mail, senha (criptografada), data de nascimento, sexo</td>\n          <td>Ao criar conta</td>\n        </tr>\n        <tr>\n          <td>Saúde e Fitness</td>\n          <td>Peso, altura, medidas corporais, frequência cardíaca, metas, histórico de treinos</td>\n          <td>Durante o uso do app</td>\n        </tr>\n        <tr>\n          <td>Pagamento</td>\n          <td>Plano contratado, histórico de transações (dados de cartão processados por terceiros)</td>\n          <td>Ao assinar plano PRO</td>\n        </tr>\n        <tr>\n          <td>Uso da plataforma</td>\n          <td>Páginas acessadas, funcionalidades utilizadas, frequência de acesso, logs de atividade</td>\n          <td>Automaticamente</td>\n        </tr>\n        <tr>\n          <td>Dispositivo</td>\n          <td>Modelo do dispositivo, sistema operacional, identificador do app, idioma</td>\n          <td>Automaticamente</td>\n        </tr>\n      </table>\n      <div class=\"box box-info\">\n        A DATAFIT não coleta dados de localização em tempo real, nem acessa câmera, microfone ou contatos do dispositivo sem solicitação e consentimento explícito do Usuário.\n      </div>\n    </div>\n  </div>\n\n  <!-- S3 -->\n  <div class=\"section\" id=\"s3\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">03</div>\n      <h2>Como e Por Que Usamos Seus Dados</h2>\n    </div>\n    <div class=\"card\">\n      <p>Utilizamos os dados coletados para as seguintes finalidades:</p>\n      <ul>\n        <li><strong>Prestação dos serviços</strong> — criar e gerenciar sua conta, personalizar sua experiência e disponibilizar as funcionalidades contratadas</li>\n        <li><strong>Monitoramento de desempenho</strong> — calcular métricas, gráficos e relatórios de saúde e fitness com base nos dados que você insere</li>\n        <li><strong>Gestão de pagamentos</strong> — processar assinaturas, renovações e cancelamentos dos planos PRO</li>\n        <li><strong>Comunicação</strong> — enviar notificações relacionadas ao serviço, atualizações importantes e, com seu consentimento, comunicações de marketing</li>\n        <li><strong>Segurança</strong> — detectar, investigar e prevenir fraudes, acessos não autorizados e ameaças à plataforma</li>\n        <li><strong>Melhoria do produto</strong> — analisar padrões de uso agregados e anonimizados para aprimorar funcionalidades e a experiência do Usuário</li>\n        <li><strong>Cumprimento legal</strong> — atender obrigações previstas na legislação brasileira e responder a requisições de autoridades competentes</li>\n      </ul>\n      <p>Os dados nunca serão utilizados para finalidades incompatíveis com as descritas acima sem novo consentimento do Usuário.</p>\n    </div>\n  </div>\n\n  <!-- S4 -->\n  <div class=\"section\" id=\"s4\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">04</div>\n      <h2>Dados Sensíveis de Saúde <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Dados relativos à saúde são classificados como <strong>dados sensíveis</strong> pela LGPD (art. 5.º, II) e recebem proteção reforçada. A DATAFIT trata esses dados somente mediante <strong>consentimento específico, destacado e informado</strong> do Usuário (art. 11, I da LGPD).</p>\n      <div class=\"box box-warn\">\n        Ao inserir dados de saúde na plataforma — como peso, medidas corporais, composição corporal ou frequência cardíaca — você consente expressamente com o tratamento dessas informações para as finalidades descritas nesta Política. Este consentimento pode ser revogado a qualquer momento.\n      </div>\n      <p>Adotamos princípios rigorosos no tratamento de dados de saúde:</p>\n      <ul>\n        <li><strong>Minimização</strong> — coletamos apenas o necessário para a funcionalidade solicitada</li>\n        <li><strong>Finalidade específica</strong> — usados exclusivamente para cálculos, relatórios e metas dentro do app</li>\n        <li><strong>Não comercialização</strong> — jamais vendemos ou cedemos dados de saúde a anunciantes ou terceiros não essenciais</li>\n        <li><strong>Separação lógica</strong> — dados de saúde armazenados em base segregada com controle de acesso diferenciado</li>\n      </ul>\n      <p><strong>Aviso médico:</strong> A DATAFIT é uma ferramenta de monitoramento pessoal. As informações apresentadas não constituem diagnóstico, prescrição médica ou substituem a orientação de profissionais de saúde habilitados.</p>\n    </div>\n  </div>\n\n  <!-- S5 -->\n  <div class=\"section\" id=\"s5\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">05</div>\n      <h2>Bases Legais para o Tratamento <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Todo tratamento de dados realizado pela DATAFIT está fundamentado em ao menos uma das seguintes bases legais previstas na LGPD:</p>\n      <ul>\n        <li><strong>Consentimento (art. 7.º, I e art. 11, I)</strong> — para dados de saúde e comunicações de marketing. Pode ser revogado a qualquer momento sem prejudicar tratamentos anteriores</li>\n        <li><strong>Execução de contrato (art. 7.º, V)</strong> — para viabilizar as funcionalidades do plano contratado (Free ou PRO)</li>\n        <li><strong>Legítimo interesse (art. 7.º, IX)</strong> — para segurança da plataforma, prevenção a fraudes e análise agregada de uso, sempre ponderado com os direitos do Usuário</li>\n        <li><strong>Cumprimento de obrigação legal (art. 7.º, II)</strong> — quando exigido por autoridade competente ou por determinação judicial</li>\n        <li><strong>Exercício regular de direitos (art. 7.º, VI)</strong> — para defesa em processos judiciais, administrativos ou arbitrais</li>\n      </ul>\n    </div>\n  </div>\n\n  <!-- S6 -->\n  <div class=\"section\" id=\"s6\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">06</div>\n      <h2>Compartilhamento de Dados</h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT <strong>não vende dados pessoais</strong>. O compartilhamento ocorre apenas nas situações abaixo:</p>\n      <ul>\n        <li><strong>Provedores de infraestrutura</strong> — serviços de hospedagem e banco de dados em nuvem que armazenam os dados em nosso nome, sob contrato com cláusulas de proteção de dados</li>\n        <li><strong>Processadores de pagamento</strong> — gateways autorizados (ex.: Google Play Billing, Apple In-App Purchase) para gestão de assinaturas PRO. Os dados de cartão nunca passam pelos servidores da DATAFIT</li>\n        <li><strong>Ferramentas analíticas</strong> — plataformas de análise de uso do app com dados anonimizados ou pseudonimizados</li>\n        <li><strong>Autoridades e órgãos públicos</strong> — quando exigido por lei, decisão judicial ou regulatória</li>\n        <li><strong>Sucessores corporativos</strong> — em caso de fusão, aquisição ou reorganização societária, com notificação prévia ao Usuário e manutenção das mesmas garantias de privacidade</li>\n      </ul>\n      <div class=\"box box-success\">\n        Todos os terceiros que recebem dados dos nossos usuários são contratualmente obrigados a tratar as informações com o mesmo nível de proteção exigido pela LGPD.\n      </div>\n    </div>\n  </div>\n\n  <!-- S7 -->\n  <div class=\"section\" id=\"s7\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">07</div>\n      <h2>Transferência Internacional de Dados <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Alguns de nossos prestadores de serviços de infraestrutura podem estar localizados fora do Brasil. Nestes casos, a transferência internacional de dados observa os requisitos do art. 33 da LGPD, sendo realizada apenas quando:</p>\n      <ul>\n        <li>O país destinatário oferece grau de proteção de dados adequado, reconhecido pela ANPD</li>\n        <li>O prestador oferece garantias suficientes mediante cláusulas contratuais específicas de proteção de dados</li>\n        <li>Há consentimento específico do Usuário para a transferência, quando necessário</li>\n      </ul>\n      <p>Os dados de saúde, por sua sensibilidade, são preferencialmente armazenados em servidores localizados no Brasil ou em países com legislação equivalente à LGPD.</p>\n    </div>\n  </div>\n\n  <!-- S8 -->\n  <div class=\"section\" id=\"s8\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">08</div>\n      <h2>Retenção e Exclusão de Dados</h2>\n    </div>\n    <div class=\"card\">\n      <p>Os dados pessoais são mantidos pelo tempo necessário ao cumprimento das finalidades para as quais foram coletados, observando os seguintes critérios:</p>\n      <ul>\n        <li><strong>Conta ativa</strong> — dados mantidos durante toda a vigência do relacionamento com a DATAFIT</li>\n        <li><strong>Após encerramento da conta</strong> — dados excluídos em até 90 (noventa) dias, salvo obrigação legal de retenção</li>\n        <li><strong>Dados fiscais e financeiros</strong> — mantidos por 5 (cinco) anos, conforme exigência do Código Tributário Nacional</li>\n        <li><strong>Logs de segurança</strong> — mantidos por 6 (seis) meses, conforme Marco Civil da Internet (Lei 12.965/2014)</li>\n        <li><strong>Dados de saúde</strong> — excluídos imediatamente após solicitação do titular, salvo quando necessários para cumprimento de obrigação legal</li>\n      </ul>\n      <div class=\"box box-info\">\n        Você pode solicitar a exclusão dos seus dados a qualquer momento pelos canais de privacidade da DATAFIT. Dados anonimizados ou agregados, que não permitem sua identificação, poderão ser mantidos para fins estatísticos.\n      </div>\n    </div>\n  </div>\n\n  <!-- S9 -->\n  <div class=\"section\" id=\"s9\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">09</div>\n      <h2>Medidas de Segurança <span class=\"section-tag tag-seg\">Segurança</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT adota medidas técnicas e organizacionais apropriadas para proteger seus dados pessoais contra acesso não autorizado, perda, alteração ou divulgação indevida:</p>\n      <div class=\"security-grid\">\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Criptografia em trânsito</div>\n          <div class=\"security-item-desc\">Toda comunicação entre o app e nossos servidores utiliza protocolo TLS 1.2 ou superior</div>\n        </div>\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Criptografia em repouso</div>\n          <div class=\"security-item-desc\">Dados armazenados nos servidores são criptografados, especialmente dados de saúde e credenciais</div>\n        </div>\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Controle de acesso</div>\n          <div class=\"security-item-desc\">Acesso aos dados restrito a colaboradores autorizados, com autenticação multifator</div>\n        </div>\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Senhas protegidas</div>\n          <div class=\"security-item-desc\">Senhas armazenadas em formato hash com salt, nunca em texto simples</div>\n        </div>\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Monitoramento contínuo</div>\n          <div class=\"security-item-desc\">Sistemas de detecção de intrusão e monitoramento de anomalias ativos 24/7</div>\n        </div>\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Backups seguros</div>\n          <div class=\"security-item-desc\">Backups regulares criptografados, testados periodicamente para garantir recuperação</div>\n        </div>\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Revisões de segurança</div>\n          <div class=\"security-item-desc\">Auditorias e testes de segurança periódicos na infraestrutura e no código</div>\n        </div>\n        <div class=\"security-item\">\n          <div class=\"security-item-title\">Política interna</div>\n          <div class=\"security-item-desc\">Colaboradores treinados em boas práticas de privacidade e proteção de dados</div>\n        </div>\n      </div>\n      <div class=\"box box-warn\">\n        Nenhum sistema é 100% seguro. Recomendamos ao Usuário utilizar senhas fortes, não reutilizadas, e manter o aplicativo sempre atualizado para se beneficiar das últimas correções de segurança.\n      </div>\n    </div>\n  </div>\n\n  <!-- S10 -->\n  <div class=\"section\" id=\"s10\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">10</div>\n      <h2>Cookies e Tecnologias de Rastreamento</h2>\n    </div>\n    <div class=\"card\">\n      <p>O aplicativo DATAFIT pode utilizar tecnologias similares a cookies para melhorar a experiência do Usuário e analisar o uso da plataforma:</p>\n      <ul>\n        <li><strong>Sessão e autenticação</strong> — tokens necessários para manter o Usuário autenticado durante o uso do app (essenciais, não podem ser desativados)</li>\n        <li><strong>Preferências</strong> — armazenam configurações do Usuário, como idioma e tema (funcionais)</li>\n        <li><strong>Analíticos</strong> — dados de uso anonimizados para entender como os Usuários interagem com o app e melhorar funcionalidades (podem ser desativados nas configurações)</li>\n      </ul>\n      <p>A DATAFIT não utiliza tecnologias de rastreamento para fins publicitários de terceiros.</p>\n    </div>\n  </div>\n\n  <!-- S11 -->\n  <div class=\"section\" id=\"s11\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">11</div>\n      <h2>Seus Direitos como Titular <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>A LGPD (arts. 17 a 22) garante ao Usuário os seguintes direitos sobre seus dados pessoais, exercíveis a qualquer momento pelo canal de privacidade da DATAFIT:</p>\n      <ul>\n        <li><strong>Acesso</strong> — obter confirmação da existência e acesso aos seus dados tratados pela DATAFIT</li>\n        <li><strong>Correção</strong> — solicitar atualização de dados incompletos, inexatos ou desatualizados</li>\n        <li><strong>Anonimização ou bloqueio</strong> — de dados desnecessários, excessivos ou tratados em desconformidade com a LGPD</li>\n        <li><strong>Eliminação</strong> — excluir dados tratados com base no consentimento (ressalvadas hipóteses legais de retenção)</li>\n        <li><strong>Portabilidade</strong> — receber seus dados em formato estruturado e interoperável</li>\n        <li><strong>Informação sobre compartilhamento</strong> — saber quais entidades recebem seus dados</li>\n        <li><strong>Revogação do consentimento</strong> — retirar o consentimento dado anteriormente, sem efeito retroativo sobre tratamentos já realizados</li>\n        <li><strong>Oposição</strong> — contestar tratamentos realizados com base em outras hipóteses legais em caso de descumprimento</li>\n        <li><strong>Revisão de decisões automatizadas</strong> — solicitar revisão de decisões tomadas exclusivamente por meios automatizados que afetem seus interesses</li>\n      </ul>\n      <div class=\"box box-success\">\n        Todas as solicitações serão respondidas em até 15 (quinze) dias úteis, conforme previsto na LGPD. Entre em contato com nosso DPO pelos canais indicados na seção 15.\n      </div>\n    </div>\n  </div>\n\n  <!-- S12 -->\n  <div class=\"section\" id=\"s12\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">12</div>\n      <h2>Menores de Idade <span class=\"section-tag tag-imp\">Importante</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT não coleta intencionalmente dados de crianças menores de 12 (doze) anos. Para adolescentes entre 12 e 17 anos, o tratamento de dados somente será realizado mediante <strong>consentimento específico e destacado</strong> fornecido pelos pais ou responsáveis legais, conforme art. 14 da LGPD.</p>\n      <p>Caso identificarmos que coletamos dados de menor de 12 anos sem o devido consentimento, tais dados serão excluídos imediatamente. Se você acredita que isso ocorreu, entre em contato com nosso DPO.</p>\n      <p>Responsáveis legais de adolescentes usuários da plataforma poderão exercer, em nome dos menores, todos os direitos de titular previstos na LGPD.</p>\n    </div>\n  </div>\n\n  <!-- S13 -->\n  <div class=\"section\" id=\"s13\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">13</div>\n      <h2>Incidentes de Segurança <span class=\"section-tag tag-seg\">Segurança</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Em caso de incidente de segurança que possa acarretar risco ou dano relevante aos Usuários, a DATAFIT adotará as seguintes medidas:</p>\n      <ul>\n        <li>Contenção imediata do incidente e investigação do ocorrido</li>\n        <li>Notificação à <strong>Autoridade Nacional de Proteção de Dados (ANPD)</strong> em prazo razoável, conforme art. 48 da LGPD</li>\n        <li>Comunicação aos Usuários afetados por meio dos canais cadastrados, com informações sobre a natureza dos dados afetados, os riscos envolvidos e as medidas adotadas</li>\n        <li>Registro do incidente e das ações tomadas para fins de accountability</li>\n      </ul>\n      <div class=\"box box-info\">\n        Se você identificar qualquer vulnerabilidade ou suspeita de uso indevido dos seus dados, comunique-nos imediatamente pelos canais de privacidade da DATAFIT.\n      </div>\n    </div>\n  </div>\n\n  <!-- S14 -->\n  <div class=\"section\" id=\"s14\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">14</div>\n      <h2>Alterações nesta Política</h2>\n    </div>\n    <div class=\"card\">\n      <p>Esta Política de Privacidade e Segurança poderá ser atualizada periodicamente para refletir mudanças em nossas práticas, na legislação ou nos serviços oferecidos.</p>\n      <p>Alterações relevantes serão comunicadas ao Usuário com antecedência mínima de <strong>15 (quinze) dias</strong> por meio de notificação no aplicativo ou e-mail cadastrado. O uso continuado da plataforma após a vigência das alterações implica aceitação da nova versão.</p>\n      <p>Recomendamos a revisão periódica desta Política. A data de \"Última atualização\" no topo do documento indica quando ocorreu a versão mais recente.</p>\n    </div>\n  </div>\n\n  <!-- S15 -->\n  <div class=\"section\" id=\"s15\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">15</div>\n      <h2>Encarregado de Dados (DPO) e Contato <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Nos termos do art. 41 da LGPD, a DATAFIT designou um <strong>Encarregado pelo Tratamento de Dados Pessoais (DPO)</strong>, responsável por:</p>\n      <ul>\n        <li>Receber e atender comunicações dos titulares de dados e da ANPD</li>\n        <li>Orientar colaboradores e operadores sobre as práticas de proteção de dados</li>\n        <li>Executar as demais atribuições previstas na LGPD e nos regulamentos da ANPD</li>\n      </ul>\n      <p>Para exercer seus direitos, tirar dúvidas sobre esta Política ou relatar qualquer incidente relacionado aos seus dados, utilize os <strong>canais oficiais de privacidade</strong> disponíveis na seção \"Privacidade\" dentro do aplicativo DATAFIT.</p>\n      <div class=\"box box-success\">\n        Garantimos resposta a todas as solicitações de privacidade em até 15 (quinze) dias úteis. Para casos urgentes relacionados a incidentes de segurança, priorizamos o atendimento em até 72 horas.\n      </div>\n    </div>\n  </div>\n\n  <div class=\"divider\"></div>\n\n  <div class=\"footer\">\n    <p><strong>DATAFIT</strong> — Plataforma de Gestão Corporativa e Fitness</p>\n    <p>Política de Privacidade e Segurança — Versão 1.0 — Vigente a partir de 29/04/2026</p>\n    <p>Em caso de dúvidas, utilize os canais oficiais de privacidade disponíveis no aplicativo.</p>\n  </div>\n\n</div>\n</body>\n</html>',
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              1.0,
                                      verticalScroll: false,
                                      horizontalScroll: false,
                                      html: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

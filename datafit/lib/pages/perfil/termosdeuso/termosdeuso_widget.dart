import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'termosdeuso_model.dart';
export 'termosdeuso_model.dart';

class TermosdeusoWidget extends StatefulWidget {
  const TermosdeusoWidget({super.key});

  static String routeName = 'termosdeuso';
  static String routePath = '/termosdeuso';

  @override
  State<TermosdeusoWidget> createState() => _TermosdeusoWidgetState();
}

class _TermosdeusoWidgetState extends State<TermosdeusoWidget> {
  late TermosdeusoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermosdeusoModel());

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
                                                    'Termos de uso',
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
                                          '<!DOCTYPE html>\n<html lang=\"pt-br\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\">\n<title>Termos de Uso — DATAFIT</title>\n<link href=\"https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap\" rel=\"stylesheet\">\n<style>\n  a { pointer-events: none; cursor: default; }\n  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }\n\n  body {\n    background: #fdfdfd;\n    color: #181818;\n    font-family: \'DM Sans\', sans-serif;\n    font-size: 15px;\n    line-height: 1.7;\n    -webkit-font-smoothing: antialiased;\n    min-height: 100vh;\n  }\n\n  .page {\n    max-width: 680px;\n    margin: 0 auto;\n    padding: 32px 20px 60px;\n  }\n\n  /* HEADER */\n  .header {\n    margin-bottom: 32px;\n    padding-bottom: 24px;\n    border-bottom: 1px solid #e4e4e4;\n  }\n\n  .badge {\n    display: inline-flex;\n    align-items: center;\n    gap: 6px;\n    font-size: 11px;\n    font-weight: 500;\n    letter-spacing: 0.06em;\n    text-transform: uppercase;\n    padding: 4px 12px;\n    border-radius: 99px;\n    background: #eaf4fc;\n    color: #1b98e0;\n    border: 1px solid #c2e0f5;\n    margin-bottom: 14px;\n  }\n\n  .badge-dot {\n    width: 6px;\n    height: 6px;\n    border-radius: 50%;\n    background: #1b98e0;\n  }\n\n  h1 {\n    font-size: 26px;\n    font-weight: 600;\n    color: #181818;\n    letter-spacing: -0.5px;\n    margin-bottom: 10px;\n    line-height: 1.2;\n  }\n\n  .header-desc {\n    font-size: 13px;\n    color: #828282;\n    line-height: 1.65;\n    max-width: 560px;\n  }\n\n  .meta-row {\n    display: flex;\n    flex-wrap: wrap;\n    gap: 16px 28px;\n    margin-top: 18px;\n  }\n\n  .meta-item {\n    font-size: 12px;\n    color: #828282;\n    font-family: \'DM Mono\', monospace;\n  }\n\n  .meta-item span { color: #181818; }\n\n  /* TOC */\n  .toc {\n    background: #f2f4f7;\n    border: 1px solid #e4e4e4;\n    border-radius: 14px;\n    padding: 18px 20px;\n    margin-bottom: 32px;\n  }\n\n  .toc-label {\n    font-size: 11px;\n    font-weight: 500;\n    letter-spacing: 0.08em;\n    text-transform: uppercase;\n    color: #828282;\n    margin-bottom: 12px;\n  }\n\n  .toc-list {\n    list-style: none;\n    display: flex;\n    flex-direction: column;\n    gap: 2px;\n  }\n\n  .toc-list li a {\n    display: flex;\n    align-items: center;\n    gap: 10px;\n    font-size: 13px;\n    color: #828282;\n    text-decoration: none;\n    padding: 5px 0;\n  }\n\n  .toc-num {\n    font-family: \'DM Mono\', monospace;\n    font-size: 11px;\n    color: #e4e4e4;\n    min-width: 20px;\n  }\n\n  /* SECTIONS */\n  .section {\n    margin-bottom: 24px;\n    scroll-margin-top: 20px;\n  }\n\n  .section-header {\n    display: flex;\n    align-items: center;\n    gap: 10px;\n    margin-bottom: 10px;\n  }\n\n  .section-num-badge {\n    width: 26px;\n    height: 26px;\n    border-radius: 8px;\n    background: #f2f4f7;\n    border: 1px solid #e4e4e4;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    font-family: \'DM Mono\', monospace;\n    font-size: 11px;\n    color: #828282;\n    flex-shrink: 0;\n  }\n\n  h2 {\n    font-size: 15px;\n    font-weight: 600;\n    color: #181818;\n    letter-spacing: -0.2px;\n  }\n\n  .section-tag {\n    display: inline-flex;\n    align-items: center;\n    font-size: 10px;\n    font-weight: 500;\n    letter-spacing: 0.05em;\n    text-transform: uppercase;\n    padding: 2px 8px;\n    border-radius: 99px;\n    margin-left: 6px;\n    vertical-align: middle;\n  }\n\n  .tag-lgpd {\n    background: #eafaf3;\n    color: #2a9c6b;\n    border: 1px solid #b5e8d0;\n  }\n\n  .tag-imp {\n    background: #fff7ec;\n    color: #c47a10;\n    border: 1px solid #f5d9a0;\n  }\n\n  .card {\n    background: #ffffff;\n    border: 1px solid #e4e4e4;\n    border-radius: 14px;\n    padding: 18px 20px;\n    font-size: 13.5px;\n    color: #828282;\n    line-height: 1.75;\n  }\n\n  .card p { margin-bottom: 12px; }\n  .card p:last-child { margin-bottom: 0; }\n\n  .card ul {\n    padding-left: 0;\n    list-style: none;\n    margin: 10px 0;\n    display: flex;\n    flex-direction: column;\n    gap: 6px;\n  }\n\n  .card ul li {\n    display: flex;\n    align-items: flex-start;\n    gap: 10px;\n    font-size: 13px;\n  }\n\n  .card ul li::before {\n    content: \'x\';\n    font-size: 0;\n    display: inline-block;\n    width: 5px;\n    height: 5px;\n    border-radius: 50%;\n    background: #e4e4e4;\n    flex-shrink: 0;\n    margin-top: 9px;\n  }\n\n  .card strong {\n    color: #181818;\n    font-weight: 500;\n  }\n\n  /* BOXES */\n  .box {\n    border-radius: 10px;\n    padding: 12px 16px;\n    font-size: 13px;\n    line-height: 1.6;\n    margin: 12px 0;\n  }\n\n  .box-info {\n    background: #eaf4fc;\n    border: 1px solid #c2e0f5;\n    color: #1b98e0;\n  }\n\n  .box-success {\n    background: #eafaf3;\n    border: 1px solid #b5e8d0;\n    color: #2a9c6b;\n  }\n\n  .box-warn {\n    background: #fff7ec;\n    border: 1px solid #f5d9a0;\n    color: #c47a10;\n  }\n\n  /* PLAN TABLE */\n  .plan-table {\n    width: 100%;\n    border-collapse: collapse;\n    font-size: 13px;\n    margin: 12px 0;\n  }\n\n  .plan-table th {\n    text-align: left;\n    font-weight: 500;\n    color: #828282;\n    font-size: 11px;\n    text-transform: uppercase;\n    letter-spacing: 0.06em;\n    padding: 0 0 10px;\n    border-bottom: 1px solid #e4e4e4;\n  }\n\n  .plan-table td {\n    padding: 10px 0;\n    color: #828282;\n    border-bottom: 1px solid #f2f4f7;\n    vertical-align: top;\n  }\n\n  .plan-table tr:last-child td { border-bottom: none; }\n  .plan-table td:first-child { color: #181818; font-weight: 500; width: 35%; }\n\n  .pill {\n    display: inline-flex;\n    align-items: center;\n    font-size: 11px;\n    padding: 2px 10px;\n    border-radius: 99px;\n    font-weight: 500;\n  }\n\n  .pill-free {\n    background: #f2f4f7;\n    color: #828282;\n    border: 1px solid #e4e4e4;\n  }\n\n  .pill-pro {\n    background: #eaf4fc;\n    color: #1b98e0;\n    border: 1px solid #c2e0f5;\n  }\n\n  /* DIVIDER */\n  .divider {\n    height: 1px;\n    background: #e4e4e4;\n    margin: 32px 0;\n  }\n\n  /* FOOTER */\n  .footer {\n    text-align: center;\n    font-size: 12px;\n    color: #828282;\n    line-height: 1.9;\n  }\n\n  .footer strong { color: #181818; font-weight: 500; }\n</style>\n</head>\n<body>\n<div class=\"page\">\n\n  <!-- HEADER -->\n  <div class=\"header\">\n    <div class=\"badge\">\n      <span class=\"badge-dot\"></span>\n      Em vigor\n    </div>\n    <h1>Termos de Uso</h1>\n    <p class=\"header-desc\">\n      Este documento regula o acesso e uso da plataforma <strong>DATAFIT</strong> e foi elaborado em conformidade com a Lei Geral de Proteção de Dados (LGPD — Lei 13.709/2018), o Código de Defesa do Consumidor (Lei 8.078/1990) e demais legislações aplicáveis no Brasil.\n    </p>\n    <div class=\"meta-row\">\n      <div class=\"meta-item\">Versão <span>1.0</span></div>\n      <div class=\"meta-item\">Vigência <span>29/04/2026</span></div>\n      <div class=\"meta-item\">Atualização <span>29/04/2026</span></div>\n    </div>\n  </div>\n\n  <!-- SUMARIO -->\n  <div class=\"toc\">\n    <div class=\"toc-label\">Sumário</div>\n    <ul class=\"toc-list\">\n      <li><a href=\"#s1\"><span class=\"toc-num\">01</span> Das Partes e Objeto</a></li>\n      <li><a href=\"#s2\"><span class=\"toc-num\">02</span> Aceitação dos Termos</a></li>\n      <li><a href=\"#s3\"><span class=\"toc-num\">03</span> Cadastro e Conta do Usuário</a></li>\n      <li><a href=\"#s4\"><span class=\"toc-num\">04</span> Planos e Pagamentos</a></li>\n      <li><a href=\"#s5\"><span class=\"toc-num\">05</span> Coleta e Tratamento de Dados Pessoais (LGPD)</a></li>\n      <li><a href=\"#s6\"><span class=\"toc-num\">06</span> Dados de Saúde</a></li>\n      <li><a href=\"#s7\"><span class=\"toc-num\">07</span> Uso Adequado da Plataforma</a></li>\n      <li><a href=\"#s8\"><span class=\"toc-num\">08</span> Propriedade Intelectual</a></li>\n      <li><a href=\"#s9\"><span class=\"toc-num\">09</span> Disponibilidade e Suporte</a></li>\n      <li><a href=\"#s10\"><span class=\"toc-num\">10</span> Limitação de Responsabilidade</a></li>\n      <li><a href=\"#s11\"><span class=\"toc-num\">11</span> Suspensão e Encerramento de Conta</a></li>\n      <li><a href=\"#s12\"><span class=\"toc-num\">12</span> Direitos do Titular dos Dados</a></li>\n      <li><a href=\"#s13\"><span class=\"toc-num\">13</span> Alterações nos Termos</a></li>\n      <li><a href=\"#s14\"><span class=\"toc-num\">14</span> Legislação Aplicável e Foro</a></li>\n      <li><a href=\"#s15\"><span class=\"toc-num\">15</span> Contato e Canal de Privacidade</a></li>\n    </ul>\n  </div>\n\n  <!-- S1 -->\n  <div class=\"section\" id=\"s1\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">01</div>\n      <h2>Das Partes e Objeto</h2>\n    </div>\n    <div class=\"card\">\n      <p>O presente instrumento é celebrado entre a <strong>DATAFIT</strong> (\"Plataforma\", \"nós\") e o usuário pessoa física ou jurídica (\"Usuário\", \"você\") que acessa, instala ou utiliza qualquer funcionalidade do aplicativo DATAFIT.</p>\n      <p>A DATAFIT é uma plataforma digital de <strong>gestão de dados corporativos e fitness</strong>, oferecendo ferramentas para monitoramento de desempenho físico, controle de métricas de saúde e bem-estar, e gestão de informações relacionadas à atividade física e performance.</p>\n      <p>Ao utilizar a plataforma, o Usuário declara ter plena capacidade civil ou, sendo menor de 18 anos, estar devidamente representado ou assistido por seus responsáveis legais, que também se sujeitam a estes Termos.</p>\n    </div>\n  </div>\n\n  <!-- S2 -->\n  <div class=\"section\" id=\"s2\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">02</div>\n      <h2>Aceitação dos Termos <span class=\"section-tag tag-imp\">Importante</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>O acesso ou uso da DATAFIT constitui aceitação plena e irrestrita destes Termos de Uso e da Política de Privacidade. Caso não concorde com qualquer disposição, o Usuário deverá interromper imediatamente o uso da plataforma.</p>\n      <div class=\"box box-warn\">\n        A aceitação destes termos tem força de contrato vinculante entre as partes, nos termos do art. 1.º do Código Civil Brasileiro e do art. 49 do CDC, quando aplicável.\n      </div>\n      <p>Usuários menores de 18 anos só poderão utilizar a plataforma com o consentimento expresso de seus responsáveis legais, conforme exigido pela LGPD (art. 14).</p>\n    </div>\n  </div>\n\n  <!-- S3 -->\n  <div class=\"section\" id=\"s3\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">03</div>\n      <h2>Cadastro e Conta do Usuário</h2>\n    </div>\n    <div class=\"card\">\n      <p>O acesso a funcionalidades completas da DATAFIT exige cadastro. O Usuário se compromete a:</p>\n      <ul>\n        <li>Fornecer informações verdadeiras, precisas, atuais e completas no momento do cadastro</li>\n        <li>Manter seus dados cadastrais atualizados</li>\n        <li>Manter sigilo absoluto sobre suas credenciais de acesso (login e senha)</li>\n        <li>Notificar imediatamente a DATAFIT sobre qualquer uso não autorizado de sua conta</li>\n        <li>Não compartilhar, ceder ou transferir sua conta a terceiros</li>\n      </ul>\n      <p>O Usuário é integralmente responsável por todas as atividades realizadas sob sua conta. A DATAFIT não se responsabiliza por prejuízos decorrentes do descumprimento das obrigações acima, incluindo acesso indevido por negligência do próprio Usuário.</p>\n      <p>É vedado criar múltiplas contas para burlar restrições de planos ou suspensões aplicadas pela plataforma.</p>\n    </div>\n  </div>\n\n  <!-- S4 -->\n  <div class=\"section\" id=\"s4\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">04</div>\n      <h2>Planos e Pagamentos <span class=\"section-tag tag-imp\">Importante</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT adota modelo <strong>freemium</strong>, com plano gratuito e planos pagos (PRO). As funcionalidades de cada plano são definidas conforme tabela vigente no aplicativo.</p>\n      <table class=\"plan-table\">\n        <tr>\n          <th>Plano</th>\n          <th>Acesso</th>\n          <th>Cobrança</th>\n        </tr>\n        <tr>\n          <td><span class=\"pill pill-free\">Free</span></td>\n          <td>Funcionalidades básicas, sem custo</td>\n          <td>Gratuito</td>\n        </tr>\n        <tr>\n          <td><span class=\"pill pill-pro\">PRO</span></td>\n          <td>Acesso completo a todos os recursos</td>\n          <td>Mensal ou anual</td>\n        </tr>\n      </table>\n      <p><strong>Pagamentos:</strong> As cobranças dos planos pagos são processadas por plataformas terceiras (ex.: Google Play, App Store ou gateway de pagamento integrado), sujeitas aos termos e políticas próprias dessas plataformas.</p>\n      <p><strong>Renovação automática:</strong> As assinaturas são renovadas automaticamente ao término do período contratado, salvo cancelamento pelo Usuário antes da data de renovação.</p>\n      <p><strong>Cancelamento e reembolso:</strong> O Usuário poderá cancelar sua assinatura a qualquer momento. Nos termos do art. 49 do CDC, compras realizadas fora de estabelecimento físico poderão ser arrependidas em até 7 (sete) dias corridos a partir da contratação, com direito a reembolso integral. Após esse prazo, não haverá reembolso proporcional pelo período não utilizado, salvo disposição contrária expressa da DATAFIT.</p>\n      <div class=\"box box-info\">\n        A DATAFIT reserva-se o direito de alterar os preços dos planos pagos, mediante comunicação prévia de no mínimo 30 dias aos usuários ativos.\n      </div>\n    </div>\n  </div>\n\n  <!-- S5 -->\n  <div class=\"section\" id=\"s5\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">05</div>\n      <h2>Coleta e Tratamento de Dados Pessoais <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT atua como <strong>controladora</strong> dos dados pessoais coletados na plataforma, nos termos do art. 5.º, VI da LGPD. O tratamento dos dados observa as seguintes bases legais (art. 7.º e art. 11 da LGPD):</p>\n      <ul>\n        <li><strong>Consentimento</strong> — para coleta de dados de saúde e comunicações de marketing</li>\n        <li><strong>Execução de contrato</strong> — para viabilizar os serviços contratados pelo Usuário</li>\n        <li><strong>Legítimo interesse</strong> — para segurança da plataforma e melhoria dos serviços</li>\n        <li><strong>Obrigação legal</strong> — quando exigido por lei ou autoridade competente</li>\n      </ul>\n      <p><strong>Dados coletados incluem:</strong> nome, e-mail, data de nascimento, dados de saúde inseridos pelo usuário (peso, medidas, frequência cardíaca, etc.), dados de pagamento (processados por terceiros) e dados de uso da plataforma.</p>\n      <p><strong>Compartilhamento:</strong> Os dados poderão ser compartilhados com parceiros tecnológicos estritamente necessários à operação da plataforma (ex.: servidores em nuvem, processadores de pagamento), sempre sob acordos de confidencialidade e proteção de dados. Não vendemos dados pessoais a terceiros.</p>\n      <p>Para informações detalhadas, consulte nossa <strong>Política de Privacidade</strong> disponível na plataforma.</p>\n    </div>\n  </div>\n\n  <!-- S6 -->\n  <div class=\"section\" id=\"s6\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">06</div>\n      <h2>Dados de Saúde <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Dados de saúde são classificados como <strong>dados sensíveis</strong> pela LGPD (art. 5.º, II), exigindo tratamento diferenciado e consentimento específico do titular.</p>\n      <div class=\"box box-warn\">\n        Ao inserir informações de saúde na DATAFIT (peso, medidas corporais, frequência cardíaca, composição corporal, etc.), o Usuário concede expressamente seu consentimento para o tratamento dessas informações, exclusivamente para as finalidades descritas na plataforma.\n      </div>\n      <p>A DATAFIT adota as seguintes salvaguardas para dados de saúde:</p>\n      <ul>\n        <li>Criptografia em trânsito (TLS) e em repouso</li>\n        <li>Acesso restrito apenas a colaboradores e sistemas autorizados</li>\n        <li>Retenção limitada ao período necessário à prestação dos serviços</li>\n        <li>Exclusão segura após encerramento da conta ou revogação do consentimento</li>\n      </ul>\n      <p><strong>Importante:</strong> As informações e funcionalidades da DATAFIT têm caráter informativo e de monitoramento pessoal. A plataforma <strong>não substitui</strong> acompanhamento médico, nutricional ou de profissionais de saúde qualificados.</p>\n    </div>\n  </div>\n\n  <!-- S7 -->\n  <div class=\"section\" id=\"s7\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">07</div>\n      <h2>Uso Adequado da Plataforma</h2>\n    </div>\n    <div class=\"card\">\n      <p>O Usuário compromete-se a utilizar a DATAFIT de forma ética, legal e responsável. É expressamente <strong>vedado</strong>:</p>\n      <ul>\n        <li>Utilizar a plataforma para fins ilegais, fraudulentos ou não autorizados</li>\n        <li>Acessar indevidamente sistemas, contas de outros usuários ou infraestrutura da plataforma</li>\n        <li>Inserir, transmitir ou disseminar vírus, malware ou qualquer código malicioso</li>\n        <li>Realizar engenharia reversa, descompilação ou desmontagem do aplicativo</li>\n        <li>Coletar dados de outros usuários sem seu consentimento expresso</li>\n        <li>Utilizar robôs, scrapers ou meios automatizados não autorizados para acessar a plataforma</li>\n        <li>Reproduzir, distribuir ou explorar comercialmente conteúdo da DATAFIT sem autorização</li>\n        <li>Praticar qualquer ato que interfira no funcionamento normal da plataforma</li>\n      </ul>\n      <p>O descumprimento destas obrigações poderá acarretar suspensão imediata da conta, sem prejuízo das responsabilidades civil e criminal cabíveis.</p>\n    </div>\n  </div>\n\n  <!-- S8 -->\n  <div class=\"section\" id=\"s8\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">08</div>\n      <h2>Propriedade Intelectual</h2>\n    </div>\n    <div class=\"card\">\n      <p>Todo o conteúdo disponibilizado na DATAFIT — incluindo, mas não se limitando a: marca, logotipo, interface, design, código-fonte, algoritmos, banco de dados, textos, gráficos e funcionalidades — é de <strong>propriedade exclusiva da DATAFIT</strong> ou de seus licenciantes, protegido pela Lei de Direitos Autorais (Lei 9.610/1998), Lei de Software (Lei 9.609/1998) e legislação de propriedade industrial.</p>\n      <p>O uso da plataforma não confere ao Usuário qualquer direito de propriedade intelectual sobre o conteúdo acessado. É vedada qualquer reprodução, modificação, distribuição, venda ou criação de obras derivadas sem autorização prévia e por escrito da DATAFIT.</p>\n      <p><strong>Conteúdo do Usuário:</strong> O Usuário mantém a titularidade dos dados que insere na plataforma e concede à DATAFIT licença limitada, não exclusiva e revogável para utilizá-los exclusivamente na prestação dos serviços contratados.</p>\n    </div>\n  </div>\n\n  <!-- S9 -->\n  <div class=\"section\" id=\"s9\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">09</div>\n      <h2>Disponibilidade e Suporte</h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT empregará esforços razoáveis para manter a plataforma disponível de forma estável e contínua. Todavia, não garante disponibilidade ininterrupta, podendo ocorrer indisponibilidades decorrentes de:</p>\n      <ul>\n        <li>Manutenções programadas ou emergenciais</li>\n        <li>Atualizações e melhorias da plataforma</li>\n        <li>Falhas em infraestrutura de terceiros (servidores, provedores de internet)</li>\n        <li>Casos fortuitos ou de força maior</li>\n      </ul>\n      <p>Manutenções programadas serão comunicadas com antecedência razoável pelos canais oficiais da plataforma. O suporte ao usuário é prestado pelos canais indicados no aplicativo, observados os prazos de atendimento de cada plano.</p>\n    </div>\n  </div>\n\n  <!-- S10 -->\n  <div class=\"section\" id=\"s10\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">10</div>\n      <h2>Limitação de Responsabilidade <span class=\"section-tag tag-imp\">Importante</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Na máxima extensão permitida pela legislação aplicável, a DATAFIT não será responsável por:</p>\n      <ul>\n        <li>Danos indiretos, incidentais, especiais ou consequentes decorrentes do uso ou impossibilidade de uso da plataforma</li>\n        <li>Perda de dados causada por falhas de dispositivo, conexão de internet ou condutas do próprio Usuário</li>\n        <li>Resultados de saúde, físicos ou de desempenho, baseados nas informações fornecidas pela plataforma</li>\n        <li>Conteúdo de terceiros eventualmente acessível por meio da plataforma</li>\n        <li>Danos decorrentes de uso indevido, acesso não autorizado ou violação de segurança causada por negligência do Usuário</li>\n      </ul>\n      <div class=\"box box-info\">\n        Quando a legislação não permitir a exclusão total de responsabilidade, a responsabilidade da DATAFIT ficará limitada ao valor pago pelo Usuário nos últimos 3 (três) meses de utilização do serviço.\n      </div>\n      <p>Nada nestes Termos exclui a responsabilidade da DATAFIT por dolo, fraude ou por qualquer obrigação que não possa ser excluída por lei, incluindo direitos básicos do consumidor previstos no CDC.</p>\n    </div>\n  </div>\n\n  <!-- S11 -->\n  <div class=\"section\" id=\"s11\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">11</div>\n      <h2>Suspensão e Encerramento de Conta</h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT poderá suspender ou encerrar a conta do Usuário, a qualquer momento, nas seguintes hipóteses:</p>\n      <ul>\n        <li>Violação de qualquer disposição destes Termos de Uso</li>\n        <li>Identificação de comportamento fraudulento, abusivo ou suspeito</li>\n        <li>Risco à segurança da plataforma, de outros usuários ou de terceiros</li>\n        <li>Inadimplência no pagamento de plano pago, após notificação</li>\n        <li>Determinação de autoridade competente</li>\n      </ul>\n      <p>Em casos de violação grave, a suspensão poderá ser imediata e sem aviso prévio. Nos demais casos, o Usuário será notificado pelos canais de comunicação cadastrados.</p>\n      <p><strong>Encerramento pelo Usuário:</strong> O Usuário poderá solicitar o encerramento de sua conta a qualquer momento, pelos canais de suporte da plataforma. Após a exclusão, os dados pessoais serão tratados conforme a Política de Privacidade e a LGPD.</p>\n    </div>\n  </div>\n\n  <!-- S12 -->\n  <div class=\"section\" id=\"s12\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">12</div>\n      <h2>Direitos do Titular dos Dados <span class=\"section-tag tag-lgpd\">LGPD</span></h2>\n    </div>\n    <div class=\"card\">\n      <p>Nos termos da LGPD (arts. 17 a 22), o Usuário, na qualidade de titular dos dados, possui os seguintes direitos, que podem ser exercidos a qualquer momento mediante solicitação à DATAFIT:</p>\n      <ul>\n        <li><strong>Confirmação e acesso</strong> — saber quais dados seus são tratados pela DATAFIT</li>\n        <li><strong>Correção</strong> — solicitar atualização de dados incompletos, inexatos ou desatualizados</li>\n        <li><strong>Anonimização, bloqueio ou eliminação</strong> — de dados desnecessários ou tratados em desconformidade com a LGPD</li>\n        <li><strong>Portabilidade</strong> — receber seus dados em formato interoperável</li>\n        <li><strong>Eliminação</strong> — excluir dados tratados com base no consentimento, salvo obrigação legal de retenção</li>\n        <li><strong>Revogação do consentimento</strong> — retirar o consentimento dado anteriormente, sem prejuízo do tratamento já realizado</li>\n        <li><strong>Oposição</strong> — opor-se a tratamentos realizados com base em outras hipóteses legais, em caso de descumprimento</li>\n        <li><strong>Informação sobre compartilhamento</strong> — saber com quais entidades seus dados são compartilhados</li>\n      </ul>\n      <div class=\"box box-success\">\n        As solicitações serão respondidas em até 15 (quinze) dias úteis, conforme previsto na LGPD. Utilize os canais de privacidade indicados na seção 15.\n      </div>\n    </div>\n  </div>\n\n  <!-- S13 -->\n  <div class=\"section\" id=\"s13\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">13</div>\n      <h2>Alterações nos Termos</h2>\n    </div>\n    <div class=\"card\">\n      <p>A DATAFIT reserva-se o direito de alterar estes Termos de Uso a qualquer momento, mediante comunicação prévia ao Usuário por meio de notificação no aplicativo, e-mail cadastrado ou outro canal adequado.</p>\n      <p>Alterações substanciais serão comunicadas com antecedência mínima de <strong>15 (quinze) dias</strong> antes de sua entrada em vigor. O uso continuado da plataforma após a vigência das alterações implica aceitação das novas condições.</p>\n      <p>Caso o Usuário não concorde com as alterações, poderá encerrar sua conta antes da entrada em vigor dos novos termos, sem ônus adicionais além dos já incorridos.</p>\n    </div>\n  </div>\n\n  <!-- S14 -->\n  <div class=\"section\" id=\"s14\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">14</div>\n      <h2>Legislação Aplicável e Foro</h2>\n    </div>\n    <div class=\"card\">\n      <p>Estes Termos de Uso são regidos e interpretados de acordo com as leis da <strong>República Federativa do Brasil</strong>, especialmente:</p>\n      <ul>\n        <li>Lei Geral de Proteção de Dados (LGPD — Lei 13.709/2018)</li>\n        <li>Código de Defesa do Consumidor (CDC — Lei 8.078/1990)</li>\n        <li>Marco Civil da Internet (Lei 12.965/2014)</li>\n        <li>Código Civil Brasileiro (Lei 10.406/2002)</li>\n      </ul>\n      <p>Fica eleito o foro da comarca do domicílio do Usuário para dirimir quaisquer controvérsias decorrentes destes Termos, nos termos do art. 101, I do CDC, salvo disposição legal imperativa em contrário.</p>\n    </div>\n  </div>\n\n  <!-- S15 -->\n  <div class=\"section\" id=\"s15\">\n    <div class=\"section-header\">\n      <div class=\"section-num-badge\">15</div>\n      <h2>Contato e Canal de Privacidade</h2>\n    </div>\n    <div class=\"card\">\n      <p>Para dúvidas, solicitações relacionadas aos seus dados pessoais (exercício de direitos LGPD) ou qualquer questão sobre estes Termos, o Usuário poderá entrar em contato pelos <strong>canais oficiais da DATAFIT</strong> disponíveis no aplicativo.</p>\n      <p>A DATAFIT designou um <strong>Encarregado de Proteção de Dados (DPO)</strong>, conforme exigido pela LGPD (art. 41), cujo contato está disponível na seção de privacidade do aplicativo.</p>\n      <div class=\"box box-success\">\n        Comprometemo-nos a responder todas as solicitações relacionadas à privacidade e proteção de dados no prazo máximo de 15 (quinze) dias úteis.\n      </div>\n    </div>\n  </div>\n\n  <div class=\"divider\"></div>\n\n  <div class=\"footer\">\n    <p><strong>DATAFIT</strong> — Plataforma de Gestão Corporativa e Fitness</p>\n    <p>Versão 1.0 — Vigente a partir de 29/04/2026</p>\n    <p>Ao continuar utilizando a plataforma, você confirma que leu, compreendeu e concorda integralmente com estes Termos de Uso.</p>\n  </div>\n\n</div>\n</body>\n</html>',
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

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ajuda_model.dart';
export 'ajuda_model.dart';

class AjudaWidget extends StatefulWidget {
  const AjudaWidget({super.key});

  static String routeName = 'ajuda';
  static String routePath = '/ajuda';

  @override
  State<AjudaWidget> createState() => _AjudaWidgetState();
}

class _AjudaWidgetState extends State<AjudaWidget> {
  late AjudaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AjudaModel());

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
                                                    'Dúvidas Frequentes',
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
                                          '<!DOCTYPE html>\n<html lang=\"pt-br\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\">\n<title>FAQ — DATAFIT</title>\n<link href=\"https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap\" rel=\"stylesheet\">\n<style>\n  a { pointer-events: none; cursor: default; }\n  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }\n\n  body {\n    background: #fdfdfd;\n    color: #181818;\n    font-family: \'DM Sans\', sans-serif;\n    font-size: 15px;\n    line-height: 1.7;\n    -webkit-font-smoothing: antialiased;\n  }\n\n  .page {\n    max-width: 680px;\n    margin: 0 auto;\n    padding: 32px 20px 60px;\n  }\n\n  .header {\n    margin-bottom: 32px;\n    padding-bottom: 24px;\n    border-bottom: 1px solid #e4e4e4;\n  }\n\n  .badge {\n    display: inline-flex;\n    align-items: center;\n    gap: 6px;\n    font-size: 11px;\n    font-weight: 500;\n    letter-spacing: 0.06em;\n    text-transform: uppercase;\n    padding: 4px 12px;\n    border-radius: 99px;\n    background: #eaf4fc;\n    color: #1b98e0;\n    border: 1px solid #c2e0f5;\n    margin-bottom: 14px;\n  }\n\n  .badge-dot {\n    width: 6px;\n    height: 6px;\n    border-radius: 50%;\n    background: #1b98e0;\n  }\n\n  h1 {\n    font-size: 26px;\n    font-weight: 600;\n    color: #181818;\n    letter-spacing: -0.5px;\n    margin-bottom: 8px;\n  }\n\n  .header-desc {\n    font-size: 13px;\n    color: #828282;\n    line-height: 1.65;\n  }\n\n  /* CATEGORIAS */\n  .category {\n    margin-bottom: 28px;\n  }\n\n  .category-label {\n    font-size: 11px;\n    font-weight: 500;\n    letter-spacing: 0.08em;\n    text-transform: uppercase;\n    color: #828282;\n    margin-bottom: 10px;\n    padding-left: 2px;\n  }\n\n  /* ACCORDION */\n  .faq-item {\n    background: #ffffff;\n    border: 1px solid #e4e4e4;\n    border-radius: 12px;\n    margin-bottom: 8px;\n    overflow: hidden;\n  }\n\n  .faq-question {\n    width: 100%;\n    background: none;\n    border: none;\n    padding: 16px 18px;\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n    gap: 12px;\n    cursor: pointer;\n    text-align: left;\n    font-family: \'DM Sans\', sans-serif;\n    font-size: 14px;\n    font-weight: 500;\n    color: #181818;\n    line-height: 1.4;\n  }\n\n  .faq-icon {\n    width: 20px;\n    height: 20px;\n    border-radius: 6px;\n    background: #f2f4f7;\n    border: 1px solid #e4e4e4;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    flex-shrink: 0;\n    transition: background 0.2s;\n  }\n\n  .faq-icon svg {\n    width: 10px;\n    height: 10px;\n    transition: transform 0.25s;\n  }\n\n  .faq-item.open .faq-icon {\n    background: #eaf4fc;\n    border-color: #c2e0f5;\n  }\n\n  .faq-item.open .faq-icon svg {\n    transform: rotate(45deg);\n  }\n\n  .faq-item.open .faq-icon svg path {\n    stroke: #1b98e0;\n  }\n\n  .faq-answer {\n    max-height: 0;\n    overflow: hidden;\n    transition: max-height 0.3s ease, padding 0.2s ease;\n  }\n\n  .faq-answer-inner {\n    padding: 0 18px 16px;\n    font-size: 13.5px;\n    color: #828282;\n    line-height: 1.7;\n    border-top: 1px solid #f2f4f7;\n    padding-top: 14px;\n  }\n\n  .faq-answer-inner strong { color: #181818; font-weight: 500; }\n\n  .faq-answer-inner a {\n    color: #1b98e0;\n    text-decoration: none;\n  }\n\n  .divider {\n    height: 1px;\n    background: #e4e4e4;\n    margin: 32px 0;\n  }\n\n  .footer {\n    text-align: center;\n    font-size: 12px;\n    color: #828282;\n    line-height: 1.9;\n  }\n\n  .footer strong { color: #181818; font-weight: 500; }\n\n  .contact-box {\n    background: #eaf4fc;\n    border: 1px solid #c2e0f5;\n    border-radius: 12px;\n    padding: 16px 20px;\n    text-align: center;\n    margin-top: 8px;\n  }\n\n  .contact-box p {\n    font-size: 13px;\n    color: #1b98e0;\n    line-height: 1.6;\n  }\n\n  .contact-box strong { color: #1b98e0; font-weight: 600; }\n</style>\n</head>\n<body>\n<div class=\"page\">\n\n  <div class=\"header\">\n    <div class=\"badge\">\n      <span class=\"badge-dot\"></span>\n      Perguntas frequentes\n    </div>\n    <h1>FAQ</h1>\n    <p class=\"header-desc\">Encontre respostas rápidas sobre a DATAFIT. Toque em cada pergunta para expandir.</p>\n  </div>\n\n  <!-- CATEGORIA: CONTA -->\n  <div class=\"category\">\n    <div class=\"category-label\">Conta</div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Como crio minha conta na DATAFIT?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Baixe o aplicativo, toque em <strong>Criar conta</strong> e preencha seu nome, e-mail e senha. Você também pode entrar com sua conta Google ou Apple. Pronto, é gratuito e leva menos de 1 minuto.\n        </div>\n      </div>\n    </div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Esqueci minha senha. Como recupero?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Na tela de login, toque em <strong>Esqueci minha senha</strong>. Enviaremos um link de redefinição para o e-mail cadastrado. Verifique também a pasta de spam caso não receba em alguns minutos.\n        </div>\n      </div>\n    </div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Como excluo minha conta?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Acesse <strong>Configurações &gt; Conta &gt; Excluir conta</strong>. Seus dados serão removidos em até 90 dias, conforme nossa Política de Privacidade. Assinaturas ativas precisam ser canceladas antes da exclusão.\n        </div>\n      </div>\n    </div>\n  </div>\n\n  <!-- CATEGORIA: PLANOS -->\n  <div class=\"category\">\n    <div class=\"category-label\">Planos e pagamento</div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Qual a diferença entre o plano Free e o PRO?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          O plano <strong>Free</strong> dá acesso às funcionalidades básicas de monitoramento. O <strong>PRO</strong> libera recursos completos: relatórios avançados, histórico ilimitado, exportação de dados e suporte prioritário. Confira a comparação completa na seção de Planos do app.\n        </div>\n      </div>\n    </div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Como cancelo minha assinatura PRO?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          O cancelamento é feito diretamente pela loja onde você assinou: <strong>Google Play</strong> (Assinaturas) ou <strong>App Store</strong> (Gerenciar assinaturas). Após o cancelamento, o acesso PRO permanece até o fim do período pago.\n        </div>\n      </div>\n    </div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Tenho direito a reembolso?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Sim. Pelo Código de Defesa do Consumidor, você pode solicitar reembolso integral em até <strong>7 dias corridos</strong> após a contratação. Após esse prazo, o acesso segue até o fim do ciclo e não há reembolso proporcional.\n        </div>\n      </div>\n    </div>\n  </div>\n\n  <!-- CATEGORIA: DADOS -->\n  <div class=\"category\">\n    <div class=\"category-label\">Dados e privacidade</div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Meus dados de saúde são compartilhados com terceiros?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Não. A DATAFIT <strong>nunca vende ou compartilha dados de saúde</strong> com anunciantes ou terceiros não essenciais. Os dados são usados exclusivamente para gerar seus relatórios e métricas dentro do app.\n        </div>\n      </div>\n    </div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Como solicito a exclusão dos meus dados?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Acesse <strong>Configurações &gt; Privacidade &gt; Meus dados</strong> e solicite a exclusão. Respondemos em até 15 dias úteis, conforme a LGPD. Dados fiscais podem ser mantidos por até 5 anos por obrigação legal.\n        </div>\n      </div>\n    </div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        O app é seguro? Como meus dados são protegidos?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Sim. Usamos <strong>criptografia TLS</strong> em todas as comunicações e criptografia em repouso nos servidores. Senhas são armazenadas em hash e nunca em texto simples. Para mais detalhes, consulte nossa Política de Privacidade e Segurança.\n        </div>\n      </div>\n    </div>\n  </div>\n\n  <!-- CATEGORIA: USO -->\n  <div class=\"category\">\n    <div class=\"category-label\">Uso do app</div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        O app funciona sem internet?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          Algumas funcionalidades básicas podem ser usadas offline, mas o sincronismo de dados, relatórios e o acesso completo exigem conexão à internet. Os dados inseridos offline são sincronizados automaticamente quando a conexão é restabelecida.\n        </div>\n      </div>\n    </div>\n\n    <div class=\"faq-item\">\n      <button class=\"faq-question\">\n        Em quais dispositivos posso usar a DATAFIT?\n        <span class=\"faq-icon\">\n          <svg viewBox=\"0 0 10 10\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\n            <path d=\"M5 1V9M1 5H9\" stroke=\"#828282\" stroke-width=\"1.5\" stroke-linecap=\"round\"/>\n          </svg>\n        </span>\n      </button>\n      <div class=\"faq-answer\">\n        <div class=\"faq-answer-inner\">\n          A DATAFIT está disponível para <strong>Android</strong> (versão 8.0 ou superior) e <strong>iOS</strong> (versão 14 ou superior). Sua conta é sincronizada automaticamente entre dispositivos com o mesmo login.\n        </div>\n      </div>\n    </div>\n  </div>\n\n  <!-- CONTATO -->\n  <div class=\"contact-box\">\n    <p>Não encontrou o que precisava?<br><strong>Fale com a gente</strong> pelos canais de suporte disponíveis no app.</p>\n  </div>\n\n  <div class=\"divider\"></div>\n\n  <div class=\"footer\">\n    <p><strong>DATAFIT</strong> — Plataforma de Gestão Corporativa e Fitness</p>\n    <p>Dúvidas adicionais? Acesse o suporte dentro do aplicativo.</p>\n  </div>\n\n</div>\n\n<script>\n  document.querySelectorAll(\'.faq-question\').forEach(function(btn) {\n    btn.addEventListener(\'click\', function() {\n      var item = this.parentElement;\n      var answer = item.querySelector(\'.faq-answer\');\n      var isOpen = item.classList.contains(\'open\');\n\n      document.querySelectorAll(\'.faq-item\').forEach(function(el) {\n        el.classList.remove(\'open\');\n        el.querySelector(\'.faq-answer\').style.maxHeight = \'0\';\n      });\n\n      if (!isOpen) {\n        item.classList.add(\'open\');\n        answer.style.maxHeight = answer.scrollHeight + \'px\';\n      }\n    });\n  });\n</script>\n</body>\n</html>',
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

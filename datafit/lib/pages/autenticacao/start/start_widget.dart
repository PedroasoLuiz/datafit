/// Tela de entrada do app (rota `/` para quem não está logado, e `/start`).
///
/// Antes esta página era só um splash: mostrava o logo por 10 segundos e
/// empurrava o login sozinha. Quem era novo caía direto no formulário de login
/// e tinha que achar o "Cadastre-se" pequeno no rodapé.
///
/// Agora ela pergunta antes de qualquer formulário. Continua sendo a primeira
/// tela — não é uma etapa a mais no caminho.
///
/// Chegou a ter manchas azuis desfocadas com uma folha de vidro
/// (`BackdropFilter`) por cima. Foi retirado a pedido: o `BackdropFilter` em
/// tela cheia força um `saveLayer` da tela inteira a cada frame e pesava no
/// emulador. O fundo agora é branco liso.
library;

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'start_model.dart';
export 'start_model.dart';

class StartWidget extends StatefulWidget {
  const StartWidget({super.key});

  static String routeName = 'start';
  static String routePath = '/start';

  @override
  State<StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget>
    with TickerProviderStateMixin {
  late StartModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  /// Saudação pelo horário do aparelho.
  ///
  /// Aqui é o relógio local mesmo, não o timezone do banco: a saudação fala do
  /// momento de quem está segurando o celular.
  String get _saudacao {
    final hora = DateTime.now().hour;
    if (hora < 12) {
      return 'Bom dia';
    } else if (hora < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StartModel());

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'contentOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeOutCubic,
            delay: 120.0.ms,
            duration: 550.0.ms,
            begin: Offset(0.0, 28.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 120.0.ms,
            duration: 550.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _irPara(String routeName) {
    context.pushNamed(
      routeName,
      extra: <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: Duration(milliseconds: 200),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: tema.primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                  child: Image.asset(
                    'assets/images/logodatafitazul.png',
                    width: 152.0,
                    height: 36.0,
                    fit: BoxFit.contain,
                    alignment: AlignmentDirectional(-1.0, 0.0),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation']!),
                ),
                Expanded(child: SizedBox()),
                // Saudação, pergunta e botões andam juntos no rodapé — é o que
                // mantém o "Boa noite" perto dos botões sem depender de
                // espaçamento chutado.
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _saudacao,
                      style: tema.displaySmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontStyle: tema.displaySmall.fontStyle,
                        ),
                        color: tema.primaryText,
                        fontSize: 32.0,
                        letterSpacing: -0.8,
                        fontWeight: FontWeight.w700,
                        fontStyle: tema.displaySmall.fontStyle,
                        lineHeight: 1.1,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: Text(
                        'Você já possui conta cadastrada ou é novo por aqui?',
                        style: tema.bodyLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontStyle: tema.bodyLarge.fontStyle,
                          ),
                          color: tema.secondaryText,
                          fontSize: 15.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: tema.bodyLarge.fontStyle,
                          lineHeight: 1.45,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 26.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          _irPara(LoginWidget.routeName);
                        },
                        text: 'Já tenho conta',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: tema.primary,
                          textStyle: tema.titleSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: tema.titleSmall.fontStyle,
                            ),
                            color: Colors.white,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: tema.titleSmall.fontStyle,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          _irPara(CadastroWidget.routeName);
                        },
                        text: 'Sou novo por aqui',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: tema.primaryBackground,
                          textStyle: tema.titleSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: tema.titleSmall.fontStyle,
                            ),
                            color: tema.primaryText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: tema.titleSmall.fontStyle,
                          ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: tema.alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ],
                ).animateOnPageLoad(
                    animationsMap['contentOnPageLoadAnimation']!),
                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

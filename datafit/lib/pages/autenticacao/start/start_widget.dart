import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StartModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 10000,
        ),
      );

      context.pushNamed(LoginWidget.routeName);
    });

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 960.0.ms,
            begin: Offset(-5.0, -5.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 100.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 200.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 300.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 400.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 700.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 500.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 500.0.ms,
            duration: 800.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 600.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 900.0.ms,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (responsiveVisibility(
                  context: context,
                  phone: false,
                  tablet: false,
                  tabletLandscape: false,
                  desktop: false,
                ))
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/datafit.png',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation']!),
                if (responsiveVisibility(
                  context: context,
                  phone: false,
                  tablet: false,
                  tabletLandscape: false,
                  desktop: false,
                ))
                  FlutterFlowWebView(
                    content:
                        '<!DOCTYPE html>\n<html lang=\"pt-BR\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<title>datafit</title>\n<style>\n@import url(\'https://fonts.cdnfonts.com/css/ibrand\');\n\n*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }\n\nhtml, body {\n  width: 100%; height: 100%;\n  background: #2E9DD4;\n  overflow: hidden;\n  display: flex;\n  align-items: center;\n  justify-content: center;\n  font-family: \'IBrand\', sans-serif;\n}\n\n/* ─────────────────────────────────────────\n   FUNDO: barras de histograma de treino\n   sobem da base como num gráfico de carga\n───────────────────────────────────────── */\n.bars-canvas {\n  position: fixed;\n  inset: 0;\n  display: flex;\n  align-items: flex-end;\n  justify-content: center;\n  gap: clamp(3px, 0.5vw, 5px);\n  padding: 0 clamp(12px, 3vw, 40px);\n  pointer-events: none;\n  opacity: 0.12;\n}\n\n.bar {\n  flex: 1;\n  max-width: 16px;\n  background: #ffffff;\n  border-radius: 3px 3px 0 0;\n  transform-origin: bottom;\n  transform: scaleY(0);\n  animation: barRise 0.55s cubic-bezier(0.16, 1, 0.3, 1) both;\n}\n\n.bar:nth-child(1)  { height: 15%; animation-delay: 0.04s; }\n.bar:nth-child(2)  { height: 28%; animation-delay: 0.07s; }\n.bar:nth-child(3)  { height: 42%; animation-delay: 0.10s; }\n.bar:nth-child(4)  { height: 60%; animation-delay: 0.13s; }\n.bar:nth-child(5)  { height: 75%; animation-delay: 0.16s; }\n.bar:nth-child(6)  { height: 90%; animation-delay: 0.19s; }\n.bar:nth-child(7)  { height: 100%;animation-delay: 0.22s; }\n.bar:nth-child(8)  { height: 88%; animation-delay: 0.25s; }\n.bar:nth-child(9)  { height: 72%; animation-delay: 0.28s; }\n.bar:nth-child(10) { height: 55%; animation-delay: 0.31s; }\n.bar:nth-child(11) { height: 78%; animation-delay: 0.34s; }\n.bar:nth-child(12) { height: 95%; animation-delay: 0.37s; }\n.bar:nth-child(13) { height: 100%;animation-delay: 0.40s; }\n.bar:nth-child(14) { height: 85%; animation-delay: 0.43s; }\n.bar:nth-child(15) { height: 65%; animation-delay: 0.46s; }\n.bar:nth-child(16) { height: 50%; animation-delay: 0.49s; }\n.bar:nth-child(17) { height: 35%; animation-delay: 0.52s; }\n.bar:nth-child(18) { height: 20%; animation-delay: 0.55s; }\n.bar:nth-child(19) { height: 12%; animation-delay: 0.58s; }\n.bar:nth-child(20) { height:  8%; animation-delay: 0.61s; }\n\n@keyframes barRise { to { transform: scaleY(1); } }\n\n/* ─────────────────────────────────────────\n   VINHETA para não competir com o logo\n───────────────────────────────────────── */\n.vignette {\n  position: fixed;\n  inset: 0;\n  background: radial-gradient(ellipse at center, rgba(46,157,212,0.0) 30%, rgba(18,80,115,0.55) 100%);\n  pointer-events: none;\n  z-index: 2;\n}\n\n/* ─────────────────────────────────────────\n   HALTERE — top left\n   balança como uma rep de treino\n───────────────────────────────────────── */\n.dumbbell-wrap {\n  position: fixed;\n  top: clamp(22px, 4vh, 44px);\n  left: clamp(22px, 4vw, 50px);\n  z-index: 5;\n  opacity: 0;\n  animation: itemIn 0.5s ease 1.0s forwards;\n}\n\n.dumbbell-svg {\n  width: clamp(52px, 8vw, 72px);\n  opacity: 0.22;\n  transform-origin: center center;\n  animation: dumbbellCurl 2.4s ease-in-out 1.3s infinite alternate;\n}\n\n@keyframes dumbbellCurl {\n  0%   { transform: rotate(-14deg) translateY(0px);  }\n  100% { transform: rotate(10deg)  translateY(-5px); }\n}\n\n/* ─────────────────────────────────────────\n   RUNNER — bottom right\n   figura humana minimalista em corrida\n───────────────────────────────────────── */\n.runner-wrap {\n  position: fixed;\n  bottom: clamp(18px, 4vh, 44px);\n  right: clamp(22px, 4vw, 52px);\n  z-index: 5;\n  opacity: 0;\n  animation: itemIn 0.5s ease 1.2s forwards;\n  display: flex;\n  flex-direction: column;\n  align-items: center;\n}\n\n.runner-svg {\n  width: clamp(52px, 8vw, 74px);\n  opacity: 0.2;\n}\n\n/* tronco se inclina alternado — stride */\n.r-body {\n  transform-origin: 30px 30px;\n  animation: runLean 0.72s ease-in-out 1.4s infinite alternate;\n}\n\n@keyframes runLean {\n  0%   { transform: rotate(-5deg); }\n  100% { transform: rotate(6deg);  }\n}\n\n.r-leg-f {\n  transform-origin: 30px 44px;\n  animation: legF 0.72s ease-in-out 1.4s infinite alternate;\n}\n\n.r-leg-b {\n  transform-origin: 30px 44px;\n  animation: legB 0.72s ease-in-out 1.4s infinite alternate;\n}\n\n.r-arm-f {\n  transform-origin: 30px 26px;\n  animation: armF 0.72s ease-in-out 1.4s infinite alternate;\n}\n\n.r-arm-b {\n  transform-origin: 30px 26px;\n  animation: armB 0.72s ease-in-out 1.4s infinite alternate;\n}\n\n@keyframes legF  { 0% { transform: rotate(-28deg); } 100% { transform: rotate(32deg); } }\n@keyframes legB  { 0% { transform: rotate(28deg);  } 100% { transform: rotate(-32deg);} }\n@keyframes armF  { 0% { transform: rotate(28deg);  } 100% { transform: rotate(-22deg);} }\n@keyframes armB  { 0% { transform: rotate(-28deg); } 100% { transform: rotate(22deg); } }\n\n/* sombra no chão pulsa com a passada */\n.runner-shadow {\n  width: 34px;\n  height: 4px;\n  border-radius: 50%;\n  background: rgba(0,0,0,0.15);\n  margin-top: -2px;\n  animation: shadowRun 0.72s ease-in-out 1.4s infinite alternate;\n}\n\n@keyframes shadowRun {\n  0%   { transform: scaleX(1.1);  opacity: 0.5; }\n  100% { transform: scaleX(0.75); opacity: 0.25;}\n}\n\n/* ─────────────────────────────────────────\n   GOTAS — top right\n───────────────────────────────────────── */\n.sweat-wrap {\n  position: fixed;\n  top: clamp(22px, 4vh, 44px);\n  right: clamp(22px, 4vw, 50px);\n  z-index: 5;\n  display: flex;\n  gap: 5px;\n  align-items: flex-end;\n  opacity: 0;\n  animation: itemIn 0.5s ease 2.2s forwards;\n}\n\n.drop {\n  background: rgba(255,255,255,0.38);\n  border-radius: 50% 50% 40% 40% / 55% 55% 45% 45%;\n  animation: sweatDrop 1.8s ease-in-out infinite;\n}\n\n.drop:nth-child(1) { width: 6px;  height: 9px;  animation-delay: 0s;    }\n.drop:nth-child(2) { width: 5px;  height: 7px;  animation-delay: 0.45s; }\n.drop:nth-child(3) { width: 4px;  height: 5px;  animation-delay: 0.9s;  }\n\n@keyframes sweatDrop {\n  0%   { transform: translateY(0)   scale(1);    opacity: 0.9; }\n  50%  { transform: translateY(10px) scale(0.85); opacity: 0.35;}\n  100% { transform: translateY(0)   scale(1);    opacity: 0.9; }\n}\n\n@keyframes itemIn { to { opacity: 1; } }\n\n/* ─────────────────────────────────────────\n   CENTRO: logo + linha + palavras + barra\n───────────────────────────────────────── */\n.center {\n  position: relative;\n  z-index: 10;\n  display: flex;\n  flex-direction: column;\n  align-items: center;\n}\n\n/* Logo */\n.logo {\n  display: flex;\n  align-items: baseline;\n  opacity: 0;\n  transform: translateY(18px) scale(0.94);\n  animation: logoIn 0.85s cubic-bezier(0.16, 1, 0.3, 1) 0.8s forwards;\n}\n\n.logo-data {\n  color: #ffffff;\n  font-size: clamp(58px, 11.5vw, 90px);\n  font-weight: 400;\n  letter-spacing: -2px;\n  line-height: 1;\n}\n\n.logo-fit {\n  color: #111820;\n  font-size: clamp(58px, 11.5vw, 90px);\n  font-weight: 700;\n  letter-spacing: -2px;\n  line-height: 1;\n}\n\n@keyframes logoIn {\n  to { opacity: 1; transform: translateY(0) scale(1); }\n}\n\n/* Linha divisória */\n.divider {\n  width: 0;\n  height: 1.5px;\n  background: rgba(255,255,255,0.30);\n  border-radius: 2px;\n  margin-top: 16px;\n  animation: lineGrow 0.65s ease 1.65s forwards;\n}\n\n@keyframes lineGrow {\n  to { width: clamp(150px, 32vw, 240px); }\n}\n\n/* Palavras rotativas */\n.words-wrap {\n  margin-top: 13px;\n  height: 20px;\n  overflow: hidden;\n  opacity: 0;\n  animation: itemIn 0.4s ease 1.9s forwards;\n}\n\n.words-inner {\n  display: flex;\n  flex-direction: column;\n  /* 4 frases × 20px = 80px por ciclo */\n  animation: cycleWords 8s cubic-bezier(0.4, 0, 0.2, 1) 2.1s infinite;\n}\n\n.word {\n  height: 20px;\n  line-height: 20px;\n  text-align: center;\n  font-size: clamp(9px, 1.6vw, 11px);\n  letter-spacing: 0.28em;\n  text-transform: uppercase;\n  color: rgba(255,255,255,0.60);\n  font-family: \'IBrand\', sans-serif;\n  font-weight: 400;\n  white-space: nowrap;\n}\n\n@keyframes cycleWords {\n  0%        { transform: translateY(0);    }\n  18%       { transform: translateY(0);    }\n  25%       { transform: translateY(-20px);}\n  43%       { transform: translateY(-20px);}\n  50%       { transform: translateY(-40px);}\n  68%       { transform: translateY(-40px);}\n  75%       { transform: translateY(-60px);}\n  93%       { transform: translateY(-60px);}\n  100%      { transform: translateY(0);    }\n}\n\n/* Barra de progresso */\n.progress-wrap {\n  margin-top: 30px;\n  width: clamp(90px, 18vw, 140px);\n  height: 2px;\n  background: rgba(255,255,255,0.18);\n  border-radius: 99px;\n  overflow: hidden;\n  opacity: 0;\n  animation: itemIn 0.4s ease 2.1s forwards;\n}\n\n.progress-fill {\n  height: 100%;\n  width: 0%;\n  background: rgba(255,255,255,0.75);\n  border-radius: 99px;\n  animation: loadFill 2.2s cubic-bezier(0.25, 1, 0.5, 1) 2.2s forwards;\n}\n\n@keyframes loadFill { to { width: 100%; } }\n</style>\n</head>\n<body>\n\n<!-- histograma de carga no fundo -->\n<div class=\"bars-canvas\" aria-hidden=\"true\">\n  <div class=\"bar\"></div><div class=\"bar\"></div><div class=\"bar\"></div>\n  <div class=\"bar\"></div><div class=\"bar\"></div><div class=\"bar\"></div>\n  <div class=\"bar\"></div><div class=\"bar\"></div><div class=\"bar\"></div>\n  <div class=\"bar\"></div><div class=\"bar\"></div><div class=\"bar\"></div>\n  <div class=\"bar\"></div><div class=\"bar\"></div><div class=\"bar\"></div>\n  <div class=\"bar\"></div><div class=\"bar\"></div><div class=\"bar\"></div>\n  <div class=\"bar\"></div><div class=\"bar\"></div>\n</div>\n\n<div class=\"vignette\"></div>\n\n<!-- haltere top left -->\n<div class=\"dumbbell-wrap\" aria-hidden=\"true\">\n  <svg class=\"dumbbell-svg\" viewBox=\"0 0 90 32\" fill=\"none\">\n    <rect x=\"0\"  y=\"8\"  width=\"12\" height=\"16\" rx=\"2.5\" fill=\"white\"/>\n    <rect x=\"12\" y=\"12\" width=\"7\"  height=\"8\"  rx=\"1.5\" fill=\"white\"/>\n    <rect x=\"19\" y=\"14\" width=\"52\" height=\"4\"  rx=\"2\"   fill=\"white\"/>\n    <rect x=\"71\" y=\"12\" width=\"7\"  height=\"8\"  rx=\"1.5\" fill=\"white\"/>\n    <rect x=\"78\" y=\"8\"  width=\"12\" height=\"16\" rx=\"2.5\" fill=\"white\"/>\n  </svg>\n</div>\n\n<!-- gotas top right -->\n<div class=\"sweat-wrap\" aria-hidden=\"true\">\n  <div class=\"drop\"></div>\n  <div class=\"drop\"></div>\n  <div class=\"drop\"></div>\n</div>\n\n<!-- runner bottom right -->\n<div class=\"runner-wrap\" aria-hidden=\"true\">\n  <svg class=\"runner-svg\" viewBox=\"0 0 60 82\" fill=\"none\">\n    <g class=\"r-body\">\n      <circle cx=\"30\" cy=\"8\" r=\"7\" fill=\"white\"/>\n      <line x1=\"30\" y1=\"15\" x2=\"30\" y2=\"44\" stroke=\"white\" stroke-width=\"4.5\" stroke-linecap=\"round\"/>\n      <g class=\"r-arm-b\">\n        <line x1=\"30\" y1=\"24\" x2=\"15\" y2=\"36\" stroke=\"white\" stroke-width=\"3.5\" stroke-linecap=\"round\"/>\n      </g>\n      <g class=\"r-arm-f\">\n        <line x1=\"30\" y1=\"24\" x2=\"45\" y2=\"34\" stroke=\"white\" stroke-width=\"3.5\" stroke-linecap=\"round\"/>\n      </g>\n      <g class=\"r-leg-b\">\n        <line x1=\"30\" y1=\"44\" x2=\"17\" y2=\"64\" stroke=\"white\" stroke-width=\"4\" stroke-linecap=\"round\"/>\n        <line x1=\"17\" y1=\"64\" x2=\"10\" y2=\"78\" stroke=\"white\" stroke-width=\"3\" stroke-linecap=\"round\"/>\n      </g>\n      <g class=\"r-leg-f\">\n        <line x1=\"30\" y1=\"44\" x2=\"43\" y2=\"62\" stroke=\"white\" stroke-width=\"4\" stroke-linecap=\"round\"/>\n        <line x1=\"43\" y1=\"62\" x2=\"52\" y2=\"75\" stroke=\"white\" stroke-width=\"3\" stroke-linecap=\"round\"/>\n      </g>\n    </g>\n  </svg>\n  <div class=\"runner-shadow\"></div>\n</div>\n\n<!-- CENTRO -->\n<div class=\"center\">\n  <div class=\"logo\">\n    <span class=\"logo-data\">data</span><span class=\"logo-fit\">fit</span>\n  </div>\n\n  <div class=\"divider\"></div>\n\n  <div class=\"words-wrap\">\n    <div class=\"words-inner\">\n      <div class=\"word\">treine mais forte</div>\n      <div class=\"word\">evolua com dados</div>\n      <div class=\"word\">supere seus limites</div>\n      <div class=\"word\">seu corpo, seus números</div>\n      <!-- repete pra fechar o loop sem salto -->\n      <div class=\"word\">treine mais forte</div>\n    </div>\n  </div>\n\n  <div class=\"progress-wrap\">\n    <div class=\"progress-fill\"></div>\n  </div>\n</div>\n\n</body>\n</html>',
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    verticalScroll: false,
                    horizontalScroll: false,
                    html: true,
                  ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                32.0, 0.0, 32.0, 0.0),
                            child: Image.asset(
                              'assets/images/logodatafitbranca.png',
                              width: 240.0,
                              height: 66.0,
                              fit: BoxFit.contain,
                              alignment: Alignment(0.0, 0.0),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation']!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';
import 'auth/recuperacao_senha.dart';

import '/backend/supabase/supabase.dart';
import '/backend/push/servico_push.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await SupaFlow.initialize();

  // Sem `await`: subir o Firebase custa algumas centenas de milissegundos e,
  // esperado aqui, esse custo virava tela parada antes do primeiro quadro —
  // eram os quadros perdidos na abertura. A subida corre em paralelo, e quem
  // depende dela (`registrarUsuario`, depois do login) a aguarda por dentro.
  //
  // Sai em silencio se as credenciais do Firebase nao estiverem preenchidas
  // — o app roda igual sem push. Ver `lib/backend/push/config_push.dart`.
  unawaited(ServicoPush.iniciar());

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  final cupertino_time_picker_hiuzb7AppState =
      cupertino_time_picker_hiuzb7_app_state.FFAppState();
  await cupertino_time_picker_hiuzb7AppState.initializePersistedState();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => appState,
      ),
      ChangeNotifierProvider(
        create: (context) => cupertino_time_picker_hiuzb7AppState,
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.path;
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = datafitSupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});

    SupaFlow.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        // Liga o portao antes de navegar.
        //
        // Era `pushNamed`, e a tela de nova senha ficava empilhada por cima de
        // um app que o roteador ja tinha aberto por baixo: bastava fechar ela
        // para estar logado sem ter trocado senha. Com o portao ligado o
        // roteador nao tem para onde levar a pessoa, e o `goNamed` nao deixa
        // nada embaixo. Ver `auth/recuperacao_senha.dart`.
        iniciarRecuperacaoDeSenha(data.session?.user.id);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _router.goNamed(
            ResetSenhaWidget.routeName,
            queryParameters: {
              'email': data.session?.user.email ?? '',
            },
          );
        });
      }
    });

    // Troca de senha interrompida na vez anterior.
    //
    // A sessao do link fica gravada no aparelho, entao matar o app no meio do
    // caminho deixava a pessoa dentro da conta sem ter escolhido senha. A
    // pendencia tambem e gravada, e aqui ela volta a valer.
    restaurarRecuperacaoPendente(SupaFlow.client.auth.currentUser?.id)
        .then((pendente) {
      if (!pendente) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _router.goNamed(
          ResetSenhaWidget.routeName,
          queryParameters: {
            'email': SupaFlow.client.auth.currentUser?.email ?? '',
          },
        );
      });
    });
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'datafit',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(
          interactive: true,
        ),
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

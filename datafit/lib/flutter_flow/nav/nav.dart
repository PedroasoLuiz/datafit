import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/backend/supabase/supabase.dart';

import '/auth/base_auth_user_provider.dart';
import '/auth/recuperacao_senha.dart';

import '/main.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:ff_commons/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';
import '/pages/components/navbar/navbar_widget.dart';

import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/index.dart'
    as $cupertino_time_picker_hiuzb7;

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) {
  $cupertino_time_picker_hiuzb7.initializeRoutes(
    homePageWidgetName: 'cupertino_time_picker_hiuzb7.HomePage',
    homePageWidgetPath: '/homePage',
  );

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: appStateNotifier,
    navigatorKey: appNavigatorKey,
    errorBuilder: (context, state) =>
        appStateNotifier.loggedIn ? LoadingWidget() : StartWidget(),
    routes: _montaRotas(appStateNotifier, [
      FFRoute(
        name: '_initialize',
        path: '/',
        builder: (context, _) =>
            appStateNotifier.loggedIn ? LoadingWidget() : StartWidget(),
      ),
      FFRoute(
        name: StartWidget.routeName,
        path: StartWidget.routePath,
        builder: (context, params) => StartWidget(),
      ),
      FFRoute(
        name: LoginWidget.routeName,
        path: LoginWidget.routePath,
        builder: (context, params) => LoginWidget(),
      ),
      FFRoute(
        name: CadastroWidget.routeName,
        path: CadastroWidget.routePath,
        builder: (context, params) => CadastroWidget(),
      ),
      FFRoute(
        name: RecuperarsenhaWidget.routeName,
        path: RecuperarsenhaWidget.routePath,
        builder: (context, params) => RecuperarsenhaWidget(
          email: params.getParam(
            'email',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: LoadingWidget.routeName,
        path: LoadingWidget.routePath,
        builder: (context, params) => LoadingWidget(),
      ),
      FFRoute(
        name: PerfilpersonalWidget.routeName,
        path: PerfilpersonalWidget.routePath,
        builder: (context, params) => PerfilpersonalWidget(
          perosnal: params.getParam(
            'perosnal',
            ParamType.DataStruct,
            isList: false,
            structBuilder: PerfilPersonalStruct.fromSerializableMap,
          ),
        ),
      ),
      FFRoute(
        name: PerfilalunoWidget.routeName,
        path: PerfilalunoWidget.routePath,
        builder: (context, params) => PerfilalunoWidget(
          alunoId: params.getParam(
            'alunoId',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: PerfilWidget.routeName,
        path: PerfilWidget.routePath,
        builder: (context, params) => PerfilWidget(),
      ),
      FFRoute(
        name: TreinosWidget.routeName,
        path: TreinosWidget.routePath,
        builder: (context, params) => TreinosWidget(),
      ),
      FFRoute(
        name: CompletarPerfilWidget.routeName,
        path: CompletarPerfilWidget.routePath,
        builder: (context, params) => CompletarPerfilWidget(),
      ),
      FFRoute(
        name: EscolherPapelWidget.routeName,
        path: EscolherPapelWidget.routePath,
        builder: (context, params) => EscolherPapelWidget(),
      ),
      FFRoute(
        name: TreinosExecucaoWidget.routeName,
        path: TreinosExecucaoWidget.routePath,
        builder: (context, params) => TreinosExecucaoWidget(
          treinoABC: params.getParam(
            'treinoABC',
            ParamType.String,
          ),
          index: params.getParam(
            'index',
            ParamType.int,
          ),
          indexGrupo: params.getParam(
            'indexGrupo',
            ParamType.int,
          ),
          indexExercicio: params.getParam(
            'indexExercicio',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: MetasWidget.routeName,
        path: MetasWidget.routePath,
        builder: (context, params) => MetasWidget(),
      ),
      FFRoute(
        name: MetricasWidget.routeName,
        path: MetricasWidget.routePath,
        builder: (context, params) => MetricasWidget(),
      ),
      FFRoute(
        name: AlunoWidget.routeName,
        path: AlunoWidget.routePath,
        builder: (context, params) => AlunoWidget(),
      ),
      FFRoute(
        name: PagamentosWidget.routeName,
        path: PagamentosWidget.routePath,
        builder: (context, params) => PagamentosWidget(),
      ),
      FFRoute(
        name: PerfilEditWidget.routeName,
        path: PerfilEditWidget.routePath,
        builder: (context, params) => PerfilEditWidget(),
      ),
      FFRoute(
        name: CriaralunoWidget.routeName,
        path: CriaralunoWidget.routePath,
        builder: (context, params) => CriaralunoWidget(),
      ),
      FFRoute(
        name: SegurancaeprivacidadeWidget.routeName,
        path: SegurancaeprivacidadeWidget.routePath,
        builder: (context, params) => SegurancaeprivacidadeWidget(),
      ),
      FFRoute(
        name: TermosdeusoWidget.routeName,
        path: TermosdeusoWidget.routePath,
        builder: (context, params) => TermosdeusoWidget(),
      ),
      FFRoute(
        name: TreinosDetalhesWidget.routeName,
        path: TreinosDetalhesWidget.routePath,
        builder: (context, params) => TreinosDetalhesWidget(
          indexGrupo: params.getParam(
            'indexGrupo',
            ParamType.int,
          ),
        ),
      ),
      FFRoute(
        name: AjudaWidget.routeName,
        path: AjudaWidget.routePath,
        builder: (context, params) => AjudaWidget(),
      ),
      FFRoute(
        name: ResetSenhaWidget.routeName,
        path: ResetSenhaWidget.routePath,
        builder: (context, params) => ResetSenhaWidget(
          email: params.getParam(
            'email',
            ParamType.String,
          ),
        ),
      ),
      FFRoute(
        name: TreinosPersonalWidget.routeName,
        path: TreinosPersonalWidget.routePath,
        builder: (context, params) => const TreinosPersonalWidget(),
      ),
      FFRoute(
        name: TreinosPersonalGrupoWidget.routeName,
        path: TreinosPersonalGrupoWidget.routePath,
        builder: (context, params) => TreinosPersonalGrupoWidget(
          grupo: params.getParam(
                'grupo',
                ParamType.DataStruct,
                isList: false,
                structBuilder: GrupostreinosStruct.fromSerializableMap,
              ) ??
              GrupostreinosStruct(),
        ),
      ),
      FFRoute(
        name: TreinosPersonalDetalheWidget.routeName,
        path: TreinosPersonalDetalheWidget.routePath,
        builder: (context, params) => TreinosPersonalDetalheWidget(
          treinoId: params.getParam('treinoId', ParamType.int) ?? 0,
          treinoNome: params.getParam('treinoNome', ParamType.String) ?? '',
          grupoNome: params.getParam('grupoNome', ParamType.String) ?? '',
        ),
      ),
      FFRoute(
        name: GestaoExerciciosWidget.routeName,
        path: GestaoExerciciosWidget.routePath,
        builder: (context, params) => const GestaoExerciciosWidget(),
      ),
      FFRoute(
        name: $cupertino_time_picker_hiuzb7.HomePageWidget.routeName,
        path: $cupertino_time_picker_hiuzb7.HomePageWidget.routePath,
        builder: (context, params) =>
            $cupertino_time_picker_hiuzb7.HomePageWidget(),
      )
    ]),
    observers: [routeObserver],
  );
}

/// Rotas que ficam sob a navbar. Sao as que o `NavbarWidget` lista em `_abas`.
const _rotasDeAba = <String>{
  '/treinos',
  '/metas',
  '/metricas',
  '/aluno',
  '/pagamentos',
  '/perfil',
  '/treinosPersonal',
};

/// Indice que cada rota de aba representa na navbar.
///
/// `/metricas` e `/pagamentos` compartilham o 3 de proposito: uma e do aluno,
/// a outra do personal, e a navbar so mostra uma das duas por vez.
const _indicePorRota = <String, int>{
  '/treinos': 0,
  '/metas': 1,
  '/aluno': 2,
  '/metricas': 3,
  '/pagamentos': 3,
  '/perfil': 4,
  '/treinosPersonal': 5,
};

/// Navigator interno do shell. So as abas vivem nele.
final _navegadorDasAbas = GlobalKey<NavigatorState>();

/// Separa as rotas de aba do resto e envolve as de aba num `ShellRoute`.
///
/// Antes cada pagina montava a propria `NavbarWidget` dentro do seu `Stack`.
/// Como a barra fazia parte da pagina, ela entrava e saia junto na transicao:
/// a pilula da aba ativa nao deslizava, ela piscava no lugar novo.
///
/// No shell a barra vive **fora** da pagina e sobrevive a troca. So o indice
/// muda, e o `AnimatedContainer` de cada item cuida do resto.
List<RouteBase> _montaRotas(
  AppStateNotifier appStateNotifier,
  List<FFRoute> rotas,
) {
  final abas = <RouteBase>[];
  final resto = <RouteBase>[];

  for (final r in rotas) {
    if (_rotasDeAba.contains(r.path)) {
      abas.add(r.toRoute(appStateNotifier));
    } else {
      // Fora do shell na arvore de rotas nao basta: sem apontar o navigator
      // raiz, um `push` vindo de uma aba monta a pagina dentro do shell.
      // Ver o comentario em `FFRoute.toRoute`.
      resto.add(r.toRoute(
        appStateNotifier,
        parentNavigatorKey: appNavigatorKey,
      ));
    }
  }

  return [
    ShellRoute(
      navigatorKey: _navegadorDasAbas,
      builder: (context, state, child) => _CascaComNavbar(
        rota: state.matchedLocation,
        child: child,
      ),
      routes: abas,
    ),
    ...resto,
  ];
}

/// Pagina + navbar por cima. A navbar nao entra na transicao da pagina.
class _CascaComNavbar extends StatelessWidget {
  const _CascaComNavbar({
    required this.rota,
    required this.child,
  });

  final String rota;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // A barra so aparece nas rotas que ela sabe alcancar. Antes o `?? 0`
    // fazia qualquer rota que caisse dentro do shell mostrar a barra com
    // "Treino" marcado — inclusive telas sem destino nenhum, como o aviso de
    // aguardando convite.
    final indice = _indicePorRota[rota];
    if (indice == null) {
      return child;
    }

    return Stack(
      children: [
        child,
        Align(
          alignment: AlignmentDirectional(0.0, 1.0),
          child: NavbarWidget(index: indice),
        ),
      ],
    );
  }
}

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo {
    final possibleKeys = [
      '__transition_info__',
      '__transition_info__cupertino_time_picker_hiuzb7'
    ];
    for (final key in possibleKeys) {
      if (extraMap.containsKey(key)) {
        return extraMap[key] as TransitionInfo;
      }
    }
    return TransitionInfo.appDefault();
  }
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  /// [parentNavigatorKey] existe por causa de um detalhe do go_router.
  ///
  /// Um `push` NAO troca a lista de rotas: ele anexa a nova rota no fim da
  /// lista atual. Estando em `/treinos` (dentro do shell), a lista vira
  /// `[shell, /treinos, /treinosDetalhes]`, e o construtor de paginas segue
  /// montando com o navigator do shell — a pagina nova nasce DENTRO do shell,
  /// por baixo da navbar. Dizer o navigator de destino tira ela de la.
  GoRoute toRoute(
    AppStateNotifier appStateNotifier, {
    GlobalKey<NavigatorState>? parentNavigatorKey,
  }) =>
      GoRoute(
        name: name,
        path: path,
        parentNavigatorKey: parentNavigatorKey,
        redirect: (context, state) {
          // O portao da recuperacao de senha vem antes de tudo.
          //
          // A sessao criada pelo link do e-mail e uma sessao valida, entao
          // `loggedIn` fica true e o app inteiro se abre para quem ainda nao
          // escolheu senha. Enquanto o portao esta ligado, todo destino que nao
          // seja a tela de nova senha volta para ela. Ver `auth/recuperacao_senha.dart`.
          // A sessao entra na condicao para o portao nao virar armadilha: se ela
          // expirar antes da troca, `updateUser` nao tem mais como gravar, e
          // segurar a pessoa numa tela que nao funciona e pior que solta-la no
          // login.
          if (emRecuperacaoDeSenha &&
              SupaFlow.client.auth.currentSession != null &&
              state.uri.path != ResetSenhaWidget.routePath) {
            final email = SupaFlow.client.auth.currentUser?.email ?? '';
            return Uri(
              path: ResetSenhaWidget.routePath,
              queryParameters: {'email': email},
            ).toString();
          }

          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/start';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  reverseTransitionDuration: transitionInfo.duration,
                  transitionsBuilder: transitionInfo.builder ??
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                            type: transitionInfo.transitionType,
                            duration: transitionInfo.duration,
                            reverseDuration: transitionInfo.duration,
                            alignment: transitionInfo.alignment,
                            child: child,
                          ).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
    this.builder,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  /// Transição própria do app. Quando informada, substitui o `PageTransition`
  /// do pacote — que só oferece deslizes de tela cheia. Ver
  /// `flutter_flow/transicoes_datafit.dart`.
  final Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  )? builder;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

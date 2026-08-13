import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

  /// Motivo pelo qual o iOS recusou registrar o aparelho no APNs.
  ///
  /// O sistema explica a recusa em `didFailToRegisterForRemoteNotifications`,
  /// e ate agora ninguem implementava esse metodo: o erro era descartado e do
  /// lado do Dart so restava "o token nao veio", sem causa. Com entitlement,
  /// capability e chave APNs todos confirmados, esta mensagem e a unica pista
  /// que ainda nao tinhamos.
  private static var ultimoErroApns: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Canal so de diagnostico: o Dart pergunta por que o registro falhou
    // depois de esgotar as tentativas de pegar o token.
    if let controller = window?.rootViewController as? FlutterViewController {
      let canal = FlutterMethodChannel(
        name: "datafit/push_diag",
        binaryMessenger: controller.binaryMessenger
      )
      canal.setMethodCallHandler { chamada, resposta in
        if chamada.method == "ultimoErroApns" {
          resposta(AppDelegate.ultimoErroApns)
        } else {
          resposta(FlutterMethodNotImplemented)
        }
      }
    }

    // Registro explicito, alem do que o firebase_messaging faz por conta ao
    // pedir permissao: quando a permissao ja foi concedida numa execucao
    // anterior, o plugin pode devolver o estado do cache e nao chamar o
    // registro de novo — e sem essa chamada o APNs nunca responde.
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    AppDelegate.ultimoErroApns = error.localizedDescription
    NSLog("APNs recusou o registro: \(error.localizedDescription)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    AppDelegate.ultimoErroApns = nil
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}

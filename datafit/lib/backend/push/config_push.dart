/// Credenciais do Firebase, preenchidas com os dados do seu projeto.
///
/// Ficam em código, e não num arquivo `google-services.json` / `.plist`, de
/// propósito: o plugin Gradle do Google exige o JSON presente no momento do
/// build e derruba a compilação sem ele. Passando as opções daqui, o app
/// continua compilando e rodando enquanto o push não está configurado — basta
/// deixar os campos vazios.
///
/// Estes valores **não são segredo**: são identificadores públicos do projeto,
/// os mesmos que ficariam no `google-services.json` dentro do APK. O que é
/// segredo é a chave da conta de serviço, e essa vive só no servidor.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

/// Preencha com o que o Firebase mostrar ao registrar cada app.
///
/// Enquanto `apiKey` estiver vazio, o push fica desligado e o app funciona
/// normalmente sem ele.
class ConfigPush {
  const ConfigPush._();

  // ── Android ────────────────────────────────────────────────────────
  // De `google-services.json`:
  //   apiKey        -> client[0].api_key[0].current_key
  //   appId         -> client[0].client_info.mobilesdk_app_id
  //   messagingSenderId -> project_info.project_number
  //   projectId     -> project_info.project_id
  static const String androidApiKey = '';
  static const String androidAppId = '';

  // ── iOS ────────────────────────────────────────────────────────────
  // De `GoogleService-Info.plist`:
  //   apiKey -> API_KEY
  //   appId  -> GOOGLE_APP_ID
  static const String iosApiKey = '';
  static const String iosAppId = '';

  // ── Comuns aos dois ────────────────────────────────────────────────
  static const String messagingSenderId = '';
  static const String projectId = '';
  static const String storageBucket = '';

  /// Verdadeiro quando há credencial suficiente para a plataforma atual.
  static bool get configurado {
    if (projectId.isEmpty || messagingSenderId.isEmpty) return false;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? iosApiKey.isNotEmpty && iosAppId.isNotEmpty
        : androidApiKey.isNotEmpty && androidAppId.isNotEmpty;
  }

  static FirebaseOptions get opcoes => FirebaseOptions(
        apiKey: defaultTargetPlatform == TargetPlatform.iOS
            ? iosApiKey
            : androidApiKey,
        appId:
            defaultTargetPlatform == TargetPlatform.iOS ? iosAppId : androidAppId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket.isEmpty ? null : storageBucket,
      );
}

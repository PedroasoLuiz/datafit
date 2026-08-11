/// Login social (Google e Apple) via `signInWithIdToken` do Supabase.
///
/// Fluxo NATIVO: o seletor de contas é o do próprio sistema operacional, sem
/// abrir navegador. O app pega o `idToken` do provedor e entrega pro Supabase,
/// que valida e cria a sessão. O `onAuthStateChange` que o app já escuta em
/// `supabase_user_provider.dart` faz o resto.
///
/// ANTES DE FUNCIONAR é preciso preencher os IDs em [SocialAuthConfig] e
/// habilitar os provedores no painel do Supabase. Ver IOS_APPSTORE.md.
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '/auth/sessao.dart';
import '/backend/supabase/supabase.dart';

/// IDs de OAuth. Preencher com os valores do Google Cloud Console.
abstract class SocialAuthConfig {
  /// OAuth client do tipo **Web** no Google Cloud.
  ///
  /// É o mesmo valor que vai no painel do Supabase em
  /// Authentication > Providers > Google > "Client IDs", e é ele que o Android
  /// usa como `serverClientId` para pedir um idToken destinado ao Supabase.
  static const String googleWebClientId =
      '122518873534-ujjhv5sjahj2qmpl9bm12u0u2q8q3lrj.apps.googleusercontent.com';

  /// OAuth client do tipo **iOS** no Google Cloud (bundle `com.virtus.datafit`).
  static const String googleIosClientId =
      '122518873534-5iv7ma1q89lutg84lmt1d17vf27jnqok.apps.googleusercontent.com';

  static bool get googleConfigurado => googleWebClientId.isNotEmpty;
}

/// Erro de login social com mensagem já pronta para exibir ao usuário.
class SocialAuthException implements Exception {
  SocialAuthException(this.mensagem);
  final String mensagem;

  @override
  String toString() => mensagem;
}

/// Entra com Google. Retorna `false` se o usuário cancelou (sem erro).
/// Lança [SocialAuthException] em caso de falha real.
Future<bool> entrarComGoogle() async {
  if (!SocialAuthConfig.googleConfigurado) {
    throw SocialAuthException(
        'Login com Google ainda não está configurado no app.');
  }

  final google = GoogleSignIn.instance;

  // O nonce precisa ser novo a cada tentativa, então `initialize` roda sempre.
  //
  // Sem passar nonce aqui, o google_sign_in gera um por conta própria e o
  // embute no id_token; o Supabase então recusa com "Passed nonce and nonce in
  // id_token should either both exist or not", porque nós não mandamos nenhum.
  //
  // O Google embute no token exatamente o que recebe, e o Supabase compara o
  // SHA-256 do que passamos com o que está no token. Por isso o provedor
  // recebe o hash e o Supabase recebe o nonce cru — mesma mecânica do Apple.
  final nonceCru = _gerarNonce();
  final nonceHash = sha256.convert(utf8.encode(nonceCru)).toString();

  await google.initialize(
    clientId: defaultTargetPlatform == TargetPlatform.iOS
        ? SocialAuthConfig.googleIosClientId
        : null,
    serverClientId: SocialAuthConfig.googleWebClientId,
    nonce: nonceHash,
  );

  final GoogleSignInAccount conta;
  try {
    conta = await google.authenticate();
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      return false;
    }
    throw SocialAuthException(
        'Não foi possível entrar com o Google: ${e.description ?? e.code.name}');
  }

  final idToken = conta.authentication.idToken;
  if (idToken == null) {
    throw SocialAuthException(
        'O Google não devolveu o token de identificação. Confira se o client "Web" está correto.');
  }

  final res = await SupaFlow.client.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    nonce: nonceCru,
  );
  await prepararSessaoPara(res.user?.id);
  return true;
}

/// Entra com Apple. Retorna `false` se o usuário cancelou.
///
/// A Apple recebe o **hash** do nonce e o Supabase recebe o nonce **cru** —
/// é assim que ele confirma que o token foi emitido para esta sessão.
Future<bool> entrarComApple() async {
  final nonceCru = _gerarNonce();
  final nonceHash = sha256.convert(utf8.encode(nonceCru)).toString();

  try {
    final credencial = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonceHash,
    );

    final idToken = credencial.identityToken;
    if (idToken == null) {
      throw SocialAuthException('A Apple não devolveu o token de identificação.');
    }

    final res = await SupaFlow.client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: nonceCru,
    );
    await prepararSessaoPara(res.user?.id);
    return true;
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return false;
    }
    throw SocialAuthException('Não foi possível entrar com a Apple: ${e.message}');
  }
}

/// Só faz sentido oferecer "Entrar com a Apple" no iOS/macOS.
bool get appleSignInDisponivel =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS);

String _gerarNonce([int tamanho = 32]) {
  const chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(tamanho, (_) => chars[random.nextInt(chars.length)])
      .join();
}

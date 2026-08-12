/// Notificações push: permissão, token e reação ao toque.
///
/// Todo o serviço é tolerante a não estar configurado. Sem as credenciais em
/// [ConfigPush], `iniciar()` sai em silêncio e o resto do app segue igual —
/// é o que permite subir o código antes de o Firebase existir.
///
/// O envio acontece no servidor: o gatilho `trg_envia_push` chama a Edge
/// Function `enviar-push` sempre que uma linha entra em `Notificacoes`. Aqui
/// só cuidamos de ter um token válido registrado.
library;

import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

import '/backend/supabase/supabase.dart';
import 'config_push.dart';

/// Handler de mensagem com o app fechado.
///
/// Precisa ser função de topo e anotada: o Flutter roda isto num isolate
/// separado, sem acesso ao estado do app. Aqui não fazemos nada — o sistema
/// já mostra a notificação sozinho — mas o registro é obrigatório para o
/// plugin não reclamar.
@pragma('vm:entry-point')
Future<void> _mensagemEmSegundoPlano(RemoteMessage mensagem) async {}

class ServicoPush {
  const ServicoPush._();

  static bool _iniciado = false;
  static String? _tokenAtual;

  /// Conta ao servidor em que ponto o registro parou.
  ///
  /// Sem isto, descobrir por que o token nao chegou custa um ciclo inteiro de
  /// build, TestFlight e instalacao por hipotese testada — e no fim so se sabe
  /// que continua sem token, nunca o motivo.
  static Future<void> _anotar(String etapa, [String? detalhe]) async {
    try {
      await SupaFlow.client.rpc('registrar_diagnostico_push', params: {
        'p_etapa': etapa,
        'p_detalhe': detalhe,
      });
    } catch (_) {
      // Diagnostico nunca pode atrapalhar o que esta diagnosticando.
    }
  }

  /// Sobe o Firebase e pede permissão. Seguro chamar mais de uma vez.
  static Future<void> iniciar() async {
    if (_iniciado || kIsWeb || !ConfigPush.configurado) return;

    try {
      await Firebase.initializeApp(options: ConfigPush.opcoes);
      FirebaseMessaging.onBackgroundMessage(_mensagemEmSegundoPlano);
      _iniciado = true;
    } catch (e) {
      // Credencial errada não pode derrubar o app inteiro na abertura.
      debugPrint('Push desligado: $e');
      unawaited(_anotar('firebase_falhou', '$e'));
    }
  }

  /// Pede permissão e registra o token para o usuário logado.
  ///
  /// Chamado depois do login, não na abertura: pedir permissão de notificação
  /// antes de a pessoa entrar na conta é pedir sem contexto, e o iOS só
  /// permite perguntar uma vez.
  static Future<void> registrarUsuario() async {
    if (!_iniciado) return;

    try {
      final permissao = await FirebaseMessaging.instance.requestPermission();
      await _anotar('permissao', permissao.authorizationStatus.name);
      if (permissao.authorizationStatus == AuthorizationStatus.denied) return;

      // No iOS o token do FCM só existe depois que o APNs responde, e o APNs
      // demora alguns segundos na primeira execução após instalar. Uma
      // tentativa só devolvia nulo e o aparelho ficava sem registro até a
      // próxima abertura — que também podia falhar do mesmo jeito.
      String? token;
      for (var tentativa = 1; tentativa <= 5; tentativa++) {
        if (Platform.isIOS) {
          final apns = await FirebaseMessaging.instance.getAPNSToken();
          if (apns == null) {
            await Future.delayed(const Duration(seconds: 3));
            continue;
          }
        }
        token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) break;
        await Future.delayed(const Duration(seconds: 3));
      }

      if (token == null || token.isEmpty) {
        await _anotar('sem_token', 'apns ou fcm nao respondeu em 5 tentativas');
        return;
      }

      await _salvar(token);

      // O token é rotacionado pelo próprio Firebase de tempos em tempos; sem
      // ouvir isso, o aparelho pararia de receber sem aviso.
      FirebaseMessaging.instance.onTokenRefresh.listen(_salvar);
    } catch (e) {
      debugPrint('Não consegui registrar o token de push: $e');
      await _anotar('erro_registro', '$e');
    }
  }

  static Future<void> _salvar(String token) async {
    _tokenAtual = token;
    try {
      await SupaFlow.client.rpc('registrar_token_push', params: {
        'p_token': token,
        'p_plataforma': Platform.isIOS ? 'ios' : 'android',
      });
    } catch (e) {
      debugPrint('Não consegui salvar o token de push: $e');
      await _anotar('erro_salvar', '$e');
    }
  }

  /// Descadastra o aparelho ao sair da conta.
  ///
  /// Sem isto, quem desloga continuaria recebendo notificação de uma conta que
  /// não está mais aberta ali — e num aparelho compartilhado isso vaza dado de
  /// outra pessoa.
  static Future<void> encerrarSessao() async {
    final token = _tokenAtual;
    if (token == null) return;
    try {
      await SupaFlow.client
          .rpc('remover_token_push', params: {'p_token': token});
    } catch (_) {
      // Falhar aqui não impede o logout.
    }
    _tokenAtual = null;
  }
}

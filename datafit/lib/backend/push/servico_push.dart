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
import 'package:flutter/services.dart' show MethodChannel;

import '/backend/diagnostico.dart';
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

  /// A subida do Firebase, para quem precisar esperar por ela.
  ///
  /// Existe porque `iniciar()` deixou de ser esperado na abertura do app: o
  /// `Firebase.initializeApp` custa algumas centenas de milissegundos e, sendo
  /// aguardado antes do `runApp`, esse custo aparecia como tela parada. Agora
  /// ele corre em paralelo com a montagem da primeira tela.
  ///
  /// Sem esta espera o preço seria pior que o ganho: `registrarUsuario()` roda
  /// logo depois do login, poderia chegar antes de a subida terminar, sairia
  /// em silêncio pelo `_iniciado` ainda falso, e o aparelho ficaria sem token
  /// até a próxima abertura.
  static Future<void>? _subida;

  /// Conta ao servidor em que ponto o registro parou.
  ///
  /// Prefixo `push_` porque o mesmo diario recebe as anotacoes da capa de
  /// video — ver [anotarDiagnostico].
  static Future<void> _anotar(String etapa, [String? detalhe]) =>
      anotarDiagnostico('push_$etapa', detalhe);

  /// Canal so de diagnostico, atendido pelo `AppDelegate`.
  static const MethodChannel _canalDiag = MethodChannel('datafit/push_diag');

  /// O que o iOS respondeu ao recusar o registro no APNs.
  ///
  /// Nulo no Android, e nulo tambem quando o sistema nao chegou a recusar —
  /// nesse caso o registro apenas nunca completou.
  static Future<String?> _motivoRecusaApns() async {
    if (!Platform.isIOS) return null;
    try {
      return await _canalDiag.invokeMethod<String>('ultimoErroApns');
    } catch (_) {
      return null;
    }
  }

  /// Sobe o Firebase. Seguro chamar mais de uma vez: a partir da segunda,
  /// devolve a mesma subida em vez de começar outra.
  static Future<void> iniciar() {
    if (_iniciado || kIsWeb || !ConfigPush.configurado) {
      return Future<void>.value();
    }
    return _subida ??= _subir();
  }

  static Future<void> _subir() async {
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
    // Espera a subida em vez de desistir se ela ainda estiver a caminho.
    await iniciar();
    if (!_iniciado) return;

    try {
      final permissao = await FirebaseMessaging.instance.requestPermission();
      await _anotar('permissao', permissao.authorizationStatus.name);
      if (permissao.authorizationStatus == AuthorizationStatus.denied) return;

      // No iOS o token do FCM só existe depois que o APNs responde, e o APNs
      // demora alguns segundos na primeira execução após instalar. Uma
      // tentativa só devolvia nulo e o aparelho ficava sem registro até a
      // próxima abertura — que também podia falhar do mesmo jeito.
      //
      // As duas etapas sao anotadas separadamente porque acusam culpados
      // opostos: APNs mudo e entitlement que nao chegou no binario (App ID ou
      // provisioning profile); APNs ok com FCM mudo e a chave .p8 ausente ou
      // errada no Firebase. Uma mensagem unica para os dois casos mandava
      // procurar no lugar errado.
      String? token;
      var apnsRespondeu = !Platform.isIOS;
      String? erroFcm;

      await _anotar('buscando_token', Platform.isIOS ? 'ios' : 'android');

      for (var tentativa = 1; tentativa <= 5; tentativa++) {
        if (Platform.isIOS && !apnsRespondeu) {
          final apns = await FirebaseMessaging.instance
              .getAPNSToken()
              .timeout(const Duration(seconds: 10), onTimeout: () => null);
          if (apns == null) {
            await Future.delayed(const Duration(seconds: 3));
            continue;
          }
          apnsRespondeu = true;
          await _anotar('apns_ok', 'na tentativa $tentativa');
        }
        try {
          // Com prazo: sem Google Play Services no aparelho, `getToken` fica
          // pendurado para sempre — nao devolve e nao lanca. O loop parava na
          // primeira volta e nenhuma etapa seguinte chegava a ser registrada,
          // o que fazia o diagnostico terminar em silencio justo no caso em
          // que ele era mais necessario.
          token = await FirebaseMessaging.instance
              .getToken()
              .timeout(const Duration(seconds: 10));
        } catch (e) {
          // getToken lanca quando o Firebase recusa o registro — tipicamente
          // por falta da APNs Key. Sem capturar, o erro caia no catch de fora
          // e virava um 'erro_registro' generico.
          erroFcm = '$e';
        }
        if (token != null && token.isNotEmpty) break;
        await Future.delayed(const Duration(seconds: 3));
      }

      if (token == null || token.isEmpty) {
        if (!apnsRespondeu) {
          // O proprio iOS explica a recusa; o AppDelegate guarda a mensagem.
          // O texto antigo aqui chutava "entitlement ausente", e o log do
          // build provou que o entitlement estava presente — um palpite
          // escrito como se fosse diagnostico atrapalha mais que a ausencia.
          final motivo = await _motivoRecusaApns();
          await _anotar('sem_token_apns',
              motivo ?? 'o iOS nao registrou no APNs e nao informou o motivo');
        } else {
          await _anotar(
              'sem_token_fcm',
              'o FCM nao devolveu token em 5 tentativas'
                  '${erroFcm == null ? '' : ' — $erroFcm'}');
        }
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

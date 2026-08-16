/// Guarda por alguns segundos o que acabou de vir do banco.
///
/// A navbar troca de aba com `goNamed`, que **substitui** a página: sair de
/// Treinos e voltar desmonta e remonta a tela, e todo `initState` roda de
/// novo. Sem isto, ir ao perfil e voltar refaz consultas que responderam há
/// dois segundos — e o app cresce em número de chamadas na mesma velocidade
/// em que a pessoa navega, não em que os dados mudam.
///
/// **Não é cache de dado, é cache de viagem.** A validade é curta de propósito:
/// o objetivo é absorver o vaivém entre abas, não segurar informação. Passado
/// o prazo, busca de novo sem perguntar.
///
/// E qualquer ação que muda o dado invalida na hora — concluir um treino,
/// avaliar, editar o perfil. Por isso [invalidar] recebe um prefixo: as chaves
/// são nomeadas por assunto, então `invalidar('treinos')` derruba tudo que fala
/// de treino sem tocar no resto.
library;

import 'dart:async';

class CacheCurto {
  const CacheCurto._();

  /// Quanto tempo uma resposta continua valendo.
  ///
  /// Quarenta segundos cobre o vaivém de abas — que é o caso que motivou isto
  /// — e é curto o bastante para ninguém ficar olhando dado velho de verdade.
  static const Duration validade = Duration(seconds: 40);

  static final Map<String, ({DateTime em, Object? valor})> _itens = {};

  /// Buscas em andamento, para duas chamadas simultâneas da mesma chave não
  /// virarem duas idas ao banco.
  ///
  /// É o caso do `initState` disparando junto com um refresh: sem isto, o
  /// cache só evita a segunda chamada depois que a primeira já voltou — e o
  /// pior momento é exatamente enquanto ela ainda não voltou.
  static final Map<String, Future<Object?>> _emVoo = {};

  /// Devolve o valor guardado, ou executa [buscar] e guarda o resultado.
  ///
  /// Erro não é guardado: uma falha de rede não pode calar a próxima tentativa
  /// por quarenta segundos.
  static Future<T?> obter<T>(
    String chave,
    Future<T?> Function() buscar, {
    bool forcar = false,
  }) async {
    if (!forcar) {
      final guardado = _itens[chave];
      if (guardado != null &&
          DateTime.now().difference(guardado.em) < validade) {
        return guardado.valor as T?;
      }
      final voando = _emVoo[chave];
      if (voando != null) return await voando as T?;
    }

    final futuro = buscar();
    _emVoo[chave] = futuro;
    try {
      final valor = await futuro;
      _itens[chave] = (em: DateTime.now(), valor: valor);
      return valor;
    } finally {
      _emVoo.remove(chave);
    }
  }

  /// Derruba o que foi guardado. Sem prefixo, derruba tudo.
  static void invalidar([String? prefixo]) {
    if (prefixo == null) {
      _itens.clear();
      return;
    }
    _itens.removeWhere((chave, _) => chave.startsWith(prefixo));
  }
}

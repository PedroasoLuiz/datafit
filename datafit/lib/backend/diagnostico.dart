/// Diario de falhas que so acontecem no aparelho do usuario.
///
/// Existe porque algumas falhas sao invisiveis daqui: o app roda num iPhone
/// que nao temos, sem console, e cada hipotese testada por build custa o ciclo
/// inteiro de compilar, subir para o TestFlight e instalar. Anotando a etapa
/// exata em que parou, uma unica rodada responde o "por que" em vez de so
/// repetir que continua sem funcionar.
///
/// A tabela chama `DiagnosticoPush` por ter nascido no push, mas o mecanismo
/// nao tem nada de especifico: `Etapa` e texto livre. Use um prefixo por
/// assunto (`push_`, `capa_`) para conseguir separar na leitura.
library;

import 'package:flutter/foundation.dart';

import '/backend/supabase/supabase.dart';

/// Anota uma etapa. Nunca lanca: diagnostico nao pode derrubar — nem atrasar —
/// o que esta sendo diagnosticado.
Future<void> anotarDiagnostico(String etapa, [String? detalhe]) async {
  debugPrint('diagnostico: $etapa${detalhe == null ? '' : ' — $detalhe'}');
  try {
    await SupaFlow.client.rpc('registrar_diagnostico_push', params: {
      'p_etapa': etapa,
      'p_detalhe': detalhe,
    });
  } catch (_) {
    // Sem rede, sem sessao, RPC fora do ar — em todos os casos o certo e
    // seguir em frente calado.
  }
}

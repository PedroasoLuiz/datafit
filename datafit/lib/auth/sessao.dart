/// Limpeza do estado local entre sessões de usuários diferentes.
///
/// O `FFAppState` persiste 16 chaves em SharedPreferences — entre elas
/// `ff_alunosdopersonal`, `ff_perfil`, `ff_pagamentos` e `ff_notificacoes`.
/// Nada no app apagava isso ao trocar de conta, então o usuário seguinte via
/// os dados do anterior até a primeira busca de rede terminar (e, em telas que
/// leem o AppState no `initState`, via até depois disso).
///
/// Por que não usar o `FFAppState.reset()` que já existe: ele troca o
/// `_instance` estático, mas o `main.dart` guarda a instância numa variável
/// local e é ela que vai para o `ChangeNotifierProvider`. Depois de um reset o
/// Provider continuaria entregando o objeto antigo enquanto `FFAppState()`
/// devolveria o novo — dois estados divergentes. Por isso aqui a limpeza é
/// feita **na instância viva**, campo a campo. Cada setter também reescreve a
/// chave correspondente no disco.
library;

import '/components/lista_notificacoes.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '/app_state.dart';
import '/backend/schema/structs/index.dart';

const String _kUltimoUsuario = 'datafit_ultimo_usuario_logado';

/// Chamar logo após um login bem-sucedido, antes de navegar.
///
/// Só limpa quando a conta é **diferente** da última que usou o aparelho —
/// assim quem sai e volta na mesma conta não perde treino em andamento nem
/// cronômetro de descanso.
Future<void> prepararSessaoPara(String? userId) async {
  final prefs = await SharedPreferences.getInstance();
  final anterior = prefs.getString(_kUltimoUsuario);

  if (anterior != null && anterior == userId) {
    return;
  }

  limparEstadoLocalDoUsuario();
  await prefs.setString(_kUltimoUsuario, userId ?? '');
}

/// Chamar ao sair da conta. Aqui limpa sempre.
Future<void> encerrarSessaoLocal() async {
  limparEstadoLocalDoUsuario();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_kUltimoUsuario);
}

/// Zera todo o estado de usuário do `FFAppState` (memória + disco).
void limparEstadoLocalDoUsuario() {
  final estado = FFAppState();

  estado.update(() {
    // Perfil e vínculos
    estado.perfil = PerfilStruct();
    estado.alunosdopersonal = [];
    estado.convitesPendentes = [];
    estado.alunosimples = AlunosimplesStruct();
    estado.alunotemp = PerfilAlunoStruct();
    estado.usuarioLogadoSupId = null;
    estado.existeCadastro = null;

    // Treinos
    estado.treinoalunos = [];
    estado.treinoaluno = TreinoStruct();
    estado.exerciciosaluno = [];
    estado.treinosTemp = GrupostreinosStruct();
    estado.exercicioTemp = ExerciciosStruct();

    // Métricas e metas
    estado.metasTemp = MetasAlunoStruct();
    estado.metricasTemp = DashMetricasStruct();
    estado.musculos = [];
    estado.registro1 = ResumoMesStruct();
    estado.resumo2 = ResumoMesStruct();
    estado.startDate = '';
    estado.endDate = '';

    // Financeiro e avisos
    estado.pagamentos = [];
    estado.notificacoes = [];

    // Execução em andamento / cronômetro
    estado.exercicioEmAndamento = false;
    estado.treinoExecucaoIdAtivo = 0;
    estado.timerDescansando = false;
    estado.timerResetTrigger = 0;
    estado.descansoinicio = '';

    estado.updatingvariable = 0;
  });

  // Sem isto o proximo login herdaria o "ja mostrei as novidades" deste.
  limparAvisoDeSessao();
}

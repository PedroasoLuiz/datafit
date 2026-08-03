# Plano de Ação — Suporte Offline (Exercícios / Visão do Aluno)

## Contexto

O aluno executa treinos lidos de `FFAppState().treinosTemp`, carregado via RPC `get_treino_ativo_aluno`. Os registros de conclusão são escritos em `ExerciciosExecucao` e `RegistrosTreino` no Supabase. Sem internet, hoje o app trava no loading ou falha silenciosamente.

---

## Arquitetura proposta

```
App abre
 ├── com internet → RPC → treinosTemp + salva cache local
 └── sem internet → carrega cache local → treinosTemp (dados do último sync)

Aluno finaliza/pula exercício
 ├── com internet → API normal
 └── sem internet → salva na fila local (sync_queue)

App reconecta
 └── SyncService.flush() → processa fila → confirma no banco
```

---

## Fase 1 — Cache de leitura (dados do treino disponíveis offline)

**O que fazer:**
1. Após `getTreinosAluno` bem-sucedido em `actions.dart`, serializar `FFAppState().treinosTemp.toMap()` e salvar via `SharedPreferences` (chave `cache_treinos`) com timestamp (`cache_treinos_ts`)
2. No início de `getTreinosAluno`: tentar RPC normalmente; se `!succeeded && cache existe` → carregar do cache
3. Opcional: banner sutil na `treinos_widget.dart` mostrando "Dados de DD/MM" quando offline

**Arquivos a modificar:**
- `lib/actions/actions.dart` — função `getTreinosAluno`
- `lib/pages/treinos/treinos/treinos_widget.dart` — banner de status (opcional)

**Dependências:** `shared_preferences` (já existe no projeto — usado por `PersistentTimer`)

**Esforço estimado:** ~3h

---

## Fase 2 — Fila de escrita offline (sync ao reconectar)

**O que fazer:**
1. Criar `lib/services/sync_service.dart` — Riverpod `AsyncNotifier` que:
   - Mantém lista de operações pendentes em `SharedPreferences` (JSON serializado)
   - Expõe `enqueue(SyncOp op)` e `flush()`
2. `SyncOp` é um sealed class com variantes:
   - `FinalizarTreino(payload: Map)`
   - `PularExercicio(execucaoId: int)`
   - `SalvarFeedback(treinoId: int, nota: int)`
3. Nos pontos de escrita da `treinos_execucao_widget.dart` e `treinos_detalhes_widget.dart`:
   - Checar conectividade via `connectivity_plus`
   - Com internet → chamada normal
   - Sem internet → `SyncService.enqueue(op)` → feedback visual "Salvo localmente"
4. `SyncService.flush()` é chamado quando `connectivity_plus` detecta reconexão; processa fila em ordem FIFO

**Arquivos a modificar:**
- `lib/actions/actions.dart` — `finalizar_treino`, `salvar_feedback_treino`
- `lib/pages/treinos/treinos_execucao/treinos_execucao_widget.dart` — pontos de conclusão de série/exercício
- `lib/pages/treinos/treinos_detalhes/treinos_detalhes_widget.dart` — pular exercício

**Dependências a adicionar ao `pubspec.yaml`:**
```yaml
connectivity_plus: ^6.0.0
```

**Esforço estimado:** ~8h

---

## Fase 3 — Indicador de status na UI

**O que fazer:**
1. Badge na navbar ou banner no topo da `treinos_execucao_widget.dart`: "X ações aguardando sync"
2. Ícone de nuvem com check após sync bem-sucedido (desaparece em 3s)
3. Pull-to-refresh na `treinos_widget.dart` força sync + refresh de cache

**Arquivos a modificar:**
- `lib/pages/treinos/treinos_execucao/treinos_execucao_widget.dart`
- `lib/pages/treinos/treinos/treinos_widget.dart`

**Esforço estimado:** ~2h

---

## Sequência de implementação recomendada

| Ordem | Fase | Impacto | Risco |
|---|---|---|---|
| 1 | Fase 1 — cache de leitura | Alto (treino disponível sem internet) | Baixo |
| 2 | Fase 2 — fila de escrita | Alto (registros não se perdem) | Médio |
| 3 | Fase 3 — UI de status | Médio (UX) | Baixo |

---

## Notas técnicas

- `GrupostreinosStruct` já é serializável via `.toMap()` / `GrupostreinosStruct.maybeFromMap()`; o cache de leitura usa exatamente isso
- A fila de sync deve persistir entre reinicializações do app (SharedPreferences, não só memória)
- Ao fazer sync, respeitar a ordem das operações — uma série finalizada antes de um "pular" deve ser enviada nessa ordem
- Conflict resolution: se o usuário fizer mudanças offline e o backend já tiver um registro mais novo (ex: personal atualizou o treino), dar prioridade ao backend na leitura mas manter as escritas offline na fila

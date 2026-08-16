# Datafit — Guia de Contexto para Claude Code

> **Leia este arquivo primeiro. Ele aponta para os demais.**
> O projeto está em desenvolvimento ativo. Antes de qualquer mudança, consulte os arquivos referenciados.

---

## O que é o Datafit

App de gestão de treinos fitness conectando **Personal Trainers** aos seus **Alunos**.
Três papéis: `Aluno`, `Personal`, `Admin`.

Package: `com.virtus.datafit`
Deep link scheme: `com.virtus.datafit://`

---

## Arquivos de contexto (leia na ordem)

| Arquivo | O que contém |
|---|---|
| [`CLAUDE.md`](./CLAUDE.md) | Este arquivo — mapa geral |
| [`STACK.md`](./STACK.md) | Stack, estrutura de pastas, padrões de código |
| [`DATABASE.md`](./DATABASE.md) | Schema Supabase, todas as tabelas e RPCs |
| [`FEATURES.md`](./FEATURES.md) | Status de cada módulo (completo / em andamento / pendente) |
| [`RULES.md`](./RULES.md) | Armadilhas conhecidas, regras invioláveis, decisões já tomadas |
| [`PERSONAS.md`](./PERSONAS.md) | Papéis de usuário, planos, fluxos por perfil |

### Kits de UI (leia antes de escrever tela)

| Kit | Para quê |
|---|---|
| `lib/components/folha_kit.dart` | todas as folhas do rodapé |
| `lib/components/perfil_kit.dart` | fichas de perfil |
| `lib/components/baralho_cartas.dart` | a pilha de cartas que se arrasta |
| `lib/components/atalho_cartao.dart` | linha branca com quadrado de ícone |

---

## Decisões rápidas (TL;DR)

- **Nunca** chame `Supabase.instance.client.rpc()` diretamente nas telas — sempre via `SupabaseService.rpc()`
- **Nunca** use `CustomPaint` para gráficos em produção — use `Container/Row/Stack/Positioned`
- **Sempre** `COALESCE("IsDeleted", false) = false` — registros antigos têm `null`, não `false`
- **Sempre** timezone `America/Sao_Paulo` em comparações de data
- Estado global → Riverpod `AsyncNotifier`. Estado local de widget → `setState` apenas
- Campos de DataType do FF vindos como `int` do Supabase: cast com `(v as num).toDouble()`
- `RegistrosCardio` **não tem** coluna `IsDeleted` — não filtre por ela
- Antes de debugar frontend, teste o RPC direto no Supabase via SQL
- `Perfis` PK é `"idUser"` (UUID) — **NÃO** `"Id"` — confirmar antes de fazer JOIN
- `valueOrDefault<String>(campo, '-') != ''` é **sempre true** — use `campo != null && campo != ''`
- **Folhas do rodapé (formulário/listagem): use `components/folha_kit.dart`.** Nunca monte a casca à mão — ver `RULES.md`
- **Todo `showModalBottomSheet` leva `useRootNavigator: true`** — sem isso folhas aninhadas fecham uma no lugar da outra
- Erro para o usuário é `MensagemWidget`, nunca `SnackBar`
- `resposta.succeeded ?? true` esconde falha — use `!= true`
- `FFLocalizations.of(context)` nunca dentro de `Future` agendado no `initState` — tela vermelha quando a folha já fechou
- `Notificacoes` **não tem** `PerfisId` — tem `DestinatarioPerfisId` e `RemetentePerfisId`
- `PersonalAlunos` pode ter múltiplos registros por aluno — **sempre filtrar** `StatusConvite = 'aceito' AND Ativo = true` para pegar o vínculo ativo
- Convite: botões Aceitar/Recusar usam `notisItem.remetenteId` (UUID) — nunca buscar por nome em `convitesPendentes`
- `TreinosExecucao`: ciclo 1 é o **plano**, ciclos > 1 são as repetições. `DataValidade` pertence ao plano
- `ExerciciosTreinos` **não tem** `IsDeleted`

---

## IDs de teste

| Usuário | UUID |
|---|---|
| Pedro Luiz (Personal) | `8f970c58-39f7-4b6b-81bc-9d9cbcaffbe0` |
| Maria Miranda (Aluna) | `ad2b23a6-c484-48ab-b3e9-d60b7665add4` |

---

## Supabase

- **Project ID:** `idsopfkwmquvndwmwlbr`
- **Região:** `sa-east-1`
- **Timezone padrão:** `America/Sao_Paulo`
- Use `execute_sql` para diagnóstico, `apply_migration` para alterações de schema

---

## Escalabilidade (norte a seguir)

O app precisa suportar muitos usuários com o tempo. As decisões de arquitetura já refletem isso:
- RPCs no Supabase concentram lógica de negócio (fácil de otimizar com índices)
- RLS ativo em todas as tabelas
- Widgets de gráfico sem `CustomPaint` (mais estável em builds de produção)
- Estado via Riverpod (sem acoplamento de UI)

Ao adicionar features, prefira sempre lógica no banco (RPC/SQL) em vez de no cliente.

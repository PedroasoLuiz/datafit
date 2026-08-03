# Datafit — Regras, Armadilhas e Decisões Já Tomadas

> Referenciado por: [`../CLAUDE.md`](../CLAUDE.md)
> **Leia este arquivo antes de qualquer mudança.** Contém lições aprendidas na prática.

---

## Regras invioláveis

### Abordagem geral
- **Mudança cirúrgica:** aplique APENAS o que foi solicitado. Nada de reestruturar, adicionar features não pedidas ou reescrever arquivos inteiros.
- **DB primeiro:** antes de tocar no frontend, teste o RPC diretamente via SQL. Se não funciona no DB, não é problema do Flutter.
- **Um problema por vez:** identifique e resolva antes de partir para o próximo.
- **Analise antes de mudar:** mudanças precipitadas causam regressões.

### Supabase / PostgreSQL

```sql
-- ✅ SEMPRE assim para soft delete (null ≠ false em registros antigos)
WHERE COALESCE("IsDeleted", false) = false

-- ✅ SEMPRE timezone explícito
NOW() AT TIME ZONE 'America/Sao_Paulo'

-- ✅ DISTINCT ON exige que a coluna apareça primeiro no ORDER BY
SELECT DISTINCT ON (coluna) coluna, outros... ORDER BY coluna, data DESC

-- ❌ MAX() não funciona em UUID — use SELECT ... LIMIT 1
```

### FlutterFlow / Flutter

```dart
// ✅ Cast correto para campos numéricos vindos do Supabase como int
final valor = (v as num).toDouble();  // NÃO: v as double

// ✅ Acesse campos de DataType via variável local
final x = FFAppState().metricasTemp;
final campo = x.algumCampo;  // NÃO: FFAppState().metricasTemp.algumCampo direto

// ✅ Gráficos — use widgets Flutter puros
Container / Row / Stack / Positioned

// ❌ NUNCA use CustomPaint em produção no FF
// CustomPaint não recebe `size` corretamente em builds minificadas/produção
```

---

## Armadilhas conhecidas

### Supabase

| Armadilha | O que acontece | Como evitar |
|---|---|---|
| Function overloads | Coexistem silenciosamente. Debugging de retorno null pode ser overload errado sendo chamado. | Sempre verificar: `SELECT pg_get_function_arguments(oid) FROM pg_proc WHERE proname = 'fn_name'` |
| Drop de overload específico | `DROP FUNCTION nome` falha se há múltiplos overloads | Usar assinatura exata: `DROP FUNCTION nome(tipo_param)` |
| Funções `STABLE` | Bloqueiam INSERT/UPDATE dentro delas | Usar `VOLATILE` (default) para RPCs que escrevem dados |
| Trigger em coluna dropada | Causa falha silenciosa com erro cryptic `record "new" has no field "X"` | Verificar `information_schema.triggers` quando remoção de coluna causa falha |
| `TO_CHAR` com `TM` | Não respeita locale PT no Supabase | Array hardcoded: `ARRAY['Janeiro','Fevereiro',...]` |
| `PGRST203` | Múltiplos overloads sem diferenciação de parâmetros | Checar overloads com `pg_proc` |

### FlutterFlow

| Armadilha | O que acontece | Como evitar |
|---|---|---|
| Imports duplicados em widget customizado | Quebra o widget silenciosamente | Nunca duplicar imports abaixo da linha `// DO NOT REMOVE OR MODIFY THE CODE ABOVE!` |
| `SingleChildScrollView` + `LayoutBuilder` + `AnimationController` | Causa remounting constante do controller | Evitar esta combinação em widgets animados |
| Nomes de campo no DataType ≠ nomes no JSON do RPC | Falha silenciosa de deserialization | Nomes devem ser idênticos |
| FF retorna 404 inesperado | Pode ser falta de headers `apikey`/`Authorization` na config da API call | Testar RPC no DB antes de debugar no FF |
| `valueOrDefault<String>(campo, '-') != ''` | **Sempre true** — fallback `'-'` nunca é vazio. Condição bugada não esconde nada. | Usar direto: `campo != null && campo != ''` |
| Container com altura fixa em volta de grid dinâmico | Grid fica cortado ou com overflow | Remover o Container; usar `GridView.builder` com `shrinkWrap: true` + `NeverScrollableScrollPhysics()` |

### Tabelas específicas

| Tabela | Regra especial |
|---|---|
| `RegistrosCardio` | **Não tem `IsDeleted`** — não filtrar por essa coluna |
| `RegistrosCardio` | Inserir via **Insert Row direto** no FF, não via RPC |
| `Pagamentos` | **Não tem coluna `Status`** — status é calculado comparando datas |
| `Pagamentos` | Trigger `trg_auto_status_atrasado` foi **dropado** — não recriar |
| `Perfis` | PK é `"idUser"` (UUID) — **NÃO** `"Id"`. Confirmar com `information_schema.columns` antes de fazer join |
| `PersonalAlunos` | **Sempre filtrar por `StatusConvite`** — um aluno pode ter múltiplos registros (pendente, aceito, recusado, substituido). Aluno ativo = `StatusConvite = 'aceito' AND Ativo = true` |
| `Notificacoes` | **Não tem `PerfisId`** — tem `DestinatarioPerfisId` e `RemetentePerfisId`. O schema antigo (Corpo, PerfisId) estava errado |

### Notificações — regras de comportamento

- **`NotificacoesStruct.remetenteId`** (String UUID) é necessário para o drawer do aluno chamar `responderConvitePersonalCall`. Sempre garantir que `get_notificacoes` retorne esse campo.
- **Tag `pagamento`**: o tap NÃO marca como lida no drawer do personal — o botão "Confirmar recebimento" é que controla. Isso evita que o botão desapareça antes do personal confirmar.
- **Tag `convite`**: os botões Aceitar/Recusar usam `notisItem.remetenteId` diretamente. `responder_convite_personal` marca a notif como lida no banco; o Flutter atualiza o estado local com `updateNotificacoesAtIndex`.
- **`criar_ou_vincular_aluno`** apaga notificações de convite pendentes do mesmo personal antes de criar nova — evita duplicatas ao reenviar convite.

---

## Padrão de componente bottom sheet animado

Todos os componentes flutuantes (ex: `substituir_exercicio`, `selecionar_exercicio`, `alunos_novo_objetivo`) seguem este padrão:

```dart
// Abertura (na página que chama)
final result = await showModalBottomSheet<T>(
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  enableDrag: false,
  context: context,
  builder: (ctx) => WebViewAware(
    child: GestureDetector(
      onTap: () { FocusScope.of(ctx).unfocus(); },
      child: Padding(
        padding: MediaQuery.viewInsetsOf(ctx),
        child: MeuComponenteWidget(parametros...),
      ),
    ),
  ),
);

// Estrutura do widget (root do build)
Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    Flexible(child: ClipRRect(borderRadius: 20, child: Container(...))),
    FlutterFlowIconButton(icon: FiRrCrossSmall, onPressed: _fechar),
  ]
  .divide(SizedBox(16))
  .addToStart(SizedBox(40))
  .addToEnd(SizedBox(40)),
)

// Animações obrigatórias
'cardOnActionTriggerAnimation': MoveEffect(delay:300, begin:Offset(0,100)) + ScaleEffect(begin:(-5,-5))
'closeButtonOnActionTriggerAnimation': MoveEffect(curve:bounceOut, delay:650, begin:Offset(0,100))

// Fechar com retorno
Future<void> _fechar([T? result]) async {
  await Future.wait([card.controller.reverse(), btn.controller.reverse()]);
  if (mounted) Navigator.pop(context, result);
}
```

---

## Decisões de arquitetura já tomadas

### Por que RPCs e não queries diretas do cliente?
- Centraliza lógica no banco (mais fácil de otimizar, auditar, versionar)
- RLS funciona mesmo com lógica complexa
- Escalabilidade: índices e query plans ajustados no banco, não no cliente

### Por que Riverpod e não BLoC/Provider?
- Já estava definido na arquitetura base do projeto
- `AsyncNotifier` encapsula loading/error/data de forma limpa

### Por que não `CustomPaint` para gráficos?
- Testado e confirmado: `size` não é passado corretamente em builds minificadas/produção do FlutterFlow
- Solução adotada: `Container` + `Row` + `Stack` + `Positioned` (widgets Flutter puros)

### Por que estado de métricas em `FFAppState().metricasTemp`?
- Widgets customizados não recebem parâmetros tipados de forma confiável no FF
- Padrão adotado: widget lê direto do AppState
- Acesso via variável local (`final x = FFAppState().metricasTemp; x.campo`)

### Por que `try/catch` individual por campo nas métricas?
- Evita que um campo com erro quebre toda a renderização
- Mais resiliente a mudanças de schema no RPC

---

## Workflow de diagnóstico (siga esta ordem)

1. **Testar RPC direto no DB** via `execute_sql` — confirmar que retorna dado correto
2. **Verificar overloads** — `SELECT pg_get_function_arguments(oid) FROM pg_proc WHERE proname = '...'`
3. **Verificar logs da API** — `get_logs` com `service: api` (fonte mais útil para 404s)
4. **Só então** ir para o frontend

---

## Ferramentas MCP

- `execute_sql` → diagnóstico (leitura)
- `apply_migration` → **toda** alteração de schema/função (fica no histórico de migrações)
- `get_logs` com `service: api` → 404s, erros de insert
- Após reconexão de sessão MCP: sempre chamar `list_projects` para confirmar projeto ativo

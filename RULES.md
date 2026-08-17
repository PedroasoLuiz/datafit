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
| **`INSERT` cru em `auth.users`** | Nasce um usuário fantasma: existe para `verificar_usuario_por_email` e não existe para o Auth. Sem linha em `auth.identities` o GoTrue não acha a pessoa por e-mail, então `/recover` responde **200 sem enviar nada** (anti-enumeração). E as colunas de token ficam `NULL` onde o GoTrue espera `''`, e a leitura da linha estoura antes de tudo: `error finding user: converting NULL to string is unsupported`, 500 `unexpected_failure` | **Nunca** criar usuário em SQL. Use a Edge Function `criar-usuario-auth` (`auth.admin.createUser`), que monta identidade e metadata |

### FlutterFlow

| Armadilha | O que acontece | Como evitar |
|---|---|---|
| Imports duplicados em widget customizado | Quebra o widget silenciosamente | Nunca duplicar imports abaixo da linha `// DO NOT REMOVE OR MODIFY THE CODE ABOVE!` |
| `SingleChildScrollView` + `LayoutBuilder` + `AnimationController` | Causa remounting constante do controller | Evitar esta combinação em widgets animados |
| Nomes de campo no DataType ≠ nomes no JSON do RPC | Falha silenciosa de deserialization | Nomes devem ser idênticos |
| FF retorna 404 inesperado | Pode ser falta de headers `apikey`/`Authorization` na config da API call | Testar RPC no DB antes de debugar no FF |
| `valueOrDefault<String>(campo, '-') != ''` | **Sempre true** — fallback `'-'` nunca é vazio. Condição bugada não esconde nada. | Usar direto: `campo != null && campo != ''` |
| Container com altura fixa em volta de grid dinâmico | Grid fica cortado ou com overflow | Remover o Container; usar `GridView.builder` com `shrinkWrap: true` + `NeverScrollableScrollPhysics()` |
| `AnimationController` do FF nasce **sem `duration`** | `forward`/`reverse` num controller que nenhum widget usa lança; dentro de `Future.wait` o erro engole o `Navigator.pop` e o fundo preto do modal fica na tela | Só declarar a animação de quem vai ser construído, e `try/catch` no recolhimento |
| `FFLocalizations.of(context)` em `Future` pós-frame | "Looking up a deactivated widget's ancestor" e tela vermelha quando a folha já fechou | Formatar data na hora de desenhar, não num `Future` agendado no `initState` |
| `showModalBottomSheet` sem `useRootNavigator: true` | Sobe no navegador da aba; folhas aninhadas caem na mesma pilha e uma fecha no lugar da outra | Sempre `useRootNavigator: true` |
| `resposta.succeeded ?? true` | Resposta nula passa por sucesso e a falha some | `resposta.succeeded != true` |
| `FlutterFlowDropDown.fillColor` | Pinta o botão **e** o menu que abre; campo sem caixa abre lista transparente | Usar `menuFillColor` e `menuElevation` (adicionados em 16/08/2026) |
| `formataData('')` | Devolve `DateTime.now()`, não nulo | Guardar `if (cru.trim().isEmpty) return null;` antes de chamar |
| Sessão da recuperação de senha | O link do e-mail cria **sessão de verdade** (é ela que autoriza o `updateUser`). O roteador vê `loggedIn` e abre o app para quem não escolheu senha nenhuma | Portão de `auth/recuperacao_senha.dart`: enquanto ligado, `FFRoute` devolve todo destino para a tela de nova senha. Navegar com `goNamed`, nunca `pushNamed`. A pendência é gravada no disco (a sessão também é, e matar o app burlava um portão só de memória), e a tela tem saída explícita que encerra a sessão |
| `authManager.updatePassword` | Engole a falha num `SnackBar` e devolve `void`: o app seguia adiante com a senha não gravada | Chamar `SupaFlow.client.auth.updateUser(UserAttributes(password: ...))` em `try/catch` e avisar com `MensagemWidget` |

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
| `TreinosExecucao` | Ciclo 1 é o **plano** (o que o personal definiu); ciclos > 1 são as repetições. `DataValidade` é propriedade do plano e se propaga na virada de ciclo |
| `ExerciciosTreinos` | **Não tem `IsDeleted`** |

### Notificações — regras de comportamento

- **`NotificacoesStruct.remetenteId`** (String UUID) é necessário para o drawer do aluno chamar `responderConvitePersonalCall`. Sempre garantir que `get_notificacoes` retorne esse campo.
- **Tag `pagamento`**: o tap NÃO marca como lida no drawer do personal — o botão "Confirmar recebimento" é que controla. Isso evita que o botão desapareça antes do personal confirmar.
- **Tag `convite`**: os botões Aceitar/Recusar usam `notisItem.remetenteId` diretamente. `responder_convite_personal` marca a notif como lida no banco; o Flutter atualiza o estado local com `updateNotificacoesAtIndex`.
- **`criar_ou_vincular_aluno`** apaga notificações de convite pendentes do mesmo personal antes de criar nova — evita duplicatas ao reenviar convite.

---

## Folhas do rodapé — use o `folha_kit`

Todo formulário e listagem que sobe do rodapé usa `lib/components/folha_kit.dart`.
**Não monte a casca à mão.** Antes de 16/08/2026 cada componente tinha o seu
desenho e a sua cópia da animação; hoje são 23 telas no mesmo kit.

```dart
// A tela inteira:
return FolhaPadrao(
  aoConfirmar: _gravar,          // devolve o valor do pop; `null` mantém aberta
  fixos: [CabecaFolha(...)],     // não rola (cabeçalho, busca)
  filhos: [CampoFolha(...)],     // rola
);

// Abertura (sempre com useRootNavigator):
await showModalBottomSheet<bool>(
  useRootNavigator: true,        // OBRIGATÓRIO — ver armadilha abaixo
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  context: context,
  builder: (folha) => WebViewAware(
    child: Padding(
      padding: MediaQuery.viewInsetsOf(folha),
      child: MinhaFolhaWidget(),
    ),
  ),
);
```

### Peças

| Peça | Para quê |
|---|---|
| `FolhaPadrao` | cartão branco, animação e os dois botões redondos |
| `CabecaFolha` | título, apoio e ícone em quadrado claro |
| `CampoFolha` | rótulo + campo de linha; acende em azul no foco |
| `CampoCompacto` | idem, sem recuo lateral, para viver numa linha |
| `LinhaCamposFolha` | dois ou três campos lado a lado |
| `CampoToqueFolha` | campo que abre algo (data, seletor) |
| `DropFolha` | dropdown com a mesma linha dos campos |
| `EscolhaFolha` / `EscolhaFolhaSimples` | pastilhas para poucas opções |
| `ChaveFolha` | liga/desliga com apoio |
| `ProgressoFolha` | slider com o número no rótulo |
| `ResumoFolha` | bloco de leitura ("sobre o quê?") |
| `BuscaFolha` / `ItemFolha` / `ListaFolha` | listagens paginadas |
| `AcaoDestrutivaFolha` | excluir, em vermelho, no pé |
| `MedidasFolha` | `lado 20`, `topo 22`, `base 24`, `entreCampos 18`, `raio 22` |

### Regras

- **`aoConfirmar` devolvendo `null` mantém a folha aberta.** É como campo
  inválido e erro de servidor se defendem sem perder o que foi digitado.
- **Fechar por dentro é `FolhaPadrao.fechar(context, resultado)`**, não
  `Navigator.pop`: só ela desfaz a animação de entrada.
- **Sem `aoConfirmar`, só o X aparece.** Use quando o toque num item já é a
  resposta (listagens) ou quando cada controle grava sozinho (preferências).
- Erro nunca é `SnackBar`: use `MensagemWidget`.

### Armadilhas que já custaram caro

- **`useRootNavigator: true` em toda folha.** Sem isso ela sobe no navegador
  da aba; um seletor de data aberto de dentro de outra folha cai na mesma
  pilha, e fechar um deixa o outro em pé.
- **`createAnimation` do FF cria `AnimationController` sem `duration`** — quem
  a define é o `Animate` ao se conectar. Mandar `forward`/`reverse` num
  controller que nenhum widget usa lança, e o erro sobe pelo `Future.wait` do
  fechamento: o cartão some e o fundo preto fica na tela. O kit só declara a
  animação de quem vai existir, e engole erro no recolhimento.
- **A altura do cartão desconta as bordas do sistema.** Limitar por fração da
  tela não basta: a folha ainda gasta 96 de folga e 72 de botões por fora, e o
  topo passava por baixo da barra de status.
- **`FFLocalizations.of(context)` nunca dentro de `Future` pós-frame.** Com a
  folha já fechada é "Looking up a deactivated widget's ancestor" e tela
  vermelha. Formate na hora de desenhar.
- **`?? true` em `resposta.succeeded` esconde falha.** Use `!= true`.

---

## Outros componentes compartilhados

| Arquivo | O que é |
|---|---|
| `components/perfil_kit.dart` | fichas de perfil: capa, avatar, cartões, chips, estrelas |
| `components/folha_kit.dart` | as folhas do rodapé (acima) |
| `components/baralho_cartas.dart` | `BaralhoCartas`: pilha que se arrasta, usada na home do aluno e na ficha do aluno pelo personal |
| `components/atalho_cartao.dart` | `AtalhoCartao`: linha branca com quadrado colorido de ícone |
| `components/mensagem_widget.dart` | o aviso padrão do app (sucesso/erro) |

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

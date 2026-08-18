# Datafit — Status dos Módulos

> Referenciado por: [`../CLAUDE.md`](../CLAUDE.md)
> Atualizado conforme sessões de desenvolvimento.

---

## Legenda

| Símbolo | Significado |
|---|---|
| ✅ | Completo (DB + UI conectados e funcionando) |
| 🔧 | DB pronto, UI pendente de conexão |
| 🚧 | Em andamento / parcialmente implementado |
| ❌ | Pendente / não iniciado |
| ⚠️ | Bug conhecido / issue aberta |

---

## Autenticação

### ✅ Tela de Boas-vindas (`/start`)
- `StartWidget` deixou de ser splash (mostrava o logo por 10s e empurrava o login sozinho) e virou a tela de entrada
- Saudação por horário do aparelho: "Bom dia" (<12h) / "Boa tarde" (<18h) / "Boa noite"
- Dois botões: `Já tenho conta` → `/login` · `Sou novo por aqui` → `/cadastro`
- Continua sendo a primeira tela (rota `/` para deslogado), não uma etapa a mais
- `FFRoute` já mostra spinner enquanto `appStateNotifier.loading` — logado nunca vê esta tela
- Botão de voltar adicionado em `login` e `cadastro`: a transição de fade não tem o gesto de voltar do iOS

---

## Módulos do Aluno

### ✅ Execução de Treino
- Fila rotacional de treinos (ordem via campo `Ordem`)
- 3 estados de exercício: Concluído / Em andamento / Pulado
- Skip logic (`pular_exercicio`)
- `PersistentTimer` (widget customizado com SharedPreferences)
- Finalização com registro de início/fim (`finalizar_treino_aluno`)
- Feedback pós-treino (`salvar_feedback_treino`)
- Seção de repetições manuais ("Suas repetições são:") **ocultada** — usa sempre as reps definidas pelo personal
- Botão "Continuar" **oculto** quando todas as séries foram concluídas (`seriesFeitas >= series`) — só "Finalizar" aparece
- "Dúvidas neste exercício?" só exibido quando `linkInstrucao != null && != ''` (condição anterior era bugada com `valueOrDefault`)

### ✅ Dados Corporais
- Upsert peso/altura por dia (`upsert_informacoes_corporais`)
- Timezone `America/Sao_Paulo`
- Função Dart `formatarPesoParaBanco`

### ✅ Gráfico de Evolução de Peso (`GraficoEvolucaoPeso`)
- Slot-building por data exata
- Propagação mensal com last-day logic
- Backward-propagation via `generate_series` + correlated subquery
- Comparações timezone-aware

### ✅ Fotos Mensais de Evolução
- `upsert_registro_mensal`, `get_registros_mensais`
- Nomes de meses em PT-BR via array hardcoded (não `TO_CHAR TM`)

### ✅ Dashboard de Métricas (`get_metricas_aluno`)
- `dsCabecalho`, `dsPerimetros`, `dsHistoricoPeso`, `dsMetricas`, `dsExercicios`
- Granularidade diária
- Períodos: 7d, 15d, 30d, 2m, 3m, 4m, 6m

### ❌ `dsCardios` em `get_metricas_aluno`
- Agrupar `RegistrosCardio` por descrição com total de minutos, km e count
- **Baixa prioridade** — explicitamente adiado

---

## Módulos do Personal

### ✅ Perfil do Personal
- RPC `get_perfil_personal_publico` funcionando no DB
- Campos: `totalTreinos`, `totalExercicios`, `linkInstrucao`, `execucaoId`
- ~~⚠️ 404: suspeita de headers ausentes~~ **Corrigido** — causa real era barra duplicada na URL (`${baseUrl}/get_perfil_personal_publico`, sendo que `baseUrl` já termina em `/`). Fix em `api_calls.dart` (`GetPerfilPersonalCall`)

### ✅ Pagamentos
- Tabela `Notificacoes` criada
- RPCs: toggle ativo/inativo, `upsert_pagamento`, `delete_pagamento`
- Geração automática de notificações
- Status calculado: `pago` / `atrasado` / `pendente` (sem coluna Status)
- `TipoPagamento` normalizado lowercase sem acentos + `fn_label_tipo_pagamento`
- Trigger `trg_auto_status_atrasado` **dropado** (não recriar)

### ✅ CRUD de Treinos do Personal
- RPCs prontas: `get_treinos_personal`, `upsert_treino`, `delete_treino`, `adicionar_exercicio_treino`, `remover_exercicio_treino`
- 3 níveis de navegação: Grupos → Treinos → Exercícios
- Swipe para editar/excluir em todos os 3 níveis
- `GruposTreino` usa `Ativo: false` para soft-delete (não `IsDeleted`)
- Nível 1: lista de grupos com busca client-side + slider editar/excluir
- Nível 2: lista de treinos com slider editar/excluir + ordenação A→Z
- Nível 3: exercícios agrupados por subcategoria (A→Z) + slider editar/excluir
- Header do nível 3 exibe breadcrumb: nome do grupo (cinza/pequeno) + nome do treino
- Gestão de Exercícios: busca, lock icon para exercícios padrão, sem duplicatas (validação `.ilike`)
- `FlutterFlowDropDown` para subcategoria no formulário de exercício
- Animação de entrada no formulário separada do carregamento de rede

### ✅ Tela de Treinos do Aluno — Foto do Personal
- RPC `get_treino_ativo_aluno` atualizada: join em `Perfis` pelo campo `"idUser"` (NÃO `"Id"`) para buscar `"FotoUrl"`
- Campo `personalFotoUrl` adicionado ao `GrupostreinosStruct`
- `treinos_widget.dart`: exibe foto via `Image.network` com fallback para asset local se null/vazio/erro

### ✅ Substituir Exercício — Componente Animado
- Componente: `lib/pages/components/substituir_exercicio/` (widget + model)
- Animação padrão do app: `cardOnActionTriggerAnimation` (MoveEffect + ScaleEffect) + botão fechar com `bounceOut`
- Carrega substitutos via RPC `get_substitutos_exercicio(p_execucao_id int)` retorna `[{id, descricao}]` de `ExerciciosSubstitutos`
- Aberto via `showModalBottomSheet(isScrollControlled: true, backgroundColor: transparent)`
- Retorna `String?` (nome escolhido) via `Navigator.pop(context, nome)` após reverter animações
- `treinos_detalhes_widget.dart`: resultado salvo em `_model.substitutos[execucaoId]`
- Na lista: nome original fica riscado + cor secundária; nome substituto aparece abaixo em destaque
- Na execução: se há substituto salvo, aplica o nome a `exercicioTemp.nome` antes de navegar

### ✅ Cadastro e Convite de Alunos (Personal)
- `novo_aluno_widget.dart`: formulário Nome + Email com debounce de verificação
- `verificar_usuario_por_email` → retorna se email existe na auth, se perfil está completo, e outros personais vinculados
- Edge Function `criar-usuario-auth` → cria a conta no Auth pela Admin API e devolve `userId` (idempotente: e-mail que já existe volta com `criado: false`). **A RPC não cria mais usuário**, ver a armadilha do INSERT cru em `RULES.md`
- `criar_ou_vincular_aluno` → recebe o UUID pronto, cria Perfis, cria PersonalAlunos com StatusConvite='pendente', dispara notificação `convite` pro aluno (apaga duplicatas antes). Sem UUID devolve `SEM_USUARIO_AUTH`
- Se aluno já vinculado a outro personal → retorna `ALUNO_JA_VINCULADO` com lista; UI pede confirmação com `forcarVinculo=true`
- Após sucesso → `supabase.auth.resetPasswordForEmail` envia e-mail pro aluno definir senha, com destino em `lib/link_email_auth.dart`. O endereço precisa estar em Authentication > URL Configuration > Redirect URLs: fora da lista o GoTrue manda a pessoa para a Site URL, que é a landing `godata.fit`, e o link não abre o app
- `responder_convite_personal` → ao aceitar: desativa personal antigo, remove treinos do antigo, ativa novo vínculo, marca notif como lida; ao recusar: marca recusado e notif como lida

### 🔧 Atribuição de Treinos a Alunos
- RPC pronta: `atribuir_treino_aluno`
- **UI não conectada ainda**

### ✅ Drawer de Notificações (Personal e Aluno)
- Design estilo Apple/Facebook: sem card com borda, só Divider (indent 52px)
- Ícones pastéis por tag: `pagamento` → azul `accent1`/`primary`; `treino` → verde `#E8F5E9`/`success`; `meta` → laranja `accent2`/`secondary`; `convite` → azul `accent1`/`primary`; default → roxo `#F3E5F5`/`#7C3AED`
- Título azul (`primary`) quando não lida; preto (`primaryText`) após tocar/marcar como lida
- Badge counter no ícone de notificações do personal (`badges.Badge`)
- Botão de confirmar pagamento no drawer do personal (desaparece após confirmar, sem marcar lida no tap)
- Botões Aceitar/Recusar no drawer do aluno para tag `convite` — usam `remetenteId` direto (UUID), sem lookup por nome
- `get_notificacoes` retorna `remetenteId` (UUID do remetente) além do `remetente` (nome)
- `NotificacoesStruct` tem campo `remetenteId`
- `responder_convite_personal` marca notificação de convite como lida ao responder

### ✅ Pagamentos — Chave Pix visível para o Aluno
- Na tela de perfil do personal (visão do aluno), aba de pagamentos exibe card com a chave Pix cadastrada acima da lista de pagamentos

### ✅ Tela de Perfil do Personal — Grid de Vídeos
- `ReelsVideoGrid` widget: aspect ratio 9:16 (portrait, estilo Instagram Reels)
- `GridView.builder` com `shrinkWrap: true` + `NeverScrollableScrollPhysics()` dentro de `SingleChildScrollView`
- Container wrapper com altura fixa **removido** (estava cortando o grid)
- Thumbnails via `https://img.youtube.com/vi/$videoId/hqdefault.jpg`
- Tap abre link no navegador via `LaunchMode.externalApplication`
- ⚠️ Seção de pagamentos: pendente de conclusão

### ❌ Dois contadores no header do perfil
- Conteúdo a definir

---

## Widgets Customizados

| Widget | Status | Descrição |
|---|---|---|
| `GraficoEvolucaoCarga` | ✅ | Bar chart — lê de `FFAppState().metricasTemp` |
| `GraficoEvolucaoPeso` | ✅ | Line chart |
| `ReelsVideoGrid` | ✅ | Grid 9:16 estilo Instagram, thumbnails YouTube, `url_launcher` |
| `YoutubeVideoCard` | ✅ | Card de vídeo YouTube |
| `YoutubeGridItem` | ✅ | Item do grid YouTube |
| `SlideToConfirm` | ✅ | Confirmação por slide |
| `PersistentTimer` | ✅ | Cronômetro com SharedPreferences |

---

## Funções Customizadas Dart

| Função | Status | Descrição |
|---|---|---|
| `extrairSubcategorias` | ✅ | |
| `achatarExercicios` | ✅ | `filtro` nullable para evitar crash |
| `gerarMeses` | ✅ | |
| `formatarMesParaCaminho` | ✅ | |
| `primeiroDiaDoMes` | ✅ | |
| `formatarPesoParaBanco` | ✅ | |

---

## Padronização de UI — 16/08/2026

### ✅ `folha_kit` — todas as folhas do rodapé
23 componentes passaram a usar `lib/components/folha_kit.dart`, de 15.400 para
3.900 linhas. Fundo branco, campo com linha embaixo que acende em azul no foco,
e os dois botões redondos com a animação de sempre. Detalhes em `RULES.md`.

Convertidos: `novo_aluno`, `selecionar_treino_aluno`, `selecionar_exercicio`,
`substituir_exercicio`, `treinos_novo_treino`, `treinos_novo_sub_treino`,
`treinos_novo_exercicio_treino`, `novo_exercicio`, `alunos_novo_exercicio`,
`alunos_edit_exercicio`, `alunos_novo_objetivo`, `alunos_editar_objetivo`,
`informar_pagamento`, `pagamentos_novo`, `pagamentos_edit`,
`perfil_aluno_status`, `confirmar_recebimento`, `avaliar_personal`,
`folha_feedback_treino`, `preferencias_app`, `feedback_app`, `convite_personal`,
`custom_date_picker`, `metas_fotos`, os dois de cárdio e os filtros de grupo.

**Fora do kit de propósito:** `mensagem_widget` (aviso, desenho próprio),
`reels_video_grid`, `novidades_sessao`, `foto_tela_cheia`.

### ✅ Componentes extraídos para reuso
- `BaralhoCartas` (era privado de `treinos_widget`): a home do aluno e a ficha
  do aluno vista pelo personal usam o mesmo baralho
- `AtalhoCartao` (era privado de `treinos_widget`): treino, personal e validade

### ✅ Ficha do aluno vista pelo personal
Baralho de cartas para os blocos do treino, atalhos abaixo, aba Desenvolvimento
com sub-chips (Métricas/Cargas/Corpo), Metas em aba própria, e a lista de
pagamentos no mesmo desenho da ficha que o aluno vê do personal.

### 🗑️ `codconfimacao` — apagado
Tela de código de 5 dígitos por e-mail, resto do scaffold inicial do
FlutterFlow. Nasceu no commit inicial, nunca foi referenciada por nada, e o
app usa o link de confirmação do Supabase em vez de código. Removida em
16/08/2026.

### ✅ Perímetros corporais na aba Corpo
`PerimetrosCorporais` era gravada pela edição de perfil e **nenhuma tela lia**.
A RPC `get_perimetros_aluno` fechou a lacuna: a aba Corpo da ficha do aluno
mostra a última medida de cada perímetro, a data e a variação desde a primeira.

- A variação vem calculada do banco, não do app
- Só aparece com duas medições ou mais (com uma só seria sempre "0,0")
- Busca sob demanda com o `CacheCurto`: quem abre a ficha para ver o treino
  nunca dispara a chamada

### ✅ Feedback do app — 18/08/2026
Item "Enviar feedback" no grupo Geral do menu do usuário, logo depois da Ajuda.
Folha `components/feedback_app.dart` no padrão do `folha_kit`.

- Assunto (Sugestão / Problema / Elogio / Outro), nota opcional de 1 a 5,
  mensagem com teto de 1000 caracteres e e-mail de resposta já preenchido
- Plataforma e versão (`package_info_plus`) vão junto sem serem digitadas: sem
  elas um "trava ao salvar" não diz em qual build travou
- A folha mostra os envios anteriores da pessoa com o status de cada um
- Grava por `enviar_feedback_app`, com teto de 5 envios por dia
- Leitura: `SELECT * FROM public.vw_feedbacks_app WHERE status = 'novo';`
- Não se confunde com `avaliar_personal`: aquele é a nota pública ao personal,
  este é privado e fala do app
- Ícone da família `FiRr` (`FFIcons.kproperty1FiRrComment`), como os vizinhos
  Segurança, Termos e Ajuda: os ícones do menu são todos de linha

### 🗑️ "Meu plano" no drawer do perfil — removido em 18/08/2026
A tabela com free / standard / partner e os preços saiu do drawer. Já vivia
oculta no iOS (Guideline 3.1.1) e o gate `tipoPerfilId == 1` a mostrava para
alunos, não para personais. Planos continuam sendo vendidos pelo site.

---

## Correções de 16/08/2026

| O quê | Causa |
|---|---|
| Validade do treino divergia entre personal e aluno | A virada de ciclo em `get_treino_ativo_aluno` reescrevia `DataValidade` para `CURRENT_DATE`: o rebase por defasagem dava sempre zero, porque todas as linhas de um ciclo têm a mesma data. Corrigido para copiar a validade do plano; ciclo corrente reparado |
| Treino C aparecia duas vezes na ficha do aluno | `get_perfil_aluno_pelo_personal` percorria toda linha `pendente` de `TreinosExecucao`, e o mesmo treino existe no ciclo 1 (plano) e no corrente. Agora `DISTINCT ON (Treinos.Id)` |
| Fundo preto ficava depois de fechar a folha | `AnimationController` do FF sem `duration` (ver `RULES.md`) |
| Tela vermelha ao editar cobrança | `FFLocalizations.of` em `Future` pós-frame |
| Seletor de treino não fechava | Folha e calendário em navegadores diferentes |
| Menu do dropdown transparente | `fillColor` pintava botão e menu; adicionados `menuFillColor` e `menuElevation` em `flutter_flow_drop_down.dart` |
| Bloquear aluno parecia não funcionar | `?? true` escondia falha. **Banco verificado e correto** — se persistir, a folha agora mostra o motivo |
| Cartão da folha passava sob a barra de status | Altura media só a fração da tela, sem descontar bordas do sistema nem o que a folha gasta em volta |

---

## Correções de 16/08 e 17/08/2026: Auth e convite

Uma causa só explicava quatro sintomas: "o aluno já existe" para quem nunca se
cadastrou, login com Apple recusado, e-mail de convite e de redefinição que não
chegavam. Detalhe em `RULES.md`, seções do INSERT cru e dos e-mails do Auth.

| O quê | Causa |
|---|---|
| Aluno existia para a checagem de e-mail e não existia para o Auth | A RPC criava o aluno com `INSERT` cru em `auth.users`. Sem linha em `auth.identities` o GoTrue não acha a pessoa por e-mail: `/recover` responde **200 sem enviar nada**. 14 usuários reparados; a criação agora é sempre pela Edge Function `criar-usuario-auth` |
| Depois do reparo, `/recover` passou a dar 500 | As colunas de token estavam `NULL` onde o GoTrue espera `''`: `error finding user: converting NULL to string is unsupported`. Normalizadas, junto com `instance_id` e `raw_app_meta_data` |
| Link do e-mail caía na landing | Template apontava para `{{ .SiteURL }}/auth/callback`, rota que não existe. Trocado por `{{ .ConfirmationURL }}`; deep links adicionados em Redirect URLs |
| Sessão do link de recuperação entrava no app sem trocar a senha | A tela subia com `pushNamed` por cima de um app já aberto por baixo. Portão em `auth/recuperacao_senha.dart`, `goNamed`, pendência gravada em disco e saída explícita na tela |
| App seguia adiante mesmo sem gravar a senha | `authManager.updatePassword` engole a falha num `SnackBar` e devolve `void`. Agora `updateUser` em `try/catch`, com `MensagemWidget` |

Testado de ponta a ponta em 17/08 com contas descartáveis (`+` no Gmail), lendo
o link de dentro dos e-mails: criar conta, convite (Edge Function, RPC, e-mail) e
redefinir senha. Os três passam, e o `verify` devolve **303** para o deep link.
Base conferida depois: 23 usuários, nenhum sem identidade, nenhum token nulo.

---

## Issues abertas

- **Lista de alunos ficava "pendente" após o aceite** (corrigido, **ainda não publicado**): a lista só vinha do `Loading`. A tela `/aluno` agora pinta o cache e busca de novo, com validade de 60s. Ver `RULES.md`, "Cache de lista com validade". Mexe em `actions.dart`, `aluno_widget.dart`, `criaraluno_widget.dart` e `perfil_aluno_status_widget.dart`
- Template **Confirm signup** ainda tem `© 2026 Sua Empresa` no rodapé, texto de exemplo
- Template **Magic Link** segue o padrão em inglês do Supabase (não usado hoje)
- `get_alunos_do_personal` calcula o mesmo join duas vezes por aluno (ver `DATABASE.md`)

As duas issues anteriores foram revisadas em 2026-07-01: As duas issues anteriores foram revisadas em 2026-07-01:
- 404 em `get_perfil_personal_publico` → **corrigido** (barra duplicada na URL, ver módulo "Perfil do Personal" acima)
- `FlutterFlowYoutubePlayer` com `url:` inválido em `alunos_edit_exercicio_widget.dart` → **não reproduz mais**: o arquivo atual não contém nenhum `FlutterFlowYoutubePlayer` nem referência a "youtube" além de um hint text de input. Nota estava desatualizada (provavelmente já resolvida antes e não documentada).

---

## Email de notificações
- **Explicitamente adiado** — fora do escopo atual

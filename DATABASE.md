# Datafit — Banco de Dados (Supabase)

> Referenciado por: [`../CLAUDE.md`](../CLAUDE.md)
> Veja também: [`RULES.md`](./RULES.md) para armadilhas de SQL

---

## Conexão

- **Project ID:** `idsopfkwmquvndwmwlbr`
- **Host:** `db.idsopfkwmquvndwmwlbr.supabase.co`
- **Schema principal:** `public`
- **Timezone padrão:** `America/Sao_Paulo`
- **Postgres Engine:** 15.x

---

## Grupos de tabelas

### 👤 Auth / Perfil

#### `auth.users` (nativa Supabase)
Criada automaticamente no cadastro.
| Coluna | Tipo |
|---|---|
| `id` | `uuid` PK |
| `email` | `text` |
| `created_at` | `timestamptz` |

#### `Perfis`
Perfil público do usuário.
| Coluna | Tipo | Obs |
|---|---|---|
| `idUser` | `uuid` PK | FK → auth.users |
| `Nome` | `varchar` | |
| `NickName` | `varchar` | |
| `TiposPerfilId` | `bigint` FK | → TiposPerfil |
| `TelefonesId` | `bigint` FK | → Telefones |
| `UrlImgPerfil` | `text` | |
| `Ativo` | `bool` | |

#### `TiposPerfil`
Catálogo: **`Personal` (1), `Aluno` (2), `Administrador` (3)**.

> ⚠️ Conferido no banco em 2026-08-10. Esta doc afirmava o inverso (Aluno=1,
> Personal=2) e isso já gerou código errado — ver `scripts/conta_demo_revisor.sql`.
> Ao criar perfil, prefira resolver pelo texto (`WHERE "Descricao" = 'Personal'`),
> como fazem `fn_auto_assinatura_free` e `criar_perfil_inicial`.

#### `Telefones`
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `Numero` | `varchar` |
| `IsWhatsApp` | `bool` |
| `Ativo` | `bool` |

#### `InformacoesCorporais`
Histórico de peso/altura por aluno. Um registro por dia (upsert-by-day).
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `PerfisId` | `uuid` FK |
| `Peso` | `real` |
| `Altura` | `real` |
| `created_at` | `timestamptz` |

**Timezone:** sempre `America/Sao_Paulo` para agrupar por dia.

#### `PerimetrosCorporais`
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `PerfisId` | `uuid` FK |
| `TiposPerimetroId` | `bigint` FK |
| `ValorCm` | `real` |
| `DataRegistro` | `date` |

#### `PersonalAlunos`
Vínculo N:N Personal ↔ Aluno.
| Coluna | Tipo | Obs |
|---|---|---|
| `Id` | `bigint` PK | |
| `PersonalPerfisId` | `uuid` FK | |
| `AlunoPerfisId` | `uuid` FK | |
| `Ativo` | `bool` | |
| `DataVinculo` | `date` | |
| `DataDesvinculo` | `date` | Preenchido ao substituir personal |
| `StatusConvite` | `varchar` | `pendente` / `aceito` / `recusado` / `substituido` |
| `StatusCobranca` | `varchar` | |

**Fluxo de StatusConvite:** personal cria → `pendente`; aluno aceita → `aceito`; aluno recusa → `recusado`; aluno aceita outro personal → registro antigo vira `substituido`.

#### `Metas`
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `Titulo` | `varchar` |
| `Progresso` | `int` |
| `SolicitantePerfisId` | `uuid` FK |
| `ExecutorPerfisId` | `uuid` FK |
| `UrlImg` | `text` |

#### `RegistrosMeta`
Fotos de progresso de uma meta.

#### `Notificacoes`
Notificações geradas automaticamente (pagamento, convite, treino, meta, etc.).
| Coluna | Tipo | Obs |
|---|---|---|
| `Id` | `bigint` PK | |
| `DestinatarioPerfisId` | `uuid` FK | Quem recebe |
| `RemetentePerfisId` | `uuid` FK nullable | Quem enviou |
| `Titulo` | `varchar` | |
| `Descricao` | `text` nullable | |
| `Tag` | `varchar` nullable | `pagamento` / `convite` / `treino` / `meta` / null |
| `Lida` | `bool` | |
| `ReferenciaId` | `bigint` nullable | ID relacionado (ex: pagamento) |
| `created_at` | `timestamptz` | |

**Tags e comportamento no drawer:**
| Tag | Ícone | Cor fundo | Ação especial |
|---|---|---|---|
| `pagamento` | `payments_rounded` | `accent1` | Botão "Confirmar recebimento" (só drawer do personal) |
| `convite` | `person_add_rounded` | `accent1` | Botões Aceitar/Recusar (só drawer do aluno) |
| `treino` | `fitness_center_rounded` | `#E8F5E9` | — |
| `meta` | `flag_rounded` | `accent2` | — |
| default | bell | `#F3E5F5` | — |

---

### 🏋️ Treinos

#### `Treinos`
Template de treino criado pelo personal.
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `Descricao` | `varchar` |
| `NiveisTreinoId` | `bigint` FK |
| `CategoriasTrabalhadasId` | `bigint` FK |
| `CriadorPerfisId` | `uuid` FK |
| `Ativo` | `bool` |
| `IsDeleted` | `bool` |

#### `Exercicios`
Banco de exercícios do personal.
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `Descricao` | `varchar` |
| `SubCategoriasTrabalhadasId` | `bigint` FK |
| `CriadorPerfisId` | `uuid` FK |
| `LinkInstrucao` | `varchar` | URL do vídeo |
| `Ativo` | `bool` |
| `IsDeleted` | `bool` |

#### `ExerciciosTreinos`
N:N — liga exercícios ao treino.

#### `ExerciciosSubstitutos`
Alternativas para um exercício.

---

### ▶️ Execução

#### `TreinosExecucao`
Instância real do treino atribuída ao aluno.
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `TreinosId` | `bigint` FK |
| `SolicitantePerfisId` | `uuid` FK | Personal |
| `ExecutorPerfisId` | `uuid` FK | Aluno |
| `DataHoraInicio` | `timestamp` |
| `DataHoraConclusao` | `timestamp` |
| `DataValidade` | `date` |
| `Ordem` | `int` | Controla fila rotacional |

**Fila rotacional:** ao concluir um treino, ele vai para o final da fila via update em `Ordem`.

#### `ExerciciosExecucao`
Config do exercício na execução (séries, reps, observação).
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `ExerciciosId` | `bigint` FK |
| `SolicitantePerfisId` | `uuid` FK |
| `SerieExecucao` | `bigint` |
| `RepExecucao` | `bigint` |
| `SerieAquecimento` | `bigint` |
| `Observacao` | `varchar` |
| `Ordem` | `int` |
| `IsDeleted` | `bool` |

#### `ExerciciosExecucaoTreinosExecucao`
N:N — liga instâncias de exercício à instância do treino.

#### `CargaExerciciosExecucao`
Carga planejada: quantidade, peso e unidade.

#### `RegistrosDescanso`
Cada disparo do cronômetro gera um registro.
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `PerfisId` | `uuid` FK |
| `TreinosExecucaoId` | `bigint` FK |
| `ExerciciosExecucaoId` | `bigint` FK |
| `DuracaoSegundos` | `int` |

#### `RegistrosCardio`
Cardio livre adicionado pelo aluno.
| Coluna | Tipo | Obs |
|---|---|---|
| `Id` | `bigint` PK | |
| `PerfisId` | `uuid` FK | |
| `TreinosExecucaoId` | `bigint` FK | |
| `Descricao` | `varchar` | |
| `DuracaoMinutos` | `int` | |
| `DistanciaKm` | `real` | |

> ⚠️ **`RegistrosCardio` NÃO tem coluna `IsDeleted`** — não filtre por ela.
> Inserir via **Insert Row direto** no FF, não via RPC.

---

### ✅ Conclusão

#### `TreinosConclusao`
Resultado final do treino.
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `TreinosExecucaoId` | `bigint` FK |
| `DataHoraInicio` | `timestamp` |
| `DataHoraConclusao` | `timestamp` |
| `IsTreinoConcluido` | `bool` |

#### `ExerciciosConclusao`
Status de cada exercício: `IsConcluido` ou `IsPulado`. Três estados possíveis: Concluído / Em andamento / Pulado.

#### `ExerciciosConclusaoTreinosConclusao`
N:N — liga ExerciciosConclusao ao TreinosConclusao.

#### `CargaExerciciosConclusao`
Carga REAL executada. Histórico de progressão de carga.

---

### 💳 Financeiro

#### `Planos`
| Código | Limite | Valor | Benefício |
|---|---|---|---|
| `free` | 1 aluno | R$ 0 | Cadastro inicial |
| `standard` | ilimitado | R$ 47 | Acesso completo |
| `partner` | ilimitado | R$ 97 | +50% comissão indicações |

#### `Assinaturas`
| Coluna | Tipo |
|---|---|
| `Id` | `bigint` PK |
| `PerfisId` | `uuid` FK |
| `PlanosId` | `bigint` FK |
| `Status` | `varchar` | `ativa` / `pendente` / `cancelada` |
| `DataVencimento` | `date` |
| `IndicadoPorPerfisId` | `uuid` FK |
| `GatewaySubscriptionId` | `varchar` |

#### `Pagamentos`
Status calculado por comparação entre `DataPagamento` e `DataVencimento` — **não existe coluna `Status` na tabela**.

| Status calculado | Condição |
|---|---|
| `pago` | `DataPagamento` preenchida |
| `atrasado` | sem pagamento + vencido |
| `pendente` | sem pagamento + não vencido |

> ⚠️ O trigger `trg_auto_status_atrasado` foi **dropado** — não recriar.

---

### 📋 Catálogos

- `NiveisTreino` — Iniciante, Intermediário, Avançado
- `CategoriasTrabalhadas` — Superiores, Inferiores, Core…
- `SubCategoriasTrabalhadas` — Bíceps, Tríceps, Quadríceps… (filho de Categorias)
- `TiposPerimetro` — 13 tipos: Braço, Cintura, Coxa…
- `Medidas` — Unidades de carga: kg, lb, reps…

---

## RPCs implementadas

### Aluno
| RPC | Descrição |
|---|---|
| `get_treino_ativo_aluno` | Retorna treino ativo + exercícios na ordem da fila. **Vira o ciclo** quando o atual acabou, sob `pg_advisory_xact_lock` por aluno. A cópia preserva `DataValidade` do plano (corrigido 16/08/2026: antes rebaseava para `CURRENT_DATE` e o treino nascia vencido) |
| `finalizar_treino_aluno` | Conclui treino, move para fim da fila rotacional |
| `salvar_feedback_treino` | Salva feedback pós-treino |
| `pular_exercicio` | Marca exercício como pulado |
| `upsert_informacoes_corporais` | Upsert peso/altura por dia (timezone SP) |
| `get_perfil_by_id` | Retorna perfil + `porcentagemGordura` |
| `upsert_registro_mensal` | Foto mensal de evolução |
| `get_registros_mensais` | Lista fotos mensais |
| `get_metricas_aluno` | Dashboard de métricas — veja campos abaixo |

#### `get_metricas_aluno` — campos retornados
- `dsCabecalho` — resumo geral
- `dsPerimetros` — perímetros musculares
- `dsHistoricoPeso` — histórico de peso (slot-based, propagação backward)
- `dsMetricas` — métricas diversas
- `dsExercicios` — evolução de exercícios

**Períodos suportados:** `"7 dias"`, `"15 dias"`, `"30 dias"`, `"2 meses"`, `"3 meses"`, `"4 meses"`, `"6 meses"`

### Personal
| RPC | Descrição |
|---|---|
| `get_treinos_personal` | Lista treinos criados pelo personal |
| `upsert_treino` | Cria/edita treino |
| `delete_treino` | Soft delete de treino |
| `adicionar_exercicio_treino` | Adiciona exercício a um treino |
| `remover_exercicio_treino` | Remove exercício de um treino |
| `atribuir_treino_aluno` | Atribui treino a um aluno |
| `get_perfil_personal_publico` | Perfil público com `totalTreinos`, `totalExercicios` |
| `get_notificacoes` | Lista notificações (retorna `remetente` nome + `remetenteId` UUID) |
| `marcar_notificacao_lida` | Marca notificação como lida |
| `criar_notificacao` | Cria notificação genérica (aceita `p_tag`) |
| `verificar_usuario_por_email` | Verifica se email existe na auth; retorna `existeNaAuth`, `userId`, `perfilCompleto`, `outrosPersonais` |
| `criar_ou_vincular_aluno` | Cria usuário na auth se não existe, cria Perfis, cria PersonalAlunos (pendente), dispara notif `convite`; retorna `ALUNO_JA_VINCULADO` se conflito sem forcarVinculo |

### Convite / Vínculo
| RPC | Descrição |
|---|---|
| `responder_convite_personal` | Aluno aceita/recusa convite; ao aceitar: desativa personal antigo + treinos; ao recusar: marca recusado. Marca notif como lida em ambos os casos |
| `get_convites_pendentes` | Lista convites pendentes do aluno (PersonalAlunos com StatusConvite='pendente') |

### Pagamentos
| RPC | Descrição |
|---|---|
| `upsert_pagamento` | Cria/edita pagamento de aluno |
| `delete_pagamento` | Remove pagamento |
| `toggle_aluno_ativo` | Ativa/desativa aluno do personal |
| `aluno_informar_pagamento` | Aluno informa pagamento; insere notif com Tag='pagamento' para o personal |
| `confirmar_pagamento_aluno` | Personal confirma recebimento; marca pagamento como pago e notif como lida |

### Helpers
| Função | Descrição |
|---|---|
| `fn_label_tipo_pagamento` | Converte `TipoPagamento` para label display |
| `criar_notificacao` | Cria notificação genérica com `p_destinatario_uuid`, `p_remetente_uuid`, `p_titulo`, `p_descricao`, `p_tag` |

---

## Padrões críticos de SQL

```sql
-- Soft delete: SEMPRE assim (registros antigos têm null)
WHERE COALESCE("IsDeleted", false) = false

-- Timezone: SEMPRE explícito
WHERE DATE(created_at AT TIME ZONE 'America/Sao_Paulo') = DATE(NOW() AT TIME ZONE 'America/Sao_Paulo')

-- Meses em português: NÃO use TO_CHAR com TM (não funciona no Supabase)
-- Use array hardcoded:
ARRAY['Janeiro','Fevereiro','Março','Abril','Maio','Junho',
      'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro']

-- Verificar overloads antes de debugar retorno null:
SELECT pg_get_function_arguments(oid) FROM pg_proc WHERE proname = 'nome_da_fn';
```

---

## Índices e escalabilidade

Ao adicionar tabelas com volume esperado alto, criar índices em:
- Colunas FK usadas em JOINs frequentes
- Colunas de data usadas em filtros de período
- `PerfisId` em todas as tabelas de histórico

---

## RPCs revisadas em 16/08/2026

| RPC | Nota |
|---|---|
| `get_treino_ativo_aluno` | A virada de ciclo copia `DataValidade` como está. Ciclo 1 é o plano; ciclos > 1 são repetições |
| `get_perfil_aluno_pelo_personal` | `subagrupamentos` usa `DISTINCT ON (Treinos.Id)` ordenado por `CicloNumero DESC`: o mesmo treino existe no plano e no ciclo corrente, e ambos `pendente` duplicavam o card |
| `toggle_status_aluno` | Lê `Ativo` e inverte. Funciona (testado com rollback); o bug de "não bloqueia" era do app |
| `atribuir_grupo_treino_aluno` | Responde `sucesso: true` com `treinosCriados: 0` em alguns casos, o app checa os dois |
| `get_perimetros_aluno(p_aluno_uuid)` | **Nova em 16/08/2026.** Um item por tipo de perímetro com valor atual, primeiro valor, variação e nº de medições. Lê `PerimetrosCorporais` + `TiposPerimetro`. Empate de data desempata pelo `Id` maior |


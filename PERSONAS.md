# Datafit — Perfis de Usuário e Fluxos

> Referenciado por: [`../CLAUDE.md`](../CLAUDE.md)

---

## Papéis (TiposPerfil)

| ID | Nome | Descrição |
|---|---|---|
| 1 | `Personal` | Treinador. Cria treinos, gerencia alunos, controla pagamentos. |
| 2 | `Aluno` | Atleta. Executa treinos, acompanha evolução. |
| 3 | `Admin` | Administrador da plataforma. Gerencia personals e assinaturas. |

---

## Planos (apenas Personal)

| Código | Limite de Alunos | Valor | Diferenciais |
|---|---|---|---|
| `free` | 1 | Grátis | Cadastro inicial automático |
| `standard` | Ilimitado | R$ 47 | Acesso completo |
| `partner` | Ilimitado | R$ 97 | 50% de comissão sobre indicações |

**Status de assinatura:** `ativa` | `pendente` | `cancelada`

**Aviso de vencimento:** popup 7 dias antes do vencimento.

---

## Fluxo do Aluno

### Cadastro
1. Email, senha, nome, WhatsApp
2. Se nome/sobrenome/WhatsApp não preenchidos → popup bloqueante obrigatório
3. Se cadastrado pelo personal → recebe e-mail de redefinição de senha para definir sua senha e entrar

### Convites de Personal
- Notificações de convite aparecem no drawer (tag `convite`)
- Botões Aceitar / Recusar visíveis enquanto `lida = false`
- **Aceitar** → `responder_convite_personal(aceitar=true)`: desativa personal antigo (e remove treinos do antigo), ativa novo vínculo
- **Recusar** → `responder_convite_personal(aceitar=false)`: marca recusado
- Após aceitar/recusar: botões somem, título vira preto (lida)

### Execução de treino
1. Abre treino ativo (fila rotacional por `Ordem`)
2. Exercícios aparecem com descrição e vídeo
3. Pode marcar como **Concluído**, **Em andamento** ou **Pulado**
4. `PersistentTimer` registra descanso entre séries (SharedPreferences)
5. Finaliza treino → registra hora início/fim, move treino para fim da fila
6. Pode adicionar **cardio livre** (não atribuído pelo personal)

### Dashboard / Métricas
- Filtros de período: 7d, 15d, 30d, 2m, 3m, 4m, 6m
- Gráficos: peso, IMC, perímetros musculares, evolução de carga
- Fotos mensais de evolução

### Perfil do Personal
- Visualiza info do seu personal: foto, WhatsApp, descrição, vídeos

---

## Fluxo do Personal

### Gestão de alunos
1. Abre `NovoAlunoWidget` (bottom sheet animado) e digita email
2. Debounce 2s → `verificar_usuario_por_email` → exibe se já tem cadastro, perfil completo, e personal atual
3. Preenche nome (obrigatório) e confirma
4. Edge Function `criar-usuario-auth` cria a conta no Auth (Admin API) e devolve o `userId`. É idempotente: e-mail que já existe volta com `criado: false`. **A RPC não cria mais usuário** (ver a armadilha do INSERT cru em `RULES.md`)
5. `criar_ou_vincular_aluno`, já com o UUID em mão:
   - Cria `Perfis` **se ainda não existir**, e envia e-mail para o aluno definir senha
   - Sem UUID devolve `SEM_USUARIO_AUTH`
   - Se já vinculado a outro personal → retorna `ALUNO_JA_VINCULADO`; UI pede confirmação; reenvio com `forcarVinculo=true`
   - Cria `PersonalAlunos` com `StatusConvite='pendente'` e dispara notificação `convite` pro aluno
6. Aluno aparece como pendente até aceitar o convite
7. Pode ativar/desativar aluno (`toggle_aluno_ativo`)
8. Visualiza dashboard individual de cada aluno

**Personal como aluno de si mesmo.** Nada impede um personal de convidar o
próprio e-mail: o vínculo nasce com o mesmo UUID nas duas pontas de
`PersonalAlunos`. Como o `Perfis` dele já existe, a RPC não cria perfil de aluno
e o `TiposPerfilId` continua **1, Personal**. Na prática ele aparece na própria
lista de alunos e pode receber treino, pagamento e ficha, tudo pelo lado do
personal, mas **nunca vê o app do lado do aluno**, porque o app escolhe o lado
pelo `TiposPerfilId`. Serve para testar o lado do personal, não a experiência do
aluno. Para essa, conta separada.

### Criação de treinos
1. Cria template de treino (`upsert_treino`)
2. Adiciona exercícios com séries, reps, vídeo, observação
3. Atribui treino a aluno(s) (`atribuir_treino_aluno`)

### Pagamentos
- Registra pagamentos dos alunos (`upsert_pagamento`)
- Status calculado automaticamente: `pago` / `atrasado` / `pendente`
- Recebe notificações de pagamentos pendentes

### Perfil público
- Foto, descrição, links de redes sociais
- Grid de vídeos por categoria
- Totais: treinos criados, exercícios cadastrados

---

## Fluxo do Admin

- Visualiza todos os personals (nome, email, WhatsApp, plano, status)
- Controla último e próximo pagamento
- Vê quantidade de alunos por personal
- Renova plano manualmente
- Exclui ou edita dados de personals
- Consulta indicações feitas pelos personals (plano Partner)

---

## Distribuição de comissões (plano Partner)

Quando um personal Partner indica outro personal que assina:
- **50%** para o personal afiliado
- **10%** para a agência
- **Restante** para o administrador

Processado via webhooks do gateway de pagamento.

---

## IDs de teste

| Usuário | Role | UUID |
|---|---|---|
| Pedro Luiz | Personal | `8f970c58-39f7-4b6b-81bc-9d9cbcaffbe0` |
| Maria Miranda | Aluna | `ad2b23a6-c484-48ab-b3e9-d60b7665add4` |

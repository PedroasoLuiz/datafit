# Datafit — Publicação na Apple App Store

> Atualizado em 2026-08-03. Substitui o levantamento de 2026-07-12, que tinha
> informações incorretas (dizia que o `PrivacyInfo.xcprivacy` já estava
> preenchido — estava vazio).

---

## 🚦 RETOMAR DAQUI

Estado em 2026-08-04: **Apple Developer Program aprovado e ativo**
("Certificates, Identifiers & Profiles" disponível no painel).
Restam 6 itens abertos.

### Destrava tudo — fazer primeiro (não depende da Apple)

- [x] **1. Ícone 1024×1024.** ✅ Feito em 2026-08-04 (`01bac88`). Fonte:
      `Downloads/icone-datafit.jpg` (1024×1024 RGB, símbolo da espiral).
      Gerados os 15 tamanhos do iOS **e os 5 do Android** — o Android usava a
      logo escrita "datafit", divergente do ícone real. Divergência **41,89% → 0,05%**.
      512×512 para a ficha do Play em `Documents/aiaiaiia/icone-play-512.png`
      (**upload manual pendente no Play Console** — a ficha ainda tem o ícone antigo).

- [x] **2. Push do repo.** ✅ Feito em 2026-08-04.
      Remote: `https://github.com/PedroasoLuiz/datafit` — **repositório público**.
      Auditado: nenhum keystore/`.p8`/`.p12`/service account commitado; as únicas
      chaves no código são a **anon key** do Supabase (pública por design, RLS protege).

- [ ] **3. Rodar o workflow `ios-build-check` no Codemagic.** Não precisa de conta
      Apple nem de assinatura — só confirma que o projeto compila em macOS.
      **Fazer isso antes da Apple aprovar**, para não descobrir erro de build no dia da submissão.

- [x] **4. Aplicar `migrations/excluir_conta_usuario.sql`.** ✅ Aplicado em
      2026-08-04; `excluir_minha_conta()` existe no banco, sem overload conflitante.
      A verificação pegou dois erros na versão escrita a partir do `DATABASE.md`
      (commit `c2674d5`): o JOIN de telefone usava `Perfis."TelefonesId"`, coluna
      **inexistente** — o vínculo real é `Telefones."PerfisId" -> Perfis."idUser"`,
      e como plpgsql não valida colunas na criação, teria quebrado só em runtime;
      e `Perfis` **tem** `IsDeleted`, que agora é marcada. Passou a limpar também
      `Cpf`, `ChavePix`, `TipoPix`, `Bio`, `Cref`, `Unidade`, `DataNascimento`.
      **Falta:** testar o botão no app com uma conta descartável.

      ⚠️ O MCP do Supabase segue **sem permissão** ("You do not have permission") —
      SQL tem que ser rodado por Pedro no SQL Editor.

- [ ] **5. Hospedar `privacidade.html`.** Precisa de URL pública (GitHub Pages serve).

### Conta Apple já aprovada — liberado

- [ ] **6. App Store Connect API Key.** Users and Access > Integrations > App Store
      Connect API > (+). Guardar o `.p8` (só baixa uma vez), Key ID e Issuer ID.
      Conectar no Codemagic com o nome **`datafit_asc`** (é o nome usado no `codemagic.yaml`).

- [ ] **7. Criar o app** com bundle `com.virtus.datafit` e substituir
      `APP_STORE_APPLE_ID: 0000000000` no `codemagic.yaml` pelo Apple ID numérico.

- [ ] **8. Ficha da loja:** descrição, palavras-chave, screenshots de iPhone
      (6.9" e 6.5" — **iPad não precisa**, o app é iPhone-only), categoria,
      classificação etária, URL da política.
      **+ conta de demonstração** para o revisor: o app é 100% atrás de login,
      é obrigatório. Usar um Personal com alunos, treinos e métricas populados.

### Armadilhas para não reaprender

- As calls do FlutterFlow (`api_calls.dart`) mandam a **anon key** no
  `Authorization`, não o JWT — `auth.uid()` chega NULL. RPC que depende do usuário
  logado tem que ir por `SupaFlow.client.rpc(...)`.
- "Arquivo enviado à loja" ≠ "versão que o revisor vê". Foi o que causou a
  2ª rejeição no Google Play. Sempre confirmar qual build está ativo.
- O `SupabaseService.rpc()` do `STACK.md` **não existe** neste codebase.

---

## ✅ Já resolvido no repositório

| Item | O que foi feito |
|---|---|
| Repositório git | Criado na raiz (`Documents/datafit`), com o projeto Flutter em `datafit/`. `.gitignore` bloqueia keystore, `key.properties`, `.p8`, `.p12`, service accounts |
| CI | `codemagic.yaml` na raiz: workflow `ios-testflight` (assinado, publica no TestFlight) e `ios-build-check` (compila sem assinatura, roda a cada push na `main`) |
| Nome do app | `CFBundleDisplayName` / `CFBundleName`: `datafit` → **`Datafit`** |
| Permissões | Strings de câmera/fotos específicas em PT-BR no lugar do texto genérico do template |
| Privacy manifest | `PrivacyInfo.xcprivacy` estava `<dict/>` vazio. Agora declara dados coletados (e-mail, nome, telefone, user ID, fitness, fotos) e Required Reason APIs (UserDefaults `CA92.1`, FileTimestamp `C617.1`) |
| iPad | `TARGETED_DEVICE_FAMILY` `1,2` → `1` e remoção de `UISupportedInterfaceOrientations~ipad`. **Não precisa de screenshots de iPad** |
| Guideline 3.1.1 | Tabela de preços dos planos (R$ 47 / R$ 97) oculta no iOS via `!isiOS` em `perfil_widget.dart`. Planos são vendidos só pelo site |
| Guideline 5.1.1(v) | Exclusão de conta implementada: `lib/components/excluir_conta.dart` + item no menu do perfil |
| Política de privacidade | Extraída do widget para `privacidade.html` (29 mil caracteres, 16 seções, LGPD), com links reativados |

---

## 🔴 Pendente — bloqueia a submissão

### 1. Ícone do app
Todo o `AppIcon.appiconset` ainda é o "F" do template Flutter (divergência medida
de **41,89%** contra o ícone real). É exatamente o que causou as duas rejeições
no Google Play.

**Bloqueio:** falta uma fonte em alta resolução. O melhor arquivo no repositório
é o `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`, com apenas
192×192 — esticar para 1024 sairia borrado. O `assets/images/datafit.png` é o
logotipo horizontal, não o ícone quadrado.

O 512×512 da ficha do Play seria uma alternativa, mas o Google Drive não está
montado de verdade nesta máquina: o service account aparece no `ls` mas retorna
`error reading` na leitura.

**Ação:** exportar o ícone original (Canva/Figma) em 1024×1024 PNG **sem canal
alpha** e gerar os 15 tamanhos do iconset.

### 2. Aplicar a migration de exclusão de conta
`migrations/excluir_conta_usuario.sql` está escrito mas **não foi aplicado**. Foi
gerado a partir do `DATABASE.md`, sem acesso de leitura ao banco (o MCP do
Supabase estava sem permissão). Rodar o bloco de verificação no fim do arquivo
antes de aplicar. Sem isso, o botão de excluir conta falha em runtime.

### 3. Publicar `privacidade.html`
A App Store Connect exige **URL pública**. GitHub Pages resolve de graça.

### 4. Push do repositório
O repo é local. Codemagic precisa dele no GitHub/GitLab/Bitbucket. O `gh` CLI
não está instalado nesta máquina.

### 5. Conta Apple + App Store Connect
- Aguardando aprovação do Apple Developer Program (assinado em 2026-08-03)
- Criar App ID `com.virtus.datafit` e o app no App Store Connect
- Gerar App Store Connect API Key (.p8, Key ID, Issuer ID) e conectar no
  Codemagic como integração de nome `datafit_asc`
- Substituir `APP_STORE_APPLE_ID: 0000000000` no `codemagic.yaml`

### 6. Ficha da loja
Descrição, palavras-chave, screenshots de iPhone (6.9" e 6.5"), categoria,
classificação etária, URL da política de privacidade.

### 7. Conta de demonstração para o revisor
O app é 100% atrás de login — é **obrigatório** informar credenciais de teste no
App Store Connect. Usar um Personal com alunos, treinos e métricas populados.

---

## 📌 Observações levantadas mas fora do escopo

- **`tipoPerfilId == 1` no card "Meu plano"** (`perfil_widget.dart:785`): o `1` é
  Aluno (confirmado pelo `navbar_widget.dart`, onde `== 2` gateia o que é do
  Personal). A tabela de preços de planos de *Personal* está sendo exibida para
  *alunos*. Parece bug pré-existente — não foi alterado, só ocultado no iOS.
- **`sign_in_with_apple` 7.0.1** está no `pubspec.yaml` e há um mixin
  `AppleSignInManager` em `auth_manager.dart`, mas não há uso real. Como não há
  login social, a Guideline 4.8 não se aplica. Remover é opcional.
- **`ios/ImageNotification/`** existe no disco mas não é target no `project.pbxproj`
  (zero referências). Código morto, não afeta o build.
- **`STACK.md` descreve um `SupabaseService.rpc()` que não existe** neste
  codebase. O padrão real é `SupaFlow.client.rpc(...)`.

---

## Ordem sugerida

1. Push do repo pro GitHub → conectar no Codemagic
2. Rodar o workflow `ios-build-check` (não precisa de conta Apple) para validar
   que o projeto compila em macOS
3. Ícone em alta → gerar o iconset
4. Verificar e aplicar a migration → testar o botão de excluir conta
5. Publicar a política de privacidade
6. Quando a Apple aprovar: API Key → app no App Store Connect → ficha → TestFlight

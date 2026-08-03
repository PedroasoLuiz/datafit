# Datafit — Publicação na Apple App Store

> Atualizado em 2026-08-03. Substitui o levantamento de 2026-07-12, que tinha
> informações incorretas (dizia que o `PrivacyInfo.xcprivacy` já estava
> preenchido — estava vazio).

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

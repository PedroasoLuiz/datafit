# Datafit — Checklist de Publicação na Apple App Store

> Levantamento feito em 2026-07-12, logo após resolver a rejeição do Google Play (Misleading Claims — ícone do launcher). Ainda não iniciado.

---

## 🔴 Bloqueio de infraestrutura

- A máquina de desenvolvimento é Windows (ver `SETUP.md`). Build de iOS (`flutter build ipa`, assinatura, arquivamento) **exige macOS + Xcode** — não é possível nesta máquina.
- Não há nenhuma configuração de CI/CD no repo (`.github/workflows`, `codemagic.yaml`, etc.) — precisa ser criada do zero.
- Opções: Mac físico (próprio ou de terceiros), ou CI na nuvem (Codemagic, GitHub Actions com runner macOS, Bitrise, Ionic Appflow).

**Decisão pendente:** qual caminho seguir pra conseguir buildar.

---

## 🔴 Ícone ainda não corrigido (mesmo bug do Google Play)

- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png` (e todos os outros tamanhos do iconset) ainda são o logo padrão do template Flutter (o "F" azul), não o logo real do Datafit.
- Mesma correção já aplicada no Android: usar o ícone oficial (já baixado da ficha do Google Play em `edits().images().list(imageType='icon')`, resultado salvo no ícone `mipmap-xxxhdpi` atual) e gerar todos os tamanhos do `AppIcon.appiconset`:
  - `Icon-App-20x20@1x/2x/3x`
  - `Icon-App-29x29@1x/2x/3x`
  - `Icon-App-40x40@1x/2x/3x`
  - `Icon-App-60x60@2x/3x`
  - `Icon-App-76x76@1x/2x`
  - `Icon-App-83.5x83.5@2x`
  - `Icon-App-1024x1024@1x` (App Store, sem alpha/transparência)
- `CFBundleDisplayName` / `CFBundleName` no `Info.plist` estão como `datafit` (minúsculo) — vale normalizar pra bater com o nome usado na ficha da loja, já que a Apple também audita mismatch de nome.

**Rápido de resolver** — mesmo processo do Android, só falta rodar.

---

## 🟡 Risco de rejeição: modelo de assinatura fora do app (Guideline 3.1.1)

- A ficha do app descreve planos pagos pro Personal Trainer (Free / Standard R$47 / Partner R$97) processados **fora do app**, via gateway de pagamento externo com webhooks (ver `PERSONAS.md`, seção "Distribuição de comissões").
- Esses planos desbloqueiam funcionalidade dentro do app (alunos ilimitados, comissão de indicação) — isso é exatamente o tipo de "digital good/serviço consumido dentro do app" que a Apple exige passar pela **In-App Purchase** nativa (Guideline 3.1.1), diferente do Google que não flagou isso na primeira rejeição.
- Pagamentos entre aluno e personal (sessões de treino, mensalidade da academia) são serviço físico/pessoa-a-pessoa e **não** precisam de IAP — isso está OK.
- O que precisa de decisão: o pagamento da *assinatura do app em si* (o personal pagando pra usar o Datafit) precisa:
  - (a) migrar pra Apple IAP (StoreKit) só na versão iOS, mantendo o gateway externo no Android/web, ou
  - (b) tentar enquadrar como exceção (ex.: "multi-platform service" — geralmente não se aplica a apps B2B pequenos como esse), ou
  - (c) redesenhar o fluxo de cobrança pra não bloquear funcionalidade in-app diretamente (risco de ainda ser flagado).

**Decisão pendente do usuário** — isso pode mudar bastante a arquitetura de pagamento antes de submeter.

---

## 🟢 Já resolvido / não crítico

- `ios/Runner/PrivacyInfo.xcprivacy` já existe (privacy manifest, exigido desde 2024 pra certas APIs) — precisa revisar se os campos preenchidos batem com o que o app realmente coleta, mas a base já está lá.
- Não há login social (Google/Facebook) no `pubspec.yaml`, só auth por e-mail/senha via Supabase — então a exigência de oferecer "Sign in with Apple" como alternativa provavelmente **não se aplica**. (Nota: `sign_in_with_apple` está como dependência no `pubspec.yaml`, mas não há uso encontrado em `lib/` — parece resquício de template, não uma feature ativa.)
- `Info.plist` já tem `CFBundleIdentifier` (`com.virtus.datafit`, mesmo package do Android) e deep link scheme (`datafit://`) configurados.
- App suporta iPad (`UISupportedInterfaceOrientations~ipad` presente) — então vai precisar de screenshots em tamanho de iPad também na App Store Connect, não só iPhone.

---

## Perguntas em aberto pro usuário

1. Já existe conta no **Apple Developer Program** (US$99/ano)? Sem isso não dá nem pra gerar certificado de assinatura nem criar o app no App Store Connect.
2. Tem acesso a um Mac, ou vai usar CI na nuvem?
3. Como resolver o ponto do IAP pro plano do Personal Trainer antes de submeter pra review?

---

## Quando voltar a isso, começar por:

1. Resolver as 3 perguntas em aberto acima
2. Gerar o ícone correto (rápido, mesmo script usado no Android)
3. Registrar o Bundle ID e criar o app no App Store Connect
4. Configurar build/assinatura (Mac ou CI)
5. Decidir e implementar a estratégia de IAP antes de submeter — resolver isso *depois* da rejeição da Apple custa muito mais tempo (review manual, ciclo de rejeição mais lento que o Google)

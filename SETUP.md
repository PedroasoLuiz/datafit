# Datafit — Setup do Ambiente de Desenvolvimento

## Máquina: Windows 11 Home (Pedro)

---

## Flutter SDK

- **Versão:** 3.44.2 stable
- **Localização:** `C:\Users\pedro\Downloads\Flutter\flutter_windows_3.44.2-stable\flutter`
- **PATH (usuário):** `C:\Users\pedro\Downloads\Flutter\flutter_windows_3.44.2-stable\flutter\bin`

> Se o terminal não reconhecer `flutter`, adicione ao PATH da sessão:
> ```powershell
> $env:Path += ";C:\Users\pedro\Downloads\Flutter\flutter_windows_3.44.2-stable\flutter\bin"
> ```

---

## Android SDK

- **Localização:** `C:\Users\pedro\AppData\Local\Android\Sdk`
- **Platform instalada:** `android-35`
- **Build tools:** `35.0.0`, `35.0.1`, `36.0.0`
- **Emulador:** instalado

> ⚠️ Flutter 3.44.2 avisa que precisa de `android-36`, mas o app roda normalmente no `android-35`.
> Para silenciar o aviso, instale a plataforma 36 via Android Studio SDK Manager.

---

## Android Studio

- Instalado após o setup inicial
- Usar para gerenciar AVDs e aceitar licenças Android

### Aceitar licenças (rodar uma vez)
```powershell
flutter doctor --android-licenses
```

---

## Emulador

- **AVD:** `Pixel_8` (Pixel 8, API 35)
- **Internal Storage:** reduzido para 4 GB (disco com pouco espaço livre)
- **Iniciar:**
  ```powershell
  flutter emulators --launch Pixel_8
  ```

> ⚠️ O disco C: tinha apenas ~6 GB livres na época do setup. Monitorar espaço antes de rodar.

---

## Correções aplicadas nos pacotes (incompatibilidade com Flutter 3.44.2)

### 1. `font_awesome_flutter`: `10.7.0` → `11.0.0`
`IconData` virou `final class` no Flutter 3.x — versões anteriores tentavam extendê-la.
Atualizado em:
- `datafit/pubspec.yaml`
- `datafit/dependencies/cupertino_time_picker_hiuzb7/pubspec.yaml`

### 2. `page_transition`: `2.1.0` → `2.2.2`
`CupertinoPageTransitionsBuilder` foi removido no Flutter 3.44.2.
Atualizado em:
- `datafit/pubspec.yaml`
- `datafit/dependencies/cupertino_time_picker_hiuzb7/pubspec.yaml`

### 3. Ajustes de tipo para `FaIconData` (breaking change da 11.0.0)
`FaIcon` passou a aceitar `FaIconData?` em vez de `IconData?`.
Arquivos alterados:
- `lib/flutter_flow/flutter_flow_widgets.dart` — campo `iconData` de `IconData?` → `FaIconData?`
- `lib/flutter_flow/flutter_flow_icon_button.dart` — cast `icon.icon as FaIconData?`
- `dependencies/cupertino_time_picker_hiuzb7/lib/flutter_flow/flutter_flow_widgets.dart` — mesmo fix

---

## Rodar o app

```powershell
# 1. Entrar na pasta do projeto
cd C:\Users\pedro\Documents\datafit\datafit

# 2. (se necessário) Garantir flutter no PATH
$env:Path += ";C:\Users\pedro\Downloads\Flutter\flutter_windows_3.44.2-stable\flutter\bin"

# 3. Instalar dependências
flutter pub get

# 4. Iniciar emulador (se não estiver aberto)
flutter emulators --launch Pixel_8

# 5. Rodar o app
flutter run
```

---

## flutter doctor (estado na época do setup)

```
[√] Flutter 3.44.2
[√] Windows Version (11 Home Single Language)
[!] Android toolchain — falta platform android-36 + licenças pendentes
[√] Chrome
[√] Visual Studio
[√] Connected device
[√] Network resources
```

---

## Notas

- Rodar no **Chrome não funciona bem** — app é mobile-first, telas com `Expanded` em `Column` quebram no web (unbounded height constraint na `login_widget.dart:667`)
- **Windows desktop** também tem problemas de layout pelo mesmo motivo
- Plataforma correta para testar: **Android (emulador ou dispositivo físico)**

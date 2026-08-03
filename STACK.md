# Datafit — Stack & Padrões de Código

> Referenciado por: [`../CLAUDE.md`](../CLAUDE.md)
> Veja também: [`RULES.md`](./RULES.md) para armadilhas

---

## Stack

| Camada | Tecnologia |
|---|---|
| Framework | Flutter 3.x (Dart) |
| Backend | Supabase (Postgres + Auth + Storage) |
| Estado | Riverpod 2.x (`AsyncNotifier`) |
| Navegação | go_router 13.x |
| Fontes | google_fonts — Inter + Work Sans |
| Packages adicionais | `url_launcher`, `shared_preferences` |

**Contexto atual:** telas originalmente implementadas em FlutterFlow. Código migrado/expandido em Flutter puro preservando os padrões do FF onde necessário.

---

## Estrutura de pastas

```
lib/
├── main.dart                          # Entrada: init Supabase + tema + router
│
├── core/
│   ├── supabase/
│   │   ├── supabase_config.dart       # URL, anonKey, client singleton
│   │   └── supabase_service.dart      # Wrapper ÚNICO de chamadas RPC
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── router/
│   │   └── app_router.dart            # GoRouter — todas as rotas aqui
│   └── utils/
│       ├── validators.dart
│       └── extensions.dart
│
├── shared/
│   ├── widgets/                       # Prefixo Df obrigatório
│   │   ├── df_button.dart
│   │   ├── df_input.dart
│   │   ├── df_logo.dart
│   │   ├── df_social_button.dart
│   │   └── df_loading.dart
│   └── models/
│       ├── perfil_model.dart
│       ├── treino_model.dart
│       ├── meta_model.dart
│       ├── assinatura_model.dart
│       └── dashboard_model.dart
│
└── features/
    ├── auth/
    │   ├── splash_screen.dart
    │   ├── login_screen.dart
    │   ├── cadastro_screen.dart
    │   ├── recuperar_senha_screen.dart
    │   └── auth_notifier.dart
    ├── treinos/
    │   ├── treinos_screen.dart
    │   ├── exercicio_detalhe_screen.dart
    │   └── treinos_notifier.dart
    ├── metricas/
    │   ├── metricas_screen.dart
    │   └── metricas_notifier.dart
    ├── metas/
    │   ├── metas_screen.dart
    │   └── metas_notifier.dart
    ├── personal/
    │   ├── alunos_screen.dart
    │   ├── aluno_detalhe_screen.dart
    │   ├── novo_treino_screen.dart
    │   ├── editar_treino_screen.dart
    │   ├── pagamentos_screen.dart
    │   └── personal_notifier.dart
    └── perfil/
        ├── perfil_screen.dart
        ├── editar_perfil_screen.dart
        └── perfil_notifier.dart
```

---

## Rotas (go_router)

| Rota | Tela |
|---|---|
| `/` | SplashScreen |
| `/login` | LoginScreen |
| `/cadastro` | CadastroScreen |
| `/recuperar-senha` | RecuperarSenhaScreen |
| `/treinos` | TreinosScreen |
| `/treinos/:execucaoId` | ExercicioDetalheScreen |
| `/metricas` | MetricasScreen |
| `/metas` | MetasScreen |
| `/alunos` | AlunosScreen |
| `/alunos/:alunoId` | AlunoDetalheScreen |
| `/alunos/:alunoId/treino/novo` | NovoTreinoScreen |
| `/pagamentos` | PagamentosScreen |
| `/perfil` | PerfilScreen |
| `/perfil/editar` | EditarPerfilScreen |

---

## Padrão de estado (Riverpod)

```dart
// ✅ Padrão correto
@riverpod
class TreinosNotifier extends _$TreinosNotifier {
  @override
  Future<TreinoModel> build() async => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<TreinoModel> _fetch() async {
    final data = await SupabaseService.rpc('get_treino_do_dia', {...});
    return TreinoModel.fromJson(data);
  }
}
```

**Regras:**
- `setState` só para estado local de widget (ex: visibilidade de senha)
- Toda lógica de negócio vive no Notifier
- Sempre `AsyncValue` para loading / error / data

---

## Padrão de chamada Supabase

```dart
// ✅ CORRETO
final data = await SupabaseService.rpc('nome_da_rpc', {
  'p_parametro': valor,
});

// ❌ ERRADO — nunca nas telas/notifiers
Supabase.instance.client.rpc(...)
```

---

## Tokens de design

### Cores → `AppColors`
| Token | Hex | Uso |
|---|---|---|
| `primary` | `#1B98E0` | Botões, bordas ativas, links |
| `darkText` | `#13293D` | "fit" no logo |
| `bgSecondary` | `#F0F0F0` | Fundo das telas |
| `bgPrimary` | `#FDFDFD` | Fundo de inputs e cards |
| `textPrimary` | `#181818` | Texto principal |
| `textSecondary` | `#828282` | Labels, placeholders |
| `border` | `#D8D8D8` | Bordas inativas |
| `error` | `#E53935` | Erros de validação |
| `success` | `#43A047` | Confirmações |

### Tipografia → `AppTextStyles`
| Token | Fonte | Peso | Size | Uso |
|---|---|---|---|---|
| `labelField` | Inter | 700 | 13 | Label de campo |
| `inputText` | Inter | 500 | 12 | Texto no input |
| `button` | Work Sans | 600 | 13 | Botão |
| `bodyMedium` | Inter | 500 | 14 | Texto geral |
| `logoLight` | Inter | 300 | 52 | "data" no logo |
| `logoBold` | Inter | 800 | 52 | "fit" no logo |

### Bordas → `AppRadius`
| Token | Valor | Uso |
|---|---|---|
| `defaultRadius` | 10px | Inputs, botões, cards |
| `largeRadius` | 16px | Bottom sheets, modais |

---

## Nomenclatura

| Tipo | Convenção | Exemplo |
|---|---|---|
| Arquivos | `snake_case` | `login_screen.dart` |
| Classes | `PascalCase` | `LoginScreen` |
| Variáveis | `camelCase` | `emailController` |
| Constantes | em classes | `AppColors.primary` |
| Widgets shared | Prefixo `Df` | `DfButton`, `DfInput` |
| Providers | sufixo `Provider` | `perfilProvider` |
| Notifiers | sufixo `Notifier` | `AuthNotifier` |
| Models | sufixo `Model` | `PerfilModel` |

---

## Checklist antes de criar qualquer arquivo

- [ ] A feature já tem pasta em `features/`?
- [ ] O widget já existe em `shared/widgets/`?
- [ ] Cores/fontes usam tokens de `core/theme/`?
- [ ] Estado usa Riverpod (não setState em lógica)?
- [ ] Chamada Supabase passa por `SupabaseService`?
- [ ] Arquivo tem comentário de documentação no topo?
- [ ] Rota registrada em `app_router.dart`?

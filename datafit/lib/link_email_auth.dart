import 'package:flutter/foundation.dart' show kIsWeb;

/// Para onde o link do e-mail de senha traz a pessoa de volta.
///
/// No app o destino e o deep link. Na web ele nao serve: o navegador recebe
/// `com.virtus.datafit://reset-password` e nao sabe abrir, entao o aluno
/// recebia o e-mail e travava no clique. Quem esta em godata.fit precisa de
/// uma rota http de verdade, e ela existe: `/resetSenha`, a do
/// `ResetSenhaWidget`.
///
/// Os dois enderecos precisam estar em Authentication > URL Configuration >
/// Redirect URLs no Supabase, senao o link cai na Site URL do projeto.
String destinoDefinirSenha() => kIsWeb
    ? 'https://godata.fit/resetSenha'
    : 'com.virtus.datafit://reset-password';

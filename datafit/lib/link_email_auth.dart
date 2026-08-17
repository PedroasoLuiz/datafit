/// Para onde o link do e-mail de senha traz a pessoa de volta.
///
/// O app so existe em Android e iOS, entao o destino e sempre o deep link.
/// Nao ha ramo para web de proposito: `godata.fit` e a landing, nao tem rota
/// de app nenhuma.
///
/// Este endereco precisa estar em Authentication > URL Configuration >
/// Redirect URLs no Supabase. Fora da lista o GoTrue ignora o que foi pedido e
/// manda a pessoa para a Site URL do projeto, que e a landing: e por isso que o
/// link de redefinir senha caia no site em vez de abrir o app.
const String destinoDefinirSenha = 'com.virtus.datafit://reset-password';

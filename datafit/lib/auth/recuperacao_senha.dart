/// O portao da recuperacao de senha.
///
/// O link do e-mail cria sessao de verdade, e nao ha como ser diferente: e ela
/// que autoriza o `updateUser` a gravar a senha nova. Ou seja, a pessoa chega
/// no app "logada" sem ter escolhido senha nenhuma.
///
/// Sem portao o estrago aparece sozinho: o roteador ve `loggedIn`, reconstroi
/// para o Loading, e quem so clicou num link cai dentro do app com a conta
/// inteira na mao. Era o que acontecia: fechar a tela de nova senha ja deixava
/// a pessoa logada.
///
/// Enquanto isto esta ligado, `FFRoute` devolve qualquer destino para a tela de
/// nova senha. Desliga em dois lugares: quando a senha e gravada com sucesso, e
/// quando a pessoa sai pela porta da frente (que tambem encerra a sessao).
library;

bool _emRecuperacao = false;

bool get emRecuperacaoDeSenha => _emRecuperacao;

void iniciarRecuperacaoDeSenha() => _emRecuperacao = true;

void encerrarRecuperacaoDeSenha() => _emRecuperacao = false;

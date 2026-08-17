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
/// nova senha. Desliga em dois lugares: quando a senha e gravada, e quando a
/// pessoa sai pela porta da frente (que tambem encerra a sessao).
///
/// A pendencia fica gravada no disco porque a sessao tambem fica. Sem isso
/// bastava matar o app no meio do caminho e abrir de novo para estar dentro da
/// conta sem ter trocado senha: o portao morria na memoria, a sessao nao.
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Guarda o id de quem tem troca de senha pendente, nao um `true` solto: assim
/// uma pendencia velha de outra conta nao segura quem entrou depois.
const String _kPendente = 'datafit_recuperacao_pendente';

bool _emRecuperacao = false;

bool get emRecuperacaoDeSenha => _emRecuperacao;

/// Liga o portao. O estado em memoria muda na hora, antes do disco, porque o
/// roteador consulta ele no mesmo instante em que a sessao chega.
Future<void> iniciarRecuperacaoDeSenha(String? userId) async {
  _emRecuperacao = true;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kPendente, userId ?? '');
}

Future<void> encerrarRecuperacaoDeSenha() async {
  _emRecuperacao = false;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_kPendente);
}

/// Chamar no arranque do app. Devolve `true` quando havia uma troca pendente
/// para a sessao que esta aberta agora, e nesse caso o portao volta ligado.
Future<bool> restaurarRecuperacaoPendente(String? userIdAtual) async {
  final prefs = await SharedPreferences.getInstance();
  final pendente = prefs.getString(_kPendente);

  if (pendente == null) {
    return false;
  }

  // Pendencia sem sessao, ou de outra conta, nao segura ninguem: apaga.
  if (userIdAtual == null || userIdAtual.isEmpty || pendente != userIdAtual) {
    await prefs.remove(_kPendente);
    return false;
  }

  _emRecuperacao = true;
  return true;
}

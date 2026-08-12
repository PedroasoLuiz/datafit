/// Conversão de carga entre quilos e libras.
///
/// Regra do app: **o banco guarda sempre em kg**. A preferência do perfil
/// (`Perfis.Unidade`) muda apenas como o valor é exibido e como o que a pessoa
/// digita é interpretado. Assim o histórico e os gráficos continuam
/// comparáveis mesmo se o aluno trocar de unidade no meio do caminho.
///
/// Antes disso a preferência era gravada e nunca lida, e a tela de execução
/// mandava um `MedidasId` escolhido na hora — o que deixava o histórico com
/// unidades misturadas.
library;

import '/app_state.dart';

/// 1 kg em libras.
const double _kLibrasPorKg = 2.2046226218487757;

/// Id de "Kg" na tabela `Medidas`. Como tudo é normalizado para quilos antes
/// de gravar, a carga sempre vai com este id.
const int kMedidaKgId = 1;

/// `true` quando o usuário prefere libras.
bool get usaLibras {
  final u = FFAppState().perfil.unidade.trim().toLowerCase();
  return u == 'lbs' || u == 'lb' || u == 'libra' || u == 'libras';
}

/// Sufixo para exibir ao lado do número.
String get rotuloUnidade => usaLibras ? 'lb' : 'kg';

/// Converte o valor guardado (kg) para a unidade que o usuário vê.
double kgParaExibicao(double kg) => usaLibras ? kg * _kLibrasPorKg : kg;

/// Converte o que o usuário digitou para kg, que é como será gravado.
double exibicaoParaKg(double valor) =>
    usaLibras ? valor / _kLibrasPorKg : valor;

/// Versões que não consultam o perfil: a tela de execução tem um seletor
/// próprio de kg/lb ao lado do campo, e é ele que manda ali.
double paraKg(double valor, {required bool emLibras}) =>
    emLibras ? valor / _kLibrasPorKg : valor;

double deKg(double kg, {required bool emLibras}) =>
    emLibras ? kg * _kLibrasPorKg : kg;

/// Passo do incremento nos botões. Em libras um passo de 0,5 kg fica
/// esquisito (1,1 lb), então usamos um passo redondo na unidade exibida.
double get passoCarga => usaLibras ? 1.0 : 0.5;

/// Passo do botão de salto rápido.
double get passoCargaGrande => usaLibras ? 20.0 : 10.0;

/// Formata para exibição sem casas decimais desnecessárias: 80 vira "80",
/// 82.5 vira "82,5".
String formatarCarga(double valorNaUnidadeExibida) {
  final arredondado = (valorNaUnidadeExibida * 10).round() / 10;
  final texto = arredondado == arredondado.roundToDouble()
      ? arredondado.toStringAsFixed(0)
      : arredondado.toStringAsFixed(1);
  return texto.replaceAll('.', ',');
}

/// Lê o que foi digitado aceitando vírgula ou ponto. Devolve `null` se não
/// for um número válido.
double? lerCargaDigitada(String texto) {
  final limpo = texto.trim().replaceAll(',', '.');
  if (limpo.isEmpty) return null;
  return double.tryParse(limpo);
}

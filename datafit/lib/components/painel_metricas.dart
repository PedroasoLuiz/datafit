/// Painel de métricas do período — os números contando o que aconteceu.
///
/// O bloco antigo eram cinco cartões escritos à mão com um número cada:
/// "14", "0", "0", "9s", "3". Número solto não informa — catorze treinos é
/// muito ou pouco? —, e cada cartão tinha a altura do seu próprio conteúdo,
/// então a grade ficava serrilhada.
///
/// Aqui a leitura desce em três degraus: a frase diz como foi o período, o
/// cartão alto à esquerda dá a nota geral, e os menores à direita trazem o
/// esforço. Todos com a mesma altura, porque coluna desalinhada faz o olho
/// procurar em vez de ler.
library;

import 'dart:math' as math;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/schema/structs/index.dart';
import '/components/chama_sequencia.dart';
import '/components/dias_treinados.dart';

/// Altura de um cartão pequeno. O alto vale dois mais o vão.
const double _kCartao = 100.0;
const double _kVao = 12.0;

class PainelMetricas extends StatefulWidget {
  const PainelMetricas({
    super.key,
    required this.metricas,
    required this.periodoLabel,
  });

  final DsMetricasStruct metricas;

  /// "7 dias", "3 meses"... Entra nas frases: o número só quer dizer algo
  /// junto com a janela em que foi medido.
  final String periodoLabel;

  @override
  State<PainelMetricas> createState() => _PainelMetricasState();
}

class _PainelMetricasState extends State<PainelMetricas> {
  DsMetricasStruct get metricas => widget.metricas;
  String get periodoLabel => widget.periodoLabel;

  /// A sequência que o desenho usa: a simulada, quando houver.
  int get _seqAtual => metricas.sequenciaAtualDias;
  int get _seqMaxima => metricas.sequenciaMaxDias;

  String get _janela => 'nos últimos ${periodoLabel.toLowerCase()}';

  /// Minutos viram horas quando passam de 90: "1912" não se lê, "31h" sim.
  String _tempo(int minutos) {
    if (minutos <= 0) return '0';
    if (minutos < 90) return '$minutos';
    final h = minutos ~/ 60;
    final m = minutos % 60;
    return m == 0 ? '${h}h' : '${h}h ${m.toString().padLeft(2, '0')}';
  }

  String _unidadeTempo(int minutos) => minutos < 90 ? 'min' : '';

  String _segundos(int s) {
    if (s <= 0) return '—';
    if (s < 60) return '${s}s';
    final m = s ~/ 60;
    final r = s % 60;
    return r == 0 ? '${m}min' : '${m}min${r}s';
  }

  /// Quanto a sequência viva pesa no desenho, de 0 a 3.
  ///
  /// Os degraus não são lineares de propósito: os primeiros dias são fáceis e
  /// não merecem festa, e é lá pelas duas semanas que manter a sequência começa
  /// a exigir organizar a vida em volta. Daí 10, 15 e 30 — e não 5, 10, 15.
  /// O descanso dito em palavras.
  ///
  /// A conta é feita descanso a descanso no banco, cada um contra o tempo do
  /// seu próprio exercício. Mostrar a razão crua obrigava a explicar isso;
  /// a frase entrega a conclusão.
  String? _leituraDoDescanso() {
    final total = metricas.descansosTotal;
    if (total == 0) return null;
    final pct = metricas.descansosNoAlvo * 100 / total;
    if (pct >= 80) return 'quase sempre no tempo';
    if (pct >= 50) return 'metade delas no tempo';
    // Fala do descanso, nao de quem descansa: "voce costuma encurtar" soava
    // como reparo, e o cartao esta descrevendo um dado.
    return 'quase sempre encurtado';
  }

  /// A frase do período: sempre a leitura mais forte que os dados permitem.
  String _historia() {
    final feitos = metricas.completos;
    final antes = metricas.completosAnterior;

    if (metricas.totalTreinos == 0) {
      return 'Nenhum treino registrado $_janela. Assim que você treinar, os números aparecem aqui.';
    }
    if (feitos == 0) {
      return 'Você começou ${metricas.totalTreinos} ${metricas.totalTreinos == 1 ? 'treino' : 'treinos'} $_janela, mas nenhum chegou ao fim.';
    }

    final plural = feitos == 1 ? 'treino' : 'treinos';
    final diferenca = feitos - antes;

    if (antes == 0) {
      return 'Você fechou $feitos $plural $_janela. É o seu primeiro período com treino registrado.';
    }
    if (diferenca > 0) {
      return 'Você fechou $feitos $plural $_janela, $diferenca a mais que nos ${periodoLabel.toLowerCase()} anteriores.';
    }
    if (diferenca < 0) {
      return 'Você fechou $feitos $plural $_janela, ${-diferenca} a menos que nos ${periodoLabel.toLowerCase()} anteriores.';
    }
    return 'Você fechou $feitos $plural $_janela — o mesmo dos ${periodoLabel.toLowerCase()} anteriores.';
  }

  @override
  Widget build(BuildContext context) {
    final descanso = metricas.descansoMedioSegundos;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Narrativa(texto: _historia()),
        const SizedBox(height: _kVao),

        // O mosaico: um cartão alto à esquerda, dois empilhados à direita.
        // A nota do período é a leitura mais importante e ganha o dobro de
        // espaço; esforço e cárdio são detalhe e cabem em metade.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _CartaoAderencia(
                  percentual: metricas.aderencia,
                  feitos: metricas.completos,
                  total: metricas.totalTreinos,
                  anterior: metricas.completosAnterior,
                  totalAnterior: metricas.totalTreinosAnterior,
                ),
              ),
              const SizedBox(width: _kVao),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _Cartao(
                        rotulo: 'Sequência',
                        valor: '$_seqMaxima',
                        // A chama no lugar de "dias seguidos": a linha de
                        // baixo ja diz que sao dias, e escrever de novo ao
                        // lado do numero roubava a largura que o valor tem.
                        sufixo: ChamaEmCirculo(dias: _seqAtual),
                        // A sequencia viva tinge o proprio cartao a partir de
                        // certo ponto: dez dias seguidos e uma conquista, e
                        // uma conquista que so mexe num icone de 22px passa
                        // despercebida na grade.
                        realce: nivelDaSequencia(_seqAtual),
                        // A contagem de series saiu daqui: volume de trabalho
                        // ja aparece em outros dois cartoes, e o que ninguem
                        // via era constancia — treinar dez dias seguidos e
                        // dez dias espalhados em dois meses davam o mesmo
                        // numero.
                        // Curtas de proposito: a linha tem uma altura so e
                        // corta com reticencias, entao frase que nao cabe vira
                        // "dias seguidos, e a seque...".
                        comparacao: _seqAtual > 0
                            ? (_seqAtual == _seqMaxima
                                ? 'dias seguidos · em curso'
                                : 'dias · hoje: $_seqAtual')
                            : 'dias seguidos · recorde',
                        neutro: true,
                      ),
                    ),
                    const SizedBox(height: _kVao),
                    Expanded(
                      child: _Cartao(
                        rotulo: 'Cárdio',
                        valor: _tempo(metricas.cardioMinutos),
                        unidade: _unidadeTempo(metricas.cardioMinutos),
                        comparacao: metricas.cardios > 0
                            ? 'em ${metricas.cardios} ${metricas.cardios == 1 ? 'sessão' : 'sessões'}'
                            : 'nenhuma sessão',
                        neutro: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: _kVao),

        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Cartao(
                  rotulo: 'Tempo em treino',
                  valor: _tempo(metricas.tempoTreinoMinutos),
                  unidade: _unidadeTempo(metricas.tempoTreinoMinutos),
                  comparacao: metricas.completos > 0 &&
                          metricas.tempoTreinoMinutos > 0
                      ? '${(metricas.tempoTreinoMinutos / metricas.completos).round()} min por treino'
                      : null,
                  neutro: true,
                ),
              ),
              const SizedBox(width: _kVao),
              Expanded(
                child: _Cartao(
                  rotulo: 'Descanso médio',
                  valor: _segundos(descanso),
                  // "por serie" cabe ao lado do numero — sao nove caracteres.
                  // No rotulo, "Descanso medio por serie" nao entrava na
                  // largura do cartao e virava reticencia.
                  unidade: 'por série',
                  // Cada exercicio tem o seu tempo, entao nao ha um "prescrito
                  // medio" que signifique alguma coisa: comparar 9s com a
                  // media de prescricoes diferentes nao se sustenta. O que se
                  // sustenta e contar quantos descansos alcancaram o tempo do
                  // SEU proprio exercicio — a conta e feita descanso a
                  // descanso no banco.
                  // Em palavras, nao em razao: "2 de 32 no alvo" fazia o
                  // proprio cliente perguntar o que era o alvo, e a resposta
                  // exigia explicar que cada exercicio tem um tempo proprio.
                  // A frase diz o comportamento, que e o que interessa.
                  comparacao: _leituraDoDescanso(),
                  neutro:
                      metricas.descansosNoAlvo * 2 >= metricas.descansosTotal,
                  subiu: false,
                ),
              ),
            ],
          ),
        ),

        // Só existe quando existe: um "0 incompletos" permanente ocuparia um
        // cartão inteiro para dizer que nada deu errado.
        // Linha única, sem número grande: "Ficaram pelo caminho / 1 /
        // 1 começado e não fechado" dizia a mesma coisa três vezes. A frase
        // sozinha já é o dado.
        if (metricas.incompletos > 0 || metricas.pulados > 0) ...[
          const SizedBox(height: _kVao),
          _LinhaAviso(
            // "Treino", sempre escrito: pular exercício é comum e não entra
            // nesta conta — quem lê "1 pulado" sem a palavra imagina que é o
            // exercício que ficou de fora, não o dia inteiro.
            texto: [
              if (metricas.incompletos > 0)
                metricas.incompletos == 1
                    ? 'Você abriu 1 treino e não chegou ao fim'
                    : 'Você abriu ${metricas.incompletos} treinos e não chegou ao fim',
              if (metricas.pulados > 0)
                metricas.pulados == 1
                    ? '1 dia de treino ficou sem começar'
                    : '${metricas.pulados} dias de treino ficaram sem começar',
            ].join(' · '),
          ),
        ],
      ],
    );
  }
}

/// A frase do período.
class _Narrativa extends StatelessWidget {
  const _Narrativa({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    // Branco como todos os outros, com o simbolo num circulo azul. O bloco
    // azul cheio destacava a frase do resto da tela — e destaque demais vira
    // desencaixe: era o unico elemento com cor propria numa grade de cartoes
    // brancos, e lia como banner, nao como parte do painel.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: tema.accent1,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child:
                Icon(Icons.insights_rounded, color: tema.primary, size: 17.0),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              texto,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.primaryText,
                fontSize: 13.5,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                lineHeight: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A nota do período, com o anel de aderência.
///
/// O anel existe para responder de relance o que a porcentagem responde
/// lendo: quanto do combinado foi cumprido. É o cartão mais alto porque é o
/// que se olha primeiro.
class _CartaoAderencia extends StatelessWidget {
  const _CartaoAderencia({
    required this.percentual,
    required this.feitos,
    required this.total,
    required this.anterior,
    required this.totalAnterior,
  });

  final int percentual;
  final int feitos;
  final int total;
  final int anterior;
  final int totalAnterior;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    // Verde so quando nao sobrou nada: verde e a cor de "esta feito", e usar
    // ela em 80% dizia que estava resolvido quando ainda faltava treino. Azul
    // enquanto anda, laranja quando menos da metade saiu do papel.
    final cor = percentual >= 100
        ? tema.success
        : (percentual >= 50 ? tema.primary : tema.secondary);

    return Container(
      height: _kCartao * 2 + _kVao,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Treinos fechados',
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 11.5,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Center(
            child: SizedBox(
              width: 104.0,
              height: 104.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 104.0,
                    height: 104.0,
                    child: CircularProgressIndicator(
                      value: (percentual / 100).clamp(0.0, 1.0),
                      strokeWidth: 9.0,
                      strokeCap: StrokeCap.round,
                      backgroundColor: tema.alternate,
                      valueColor: AlwaysStoppedAnimation<Color>(cor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$feitos',
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: tema.primaryText,
                          fontSize: 30.0,
                          letterSpacing: -1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'de $total',
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: tema.secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // O que o anel quer dizer, escrito. A porcentagem sozinha deixava a
          // pergunta "por cento de quê?" no ar.
          Text(
            totalAnterior > 0
                ? '$percentual% do período · antes eram $anterior de $totalAnterior'
                : '$percentual% dos treinos do período',
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 11.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
              lineHeight: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Um número com o rótulo em cima e a leitura embaixo.
///
/// Altura fixa: sem ela, o cartão sem nota encolhia e a coluna ficava
/// serrilhada.
class _Cartao extends StatelessWidget {
  const _Cartao({
    required this.rotulo,
    required this.valor,
    this.unidade,
    this.sufixo,
    this.comparacao,
    this.subiu = true,
    this.neutro = false,
    this.realce = 0,
  });

  final String rotulo;
  final String valor;

  /// Vai numa pílula ao lado do número, como no cartão de calorias da
  /// referência: diz o que o número mede sem competir com ele.
  final String? unidade;

  /// Um widget no lugar da unidade escrita — hoje só a chama da sequência.
  final Widget? sufixo;

  final String? comparacao;
  final bool subiu;

  /// Linha de baixo em cinza, sem verde nem vermelho. Serve para o que é
  /// contexto e não julgamento — o descanso prescrito, por exemplo.
  final bool neutro;

  /// 0 = cartão comum. De 1 a 3, a sequência viva vai tomando conta dele.
  final int realce;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final corComp = (comparacao == null || neutro)
        ? tema.secondaryText
        : (subiu ? tema.success : tema.error);

    return Container(
      height: _kCartao,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        // A partir de 30 dias o fundo inteiro puxa para o laranja; antes
        // disso, só a borda muda. O fundo é o último degrau porque é o que
        // tira o cartão da grade — usar isso cedo demais gastaria o recurso
        // que deveria marcar a conquista rara.
        // Só o último degrau tinge o cartão. A borda que havia no degrau 2
        // recortava o cartão da grade sem dizer o porquê — quem olha vê uma
        // moldura, não uma conquista. Lá o realce passou para o número.
        color: realce >= 3
            ? Color.alphaBlend(
                tema.secondary.withValues(alpha: 0.12), tema.primaryBackground)
            : tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  rotulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 11.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Row(
            // `center`, e nao `baseline`: o sufixo deste cartao pode ser a
            // chama, que e um Transform animado sem linha de base. Pedir a
            // baseline dela durante o layout dispara outro layout ali dentro,
            // e a tela trava — foi o que aconteceu ao trocar o periodo.
            crossAxisAlignment: CrossAxisAlignment.center,
            // `spaceBetween` no lugar de um Spacer: o Spacer e o texto sao os
            // dois flexiveis da linha e dividiam a folga meio a meio, entao o
            // disco parava no meio do cartao em vez de encostar na borda. O
            // alinhamento joga a sobra inteira entre os dois.
            mainAxisAlignment: sufixo != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    // A partir de 15 dias o proprio numero vai para o laranja:
                    // e o dado que mudou, entao e ele que muda de cor.
                    color: realce >= 2 ? tema.secondary : tema.primaryText,
                    fontSize: 26.0,
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (sufixo != null) ...[
                // Na borda: colado no numero, o disco parecia uma unidade de
                // medida mal encaixada. Nos dois cantos, cada um tem um
                // trabalho — o numero conta, o disco mostra o estado — e o
                // cartao ganha a mesma leitura do anel.
                const SizedBox(width: 6.0),
                sufixo!,
              ] else if ((unidade ?? '').isNotEmpty) ...[
                const SizedBox(width: 5.0),
                Flexible(
                  child: Text(
                    unidade!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      color: tema.secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // Uma linha sempre ocupada, mesmo vazia: é o que mantém os números
          // dos dois cartões na mesma altura.
          SizedBox(
            height: 15.0,
            child: (comparacao != null
                ? Text(
                    comparacao!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: corComp,
                      fontSize: 10.5,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}

/// Serve para o que é exceção e não métrica: não tem número grande porque o
/// número já está dentro da frase, e não tem cartão inteiro porque não é
/// deste tamanho a importância dele.
class _LinhaAviso extends StatelessWidget {
  const _LinhaAviso({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.primaryText,
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              color: tema.secondary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.priority_high_rounded,
                color: tema.secondary, size: 16.0),
          ),
        ],
      ),
    );
  }
}

/// A chama da sequência.
///
/// Fogo não pulsa em compasso: ele treme. Uma escala indo e voltando no mesmo
/// ritmo lê como ícone piscando, não como chama — daí a animação ser a soma de
/// três ondas de velocidades diferentes.
///
/// As três dão voltas inteiras dentro do ciclo (2, 3 e 5 voltas em 6s). Isso
/// não é detalhe: com frequências quebradas, o fim do ciclo pega cada onda num
/// ponto diferente de onde ela começou, e o loop salta de estado a cada volta.
/// Sendo inteiras, o último quadro encosta no primeiro e a chama tremula sem
/// costura. Escolhidas 2, 3 e 5 — primos entre si — o padrão só se repete de
/// verdade a cada seis segundos, tempo suficiente para o olho não decorar.
///
/// São três movimentos ao mesmo tempo, todos pequenos:
/// o corpo estica mais na vertical que na horizontal, como fogo sobe;
/// a ponta balança alguns graus para os lados;
/// e a chama sobe e desce um fio, fora de fase com o tamanho.
/// A cor caminha do laranja da marca para o vermelho no pico da onda rápida,
/// que é o que dá o estalo.
///
/// Apagada, fica cinza e imóvel: o número do cartão é o recorde histórico, e
/// manter fogo animado numa sequência já quebrada seria comemorar o que não
/// está acontecendo.
class _Chama extends StatefulWidget {
  const _Chama({
    required this.acesa,
    required this.atual,
    required this.maxima,
  });

  final bool acesa;
  final int atual;
  final int maxima;

  @override
  State<_Chama> createState() => _ChamaState();
}

class _ChamaState extends State<_Chama> with SingleTickerProviderStateMixin {
  /// Quanto a sequência já vale, de 0 a 3. Governa tamanho e velocidade.
  int get _nivel {
    if (widget.atual >= 30) return 3;
    if (widget.atual >= 15) return 2;
    if (widget.atual >= 10) return 1;
    return 0;
  }

  /// A chama cresce com a sequência.
  double get _tamanho => const [22.0, 26.0, 28.0, 31.0][_nivel];

  /// E acelera. O ciclo continua fechando (as ondas dão voltas inteiras), só
  /// que mais rápido — é o mesmo desenho tremendo com mais pressa, não outra
  /// animação.
  int get _ciclo => const [6000, 4200, 3200, 2400][_nivel];

  /// Quanto o tremor abre. Perto do teto ele fica visivelmente mais nervoso.
  double get _amplitude => const [1.0, 1.25, 1.5, 1.8][_nivel];

  /// O ciclo inteiro. As três ondas fecham juntas no fim dele.
  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _ciclo),
  );

  @override
  void initState() {
    super.initState();
    if (widget.acesa) _controle.repeat();
  }

  @override
  void didUpdateWidget(_Chama old) {
    super.didUpdateWidget(old);
    // A sequência pode ter mudado de faixa entre uma carga e outra.
    if (old.atual != widget.atual)
      _controle.duration = Duration(milliseconds: _ciclo);
    if (widget.acesa && !_controle.isAnimating) {
      _controle.repeat();
    } else if (!widget.acesa && _controle.isAnimating) {
      _controle.stop();
    }
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    if (!widget.acesa) {
      return _tocavel(
        context,
        Icon(Icons.local_fire_department_rounded,
            color: tema.secondaryText.withValues(alpha: 0.45), size: 22.0),
      );
    }

    return _tocavel(
      context,
      SizedBox(
        // Só o espaço que o ícone precisa para esticar e balançar sem ser
        // cortado. Havia um halo circular atrás dele aqui — some, porque um
        // disco de cor atrás de um ícone lê como fundo de botão, e o cartão
        // passava a ter um chip dentro dele.
        width: _tamanho + 4.0,
        height: _tamanho + 6.0,
        child: AnimatedBuilder(
          animation: _controle,
          builder: (context, _) {
            final t = _controle.value * 2 * math.pi;

            // Voltas inteiras: 2, 3 e 5 dentro do ciclo. As fases deslocam o
            // desenho sem quebrar o fechamento.
            final lenta = math.sin(t * 2);
            final media = math.sin(t * 3 + 1.1);
            final rapida = math.sin(t * 5 + 2.3);

            // O tremor mistura as três; a rápida entra com pouco peso, senão
            // vira vibração e não chama.
            final tremor =
                (lenta * 0.5 + media * 0.35 + rapida * 0.15) * _amplitude;

            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  // Sobe e desce um fio, fora de fase com o tamanho.
                  offset: Offset(0.0, -1.2 * media),
                  child: Transform.rotate(
                    // Cinco graus de balanço: mais que isso o ícone parece
                    // tombando em vez de tremulando.
                    angle: 0.09 * tremor,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      // Estica mais na vertical que na horizontal — fogo sobe.
                      transform: Matrix4.diagonal3Values(
                        1.0 + 0.05 * tremor,
                        1.0 + 0.14 * tremor,
                        1.0,
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: Color.lerp(
                          tema.secondary,
                          tema.error,
                          // Mais perto do vermelho conforme a sequência cresce.
                          (0.5 + rapida * 0.5) * (0.45 + 0.15 * _nivel),
                        ),
                        size: _tamanho,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// A chama abre a lista de dias treinados.
  ///
  /// Um número de sequência sem como conferir é uma afirmação sem prova — e
  /// justamente o tipo de dado que dá vontade de checar. A chave está aqui e
  /// não no cartão inteiro porque tocar no cartão abriria a lista sem que nada
  /// tivesse convidado para isso.
  Widget _tocavel(BuildContext context, Widget filho) {
    return Semantics(
      button: true,
      label: 'Ver os dias treinados',
      child: Builder(builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final caixa = ctx.findRenderObject() as RenderBox?;
            mostrarDiasTreinados(
              context,
              sequenciaAtual: widget.atual,
              sequenciaMaxima: widget.maxima,
              origem: (caixa != null && caixa.hasSize)
                  ? caixa.localToGlobal(caixa.size.center(Offset.zero))
                  : null,
            );
          },
          child: filho,
        );
      }),
    );
  }
}

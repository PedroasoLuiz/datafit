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

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/schema/structs/index.dart';

/// Altura de um cartão pequeno. O alto vale dois mais o vão.
const double _kCartao = 100.0;
const double _kVao = 12.0;

/// Escurece mantendo matiz e saturação.
///
/// Misturar com preto lava a cor: o azul vira cinza-escuro e deixa de ser o
/// azul da marca.
Color _tom(Color cor, double delta) {
  final hsl = HSLColor.fromColor(cor);
  return hsl.withLightness((hsl.lightness + delta).clamp(0.0, 1.0)).toColor();
}

class PainelMetricas extends StatelessWidget {
  const PainelMetricas({
    super.key,
    required this.metricas,
    required this.periodoLabel,
  });

  final DsMetricasStruct metricas;

  /// "7 dias", "3 meses"... Entra nas frases: o número só quer dizer algo
  /// junto com a janela em que foi medido.
  final String periodoLabel;

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
                        rotulo: 'Séries',
                        valor: '${metricas.seriesConcluidas}',
                        unidade: 'concluídas',
                        // "3,3 series por treino" e uma media que nao existe
                        // na vida real: ninguem faz um terco de serie. Em
                        // quantos treinos elas sairam e um numero inteiro e
                        // verdadeiro, e segue a mesma forma do cartao de
                        // cardio ao lado.
                        comparacao: metricas.completos > 0
                            ? 'em ${metricas.completos} ${metricas.completos == 1 ? 'treino' : 'treinos'}'
                            : null,
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
                  rotulo: 'Descanso por série',
                  valor: _segundos(descanso),
                  // Sem unidade ao lado: "por serie" ja esta dito no rotulo,
                  // e ali ele disputava com o valor e cortava.
                  unidade: null,
                  // Cada exercicio tem o seu tempo, entao nao ha um "prescrito
                  // medio" que signifique alguma coisa: comparar 9s com a
                  // media de prescricoes diferentes nao se sustenta. O que se
                  // sustenta e contar quantos descansos alcancaram o tempo do
                  // SEU proprio exercicio — a conta e feita descanso a
                  // descanso no banco.
                  // Curta de proposito: o cartao tem uma linha, e "por série ·
                  // 2 de 32 no tempo pedido" nao cabia nela em telas
                  // estreitas. "no alvo" diz o mesmo em tres letras.
                  comparacao: metricas.descansosTotal > 0
                      ? '${metricas.descansosNoAlvo} de ${metricas.descansosTotal} no alvo'
                      : 'por série',
                  neutro: metricas.descansosNoAlvo * 2 >= metricas.descansosTotal,
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
            texto: [
              if (metricas.incompletos > 0)
                '${metricas.incompletos} ${metricas.incompletos == 1 ? 'treino começado e não fechado' : 'treinos começados e não fechados'}',
              if (metricas.pulados > 0)
                '${metricas.pulados} ${metricas.pulados == 1 ? 'treino pulado' : 'treinos pulados'}',
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

    return Container(
      width: double.infinity,
      // Menos respiro em cima que embaixo: a frase começa logo abaixo da
      // borda e o cartão termina com folga, o que o encaixa sob os chips sem
      // abrir um vão entre os dois.
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
      decoration: BoxDecoration(
        // Azul fechado, não o `primary`: o primary é a cor de ação do app e
        // um bloco inteiro dele parece um botão gigante.
        color: _tom(tema.primary, -0.20),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.insights_rounded,
              color: Colors.white.withValues(alpha: 0.9), size: 18.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              texto,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: Colors.white,
                fontSize: 14.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                lineHeight: 1.45,
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
    this.comparacao,
    this.subiu = true,
    this.neutro = false,
  });

  final String rotulo;
  final String valor;

  /// Vai numa pílula ao lado do número, como no cartão de calorias da
  /// referência: diz o que o número mede sem competir com ele.
  final String? unidade;

  final String? comparacao;
  final bool subiu;

  /// Linha de baixo em cinza, sem verde nem vermelho. Serve para o que é
  /// contexto e não julgamento — o descanso prescrito, por exemplo.
  final bool neutro;

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
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: tema.primaryText,
                    fontSize: 26.0,
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if ((unidade ?? '').isNotEmpty) ...[
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

/// Aviso de uma linha, com o ícone à direita.
///
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

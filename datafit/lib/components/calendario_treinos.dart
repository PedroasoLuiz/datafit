/// Calendário de treinos do aluno.
///
/// Um mês por vez, folheado com as setas. Os dias em que houve treino ganham
/// um ponto embaixo do número; tocar num deles abre o detalhe do que foi
/// feito naquele dia.
///
/// A grade é montada à mão, com `Row`/`Column`, e não com `CustomPaint` nem
/// com pacote de calendário: é a mesma decisão dos gráficos do app — o que se
/// desenha com widgets sobrevive melhor ao build de produção.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

const List<String> _mesesPtBr = [
  'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
  'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
];

const List<String> _diasDaSemana = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

class CalendarioTreinos extends StatefulWidget {
  const CalendarioTreinos({super.key, this.alunoUuid});

  /// Quando nulo assume o próprio usuário — que é o caso do aluno vendo o
  /// próprio histórico. O personal passa o uuid do aluno.
  final String? alunoUuid;

  @override
  State<CalendarioTreinos> createState() => _CalendarioTreinosState();
}

class _CalendarioTreinosState extends State<CalendarioTreinos> {
  late DateTime _mesVisivel;
  bool _carregando = true;

  /// Dia (yyyy-MM-dd) -> lista de treinos concluídos naquele dia.
  Map<String, List<dynamic>> _porDia = {};

  /// Soma dos treinos do mes. Nao e o mesmo que a quantidade de dias: um dia
  /// pode ter A e C feitos em seguida.
  int get _totalTreinos =>
      _porDia.values.fold<int>(0, (soma, l) => soma + l.length);

  @override
  void initState() {
    super.initState();
    final agora = DateTime.now();
    _mesVisivel = DateTime(agora.year, agora.month);
    _carregar();
  }

  Future<void> _carregar() async {
    safeSetState(() => _carregando = true);
    try {
      final resposta = await AlunoGroup.getCalendarioCall.call(
        alunoUuid: widget.alunoUuid ?? currentUserUid,
        ano: _mesVisivel.year,
        mes: _mesVisivel.month,
      );
      if (!mounted) return;

      final dias = getJsonField(resposta.jsonBody, r'''$.dias''');
      final mapa = <String, List<dynamic>>{};
      if (dias is List) {
        for (final d in dias) {
          final dia = (d as Map)['dia']?.toString();
          if (dia == null) continue;
          mapa[dia] = (d['treinos'] as List?) ?? const [];
        }
      }
      safeSetState(() {
        _porDia = mapa;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      safeSetState(() {
        _porDia = {};
        _carregando = false;
      });
    }
  }

  void _mudarMes(int passo) {
    setState(() {
      _mesVisivel = DateTime(_mesVisivel.year, _mesVisivel.month + passo);
    });
    _carregar();
  }

  /// Dias que a grade precisa mostrar antes do dia 1.
  ///
  /// `weekday` do Dart vai de 1 (segunda) a 7 (domingo); a grade começa no
  /// domingo, daí o `% 7`.
  int get _vaziosNoInicio =>
      DateTime(_mesVisivel.year, _mesVisivel.month, 1).weekday % 7;

  int get _diasNoMes =>
      DateTime(_mesVisivel.year, _mesVisivel.month + 1, 0).day;

  void _abrirDia(DateTime dia, List<dynamic> treinos) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetalheDoDia(dia: dia, treinos: treinos),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final hoje = DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          // Zero no topo: quem afasta o calendario da linha de abas e o
          // padding dela. Com os 8 daqui somando, o calendario descia mais
          // que o painel e o grafico, e as abas pareciam ter alturas
          // diferentes.
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Container(
            decoration: BoxDecoration(
              color: tema.primaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [tema.designToken.shadow.lg],
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Cabeçalho do mês ──────────────────────────────
                // Dentro do cartao, e nao acima dele: o mes e as setas
                // comandam a grade que vem logo abaixo, e soltos por fora
                // pareciam pertencer a tela em vez do calendario.
                Row(
                  children: [
                    _SetaMes(
                      icone: Icons.chevron_left_rounded,
                      aoTocar: () => _mudarMes(-1),
                    ),
                    Expanded(
                      child: Text(
                        '${_mesesPtBr[_mesVisivel.month - 1]} ${_mesVisivel.year}',
                        textAlign: TextAlign.center,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: tema.primaryText,
                          fontSize: 15.0,
                          letterSpacing: -0.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _SetaMes(
                      icone: Icons.chevron_right_rounded,
                      aoTocar: () => _mudarMes(1),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    for (final d in _diasDaSemana)
                      Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: tema.bodyMedium.override(
                              font:
                                  GoogleFonts.inter(fontWeight: FontWeight.w600),
                              color: tema.secondaryText,
                              fontSize: 11.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6.0),
                if (_carregando)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(tema.primary),
                      ),
                    ),
                  )
                else
                  ..._semanas(context, hoje),
              ],
            ),
          ),
        ),

        // ── Resumo do mês ────────────────────────────────────────────
        // Duas leituras: quantos dias houve treino e quantos treinos ao todo.
        // Um dia pode ter mais de um treino, entao os dois numeros dizem
        // coisas diferentes e vale mostrar os dois.
        if (!_carregando)
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 0.0),
            child: Row(
              children: [
                Expanded(
                  child: _Resumo(
                    numero: '${_porDia.length}',
                    rotulo: _porDia.length == 1 ? 'dia treinado' : 'dias treinados',
                    cor: tema.primary,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: _Resumo(
                    numero: '$_totalTreinos',
                    rotulo: _totalTreinos == 1 ? 'treino feito' : 'treinos feitos',
                    cor: tema.success,
                  ),
                ),
              ],
            ),
          ),
        if (!_carregando && _porDia.isEmpty)
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
            child: Text(
              'Nenhum treino neste mês. Use as setas para ver outro.',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                color: tema.secondaryText,
                fontSize: 12.5,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _semanas(BuildContext context, DateTime hoje) {
    final celulas = <Widget>[];

    for (var i = 0; i < _vaziosNoInicio; i++) {
      celulas.add(const Expanded(child: SizedBox(height: 40.0)));
    }

    for (var dia = 1; dia <= _diasNoMes; dia++) {
      final data = DateTime(_mesVisivel.year, _mesVisivel.month, dia);
      final chave = DateFormat('yyyy-MM-dd').format(data);
      final treinos = _porDia[chave];
      final treinou = treinos != null && treinos.isNotEmpty;
      final ehHoje = data.year == hoje.year &&
          data.month == hoje.month &&
          data.day == hoje.day;

      celulas.add(
        Expanded(
          child: _Celula(
            dia: dia,
            treinou: treinou,
            ehHoje: ehHoje,
            aoTocar: treinou ? () => _abrirDia(data, treinos) : null,
          ),
        ),
      );
    }

    // Completa a última linha para as células não esticarem.
    while (celulas.length % 7 != 0) {
      celulas.add(const Expanded(child: SizedBox(height: 40.0)));
    }

    final linhas = <Widget>[];
    for (var i = 0; i < celulas.length; i += 7) {
      linhas.add(Row(children: celulas.sublist(i, i + 7)));
    }
    return linhas
        .map((l) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: l,
            ))
        .toList();
  }
}

class _SetaMes extends StatelessWidget {
  const _SetaMes({required this.icone, required this.aoTocar});

  final IconData icone;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Material(
      color: tema.primaryBackground,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: aoTocar,
        child: SizedBox(
          width: 34.0,
          height: 34.0,
          child: Icon(icone, color: tema.primary, size: 20.0),
        ),
      ),
    );
  }
}

class _Celula extends StatelessWidget {
  const _Celula({
    required this.dia,
    required this.treinou,
    required this.ehHoje,
    this.aoTocar,
  });

  final int dia;
  final bool treinou;
  final bool ehHoje;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: aoTocar,
      child: SizedBox(
        height: 40.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28.0,
              height: 28.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // Dia treinado ganha fundo cheio; hoje ganha só o contorno.
                // Assim os dois se distinguem mesmo quando coincidem.
                color: treinou ? tema.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: ehHoje && !treinou
                    ? Border.all(color: tema.primary, width: 1.5)
                    : null,
                boxShadow: treinou
                    ? [
                        BoxShadow(
                          color: tema.primary.withValues(alpha: 0.30),
                          blurRadius: 6.0,
                          offset: const Offset(0.0, 2.0),
                        )
                      ]
                    : null,
              ),
              child: Text(
                '$dia',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: treinou ? FontWeight.w600 : FontWeight.w400,
                  ),
                  color: treinou
                      ? Colors.white
                      : (ehHoje ? tema.primary : tema.primaryText),
                  fontSize: 12.5,
                  letterSpacing: 0.0,
                  fontWeight: treinou ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Detalhe de um dia: o que foi treinado, com o que ficou por fazer.
class _DetalheDoDia extends StatelessWidget {
  const _DetalheDoDia({required this.dia, required this.treinos});

  final DateTime dia;
  final List<dynamic> treinos;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.0,
                height: 4.0,
                margin: const EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                  color: tema.alternate,
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 4.0),
              child: Text(
                DateFormat("d 'de' MMMM", 'pt_BR').format(dia),
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: tema.primaryText,
                  fontSize: 17.0,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 8.0, 16.0, 16.0),
                itemCount: treinos.length,
                itemBuilder: (context, i) => _CardTreinoDoDia(
                  treino: treinos[i] as Map<String, dynamic>,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardTreinoDoDia extends StatelessWidget {
  const _CardTreinoDoDia({required this.treino});

  final Map<String, dynamic> treino;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final exercicios = (treino['exercicios'] as List?) ?? const [];
    final cardios = (treino['cardios'] as List?) ?? const [];
    final feitos =
        exercicios.where((e) => (e as Map)['isConcluido'] == true).length;
    final pulados =
        exercicios.where((e) => (e as Map)['isPulado'] == true).length;
    final duracao = treino['duracaoMinutos'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [tema.designToken.shadow.sm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  treino['nome']?.toString() ?? 'Treino',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: tema.primaryText,
                    fontSize: 15.0,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (duracao != null && (duracao as num) > 0)
                Text(
                  '${duracao.round()} min',
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
          if (exercicios.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
              child: Text(
                '$feitos de ${exercicios.length} exercícios'
                '${pulados > 0 ? " · $pulados pulado${pulados > 1 ? "s" : ""}" : ""}',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  color: tema.secondaryText,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 10.0),
          for (final e in exercicios)
            _LinhaExercicio(exercicio: e as Map<String, dynamic>),
          for (final c in cardios)
            _LinhaCardio(cardio: c as Map<String, dynamic>),
        ],
      ),
    );
  }
}

class _LinhaExercicio extends StatelessWidget {
  const _LinhaExercicio({required this.exercicio});

  final Map<String, dynamic> exercicio;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final concluido = exercicio['isConcluido'] == true;
    final pulado = exercicio['isPulado'] == true;

    final series = exercicio['series'];
    final reps = exercicio['repeticoes'];
    final detalhe = (series != null && reps != null)
        ? '$series × $reps'
        : null;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
      child: Row(
        children: [
          Icon(
            concluido
                ? Icons.check_circle_rounded
                : (pulado
                    ? Icons.remove_circle_outline_rounded
                    : Icons.radio_button_unchecked_rounded),
            color: concluido
                ? tema.success
                : (pulado ? tema.warning : tema.alternate),
            size: 16.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              exercicio['nome']?.toString() ?? '',
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                color: pulado ? tema.secondaryText : tema.primaryText,
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
                decoration: pulado ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (detalhe != null)
            Text(
              detalhe,
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
    );
  }
}

class _LinhaCardio extends StatelessWidget {
  const _LinhaCardio({required this.cardio});

  final Map<String, dynamic> cardio;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final partes = <String>[
      if (cardio['duracaoMinutos'] != null)
        '${(cardio['duracaoMinutos'] as num).round()} min',
      if (cardio['distanciaKm'] != null &&
          (cardio['distanciaKm'] as num) > 0)
        '${cardio['distanciaKm']} km',
      if (cardio['kcal'] != null) '${cardio['kcal']} kcal',
    ];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
      child: Row(
        children: [
          Icon(Icons.directions_run_rounded, color: tema.primary, size: 16.0),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              cardio['descricao']?.toString() ?? 'Cardio',
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                color: tema.primaryText,
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (partes.isNotEmpty)
            Text(
              partes.join(' · '),
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
    );
  }
}

/// Número grande com rótulo, para o resumo do mês.
///
/// Os dois cartões lado a lado respondem perguntas diferentes: em quantos
/// dias houve treino, e quantos treinos foram feitos. Um dia com A e C
/// concluídos conta como 1 dia e 2 treinos.
class _Resumo extends StatelessWidget {
  const _Resumo({
    required this.numero,
    required this.rotulo,
    required this.cor,
  });

  final String numero;
  final String rotulo;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [tema.designToken.shadow.sm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            numero,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: cor,
              fontSize: 22.0,
              letterSpacing: -0.6,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            rotulo,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 11.5,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

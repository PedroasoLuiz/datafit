// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/components/folha_kit.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

/// Abre o calendário do app e devolve a data escolhida, ou `null`.
Future<DateTime?> showCustomDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final hoje = DateUtils.dateOnly(DateTime.now());
  final primeira = firstDate != null ? DateUtils.dateOnly(firstDate) : hoje;
  final ultima = lastDate ?? DateTime(2099, 12, 31);

  var inicial = initialDate != null ? DateUtils.dateOnly(initialDate) : null;
  if (inicial != null && inicial.isBefore(primeira)) inicial = primeira;

  return showModalBottomSheet<DateTime>(
    context: context,
    // No navegador raiz: este calendário quase sempre abre de dentro de outra
    // folha, e nas duas pilhas separadas fechar um deixava o outro em pé.
    useRootNavigator: true,
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (folha) => WebViewAware(
      child: _FolhaCalendario(
        initialDate: inicial,
        firstDate: primeira,
        lastDate: ultima,
      ),
    ),
  );
}

class _FolhaCalendario extends StatefulWidget {
  const _FolhaCalendario({
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_FolhaCalendario> createState() => _FolhaCalendarioState();
}

class _FolhaCalendarioState extends State<_FolhaCalendario> {
  DateTime? _escolhida;

  @override
  void initState() {
    super.initState();
    _escolhida = widget.initialDate;
  }

  String _porExtenso(DateTime d) {
    const meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];
    return '${d.day} de ${meses[d.month - 1]} de ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final hoje = DateUtils.dateOnly(DateTime.now());

    final fonte = GoogleFonts.inter().fontFamily;

    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      firstDayOfWeek: 0,
      selectedDayHighlightColor: tema.primary,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: fonte,
      ),
      dayTextStyle: TextStyle(
        color: tema.primaryText,
        fontWeight: FontWeight.w500,
        fontFamily: fonte,
      ),
      disabledDayTextStyle: TextStyle(
        color: tema.secondaryText.withValues(alpha: 0.4),
        fontFamily: fonte,
      ),
      weekdayLabelTextStyle: TextStyle(
        color: tema.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 12.0,
        fontFamily: fonte,
      ),
      controlsTextStyle: TextStyle(
        color: tema.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
        fontFamily: fonte,
      ),
      dayBuilder: ({
        required date,
        decoration,
        textStyle,
        isSelected,
        isDisabled,
        isToday,
      }) {
        final ehEscolhida =
            _escolhida != null && DateUtils.isSameDay(date, _escolhida);
        final ehHoje = DateUtils.isSameDay(date, hoje);
        final bloqueada = isDisabled ?? false;

        Color? fundo;
        Color tinta;

        if (ehEscolhida) {
          fundo = tema.primary;
          tinta = Colors.white;
        } else if (ehHoje && !bloqueada) {
          // Hoje marcado sem estar escolhido: é a referência que faz "daqui a
          // uma semana" ser uma conta de olho em vez de uma de cabeça.
          fundo = tema.primary.withValues(alpha: 0.12);
          tinta = tema.primary;
        } else {
          fundo = null;
          tinta = bloqueada
              ? tema.secondaryText.withValues(alpha: 0.35)
              : tema.primaryText;
        }

        return Container(
          decoration: fundo == null
              ? null
              : BoxDecoration(color: fundo, shape: BoxShape.circle),
          child: Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: tinta,
                fontWeight: ehEscolhida ? FontWeight.bold : FontWeight.w500,
                fontSize: 14.0,
                fontFamily: fonte,
              ),
            ),
          ),
        );
      },
    );

    return FolhaPadrao(
      // Devolve a data escolhida; sem escolha o visto não fecha.
      aoConfirmar: () async => _escolhida,
      filhos: [
        CabecaFolha(
          titulo: 'Selecionar data',
          // A data por extenso no apoio: o número no calendário diz o dia, e
          // o texto confirma o mês e o ano sem obrigar a conferir o topo.
          apoio: _escolhida == null
              ? 'Toque no dia que você quer.'
              : _porExtenso(_escolhida!),
          icone: Icons.calendar_month_rounded,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
          child: CalendarDatePicker2(
            config: config,
            value: _escolhida != null ? [_escolhida] : [],
            onValueChanged: (valores) {
              if (valores.isEmpty || valores[0] == null) return;
              setState(() => _escolhida = valores[0]);
            },
          ),
        ),
      ],
    );
  }
}

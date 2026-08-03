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

import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'index.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

final today = DateUtils.dateOnly(DateTime.now());

class CustomDateRangePicker extends StatefulWidget {
  const CustomDateRangePicker({
    super.key,
    this.width,
    this.height,
    required this.updatePageUi,
  });

  final double? width;
  final double? height;
  final Future<dynamic> Function() updatePageUi;

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  List<DateTime?> _rangeValue = [null, null];

  @override
  void initState() {
    super.initState();

    // Inicializando com valores do FFAppState
    try {
      final start = FFAppState().startDate.isNotEmpty
          ? DateTime.parse(FFAppState().startDate)
          : null;
      final end = FFAppState().endDate.isNotEmpty
          ? DateTime.parse(FFAppState().endDate)
          : null;

      _rangeValue = [start, end];
    } catch (_) {
      _rangeValue = [null, null];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      firstDayOfWeek: 1,

      selectedDayHighlightColor: theme.primary,
      selectedDayTextStyle: TextStyle(
        color: theme.primaryBackground,
        fontWeight: FontWeight.bold,
      ),

      dayTextStyle: TextStyle(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
      ),

      weekdayLabelTextStyle: TextStyle(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
      ),

      controlsTextStyle: TextStyle(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),

      // Highlight manual
      dayBuilder: ({
        required date,
        decoration,
        textStyle,
        isSelected,
        isDisabled,
        isToday,
      }) {
        final start = _rangeValue.isNotEmpty ? _rangeValue[0] : null;
        final end = _rangeValue.length > 1 ? _rangeValue[1] : null;

        bool inRange = false;

        if (start != null && end != null) {
          inRange = date.isAfter(DateUtils.dateOnly(start)) &&
              date.isBefore(DateUtils.dateOnly(end));
        }

        final isStart = start != null && DateUtils.isSameDay(date, start);
        final isEnd = end != null && DateUtils.isSameDay(date, end);

        // Dia selecionado
        if (isStart || isEnd) {
          return Container(
            decoration: BoxDecoration(
              color: theme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: theme.primaryBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        // Intervalo
        if (inRange) {
          return Container(
            decoration: BoxDecoration(
              color: theme.accent3.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: theme.primaryText,
                ),
              ),
            ),
          );
        }

        return Center(
          child: Text(
            date.day.toString(),
            style: textStyle,
          ),
        );
      },
    );

    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(4),
      color: theme.secondaryBackground,
      child: CalendarDatePicker2(
        config: config,
        value: _rangeValue,
        onValueChanged: (values) {
          setState(() => _rangeValue = values);

          // Só dispara ação quando existir START e END
          if (values.length == 2 && values[0] != null && values[1] != null) {
            final start = DateUtils.dateOnly(values[0]!);
            final end = DateUtils.dateOnly(values[1]!);

            FFAppState().startDate = start.toIso8601String();
            FFAppState().endDate = end.toIso8601String();

            widget.updatePageUi();
          }
        },
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

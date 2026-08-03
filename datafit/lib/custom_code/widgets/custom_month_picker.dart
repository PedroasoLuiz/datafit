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

class CustomMonthPicker extends StatefulWidget {
  const CustomMonthPicker({
    super.key,
    this.width,
    this.height,
    required this.updatePageUi,
  });

  final double? width;
  final double? height;
  final Future<dynamic> Function() updatePageUi;

  @override
  State<CustomMonthPicker> createState() => _CustomMonthPickerState();
}

class _CustomMonthPickerState extends State<CustomMonthPicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    try {
      if (FFAppState().startDate.isNotEmpty) {
        _selectedDate =
            DateUtils.dateOnly(DateTime.parse(FFAppState().startDate));
      }
    } catch (_) {
      _selectedDate = null;
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateUtils.dateOnly(date);
    });

    FFAppState().startDate = _selectedDate!.toIso8601String();
    widget.updatePageUi();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
      dayBuilder: ({
        required date,
        decoration,
        textStyle,
        isSelected,
        isDisabled,
        isToday,
      }) {
        final isSelectedDate =
            _selectedDate != null && DateUtils.isSameDay(date, _selectedDate);

        if (isSelectedDate) {
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

        if (DateUtils.isSameDay(date, today)) {
          return Container(
            decoration: BoxDecoration(
              color: theme.secondary,
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
      color: theme.secondaryBackground,
      child: Column(
        children: [
          Expanded(
            child: CalendarDatePicker2(
              config: config,
              value: _selectedDate != null ? [_selectedDate] : [],
              onValueChanged: (values) {
                if (values.isNotEmpty && values[0] != null) {
                  _selectDate(values[0]!);
                }
              },
            ),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: theme.primary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                      style: TextStyle(
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

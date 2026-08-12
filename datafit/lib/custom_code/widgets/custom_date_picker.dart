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

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

Future<DateTime?> showCustomDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final now = DateTime.now();
  final effective = DateUtils.dateOnly(now);
  final first = firstDate != null ? DateUtils.dateOnly(firstDate) : effective;
  final last = lastDate ?? DateTime(2099, 12, 31);
  DateTime? init = initialDate != null ? DateUtils.dateOnly(initialDate) : null;
  if (init != null && init.isBefore(first)) init = first;

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _CustomDatePickerSheet(
      initialDate: init,
      firstDate: first,
      lastDate: last,
    ),
  );
}

class _CustomDatePickerSheet extends StatefulWidget {
  const _CustomDatePickerSheet({
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_CustomDatePickerSheet> createState() => _CustomDatePickerSheetState();
}

class _CustomDatePickerSheetState extends State<_CustomDatePickerSheet>
    with TickerProviderStateMixin {
  DateTime? _selected;

  var hasCardTriggered = false;
  var hasBtn1Triggered = false;
  var hasBtn2Triggered = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;

    animationsMap.addAll({
      'cardOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOutQuint,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(-5.0, -5.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'btn1OnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 650.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 650.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'btn2OnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 650.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 650.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if (animationsMap['cardOnActionTriggerAnimation'] != null) {
            setState(() => hasCardTriggered = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['cardOnActionTriggerAnimation']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
        Future(() async {
          if (animationsMap['btn1OnActionTriggerAnimation'] != null) {
            setState(() => hasBtn1Triggered = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['btn1OnActionTriggerAnimation']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
        Future(() async {
          if (animationsMap['btn2OnActionTriggerAnimation'] != null) {
            setState(() => hasBtn2Triggered = true);
            SchedulerBinding.instance.addPostFrameCallback((_) async =>
                await animationsMap['btn2OnActionTriggerAnimation']!
                    .controller
                    .forward(from: 0.0));
          }
        }),
      ]);
    });
  }

  Future<void> _fechar([DateTime? result]) async {
    await Future.wait([
      Future(() async {
        if (animationsMap['cardOnActionTriggerAnimation'] != null) {
          await animationsMap['cardOnActionTriggerAnimation']!
              .controller
              .reverse();
        }
      }),
      Future(() async {
        if (animationsMap['btn1OnActionTriggerAnimation'] != null) {
          await animationsMap['btn1OnActionTriggerAnimation']!
              .controller
              .reverse();
        }
      }),
      Future(() async {
        if (animationsMap['btn2OnActionTriggerAnimation'] != null) {
          await animationsMap['btn2OnActionTriggerAnimation']!
              .controller
              .reverse();
        }
      }),
    ]);
    if (mounted) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final today = DateUtils.dateOnly(DateTime.now());

    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      firstDayOfWeek: 0,
      selectedDayHighlightColor: theme.primary,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      dayTextStyle: TextStyle(
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      disabledDayTextStyle: TextStyle(
        color: theme.secondaryText.withOpacity(0.4),
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      weekdayLabelTextStyle: TextStyle(
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      controlsTextStyle: TextStyle(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 15,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      dayBuilder: ({
        required date,
        decoration,
        textStyle,
        isSelected,
        isDisabled,
        isToday,
      }) {
        final isSelectedDay =
            _selected != null && DateUtils.isSameDay(date, _selected);
        final isTodayDay = DateUtils.isSameDay(date, today);

        Color? bg;
        Color textColor;

        if (isSelectedDay) {
          bg = theme.primary;
          textColor = Colors.white;
        } else if (isTodayDay && !(isDisabled ?? false)) {
          bg = theme.primary.withOpacity(0.12);
          textColor = theme.primary;
        } else {
          bg = null;
          textColor = (isDisabled ?? false)
              ? theme.secondaryText.withOpacity(0.35)
              : theme.primaryText;
        }

        return Container(
          decoration: bg != null
              ? BoxDecoration(color: bg, shape: BoxShape.circle)
              : null,
          child: Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: isSelectedDay ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ),
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.accent1,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Selecionar data',
                                style: TextStyle(
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_month_rounded,
                              color: theme.primary,
                              size: 18.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CalendarDatePicker2(
                      config: config,
                      value: _selected != null ? [_selected] : [],
                      onValueChanged: (values) {
                        if (values.isNotEmpty && values[0] != null) {
                          setState(() => _selected = values[0]);
                        }
                      },
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ).animateOnActionTrigger(
            animationsMap['cardOnActionTriggerAnimation']!,
            hasBeenTriggered: hasCardTriggered,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
              child: FlutterFlowIconButton(
                borderRadius: 20.0,
                buttonSize: 56.0,
                fillColor: _selected != null
                    ? theme.primary
                    : theme.primary.withOpacity(0.35),
                icon: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: _selected == null ? null : () => _fechar(_selected),
              ).animateOnActionTrigger(
                animationsMap['btn1OnActionTriggerAnimation']!,
                hasBeenTriggered: hasBtn1Triggered,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
              child: FlutterFlowIconButton(
                borderRadius: 20.0,
                buttonSize: 56.0,
                fillColor: theme.secondaryBackground,
                icon: Icon(
                  FFIcons.kproperty1FiRrCrossSmall,
                  color: theme.secondaryText,
                  size: 24.0,
                ),
                onPressed: () => _fechar(),
              ).animateOnActionTrigger(
                animationsMap['btn2OnActionTriggerAnimation']!,
                hasBeenTriggered: hasBtn2Triggered,
              ),
            ),
          ],
        ),
      ]
          .divide(const SizedBox(height: 16.0))
          .addToStart(const SizedBox(height: 40.0))
          .addToEnd(const SizedBox(height: 40.0)),
    );
  }
}

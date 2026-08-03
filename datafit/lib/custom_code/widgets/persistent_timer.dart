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
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// PersistentTimer
///
/// Timer persistente que continua mesmo ao sair e voltar pro app.
///
/// Parâmetros: - storageKey    : chave única ex: "timer_execucao" ou
/// "timer_descanso" - running       : true = rodando, false = parado -
/// resetTrigger  : incremente pra resetar o timer - textColor     : cor do
/// texto - fontSize      : tamanho da fonte - alignment     : "left",
/// "center" ou "right"
class PersistentTimer extends StatefulWidget {
  const PersistentTimer({
    super.key,
    this.width,
    this.height,
    required this.storageKey,
    required this.running,
    required this.resetTrigger,
    required this.textColor,
    required this.fontSize,
    this.alignment = 'left',
  });

  final double? width;
  final double? height;
  final String storageKey;
  final bool running;
  final int resetTrigger;
  final Color textColor;
  final double fontSize;
  final String alignment;

  @override
  State<PersistentTimer> createState() => _PersistentTimerState();
}

class _PersistentTimerState extends State<PersistentTimer> {
  Timer? _ticker;
  int _elapsedSeconds = 0;
  int _lastResetTrigger = -1;
  bool _initialized = false;

  String get _keyStart => '${widget.storageKey}_start';
  String get _keyElapsed => '${widget.storageKey}_elapsed';
  String get _keyReset => '${widget.storageKey}_reset';

  @override
  void initState() {
    super.initState();
    _lastResetTrigger = widget.resetTrigger;
    _restoreState();
  }

  @override
  void didUpdateWidget(PersistentTimer old) {
    super.didUpdateWidget(old);

    // Reset disparado
    if (widget.resetTrigger != _lastResetTrigger) {
      _lastResetTrigger = widget.resetTrigger;
      _reset();
      return;
    }

    if (!_initialized) return;

    // Mudou estado running
    if (widget.running != old.running) {
      if (widget.running) {
        _startTicker();
      } else {
        _stopTicker();
      }
    }
  }

  Future<void> _restoreState() async {
    final prefs = await SharedPreferences.getInstance();

    final savedReset = prefs.getInt(_keyReset) ?? 0;
    final savedElapsed = prefs.getInt(_keyElapsed) ?? 0;
    final startMs = prefs.getInt(_keyStart);

    // Reset mudou enquanto app estava fechado
    if (savedReset != widget.resetTrigger) {
      await _resetPrefs();
      if (!mounted) return;
      setState(() {
        _elapsedSeconds = 0;
        _initialized = true;
      });
      if (widget.running) _startTicker();
      return;
    }

    // Calcula tempo extra que passou com app fechado (só se estava running)
    int extra = 0;
    if (widget.running && startMs != null) {
      final start = DateTime.fromMillisecondsSinceEpoch(startMs);
      extra = DateTime.now().difference(start).inSeconds;
    }

    if (!mounted) return;
    setState(() {
      _elapsedSeconds = savedElapsed + extra;
      _initialized = true;
    });

    await prefs.setInt(_keyElapsed, _elapsedSeconds);

    // Só inicia o ticker se running == true
    if (widget.running) {
      _startTicker();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _saveStart();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);
      _saveElapsed();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
    _clearStart();
    _saveElapsed();
  }

  Future<void> _reset() async {
    _ticker?.cancel();
    _ticker = null;
    await _resetPrefs();
    if (!mounted) return;
    setState(() => _elapsedSeconds = 0);
    if (widget.running) _startTicker();
  }

  Future<void> _resetPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyElapsed, 0);
    await prefs.remove(_keyStart);
    await prefs.setInt(_keyReset, widget.resetTrigger);
  }

  Future<void> _saveStart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyStart, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _clearStart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyStart);
  }

  Future<void> _saveElapsed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyElapsed, _elapsedSeconds);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _format(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:'
          '${m.toString().padLeft(2, '0')}:'
          '${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  TextAlign get _textAlign {
    switch (widget.alignment.toLowerCase()) {
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      default:
        return TextAlign.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Align(
        alignment: widget.alignment.toLowerCase() == 'right'
            ? Alignment.centerRight
            : widget.alignment.toLowerCase() == 'center'
                ? Alignment.center
                : Alignment.centerLeft,
        child: Text(
          _format(_elapsedSeconds),
          textAlign: _textAlign,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w800,
            color: widget.textColor,
            letterSpacing: 1.5,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}

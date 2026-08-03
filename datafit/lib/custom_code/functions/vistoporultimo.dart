import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:ff_commons/flutter_flow/place.dart';
import 'package:ff_commons/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String? vistoporultimo(String dateString) {
  DateTime? parseDate(String dateStr) {
    final formats = [
      DateFormat(
          'EEE dd MMM yyyy HH:mm:ss z'), // Fri 23 Jan 2026 15:48:05 GMT-0300
      DateFormat('EEE dd MMM yyyy HH:mm:ss'), // Fri 23 Jan 2026 15:48:05
      DateFormat('yyyy-MM-ddTHH:mm:ss'), // ISO sem timezone
      DateFormat('yyyy-MM-dd HH:mm:ss'), // Formato SQL
    ];

    for (final format in formats) {
      try {
        return format.parse(dateStr);
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  final dateTime = parseDate(dateString);

  if (dateTime == null) {
    return 'Data não disponível';
  }

  final localDateTime = dateTime.toLocal();
  final now = DateTime.now();

  // Verifica se é hoje
  if (localDateTime.year == now.year &&
      localDateTime.month == now.month &&
      localDateTime.day == now.day) {
    return 'Visto por último hoje às ${DateFormat.Hm().format(localDateTime)}';
  }

  // Verifica se foi ontem
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (localDateTime.year == yesterday.year &&
      localDateTime.month == yesterday.month &&
      localDateTime.day == yesterday.day) {
    return 'Visto por último ontem';
  }

  // Para outros dias
  return 'Visto por último em ${DateFormat.yMMMd('pt_BR').format(localDateTime)} às ${DateFormat.Hm().format(localDateTime)}';
}

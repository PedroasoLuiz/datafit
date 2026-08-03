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

DateTime formataDataCopy(String? input) {
  if (input == null || input.isEmpty) {
    return DateTime.now(); // Retorna data atual se input for nulo ou vazio
  }

  try {
    input = input.trim();

    // Padrão para timestamptz do Supabase (com fração de segundo e offset)
    if (RegExp(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+[+-]\d{2}')
        .hasMatch(input)) {
      // Extrai a parte principal da data e o offset
      final datePart = input.substring(0, 23); // Pega até os milissegundos
      final offsetSign = input[23] == '+' ? 1 : -1;
      final offsetHours = int.parse(input.substring(24, 26));

      // Converte para UTC
      final utcDateTime = DateTime.parse(datePart + 'Z');

      // Ajusta pelo offset (se +00, não precisa ajustar)
      final adjustedDateTime = utcDateTime.add(Duration(
        hours: offsetSign * offsetHours * -1, // Inverte o sinal do offset
      ));

      return adjustedDateTime.toLocal();
    }
    // Para outros formatos ISO 8601
    else {
      return DateTime.parse(input).toLocal();
    }
  } catch (e) {
    // Em caso de erro na conversão, retorna a data atual
    return DateTime.now();
  }
}

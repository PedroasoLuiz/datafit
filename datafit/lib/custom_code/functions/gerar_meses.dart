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

List<DateTime> gerarMeses(String dataCadastro) {
  final now = DateTime.now();
  final parsed = DateTime.tryParse(dataCadastro);
  if (parsed == null) return [];

  final inicio = DateTime(parsed.year, parsed.month, 1);
  final meses = <DateTime>[];

  var atual = DateTime(now.year, now.month, 1);
  while (!atual.isBefore(inicio)) {
    meses.add(atual);
    atual = DateTime(atual.year, atual.month - 1, 1);
  }
  return meses;
}

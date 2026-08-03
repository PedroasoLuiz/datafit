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

List<String> listarExercicios(DashMetricasStruct? metricas) {
  final nomes = <String>[];
  if (metricas == null) return nomes;

  for (final cat in metricas.dsExercicios) {
    for (final sub in cat.subcategorias) {
      for (final ex in sub.exercicios) {
        if (ex.historicoCargas.isNotEmpty && !nomes.contains(ex.nome)) {
          nomes.add(ex.nome);
        }
      }
    }
  }
  return nomes;
}

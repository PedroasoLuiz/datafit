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

  // Alfabética, e não na ordem em que os grupos vieram do banco: numa lista
  // de dezenas de nomes, "onde está o supino?" só tem resposta rápida se a
  // ordem for a que a pessoa já conhece. A comparação ignora acento e caixa,
  // senão "Água" e "abdominal" caem em blocos separados.
  nomes.sort((a, b) => _semAcento(a).compareTo(_semAcento(b)));
  return nomes;
}

/// Minúsculas e sem acento, só para ordenar.
String _semAcento(String texto) {
  const com = 'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ';
  const sem = 'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC';
  final b = StringBuffer();
  for (final c in texto.toLowerCase().split('')) {
    final i = com.indexOf(c);
    b.write(i >= 0 ? sem[i] : c);
  }
  return b.toString();
}

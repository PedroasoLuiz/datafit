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

List<ExerciciosStruct> achatarExercicios(
  List<TreinoPersonalStruct> treinos,
  String? filtro,
) {
  final todos = treinos.expand((t) => t.exercicios).toList();

  if (filtro == null || filtro.isEmpty || filtro == 'Todos') {
    return todos;
  }

  return todos.where((e) => e.subcategoria == filtro).toList();
}

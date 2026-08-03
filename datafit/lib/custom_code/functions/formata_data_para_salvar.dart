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

DateTime formataDataParaSalvar(String data) {
  List<String> dataSplit = data.split('/');

  int dia = int.parse(dataSplit[0]);
  int mes = int.parse(dataSplit[1]);
  int ano = int.parse(dataSplit[2]);

  // Se o ano for um número de dois dígitos, presume-se que seja do século 2000+
  if (ano < 100) {
    ano += 2000;
  }

  return DateTime(ano, mes, dia);
}

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

String formatames(String dateTimeString) {
  if (dateTimeString.isEmpty) {
    return '-';
  }

  DateTime dateTime;
  try {
    dateTime = DateTime.parse(dateTimeString);
  } catch (e) {
    return '-';
  }

  final DateTime now = DateTime.now();

  int years = now.year - dateTime.year;
  int months = now.month - dateTime.month;
  int days = now.day - dateTime.day;

  if (days < 0) {
    months -= 1;
    days += DateTime(now.year, now.month, 0).day;
  }
  if (months < 0) {
    years -= 1;
    months += 12;
  }

  final int totalMonths = years * 12 + months;

  if (years >= 1) {
    return '${years}a';
  } else if (totalMonths >= 1) {
    return '${totalMonths}m';
  } else {
    return '${days}d';
  }
}

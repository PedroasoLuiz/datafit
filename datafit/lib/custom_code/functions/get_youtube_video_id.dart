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

String getYoutubeVideoId(String videoUrl) {
  if (videoUrl == null || videoUrl.trim().isEmpty) {
    return '';
  }

  final cleanUrl = videoUrl.trim();
  final uri = Uri.tryParse(cleanUrl);
  if (uri == null) return '';

  // watch?v=
  if (uri.queryParameters.containsKey('v')) {
    return uri.queryParameters['v'] ?? '';
  }

  // youtu.be/
  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
  }

  // embed/
  if (uri.pathSegments.contains('embed')) {
    final index = uri.pathSegments.indexOf('embed');
    if (index + 1 < uri.pathSegments.length) {
      return uri.pathSegments[index + 1];
    }
  }

  // 🔥 shorts/
  if (uri.pathSegments.contains('shorts')) {
    final index = uri.pathSegments.indexOf('shorts');
    if (index + 1 < uri.pathSegments.length) {
      return uri.pathSegments[index + 1];
    }
  }

  return '';
}

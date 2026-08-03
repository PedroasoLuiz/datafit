// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MetricasStruct extends BaseStruct {
  MetricasStruct({
    int? completos,
    int? incompletos,
    int? pulados,
    int? mediaDescansoSeg,
    int? totalCardioMinutos,
  })  : _completos = completos,
        _incompletos = incompletos,
        _pulados = pulados,
        _mediaDescansoSeg = mediaDescansoSeg,
        _totalCardioMinutos = totalCardioMinutos;

  // "completos" field.
  int? _completos;
  int get completos => _completos ?? 0;
  set completos(int? val) => _completos = val;

  void incrementCompletos(int amount) => completos = completos + amount;

  bool hasCompletos() => _completos != null;

  // "incompletos" field.
  int? _incompletos;
  int get incompletos => _incompletos ?? 0;
  set incompletos(int? val) => _incompletos = val;

  void incrementIncompletos(int amount) => incompletos = incompletos + amount;

  bool hasIncompletos() => _incompletos != null;

  // "pulados" field.
  int? _pulados;
  int get pulados => _pulados ?? 0;
  set pulados(int? val) => _pulados = val;

  void incrementPulados(int amount) => pulados = pulados + amount;

  bool hasPulados() => _pulados != null;

  // "mediaDescansoSeg" field.
  int? _mediaDescansoSeg;
  int get mediaDescansoSeg => _mediaDescansoSeg ?? 0;
  set mediaDescansoSeg(int? val) => _mediaDescansoSeg = val;

  void incrementMediaDescansoSeg(int amount) =>
      mediaDescansoSeg = mediaDescansoSeg + amount;

  bool hasMediaDescansoSeg() => _mediaDescansoSeg != null;

  // "totalCardioMinutos" field.
  int? _totalCardioMinutos;
  int get totalCardioMinutos => _totalCardioMinutos ?? 0;
  set totalCardioMinutos(int? val) => _totalCardioMinutos = val;

  void incrementTotalCardioMinutos(int amount) =>
      totalCardioMinutos = totalCardioMinutos + amount;

  bool hasTotalCardioMinutos() => _totalCardioMinutos != null;

  static MetricasStruct fromMap(Map<String, dynamic> data) => MetricasStruct(
        completos: castToType<int>(data['completos']),
        incompletos: castToType<int>(data['incompletos']),
        pulados: castToType<int>(data['pulados']),
        mediaDescansoSeg: castToType<int>(data['mediaDescansoSeg']),
        totalCardioMinutos: castToType<int>(data['totalCardioMinutos']),
      );

  static MetricasStruct? maybeFromMap(dynamic data) =>
      data is Map ? MetricasStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'completos': _completos,
        'incompletos': _incompletos,
        'pulados': _pulados,
        'mediaDescansoSeg': _mediaDescansoSeg,
        'totalCardioMinutos': _totalCardioMinutos,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'completos': serializeParam(
          _completos,
          ParamType.int,
        ),
        'incompletos': serializeParam(
          _incompletos,
          ParamType.int,
        ),
        'pulados': serializeParam(
          _pulados,
          ParamType.int,
        ),
        'mediaDescansoSeg': serializeParam(
          _mediaDescansoSeg,
          ParamType.int,
        ),
        'totalCardioMinutos': serializeParam(
          _totalCardioMinutos,
          ParamType.int,
        ),
      }.withoutNulls;

  static MetricasStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetricasStruct(
        completos: deserializeParam(
          data['completos'],
          ParamType.int,
          false,
        ),
        incompletos: deserializeParam(
          data['incompletos'],
          ParamType.int,
          false,
        ),
        pulados: deserializeParam(
          data['pulados'],
          ParamType.int,
          false,
        ),
        mediaDescansoSeg: deserializeParam(
          data['mediaDescansoSeg'],
          ParamType.int,
          false,
        ),
        totalCardioMinutos: deserializeParam(
          data['totalCardioMinutos'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'MetricasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MetricasStruct &&
        completos == other.completos &&
        incompletos == other.incompletos &&
        pulados == other.pulados &&
        mediaDescansoSeg == other.mediaDescansoSeg &&
        totalCardioMinutos == other.totalCardioMinutos;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [completos, incompletos, pulados, mediaDescansoSeg, totalCardioMinutos]);
}

MetricasStruct createMetricasStruct({
  int? completos,
  int? incompletos,
  int? pulados,
  int? mediaDescansoSeg,
  int? totalCardioMinutos,
}) =>
    MetricasStruct(
      completos: completos,
      incompletos: incompletos,
      pulados: pulados,
      mediaDescansoSeg: mediaDescansoSeg,
      totalCardioMinutos: totalCardioMinutos,
    );

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsMetricasStruct extends BaseStruct {
  DsMetricasStruct({
    int? completos,
    int? incompletos,
    int? pulados,
    int? descansoMedioSegundos,
    int? cardiosHoje,
    int? cardioMinutosHoje,
  })  : _completos = completos,
        _incompletos = incompletos,
        _pulados = pulados,
        _descansoMedioSegundos = descansoMedioSegundos,
        _cardiosHoje = cardiosHoje,
        _cardioMinutosHoje = cardioMinutosHoje;

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

  // "descansoMedioSegundos" field.
  int? _descansoMedioSegundos;
  int get descansoMedioSegundos => _descansoMedioSegundos ?? 0;
  set descansoMedioSegundos(int? val) => _descansoMedioSegundos = val;

  void incrementDescansoMedioSegundos(int amount) =>
      descansoMedioSegundos = descansoMedioSegundos + amount;

  bool hasDescansoMedioSegundos() => _descansoMedioSegundos != null;

  // "cardiosHoje" field.
  int? _cardiosHoje;
  int get cardiosHoje => _cardiosHoje ?? 0;
  set cardiosHoje(int? val) => _cardiosHoje = val;

  void incrementCardiosHoje(int amount) => cardiosHoje = cardiosHoje + amount;

  bool hasCardiosHoje() => _cardiosHoje != null;

  // "cardioMinutosHoje" field.
  int? _cardioMinutosHoje;
  int get cardioMinutosHoje => _cardioMinutosHoje ?? 0;
  set cardioMinutosHoje(int? val) => _cardioMinutosHoje = val;

  void incrementCardioMinutosHoje(int amount) =>
      cardioMinutosHoje = cardioMinutosHoje + amount;

  bool hasCardioMinutosHoje() => _cardioMinutosHoje != null;

  static DsMetricasStruct fromMap(Map<String, dynamic> data) =>
      DsMetricasStruct(
        completos: castToType<int>(data['completos']),
        incompletos: castToType<int>(data['incompletos']),
        pulados: castToType<int>(data['pulados']),
        descansoMedioSegundos: castToType<int>(data['descansoMedioSegundos']),
        cardiosHoje: castToType<int>(data['cardiosHoje']),
        cardioMinutosHoje: castToType<int>(data['cardioMinutosHoje']),
      );

  static DsMetricasStruct? maybeFromMap(dynamic data) => data is Map
      ? DsMetricasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'completos': _completos,
        'incompletos': _incompletos,
        'pulados': _pulados,
        'descansoMedioSegundos': _descansoMedioSegundos,
        'cardiosHoje': _cardiosHoje,
        'cardioMinutosHoje': _cardioMinutosHoje,
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
        'descansoMedioSegundos': serializeParam(
          _descansoMedioSegundos,
          ParamType.int,
        ),
        'cardiosHoje': serializeParam(
          _cardiosHoje,
          ParamType.int,
        ),
        'cardioMinutosHoje': serializeParam(
          _cardioMinutosHoje,
          ParamType.int,
        ),
      }.withoutNulls;

  static DsMetricasStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsMetricasStruct(
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
        descansoMedioSegundos: deserializeParam(
          data['descansoMedioSegundos'],
          ParamType.int,
          false,
        ),
        cardiosHoje: deserializeParam(
          data['cardiosHoje'],
          ParamType.int,
          false,
        ),
        cardioMinutosHoje: deserializeParam(
          data['cardioMinutosHoje'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DsMetricasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DsMetricasStruct &&
        completos == other.completos &&
        incompletos == other.incompletos &&
        pulados == other.pulados &&
        descansoMedioSegundos == other.descansoMedioSegundos &&
        cardiosHoje == other.cardiosHoje &&
        cardioMinutosHoje == other.cardioMinutosHoje;
  }

  @override
  int get hashCode => const ListEquality().hash([
        completos,
        incompletos,
        pulados,
        descansoMedioSegundos,
        cardiosHoje,
        cardioMinutosHoje
      ]);
}

DsMetricasStruct createDsMetricasStruct({
  int? completos,
  int? incompletos,
  int? pulados,
  int? descansoMedioSegundos,
  int? cardiosHoje,
  int? cardioMinutosHoje,
}) =>
    DsMetricasStruct(
      completos: completos,
      incompletos: incompletos,
      pulados: pulados,
      descansoMedioSegundos: descansoMedioSegundos,
      cardiosHoje: cardiosHoje,
      cardioMinutosHoje: cardioMinutosHoje,
    );

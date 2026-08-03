// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsPerimetrosStruct extends BaseStruct {
  DsPerimetrosStruct({
    int? tipoId,
    String? tipo,
    double? valorCm,
    String? data,
  })  : _tipoId = tipoId,
        _tipo = tipo,
        _valorCm = valorCm,
        _data = data;

  // "tipoId" field.
  int? _tipoId;
  int get tipoId => _tipoId ?? 0;
  set tipoId(int? val) => _tipoId = val;

  void incrementTipoId(int amount) => tipoId = tipoId + amount;

  bool hasTipoId() => _tipoId != null;

  // "tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  set tipo(String? val) => _tipo = val;

  bool hasTipo() => _tipo != null;

  // "valorCm" field.
  double? _valorCm;
  double get valorCm => _valorCm ?? 0.0;
  set valorCm(double? val) => _valorCm = val;

  void incrementValorCm(double amount) => valorCm = valorCm + amount;

  bool hasValorCm() => _valorCm != null;

  // "data" field.
  String? _data;
  String get data => _data ?? '';
  set data(String? val) => _data = val;

  bool hasData() => _data != null;

  static DsPerimetrosStruct fromMap(Map<String, dynamic> data) =>
      DsPerimetrosStruct(
        tipoId: castToType<int>(data['tipoId']),
        tipo: data['tipo'] as String?,
        valorCm: castToType<double>(data['valorCm']),
        data: data['data'] as String?,
      );

  static DsPerimetrosStruct? maybeFromMap(dynamic data) => data is Map
      ? DsPerimetrosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'tipoId': _tipoId,
        'tipo': _tipo,
        'valorCm': _valorCm,
        'data': _data,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'tipoId': serializeParam(
          _tipoId,
          ParamType.int,
        ),
        'tipo': serializeParam(
          _tipo,
          ParamType.String,
        ),
        'valorCm': serializeParam(
          _valorCm,
          ParamType.double,
        ),
        'data': serializeParam(
          _data,
          ParamType.String,
        ),
      }.withoutNulls;

  static DsPerimetrosStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsPerimetrosStruct(
        tipoId: deserializeParam(
          data['tipoId'],
          ParamType.int,
          false,
        ),
        tipo: deserializeParam(
          data['tipo'],
          ParamType.String,
          false,
        ),
        valorCm: deserializeParam(
          data['valorCm'],
          ParamType.double,
          false,
        ),
        data: deserializeParam(
          data['data'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DsPerimetrosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DsPerimetrosStruct &&
        tipoId == other.tipoId &&
        tipo == other.tipo &&
        valorCm == other.valorCm &&
        data == other.data;
  }

  @override
  int get hashCode => const ListEquality().hash([tipoId, tipo, valorCm, data]);
}

DsPerimetrosStruct createDsPerimetrosStruct({
  int? tipoId,
  String? tipo,
  double? valorCm,
  String? data,
}) =>
    DsPerimetrosStruct(
      tipoId: tipoId,
      tipo: tipo,
      valorCm: valorCm,
      data: data,
    );

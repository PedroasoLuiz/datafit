// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConviteStruct extends BaseStruct {
  ConviteStruct({
    String? personalUuid,
    String? personalNome,
    String? personalFoto,
    String? dataVinculo,
  })  : _personalUuid = personalUuid,
        _personalNome = personalNome,
        _personalFoto = personalFoto,
        _dataVinculo = dataVinculo;

  // "personalUuid" field.
  String? _personalUuid;
  String get personalUuid => _personalUuid ?? '';
  set personalUuid(String? val) => _personalUuid = val;

  bool hasPersonalUuid() => _personalUuid != null;

  // "personalNome" field.
  String? _personalNome;
  String get personalNome => _personalNome ?? '';
  set personalNome(String? val) => _personalNome = val;

  bool hasPersonalNome() => _personalNome != null;

  // "personalFoto" field.
  String? _personalFoto;
  String get personalFoto => _personalFoto ?? '';
  set personalFoto(String? val) => _personalFoto = val;

  bool hasPersonalFoto() => _personalFoto != null;

  // "dataVinculo" field.
  String? _dataVinculo;
  String get dataVinculo => _dataVinculo ?? '';
  set dataVinculo(String? val) => _dataVinculo = val;

  bool hasDataVinculo() => _dataVinculo != null;

  static ConviteStruct fromMap(Map<String, dynamic> data) => ConviteStruct(
        personalUuid: data['personalUuid'] as String?,
        personalNome: data['personalNome'] as String?,
        personalFoto: data['personalFoto'] as String?,
        dataVinculo: data['dataVinculo'] as String?,
      );

  static ConviteStruct? maybeFromMap(dynamic data) =>
      data is Map ? ConviteStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'personalUuid': _personalUuid,
        'personalNome': _personalNome,
        'personalFoto': _personalFoto,
        'dataVinculo': _dataVinculo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'personalUuid': serializeParam(
          _personalUuid,
          ParamType.String,
        ),
        'personalNome': serializeParam(
          _personalNome,
          ParamType.String,
        ),
        'personalFoto': serializeParam(
          _personalFoto,
          ParamType.String,
        ),
        'dataVinculo': serializeParam(
          _dataVinculo,
          ParamType.String,
        ),
      }.withoutNulls;

  static ConviteStruct fromSerializableMap(Map<String, dynamic> data) =>
      ConviteStruct(
        personalUuid: deserializeParam(
          data['personalUuid'],
          ParamType.String,
          false,
        ),
        personalNome: deserializeParam(
          data['personalNome'],
          ParamType.String,
          false,
        ),
        personalFoto: deserializeParam(
          data['personalFoto'],
          ParamType.String,
          false,
        ),
        dataVinculo: deserializeParam(
          data['dataVinculo'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ConviteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ConviteStruct &&
        personalUuid == other.personalUuid &&
        personalNome == other.personalNome &&
        personalFoto == other.personalFoto &&
        dataVinculo == other.dataVinculo;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([personalUuid, personalNome, personalFoto, dataVinculo]);
}

ConviteStruct createConviteStruct({
  String? personalUuid,
  String? personalNome,
  String? personalFoto,
  String? dataVinculo,
}) =>
    ConviteStruct(
      personalUuid: personalUuid,
      personalNome: personalNome,
      personalFoto: personalFoto,
      dataVinculo: dataVinculo,
    );

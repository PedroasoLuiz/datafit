// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RegistrosStruct extends BaseStruct {
  RegistrosStruct({
    int? id,
    String? urlImg,
    String? data,
  })  : _id = id,
        _urlImg = urlImg,
        _data = data;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "urlImg" field.
  String? _urlImg;
  String get urlImg => _urlImg ?? '';
  set urlImg(String? val) => _urlImg = val;

  bool hasUrlImg() => _urlImg != null;

  // "data" field.
  String? _data;
  String get data => _data ?? '1990-01-01';
  set data(String? val) => _data = val;

  bool hasData() => _data != null;

  static RegistrosStruct fromMap(Map<String, dynamic> data) => RegistrosStruct(
        id: castToType<int>(data['id']),
        urlImg: data['urlImg'] as String?,
        data: data['data'] as String?,
      );

  static RegistrosStruct? maybeFromMap(dynamic data) => data is Map
      ? RegistrosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'urlImg': _urlImg,
        'data': _data,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'urlImg': serializeParam(
          _urlImg,
          ParamType.String,
        ),
        'data': serializeParam(
          _data,
          ParamType.String,
        ),
      }.withoutNulls;

  static RegistrosStruct fromSerializableMap(Map<String, dynamic> data) =>
      RegistrosStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        urlImg: deserializeParam(
          data['urlImg'],
          ParamType.String,
          false,
        ),
        data: deserializeParam(
          data['data'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RegistrosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RegistrosStruct &&
        id == other.id &&
        urlImg == other.urlImg &&
        data == other.data;
  }

  @override
  int get hashCode => const ListEquality().hash([id, urlImg, data]);
}

RegistrosStruct createRegistrosStruct({
  int? id,
  String? urlImg,
  String? data,
}) =>
    RegistrosStruct(
      id: id,
      urlImg: urlImg,
      data: data,
    );

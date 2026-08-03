// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ResumoMesStruct extends BaseStruct {
  ResumoMesStruct({
    int? id,
    String? urlImg,
    String? mesAno,
    String? nomeMes,
  })  : _id = id,
        _urlImg = urlImg,
        _mesAno = mesAno,
        _nomeMes = nomeMes;

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

  // "mesAno" field.
  String? _mesAno;
  String get mesAno => _mesAno ?? '';
  set mesAno(String? val) => _mesAno = val;

  bool hasMesAno() => _mesAno != null;

  // "nomeMes" field.
  String? _nomeMes;
  String get nomeMes => _nomeMes ?? '';
  set nomeMes(String? val) => _nomeMes = val;

  bool hasNomeMes() => _nomeMes != null;

  static ResumoMesStruct fromMap(Map<String, dynamic> data) => ResumoMesStruct(
        id: castToType<int>(data['id']),
        urlImg: data['urlImg'] as String?,
        mesAno: data['mesAno'] as String?,
        nomeMes: data['nomeMes'] as String?,
      );

  static ResumoMesStruct? maybeFromMap(dynamic data) => data is Map
      ? ResumoMesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'urlImg': _urlImg,
        'mesAno': _mesAno,
        'nomeMes': _nomeMes,
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
        'mesAno': serializeParam(
          _mesAno,
          ParamType.String,
        ),
        'nomeMes': serializeParam(
          _nomeMes,
          ParamType.String,
        ),
      }.withoutNulls;

  static ResumoMesStruct fromSerializableMap(Map<String, dynamic> data) =>
      ResumoMesStruct(
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
        mesAno: deserializeParam(
          data['mesAno'],
          ParamType.String,
          false,
        ),
        nomeMes: deserializeParam(
          data['nomeMes'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ResumoMesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ResumoMesStruct &&
        id == other.id &&
        urlImg == other.urlImg &&
        mesAno == other.mesAno &&
        nomeMes == other.nomeMes;
  }

  @override
  int get hashCode => const ListEquality().hash([id, urlImg, mesAno, nomeMes]);
}

ResumoMesStruct createResumoMesStruct({
  int? id,
  String? urlImg,
  String? mesAno,
  String? nomeMes,
}) =>
    ResumoMesStruct(
      id: id,
      urlImg: urlImg,
      mesAno: mesAno,
      nomeMes: nomeMes,
    );

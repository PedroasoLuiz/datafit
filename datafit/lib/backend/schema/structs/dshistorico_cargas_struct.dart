// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DshistoricoCargasStruct extends BaseStruct {
  DshistoricoCargasStruct({
    String? mesAno,
    String? nomeMes,
    double? peso,
    int? qtd,
    String? medida,
    String? data,
  })  : _mesAno = mesAno,
        _nomeMes = nomeMes,
        _peso = peso,
        _qtd = qtd,
        _medida = medida,
        _data = data;

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

  // "peso" field.
  double? _peso;
  double get peso => _peso ?? 0.0;
  set peso(double? val) => _peso = val;

  void incrementPeso(double amount) => peso = peso + amount;

  bool hasPeso() => _peso != null;

  // "qtd" field.
  int? _qtd;
  int get qtd => _qtd ?? 0;
  set qtd(int? val) => _qtd = val;

  void incrementQtd(int amount) => qtd = qtd + amount;

  bool hasQtd() => _qtd != null;

  // "medida" field.
  String? _medida;
  String get medida => _medida ?? '';
  set medida(String? val) => _medida = val;

  bool hasMedida() => _medida != null;

  // "data" field.
  String? _data;
  String get data => _data ?? '';
  set data(String? val) => _data = val;

  bool hasData() => _data != null;

  static DshistoricoCargasStruct fromMap(Map<String, dynamic> data) =>
      DshistoricoCargasStruct(
        mesAno: data['mesAno'] as String?,
        nomeMes: data['nomeMes'] as String?,
        peso: castToType<double>(data['peso']),
        qtd: castToType<int>(data['qtd']),
        medida: data['medida'] as String?,
        data: data['data'] as String?,
      );

  static DshistoricoCargasStruct? maybeFromMap(dynamic data) => data is Map
      ? DshistoricoCargasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mesAno': _mesAno,
        'nomeMes': _nomeMes,
        'peso': _peso,
        'qtd': _qtd,
        'medida': _medida,
        'data': _data,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'mesAno': serializeParam(
          _mesAno,
          ParamType.String,
        ),
        'nomeMes': serializeParam(
          _nomeMes,
          ParamType.String,
        ),
        'peso': serializeParam(
          _peso,
          ParamType.double,
        ),
        'qtd': serializeParam(
          _qtd,
          ParamType.int,
        ),
        'medida': serializeParam(
          _medida,
          ParamType.String,
        ),
        'data': serializeParam(
          _data,
          ParamType.String,
        ),
      }.withoutNulls;

  static DshistoricoCargasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DshistoricoCargasStruct(
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
        peso: deserializeParam(
          data['peso'],
          ParamType.double,
          false,
        ),
        qtd: deserializeParam(
          data['qtd'],
          ParamType.int,
          false,
        ),
        medida: deserializeParam(
          data['medida'],
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
  String toString() => 'DshistoricoCargasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DshistoricoCargasStruct &&
        mesAno == other.mesAno &&
        nomeMes == other.nomeMes &&
        peso == other.peso &&
        qtd == other.qtd &&
        medida == other.medida &&
        data == other.data;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([mesAno, nomeMes, peso, qtd, medida, data]);
}

DshistoricoCargasStruct createDshistoricoCargasStruct({
  String? mesAno,
  String? nomeMes,
  double? peso,
  int? qtd,
  String? medida,
  String? data,
}) =>
    DshistoricoCargasStruct(
      mesAno: mesAno,
      nomeMes: nomeMes,
      peso: peso,
      qtd: qtd,
      medida: medida,
      data: data,
    );

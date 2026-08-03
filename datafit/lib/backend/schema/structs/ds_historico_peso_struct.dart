// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsHistoricoPesoStruct extends BaseStruct {
  DsHistoricoPesoStruct({
    String? mesAno,
    String? nomeMes,
    double? peso,
    double? gordura,
  })  : _mesAno = mesAno,
        _nomeMes = nomeMes,
        _peso = peso,
        _gordura = gordura;

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

  // "gordura" field.
  double? _gordura;
  double get gordura => _gordura ?? 0.0;
  set gordura(double? val) => _gordura = val;

  void incrementGordura(double amount) => gordura = gordura + amount;

  bool hasGordura() => _gordura != null;

  static DsHistoricoPesoStruct fromMap(Map<String, dynamic> data) =>
      DsHistoricoPesoStruct(
        mesAno: data['mesAno'] as String?,
        nomeMes: data['nomeMes'] as String?,
        peso: castToType<double>(data['peso']),
        gordura: castToType<double>(data['gordura']),
      );

  static DsHistoricoPesoStruct? maybeFromMap(dynamic data) => data is Map
      ? DsHistoricoPesoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mesAno': _mesAno,
        'nomeMes': _nomeMes,
        'peso': _peso,
        'gordura': _gordura,
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
        'gordura': serializeParam(
          _gordura,
          ParamType.double,
        ),
      }.withoutNulls;

  static DsHistoricoPesoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsHistoricoPesoStruct(
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
        gordura: deserializeParam(
          data['gordura'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DsHistoricoPesoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DsHistoricoPesoStruct &&
        mesAno == other.mesAno &&
        nomeMes == other.nomeMes &&
        peso == other.peso &&
        gordura == other.gordura;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([mesAno, nomeMes, peso, gordura]);
}

DsHistoricoPesoStruct createDsHistoricoPesoStruct({
  String? mesAno,
  String? nomeMes,
  double? peso,
  double? gordura,
}) =>
    DsHistoricoPesoStruct(
      mesAno: mesAno,
      nomeMes: nomeMes,
      peso: peso,
      gordura: gordura,
    );

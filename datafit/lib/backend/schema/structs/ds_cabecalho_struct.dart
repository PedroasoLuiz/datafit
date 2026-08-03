// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsCabecalhoStruct extends BaseStruct {
  DsCabecalhoStruct({
    double? peso,
    double? altura,
    double? imc,
    double? gordura,
    String? dataRegistro,
  })  : _peso = peso,
        _altura = altura,
        _imc = imc,
        _gordura = gordura,
        _dataRegistro = dataRegistro;

  // "peso" field.
  double? _peso;
  double get peso => _peso ?? 0.0;
  set peso(double? val) => _peso = val;

  void incrementPeso(double amount) => peso = peso + amount;

  bool hasPeso() => _peso != null;

  // "altura" field.
  double? _altura;
  double get altura => _altura ?? 0.0;
  set altura(double? val) => _altura = val;

  void incrementAltura(double amount) => altura = altura + amount;

  bool hasAltura() => _altura != null;

  // "imc" field.
  double? _imc;
  double get imc => _imc ?? 0.0;
  set imc(double? val) => _imc = val;

  void incrementImc(double amount) => imc = imc + amount;

  bool hasImc() => _imc != null;

  // "gordura" field.
  double? _gordura;
  double get gordura => _gordura ?? 0.0;
  set gordura(double? val) => _gordura = val;

  void incrementGordura(double amount) => gordura = gordura + amount;

  bool hasGordura() => _gordura != null;

  // "dataRegistro" field.
  String? _dataRegistro;
  String get dataRegistro => _dataRegistro ?? '';
  set dataRegistro(String? val) => _dataRegistro = val;

  bool hasDataRegistro() => _dataRegistro != null;

  static DsCabecalhoStruct fromMap(Map<String, dynamic> data) =>
      DsCabecalhoStruct(
        peso: castToType<double>(data['peso']),
        altura: castToType<double>(data['altura']),
        imc: castToType<double>(data['imc']),
        gordura: castToType<double>(data['gordura']),
        dataRegistro: data['dataRegistro'] as String?,
      );

  static DsCabecalhoStruct? maybeFromMap(dynamic data) => data is Map
      ? DsCabecalhoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'peso': _peso,
        'altura': _altura,
        'imc': _imc,
        'gordura': _gordura,
        'dataRegistro': _dataRegistro,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'peso': serializeParam(
          _peso,
          ParamType.double,
        ),
        'altura': serializeParam(
          _altura,
          ParamType.double,
        ),
        'imc': serializeParam(
          _imc,
          ParamType.double,
        ),
        'gordura': serializeParam(
          _gordura,
          ParamType.double,
        ),
        'dataRegistro': serializeParam(
          _dataRegistro,
          ParamType.String,
        ),
      }.withoutNulls;

  static DsCabecalhoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsCabecalhoStruct(
        peso: deserializeParam(
          data['peso'],
          ParamType.double,
          false,
        ),
        altura: deserializeParam(
          data['altura'],
          ParamType.double,
          false,
        ),
        imc: deserializeParam(
          data['imc'],
          ParamType.double,
          false,
        ),
        gordura: deserializeParam(
          data['gordura'],
          ParamType.double,
          false,
        ),
        dataRegistro: deserializeParam(
          data['dataRegistro'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DsCabecalhoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DsCabecalhoStruct &&
        peso == other.peso &&
        altura == other.altura &&
        imc == other.imc &&
        gordura == other.gordura &&
        dataRegistro == other.dataRegistro;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([peso, altura, imc, gordura, dataRegistro]);
}

DsCabecalhoStruct createDsCabecalhoStruct({
  double? peso,
  double? altura,
  double? imc,
  double? gordura,
  String? dataRegistro,
}) =>
    DsCabecalhoStruct(
      peso: peso,
      altura: altura,
      imc: imc,
      gordura: gordura,
      dataRegistro: dataRegistro,
    );

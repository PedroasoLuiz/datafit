// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CampoPersonalizadoStruct extends BaseStruct {
  CampoPersonalizadoStruct({
    int? id,
    String? perfisId,
    String? nome,
    String? unidade,
    String? valor,
  })  : _id = id,
        _perfisId = perfisId,
        _nome = nome,
        _unidade = unidade,
        _valor = valor;

  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;
  bool hasId() => _id != null;

  String? _perfisId;
  String get perfisId => _perfisId ?? '';
  set perfisId(String? val) => _perfisId = val;
  bool hasPerfisId() => _perfisId != null;

  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;
  bool hasNome() => _nome != null && _nome!.isNotEmpty;

  String? _unidade;
  String get unidade => _unidade ?? 'cm';
  set unidade(String? val) => _unidade = val;
  bool hasUnidade() => _unidade != null;

  String? _valor;
  String get valor => _valor ?? '';
  set valor(String? val) => _valor = val;
  bool hasValor() => _valor != null && _valor!.isNotEmpty;

  static CampoPersonalizadoStruct fromMap(Map<String, dynamic> data) =>
      CampoPersonalizadoStruct(
        id: castToType<int>(data['id']),
        perfisId: data['perfisId'] as String?,
        nome: data['nome'] as String?,
        unidade: data['unidade'] as String?,
        valor: data['valor'] as String?,
      );

  static CampoPersonalizadoStruct? maybeFromMap(dynamic data) => data is Map
      ? CampoPersonalizadoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'perfisId': _perfisId,
        'nome': _nome,
        'unidade': _unidade,
        'valor': _valor,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(_id, ParamType.int),
        'perfisId': serializeParam(_perfisId, ParamType.String),
        'nome': serializeParam(_nome, ParamType.String),
        'unidade': serializeParam(_unidade, ParamType.String),
        'valor': serializeParam(_valor, ParamType.String),
      }.withoutNulls;

  static CampoPersonalizadoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CampoPersonalizadoStruct(
        id: deserializeParam(data['id'], ParamType.int, false),
        perfisId: deserializeParam(data['perfisId'], ParamType.String, false),
        nome: deserializeParam(data['nome'], ParamType.String, false),
        unidade: deserializeParam(data['unidade'], ParamType.String, false),
        valor: deserializeParam(data['valor'], ParamType.String, false),
      );

  @override
  String toString() => 'CampoPersonalizadoStruct(${toMap()})';

  @override
  bool operator ==(Object other) =>
      other is CampoPersonalizadoStruct &&
      id == other.id &&
      perfisId == other.perfisId &&
      nome == other.nome &&
      unidade == other.unidade &&
      valor == other.valor;

  @override
  int get hashCode =>
      const ListEquality().hash([id, perfisId, nome, unidade, valor]);
}

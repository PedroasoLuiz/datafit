// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TreinoStruct extends BaseStruct {
  TreinoStruct({
    int? id,
    String? createdAt,
    int? fkaluno,
    String? nome,
    String? data,
  })  : _id = id,
        _createdAt = createdAt,
        _fkaluno = fkaluno,
        _nome = nome,
        _data = data;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "fkaluno" field.
  int? _fkaluno;
  int get fkaluno => _fkaluno ?? 0;
  set fkaluno(int? val) => _fkaluno = val;

  void incrementFkaluno(int amount) => fkaluno = fkaluno + amount;

  bool hasFkaluno() => _fkaluno != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "data" field.
  String? _data;
  String get data => _data ?? '';
  set data(String? val) => _data = val;

  bool hasData() => _data != null;

  static TreinoStruct fromMap(Map<String, dynamic> data) => TreinoStruct(
        id: castToType<int>(data['id']),
        createdAt: data['created_at'] as String?,
        fkaluno: castToType<int>(data['fkaluno']),
        nome: data['nome'] as String?,
        data: data['data'] as String?,
      );

  static TreinoStruct? maybeFromMap(dynamic data) =>
      data is Map ? TreinoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'fkaluno': _fkaluno,
        'nome': _nome,
        'data': _data,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'fkaluno': serializeParam(
          _fkaluno,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'data': serializeParam(
          _data,
          ParamType.String,
        ),
      }.withoutNulls;

  static TreinoStruct fromSerializableMap(Map<String, dynamic> data) =>
      TreinoStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        fkaluno: deserializeParam(
          data['fkaluno'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
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
  String toString() => 'TreinoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TreinoStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        fkaluno == other.fkaluno &&
        nome == other.nome &&
        data == other.data;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, createdAt, fkaluno, nome, data]);
}

TreinoStruct createTreinoStruct({
  int? id,
  String? createdAt,
  int? fkaluno,
  String? nome,
  String? data,
}) =>
    TreinoStruct(
      id: id,
      createdAt: createdAt,
      fkaluno: fkaluno,
      nome: nome,
      data: data,
    );

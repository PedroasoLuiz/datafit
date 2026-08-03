// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MusculosStruct extends BaseStruct {
  MusculosStruct({
    int? id,
    String? createdAt,
    String? nome,
    String? membro,
  })  : _id = id,
        _createdAt = createdAt,
        _nome = nome,
        _membro = membro;

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

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "membro" field.
  String? _membro;
  String get membro => _membro ?? '';
  set membro(String? val) => _membro = val;

  bool hasMembro() => _membro != null;

  static MusculosStruct fromMap(Map<String, dynamic> data) => MusculosStruct(
        id: castToType<int>(data['id']),
        createdAt: data['created_at'] as String?,
        nome: data['nome'] as String?,
        membro: data['membro'] as String?,
      );

  static MusculosStruct? maybeFromMap(dynamic data) =>
      data is Map ? MusculosStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'nome': _nome,
        'membro': _membro,
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
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'membro': serializeParam(
          _membro,
          ParamType.String,
        ),
      }.withoutNulls;

  static MusculosStruct fromSerializableMap(Map<String, dynamic> data) =>
      MusculosStruct(
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
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        membro: deserializeParam(
          data['membro'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MusculosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MusculosStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        nome == other.nome &&
        membro == other.membro;
  }

  @override
  int get hashCode => const ListEquality().hash([id, createdAt, nome, membro]);
}

MusculosStruct createMusculosStruct({
  int? id,
  String? createdAt,
  String? nome,
  String? membro,
}) =>
    MusculosStruct(
      id: id,
      createdAt: createdAt,
      nome: nome,
      membro: membro,
    );

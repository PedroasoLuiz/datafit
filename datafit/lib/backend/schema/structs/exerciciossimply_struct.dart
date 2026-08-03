// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ExerciciossimplyStruct extends BaseStruct {
  ExerciciossimplyStruct({
    int? id,
    String? nome,
    int? grupoId,
    String? grupoNome,
    String? linkInstrucao,
    bool? isGlobal,
    String? createdAt,
  })  : _id = id,
        _nome = nome,
        _grupoId = grupoId,
        _grupoNome = grupoNome,
        _linkInstrucao = linkInstrucao,
        _isGlobal = isGlobal,
        _createdAt = createdAt;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "grupoId" field.
  int? _grupoId;
  int get grupoId => _grupoId ?? 0;
  set grupoId(int? val) => _grupoId = val;

  void incrementGrupoId(int amount) => grupoId = grupoId + amount;

  bool hasGrupoId() => _grupoId != null;

  // "grupoNome" field.
  String? _grupoNome;
  String get grupoNome => _grupoNome ?? '';
  set grupoNome(String? val) => _grupoNome = val;

  bool hasGrupoNome() => _grupoNome != null;

  // "linkInstrucao" field.
  String? _linkInstrucao;
  String get linkInstrucao => _linkInstrucao ?? '';
  set linkInstrucao(String? val) => _linkInstrucao = val;

  bool hasLinkInstrucao() => _linkInstrucao != null;

  // "isGlobal" field.
  bool? _isGlobal;
  bool get isGlobal => _isGlobal ?? false;
  set isGlobal(bool? val) => _isGlobal = val;

  bool hasIsGlobal() => _isGlobal != null;

  // "createdAt" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  static ExerciciossimplyStruct fromMap(Map<String, dynamic> data) =>
      ExerciciossimplyStruct(
        id: castToType<int>(data['id']),
        nome: data['nome'] as String?,
        grupoId: castToType<int>(data['grupoId']),
        grupoNome: data['grupoNome'] as String?,
        linkInstrucao: data['linkInstrucao'] as String?,
        isGlobal: data['isGlobal'] as bool?,
        createdAt: data['createdAt'] as String?,
      );

  static ExerciciossimplyStruct? maybeFromMap(dynamic data) => data is Map
      ? ExerciciossimplyStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'grupoId': _grupoId,
        'grupoNome': _grupoNome,
        'linkInstrucao': _linkInstrucao,
        'isGlobal': _isGlobal,
        'createdAt': _createdAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'grupoId': serializeParam(
          _grupoId,
          ParamType.int,
        ),
        'grupoNome': serializeParam(
          _grupoNome,
          ParamType.String,
        ),
        'linkInstrucao': serializeParam(
          _linkInstrucao,
          ParamType.String,
        ),
        'isGlobal': serializeParam(
          _isGlobal,
          ParamType.bool,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static ExerciciossimplyStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ExerciciossimplyStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        grupoId: deserializeParam(
          data['grupoId'],
          ParamType.int,
          false,
        ),
        grupoNome: deserializeParam(
          data['grupoNome'],
          ParamType.String,
          false,
        ),
        linkInstrucao: deserializeParam(
          data['linkInstrucao'],
          ParamType.String,
          false,
        ),
        isGlobal: deserializeParam(
          data['isGlobal'],
          ParamType.bool,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ExerciciossimplyStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ExerciciossimplyStruct &&
        id == other.id &&
        nome == other.nome &&
        grupoId == other.grupoId &&
        grupoNome == other.grupoNome &&
        linkInstrucao == other.linkInstrucao &&
        isGlobal == other.isGlobal &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, nome, grupoId, grupoNome, linkInstrucao, isGlobal, createdAt]);
}

ExerciciossimplyStruct createExerciciossimplyStruct({
  int? id,
  String? nome,
  int? grupoId,
  String? grupoNome,
  String? linkInstrucao,
  bool? isGlobal,
  String? createdAt,
}) =>
    ExerciciossimplyStruct(
      id: id,
      nome: nome,
      grupoId: grupoId,
      grupoNome: grupoNome,
      linkInstrucao: linkInstrucao,
      isGlobal: isGlobal,
      createdAt: createdAt,
    );

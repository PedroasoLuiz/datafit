// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificacoesStruct extends BaseStruct {
  NotificacoesStruct({
    int? id,
    String? titulo,
    String? descricao,
    String? tag,
    bool? lida,
    String? criadoEm,
    String? remetente,
    String? remetenteId,
    int? referenciaId,
  })  : _id = id,
        _titulo = titulo,
        _descricao = descricao,
        _tag = tag,
        _lida = lida,
        _criadoEm = criadoEm,
        _remetente = remetente,
        _remetenteId = remetenteId,
        _referenciaId = referenciaId;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? '';
  set titulo(String? val) => _titulo = val;

  bool hasTitulo() => _titulo != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "tag" field.
  String? _tag;
  String get tag => _tag ?? '';
  set tag(String? val) => _tag = val;

  bool hasTag() => _tag != null;

  // "lida" field.
  bool? _lida;
  bool get lida => _lida ?? false;
  set lida(bool? val) => _lida = val;

  bool hasLida() => _lida != null;

  // "criadoEm" field.
  String? _criadoEm;
  String get criadoEm => _criadoEm ?? '';
  set criadoEm(String? val) => _criadoEm = val;

  bool hasCriadoEm() => _criadoEm != null;

  // "remetente" field.
  String? _remetente;
  String get remetente => _remetente ?? '';
  set remetente(String? val) => _remetente = val;

  bool hasRemetente() => _remetente != null;

  // "remetenteId" field.
  String? _remetenteId;
  String get remetenteId => _remetenteId ?? '';
  set remetenteId(String? val) => _remetenteId = val;

  bool hasRemetenteId() => _remetenteId != null;

  // "referenciaId" field.
  int? _referenciaId;
  int get referenciaId => _referenciaId ?? 0;
  set referenciaId(int? val) => _referenciaId = val;

  bool hasReferenciaId() => _referenciaId != null;

  static NotificacoesStruct fromMap(Map<String, dynamic> data) =>
      NotificacoesStruct(
        id: castToType<int>(data['id']),
        titulo: data['titulo'] as String?,
        descricao: data['descricao'] as String?,
        tag: data['tag'] as String?,
        lida: data['lida'] as bool?,
        criadoEm: data['criadoEm'] as String?,
        remetente: data['remetente'] as String?,
        remetenteId: data['remetenteId'] as String?,
        referenciaId: castToType<int>(data['referenciaId']),
      );

  static NotificacoesStruct? maybeFromMap(dynamic data) => data is Map
      ? NotificacoesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'titulo': _titulo,
        'descricao': _descricao,
        'tag': _tag,
        'lida': _lida,
        'criadoEm': _criadoEm,
        'remetente': _remetente,
        'remetenteId': _remetenteId,
        'referenciaId': _referenciaId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'titulo': serializeParam(
          _titulo,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'tag': serializeParam(
          _tag,
          ParamType.String,
        ),
        'lida': serializeParam(
          _lida,
          ParamType.bool,
        ),
        'criadoEm': serializeParam(
          _criadoEm,
          ParamType.String,
        ),
        'remetente': serializeParam(
          _remetente,
          ParamType.String,
        ),
        'remetenteId': serializeParam(
          _remetenteId,
          ParamType.String,
        ),
        'referenciaId': serializeParam(
          _referenciaId,
          ParamType.int,
        ),
      }.withoutNulls;

  static NotificacoesStruct fromSerializableMap(Map<String, dynamic> data) =>
      NotificacoesStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        titulo: deserializeParam(
          data['titulo'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        tag: deserializeParam(
          data['tag'],
          ParamType.String,
          false,
        ),
        lida: deserializeParam(
          data['lida'],
          ParamType.bool,
          false,
        ),
        criadoEm: deserializeParam(
          data['criadoEm'],
          ParamType.String,
          false,
        ),
        remetente: deserializeParam(
          data['remetente'],
          ParamType.String,
          false,
        ),
        remetenteId: deserializeParam(
          data['remetenteId'],
          ParamType.String,
          false,
        ),
        referenciaId: deserializeParam(
          data['referenciaId'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'NotificacoesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NotificacoesStruct &&
        id == other.id &&
        titulo == other.titulo &&
        descricao == other.descricao &&
        tag == other.tag &&
        lida == other.lida &&
        criadoEm == other.criadoEm &&
        remetente == other.remetente &&
        remetenteId == other.remetenteId &&
        referenciaId == other.referenciaId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        titulo,
        descricao,
        tag,
        lida,
        criadoEm,
        remetente,
        remetenteId,
        referenciaId
      ]);
}

NotificacoesStruct createNotificacoesStruct({
  int? id,
  String? titulo,
  String? descricao,
  String? tag,
  bool? lida,
  String? criadoEm,
  String? remetente,
  String? remetenteId,
  int? referenciaId,
}) =>
    NotificacoesStruct(
      id: id,
      titulo: titulo,
      descricao: descricao,
      tag: tag,
      lida: lida,
      criadoEm: criadoEm,
      remetente: remetente,
      remetenteId: remetenteId,
      referenciaId: referenciaId,
    );

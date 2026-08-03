// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfiltelefoneStruct extends BaseStruct {
  PerfiltelefoneStruct({
    int? id,
    String? numero,
    bool? isWhatsapp,
    bool? ativo,
  })  : _id = id,
        _numero = numero,
        _isWhatsapp = isWhatsapp,
        _ativo = ativo;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "numero" field.
  String? _numero;
  String get numero => _numero ?? '';
  set numero(String? val) => _numero = val;

  bool hasNumero() => _numero != null;

  // "is_whatsapp" field.
  bool? _isWhatsapp;
  bool get isWhatsapp => _isWhatsapp ?? false;
  set isWhatsapp(bool? val) => _isWhatsapp = val;

  bool hasIsWhatsapp() => _isWhatsapp != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  static PerfiltelefoneStruct fromMap(Map<String, dynamic> data) =>
      PerfiltelefoneStruct(
        id: castToType<int>(data['id']),
        numero: data['numero'] as String?,
        isWhatsapp: data['is_whatsapp'] as bool?,
        ativo: data['ativo'] as bool?,
      );

  static PerfiltelefoneStruct? maybeFromMap(dynamic data) => data is Map
      ? PerfiltelefoneStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'numero': _numero,
        'is_whatsapp': _isWhatsapp,
        'ativo': _ativo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'numero': serializeParam(
          _numero,
          ParamType.String,
        ),
        'is_whatsapp': serializeParam(
          _isWhatsapp,
          ParamType.bool,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
      }.withoutNulls;

  static PerfiltelefoneStruct fromSerializableMap(Map<String, dynamic> data) =>
      PerfiltelefoneStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        numero: deserializeParam(
          data['numero'],
          ParamType.String,
          false,
        ),
        isWhatsapp: deserializeParam(
          data['is_whatsapp'],
          ParamType.bool,
          false,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'PerfiltelefoneStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PerfiltelefoneStruct &&
        id == other.id &&
        numero == other.numero &&
        isWhatsapp == other.isWhatsapp &&
        ativo == other.ativo;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, numero, isWhatsapp, ativo]);
}

PerfiltelefoneStruct createPerfiltelefoneStruct({
  int? id,
  String? numero,
  bool? isWhatsapp,
  bool? ativo,
}) =>
    PerfiltelefoneStruct(
      id: id,
      numero: numero,
      isWhatsapp: isWhatsapp,
      ativo: ativo,
    );

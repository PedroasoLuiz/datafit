// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GrupostreinosStruct extends BaseStruct {
  GrupostreinosStruct({
    int? grupoTreinoId,
    String? nome,
    String? dataValidade,
    List<GruposStruct>? subagrupamentos,
    bool? ativo,
    String? personalUuid,
    String? personalFotoUrl,
  })  : _grupoTreinoId = grupoTreinoId,
        _nome = nome,
        _dataValidade = dataValidade,
        _subagrupamentos = subagrupamentos,
        _ativo = ativo,
        _personalUuid = personalUuid,
        _personalFotoUrl = personalFotoUrl;

  // "grupoTreinoId" field.
  int? _grupoTreinoId;
  int get grupoTreinoId => _grupoTreinoId ?? 0;
  set grupoTreinoId(int? val) => _grupoTreinoId = val;

  void incrementGrupoTreinoId(int amount) =>
      grupoTreinoId = grupoTreinoId + amount;

  bool hasGrupoTreinoId() => _grupoTreinoId != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "dataValidade" field.
  String? _dataValidade;
  String get dataValidade => _dataValidade ?? '';
  set dataValidade(String? val) => _dataValidade = val;

  bool hasDataValidade() => _dataValidade != null;

  // "subagrupamentos" field.
  List<GruposStruct>? _subagrupamentos;
  List<GruposStruct> get subagrupamentos => _subagrupamentos ?? const [];
  set subagrupamentos(List<GruposStruct>? val) => _subagrupamentos = val;

  void updateSubagrupamentos(Function(List<GruposStruct>) updateFn) {
    updateFn(_subagrupamentos ??= []);
  }

  bool hasSubagrupamentos() => _subagrupamentos != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  // "personalUuid" field.
  String? _personalUuid;
  String get personalUuid => _personalUuid ?? '';
  set personalUuid(String? val) => _personalUuid = val;

  bool hasPersonalUuid() => _personalUuid != null;

  // "personalFotoUrl" field.
  String? _personalFotoUrl;
  String get personalFotoUrl => _personalFotoUrl ?? '';
  set personalFotoUrl(String? val) => _personalFotoUrl = val;

  bool hasPersonalFotoUrl() => _personalFotoUrl != null;

  static GrupostreinosStruct fromMap(Map<String, dynamic> data) =>
      GrupostreinosStruct(
        grupoTreinoId: castToType<int>(data['grupoTreinoId']),
        nome: data['nome'] as String?,
        dataValidade: data['dataValidade'] as String?,
        subagrupamentos: getStructList(
          data['subagrupamentos'],
          GruposStruct.fromMap,
        ),
        ativo: data['ativo'] as bool?,
        personalUuid: data['personalUuid'] as String?,
        personalFotoUrl: data['personalFotoUrl'] as String?,
      );

  static GrupostreinosStruct? maybeFromMap(dynamic data) => data is Map
      ? GrupostreinosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'grupoTreinoId': _grupoTreinoId,
        'nome': _nome,
        'dataValidade': _dataValidade,
        'subagrupamentos': _subagrupamentos?.map((e) => e.toMap()).toList(),
        'ativo': _ativo,
        'personalUuid': _personalUuid,
        'personalFotoUrl': _personalFotoUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'grupoTreinoId': serializeParam(
          _grupoTreinoId,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'dataValidade': serializeParam(
          _dataValidade,
          ParamType.String,
        ),
        'subagrupamentos': serializeParam(
          _subagrupamentos,
          ParamType.DataStruct,
          isList: true,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
        'personalUuid': serializeParam(
          _personalUuid,
          ParamType.String,
        ),
        'personalFotoUrl': serializeParam(
          _personalFotoUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static GrupostreinosStruct fromSerializableMap(Map<String, dynamic> data) =>
      GrupostreinosStruct(
        grupoTreinoId: deserializeParam(
          data['grupoTreinoId'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        dataValidade: deserializeParam(
          data['dataValidade'],
          ParamType.String,
          false,
        ),
        subagrupamentos: deserializeStructParam<GruposStruct>(
          data['subagrupamentos'],
          ParamType.DataStruct,
          true,
          structBuilder: GruposStruct.fromSerializableMap,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
        personalUuid: deserializeParam(
          data['personalUuid'],
          ParamType.String,
          false,
        ),
        personalFotoUrl: deserializeParam(
          data['personalFotoUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'GrupostreinosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is GrupostreinosStruct &&
        grupoTreinoId == other.grupoTreinoId &&
        nome == other.nome &&
        dataValidade == other.dataValidade &&
        listEquality.equals(subagrupamentos, other.subagrupamentos) &&
        ativo == other.ativo &&
        personalUuid == other.personalUuid &&
        personalFotoUrl == other.personalFotoUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        grupoTreinoId,
        nome,
        dataValidade,
        subagrupamentos,
        ativo,
        personalUuid,
        personalFotoUrl,
      ]);
}

GrupostreinosStruct createGrupostreinosStruct({
  int? grupoTreinoId,
  String? nome,
  String? dataValidade,
  bool? ativo,
  String? personalUuid,
  String? personalFotoUrl,
}) =>
    GrupostreinosStruct(
      grupoTreinoId: grupoTreinoId,
      nome: nome,
      dataValidade: dataValidade,
      ativo: ativo,
      personalUuid: personalUuid,
      personalFotoUrl: personalFotoUrl,
    );

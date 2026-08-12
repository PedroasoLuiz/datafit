// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CardioStruct extends BaseStruct {
  CardioStruct({
    int? id,
    String? descricao,
    int? duracaoMinutos,
    double? distanciaKm,
    int? kcal,
    String? observacao,
    String? createdAt,
    String? dataHoraInicio,
    String? dataHoraFim,
  })  : _id = id,
        _descricao = descricao,
        _duracaoMinutos = duracaoMinutos,
        _distanciaKm = distanciaKm,
        _kcal = kcal,
        _observacao = observacao,
        _createdAt = createdAt,
        _dataHoraInicio = dataHoraInicio,
        _dataHoraFim = dataHoraFim;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "duracaoMinutos" field.
  int? _duracaoMinutos;
  int get duracaoMinutos => _duracaoMinutos ?? 0;
  set duracaoMinutos(int? val) => _duracaoMinutos = val;

  void incrementDuracaoMinutos(int amount) =>
      duracaoMinutos = duracaoMinutos + amount;

  bool hasDuracaoMinutos() => _duracaoMinutos != null;

  // "distanciaKm" field.
  double? _distanciaKm;
  double get distanciaKm => _distanciaKm ?? 0.0;
  set distanciaKm(double? val) => _distanciaKm = val;

  void incrementDistanciaKm(double amount) =>
      distanciaKm = distanciaKm + amount;

  bool hasDistanciaKm() => _distanciaKm != null;

  // "kcal" field.
  //
  // Nullable de proposito: null e "nao informado", que e diferente de 0.
  // Quem le deve checar hasKcal() antes de confiar no getter.
  int? _kcal;
  int get kcal => _kcal ?? 0;
  set kcal(int? val) => _kcal = val;

  bool hasKcal() => _kcal != null;

  // "observacao" field.
  String? _observacao;
  String get observacao => _observacao ?? '';
  set observacao(String? val) => _observacao = val;

  bool hasObservacao() => _observacao != null;

  // "createdAt" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "dataHoraInicio" field.
  String? _dataHoraInicio;
  String get dataHoraInicio => _dataHoraInicio ?? '';
  set dataHoraInicio(String? val) => _dataHoraInicio = val;

  bool hasDataHoraInicio() => _dataHoraInicio != null;

  // "dataHoraFim" field.
  String? _dataHoraFim;
  String get dataHoraFim => _dataHoraFim ?? '';
  set dataHoraFim(String? val) => _dataHoraFim = val;

  bool hasDataHoraFim() => _dataHoraFim != null;

  static CardioStruct fromMap(Map<String, dynamic> data) => CardioStruct(
        id: castToType<int>(data['id']),
        descricao: data['descricao'] as String?,
        duracaoMinutos: (data['duracaoMinutos'] as num?)?.toInt(),
        distanciaKm: (data['distanciaKm'] as num?)?.toDouble(),
        kcal: (data['kcal'] as num?)?.toInt(),
        observacao: data['observacao'] as String?,
        createdAt: data['createdAt'] as String?,
        dataHoraInicio: data['dataHoraInicio'] as String?,
        dataHoraFim: data['dataHoraFim'] as String?,
      );

  static CardioStruct? maybeFromMap(dynamic data) =>
      data is Map ? CardioStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'descricao': _descricao,
        'duracaoMinutos': _duracaoMinutos,
        'distanciaKm': _distanciaKm,
        'kcal': _kcal,
        'observacao': _observacao,
        'createdAt': _createdAt,
        'dataHoraInicio': _dataHoraInicio,
        'dataHoraFim': _dataHoraFim,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'duracaoMinutos': serializeParam(
          _duracaoMinutos,
          ParamType.int,
        ),
        'distanciaKm': serializeParam(
          _distanciaKm,
          ParamType.double,
        ),
        'kcal': serializeParam(
          _kcal,
          ParamType.int,
        ),
        'observacao': serializeParam(
          _observacao,
          ParamType.String,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'dataHoraInicio': serializeParam(
          _dataHoraInicio,
          ParamType.String,
        ),
        'dataHoraFim': serializeParam(
          _dataHoraFim,
          ParamType.String,
        ),
      }.withoutNulls;

  static CardioStruct fromSerializableMap(Map<String, dynamic> data) =>
      CardioStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        duracaoMinutos: deserializeParam(
          data['duracaoMinutos'],
          ParamType.int,
          false,
        ),
        distanciaKm: deserializeParam(
          data['distanciaKm'],
          ParamType.double,
          false,
        ),
        kcal: deserializeParam(
          data['kcal'],
          ParamType.int,
          false,
        ),
        observacao: deserializeParam(
          data['observacao'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.String,
          false,
        ),
        dataHoraInicio: deserializeParam(
          data['dataHoraInicio'],
          ParamType.String,
          false,
        ),
        dataHoraFim: deserializeParam(
          data['dataHoraFim'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CardioStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CardioStruct &&
        id == other.id &&
        descricao == other.descricao &&
        duracaoMinutos == other.duracaoMinutos &&
        distanciaKm == other.distanciaKm &&
        kcal == other.kcal &&
        observacao == other.observacao &&
        createdAt == other.createdAt &&
        dataHoraInicio == other.dataHoraInicio &&
        dataHoraFim == other.dataHoraFim;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        descricao,
        duracaoMinutos,
        distanciaKm,
        kcal,
        observacao,
        createdAt,
        dataHoraInicio,
        dataHoraFim
      ]);
}

CardioStruct createCardioStruct({
  int? id,
  String? descricao,
  int? duracaoMinutos,
  double? distanciaKm,
  int? kcal,
  String? observacao,
  String? createdAt,
  String? dataHoraInicio,
  String? dataHoraFim,
}) =>
    CardioStruct(
      id: id,
      descricao: descricao,
      duracaoMinutos: duracaoMinutos,
      distanciaKm: distanciaKm,
      kcal: kcal,
      observacao: observacao,
      createdAt: createdAt,
      dataHoraInicio: dataHoraInicio,
      dataHoraFim: dataHoraFim,
    );

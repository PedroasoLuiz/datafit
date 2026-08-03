// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GruposStruct extends BaseStruct {
  GruposStruct({
    List<GrupossubcategoriasStruct>? grupos,
    int? treinoExecucaoId,
    String? nome,
    int? diaSemana,
    int? ordem,
    String? status,
    String? dataInicio,
    String? feedback,
    List<CardioStruct>? cardios,
  })  : _grupos = grupos,
        _treinoExecucaoId = treinoExecucaoId,
        _nome = nome,
        _diaSemana = diaSemana,
        _ordem = ordem,
        _status = status,
        _dataInicio = dataInicio,
        _feedback = feedback,
        _cardios = cardios;

  // "grupos" field.
  List<GrupossubcategoriasStruct>? _grupos;
  List<GrupossubcategoriasStruct> get grupos => _grupos ?? const [];
  set grupos(List<GrupossubcategoriasStruct>? val) => _grupos = val;

  void updateGrupos(Function(List<GrupossubcategoriasStruct>) updateFn) {
    updateFn(_grupos ??= []);
  }

  bool hasGrupos() => _grupos != null;

  // "treinoExecucaoId" field.
  int? _treinoExecucaoId;
  int get treinoExecucaoId => _treinoExecucaoId ?? 0;
  set treinoExecucaoId(int? val) => _treinoExecucaoId = val;

  void incrementTreinoExecucaoId(int amount) =>
      treinoExecucaoId = treinoExecucaoId + amount;

  bool hasTreinoExecucaoId() => _treinoExecucaoId != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "diaSemana" field.
  int? _diaSemana;
  int get diaSemana => _diaSemana ?? 0;
  set diaSemana(int? val) => _diaSemana = val;

  void incrementDiaSemana(int amount) => diaSemana = diaSemana + amount;

  bool hasDiaSemana() => _diaSemana != null;

  // "ordem" field.
  int? _ordem;
  int get ordem => _ordem ?? 0;
  set ordem(int? val) => _ordem = val;

  void incrementOrdem(int amount) => ordem = ordem + amount;

  bool hasOrdem() => _ordem != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "dataInicio" field.
  String? _dataInicio;
  String get dataInicio => _dataInicio ?? '';
  set dataInicio(String? val) => _dataInicio = val;

  bool hasDataInicio() => _dataInicio != null;

  // "feedback" field.
  String? _feedback;
  String get feedback => _feedback ?? '';
  set feedback(String? val) => _feedback = val;

  bool hasFeedback() => _feedback != null;

  // "cardios" field.
  List<CardioStruct>? _cardios;
  List<CardioStruct> get cardios => _cardios ?? const [];
  set cardios(List<CardioStruct>? val) => _cardios = val;

  void updateCardios(Function(List<CardioStruct>) updateFn) {
    updateFn(_cardios ??= []);
  }

  bool hasCardios() => _cardios != null;

  static GruposStruct fromMap(Map<String, dynamic> data) => GruposStruct(
        grupos: getStructList(
          data['grupos'],
          GrupossubcategoriasStruct.fromMap,
        ),
        treinoExecucaoId: castToType<int>(data['treinoExecucaoId']),
        nome: data['nome'] as String?,
        diaSemana: castToType<int>(data['diaSemana']),
        ordem: castToType<int>(data['ordem']),
        status: data['status'] as String?,
        dataInicio: data['dataInicio'] as String?,
        feedback: data['feedback'] as String?,
        cardios: getStructList(
          data['cardios'],
          CardioStruct.fromMap,
        ),
      );

  static GruposStruct? maybeFromMap(dynamic data) =>
      data is Map ? GruposStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'grupos': _grupos?.map((e) => e.toMap()).toList(),
        'treinoExecucaoId': _treinoExecucaoId,
        'nome': _nome,
        'diaSemana': _diaSemana,
        'ordem': _ordem,
        'status': _status,
        'dataInicio': _dataInicio,
        'feedback': _feedback,
        'cardios': _cardios?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'grupos': serializeParam(
          _grupos,
          ParamType.DataStruct,
          isList: true,
        ),
        'treinoExecucaoId': serializeParam(
          _treinoExecucaoId,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'diaSemana': serializeParam(
          _diaSemana,
          ParamType.int,
        ),
        'ordem': serializeParam(
          _ordem,
          ParamType.int,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'dataInicio': serializeParam(
          _dataInicio,
          ParamType.String,
        ),
        'feedback': serializeParam(
          _feedback,
          ParamType.String,
        ),
        'cardios': serializeParam(
          _cardios,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static GruposStruct fromSerializableMap(Map<String, dynamic> data) =>
      GruposStruct(
        grupos: deserializeStructParam<GrupossubcategoriasStruct>(
          data['grupos'],
          ParamType.DataStruct,
          true,
          structBuilder: GrupossubcategoriasStruct.fromSerializableMap,
        ),
        treinoExecucaoId: deserializeParam(
          data['treinoExecucaoId'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        diaSemana: deserializeParam(
          data['diaSemana'],
          ParamType.int,
          false,
        ),
        ordem: deserializeParam(
          data['ordem'],
          ParamType.int,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        dataInicio: deserializeParam(
          data['dataInicio'],
          ParamType.String,
          false,
        ),
        feedback: deserializeParam(
          data['feedback'],
          ParamType.String,
          false,
        ),
        cardios: deserializeStructParam<CardioStruct>(
          data['cardios'],
          ParamType.DataStruct,
          true,
          structBuilder: CardioStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'GruposStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is GruposStruct &&
        listEquality.equals(grupos, other.grupos) &&
        treinoExecucaoId == other.treinoExecucaoId &&
        nome == other.nome &&
        diaSemana == other.diaSemana &&
        ordem == other.ordem &&
        status == other.status &&
        dataInicio == other.dataInicio &&
        feedback == other.feedback &&
        listEquality.equals(cardios, other.cardios);
  }

  @override
  int get hashCode => const ListEquality().hash([
        grupos,
        treinoExecucaoId,
        nome,
        diaSemana,
        ordem,
        status,
        dataInicio,
        feedback,
        cardios
      ]);
}

GruposStruct createGruposStruct({
  int? treinoExecucaoId,
  String? nome,
  int? diaSemana,
  int? ordem,
  String? status,
  String? dataInicio,
  String? feedback,
}) =>
    GruposStruct(
      treinoExecucaoId: treinoExecucaoId,
      nome: nome,
      diaSemana: diaSemana,
      ordem: ordem,
      status: status,
      dataInicio: dataInicio,
      feedback: feedback,
    );

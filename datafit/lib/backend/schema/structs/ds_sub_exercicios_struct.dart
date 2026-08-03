// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsSubExerciciosStruct extends BaseStruct {
  DsSubExerciciosStruct({
    int? execucaoId,
    String? nome,
    List<DshistoricoCargasStruct>? historicoCargas,
    int? totalConclusoes,
  })  : _execucaoId = execucaoId,
        _nome = nome,
        _historicoCargas = historicoCargas,
        _totalConclusoes = totalConclusoes;

  // "execucaoId" field.
  int? _execucaoId;
  int get execucaoId => _execucaoId ?? 0;
  set execucaoId(int? val) => _execucaoId = val;

  void incrementExecucaoId(int amount) => execucaoId = execucaoId + amount;

  bool hasExecucaoId() => _execucaoId != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "historicoCargas" field.
  List<DshistoricoCargasStruct>? _historicoCargas;
  List<DshistoricoCargasStruct> get historicoCargas =>
      _historicoCargas ?? const [];
  set historicoCargas(List<DshistoricoCargasStruct>? val) =>
      _historicoCargas = val;

  void updateHistoricoCargas(Function(List<DshistoricoCargasStruct>) updateFn) {
    updateFn(_historicoCargas ??= []);
  }

  bool hasHistoricoCargas() => _historicoCargas != null;

  // "totalConclusoes" field.
  int? _totalConclusoes;
  int get totalConclusoes => _totalConclusoes ?? 0;
  set totalConclusoes(int? val) => _totalConclusoes = val;

  void incrementTotalConclusoes(int amount) =>
      totalConclusoes = totalConclusoes + amount;

  bool hasTotalConclusoes() => _totalConclusoes != null;

  static DsSubExerciciosStruct fromMap(Map<String, dynamic> data) =>
      DsSubExerciciosStruct(
        execucaoId: castToType<int>(data['execucaoId']),
        nome: data['nome'] as String?,
        historicoCargas: getStructList(
          data['historicoCargas'],
          DshistoricoCargasStruct.fromMap,
        ),
        totalConclusoes: castToType<int>(data['totalConclusoes']),
      );

  static DsSubExerciciosStruct? maybeFromMap(dynamic data) => data is Map
      ? DsSubExerciciosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'execucaoId': _execucaoId,
        'nome': _nome,
        'historicoCargas': _historicoCargas?.map((e) => e.toMap()).toList(),
        'totalConclusoes': _totalConclusoes,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'execucaoId': serializeParam(
          _execucaoId,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'historicoCargas': serializeParam(
          _historicoCargas,
          ParamType.DataStruct,
          isList: true,
        ),
        'totalConclusoes': serializeParam(
          _totalConclusoes,
          ParamType.int,
        ),
      }.withoutNulls;

  static DsSubExerciciosStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsSubExerciciosStruct(
        execucaoId: deserializeParam(
          data['execucaoId'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        historicoCargas: deserializeStructParam<DshistoricoCargasStruct>(
          data['historicoCargas'],
          ParamType.DataStruct,
          true,
          structBuilder: DshistoricoCargasStruct.fromSerializableMap,
        ),
        totalConclusoes: deserializeParam(
          data['totalConclusoes'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DsSubExerciciosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DsSubExerciciosStruct &&
        execucaoId == other.execucaoId &&
        nome == other.nome &&
        listEquality.equals(historicoCargas, other.historicoCargas) &&
        totalConclusoes == other.totalConclusoes;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([execucaoId, nome, historicoCargas, totalConclusoes]);
}

DsSubExerciciosStruct createDsSubExerciciosStruct({
  int? execucaoId,
  String? nome,
  int? totalConclusoes,
}) =>
    DsSubExerciciosStruct(
      execucaoId: execucaoId,
      nome: nome,
      totalConclusoes: totalConclusoes,
    );

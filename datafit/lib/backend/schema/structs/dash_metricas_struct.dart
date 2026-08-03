// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DashMetricasStruct extends BaseStruct {
  DashMetricasStruct({
    DsCabecalhoStruct? dsCabecalho,
    List<DsPerimetrosStruct>? dsPerimetros,
    List<DsHistoricoPesoStruct>? dsHistoricoPeso,
    DsMetricasStruct? dsMetricas,
    List<DsExerciciosStruct>? dsExercicios,
  })  : _dsCabecalho = dsCabecalho,
        _dsPerimetros = dsPerimetros,
        _dsHistoricoPeso = dsHistoricoPeso,
        _dsMetricas = dsMetricas,
        _dsExercicios = dsExercicios;

  // "dsCabecalho" field.
  DsCabecalhoStruct? _dsCabecalho;
  DsCabecalhoStruct get dsCabecalho => _dsCabecalho ?? DsCabecalhoStruct();
  set dsCabecalho(DsCabecalhoStruct? val) => _dsCabecalho = val;

  void updateDsCabecalho(Function(DsCabecalhoStruct) updateFn) {
    updateFn(_dsCabecalho ??= DsCabecalhoStruct());
  }

  bool hasDsCabecalho() => _dsCabecalho != null;

  // "dsPerimetros" field.
  List<DsPerimetrosStruct>? _dsPerimetros;
  List<DsPerimetrosStruct> get dsPerimetros => _dsPerimetros ?? const [];
  set dsPerimetros(List<DsPerimetrosStruct>? val) => _dsPerimetros = val;

  void updateDsPerimetros(Function(List<DsPerimetrosStruct>) updateFn) {
    updateFn(_dsPerimetros ??= []);
  }

  bool hasDsPerimetros() => _dsPerimetros != null;

  // "dsHistoricoPeso" field.
  List<DsHistoricoPesoStruct>? _dsHistoricoPeso;
  List<DsHistoricoPesoStruct> get dsHistoricoPeso =>
      _dsHistoricoPeso ?? const [];
  set dsHistoricoPeso(List<DsHistoricoPesoStruct>? val) =>
      _dsHistoricoPeso = val;

  void updateDsHistoricoPeso(Function(List<DsHistoricoPesoStruct>) updateFn) {
    updateFn(_dsHistoricoPeso ??= []);
  }

  bool hasDsHistoricoPeso() => _dsHistoricoPeso != null;

  // "dsMetricas" field.
  DsMetricasStruct? _dsMetricas;
  DsMetricasStruct get dsMetricas => _dsMetricas ?? DsMetricasStruct();
  set dsMetricas(DsMetricasStruct? val) => _dsMetricas = val;

  void updateDsMetricas(Function(DsMetricasStruct) updateFn) {
    updateFn(_dsMetricas ??= DsMetricasStruct());
  }

  bool hasDsMetricas() => _dsMetricas != null;

  // "dsExercicios" field.
  List<DsExerciciosStruct>? _dsExercicios;
  List<DsExerciciosStruct> get dsExercicios => _dsExercicios ?? const [];
  set dsExercicios(List<DsExerciciosStruct>? val) => _dsExercicios = val;

  void updateDsExercicios(Function(List<DsExerciciosStruct>) updateFn) {
    updateFn(_dsExercicios ??= []);
  }

  bool hasDsExercicios() => _dsExercicios != null;

  static DashMetricasStruct fromMap(Map<String, dynamic> data) =>
      DashMetricasStruct(
        dsCabecalho: data['dsCabecalho'] is DsCabecalhoStruct
            ? data['dsCabecalho']
            : DsCabecalhoStruct.maybeFromMap(data['dsCabecalho']),
        dsPerimetros: getStructList(
          data['dsPerimetros'],
          DsPerimetrosStruct.fromMap,
        ),
        dsHistoricoPeso: getStructList(
          data['dsHistoricoPeso'],
          DsHistoricoPesoStruct.fromMap,
        ),
        dsMetricas: data['dsMetricas'] is DsMetricasStruct
            ? data['dsMetricas']
            : DsMetricasStruct.maybeFromMap(data['dsMetricas']),
        dsExercicios: getStructList(
          data['dsExercicios'],
          DsExerciciosStruct.fromMap,
        ),
      );

  static DashMetricasStruct? maybeFromMap(dynamic data) => data is Map
      ? DashMetricasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'dsCabecalho': _dsCabecalho?.toMap(),
        'dsPerimetros': _dsPerimetros?.map((e) => e.toMap()).toList(),
        'dsHistoricoPeso': _dsHistoricoPeso?.map((e) => e.toMap()).toList(),
        'dsMetricas': _dsMetricas?.toMap(),
        'dsExercicios': _dsExercicios?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'dsCabecalho': serializeParam(
          _dsCabecalho,
          ParamType.DataStruct,
        ),
        'dsPerimetros': serializeParam(
          _dsPerimetros,
          ParamType.DataStruct,
          isList: true,
        ),
        'dsHistoricoPeso': serializeParam(
          _dsHistoricoPeso,
          ParamType.DataStruct,
          isList: true,
        ),
        'dsMetricas': serializeParam(
          _dsMetricas,
          ParamType.DataStruct,
        ),
        'dsExercicios': serializeParam(
          _dsExercicios,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static DashMetricasStruct fromSerializableMap(Map<String, dynamic> data) =>
      DashMetricasStruct(
        dsCabecalho: deserializeStructParam(
          data['dsCabecalho'],
          ParamType.DataStruct,
          false,
          structBuilder: DsCabecalhoStruct.fromSerializableMap,
        ),
        dsPerimetros: deserializeStructParam<DsPerimetrosStruct>(
          data['dsPerimetros'],
          ParamType.DataStruct,
          true,
          structBuilder: DsPerimetrosStruct.fromSerializableMap,
        ),
        dsHistoricoPeso: deserializeStructParam<DsHistoricoPesoStruct>(
          data['dsHistoricoPeso'],
          ParamType.DataStruct,
          true,
          structBuilder: DsHistoricoPesoStruct.fromSerializableMap,
        ),
        dsMetricas: deserializeStructParam(
          data['dsMetricas'],
          ParamType.DataStruct,
          false,
          structBuilder: DsMetricasStruct.fromSerializableMap,
        ),
        dsExercicios: deserializeStructParam<DsExerciciosStruct>(
          data['dsExercicios'],
          ParamType.DataStruct,
          true,
          structBuilder: DsExerciciosStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'DashMetricasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DashMetricasStruct &&
        dsCabecalho == other.dsCabecalho &&
        listEquality.equals(dsPerimetros, other.dsPerimetros) &&
        listEquality.equals(dsHistoricoPeso, other.dsHistoricoPeso) &&
        dsMetricas == other.dsMetricas &&
        listEquality.equals(dsExercicios, other.dsExercicios);
  }

  @override
  int get hashCode => const ListEquality().hash(
      [dsCabecalho, dsPerimetros, dsHistoricoPeso, dsMetricas, dsExercicios]);
}

DashMetricasStruct createDashMetricasStruct({
  DsCabecalhoStruct? dsCabecalho,
  DsMetricasStruct? dsMetricas,
}) =>
    DashMetricasStruct(
      dsCabecalho: dsCabecalho ?? DsCabecalhoStruct(),
      dsMetricas: dsMetricas ?? DsMetricasStruct(),
    );

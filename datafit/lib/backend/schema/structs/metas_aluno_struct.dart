// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MetasAlunoStruct extends BaseStruct {
  MetasAlunoStruct({
    List<ResumoMesStruct>? acompanhamentoMensal,
    List<MetasStruct>? definidosPeloPersonal,
    List<MetasStruct>? meusObjetivos,
  })  : _acompanhamentoMensal = acompanhamentoMensal,
        _definidosPeloPersonal = definidosPeloPersonal,
        _meusObjetivos = meusObjetivos;

  // "acompanhamentoMensal" field.
  List<ResumoMesStruct>? _acompanhamentoMensal;
  List<ResumoMesStruct> get acompanhamentoMensal =>
      _acompanhamentoMensal ?? const [];
  set acompanhamentoMensal(List<ResumoMesStruct>? val) =>
      _acompanhamentoMensal = val;

  void updateAcompanhamentoMensal(Function(List<ResumoMesStruct>) updateFn) {
    updateFn(_acompanhamentoMensal ??= []);
  }

  bool hasAcompanhamentoMensal() => _acompanhamentoMensal != null;

  // "definidosPeloPersonal" field.
  List<MetasStruct>? _definidosPeloPersonal;
  List<MetasStruct> get definidosPeloPersonal =>
      _definidosPeloPersonal ?? const [];
  set definidosPeloPersonal(List<MetasStruct>? val) =>
      _definidosPeloPersonal = val;

  void updateDefinidosPeloPersonal(Function(List<MetasStruct>) updateFn) {
    updateFn(_definidosPeloPersonal ??= []);
  }

  bool hasDefinidosPeloPersonal() => _definidosPeloPersonal != null;

  // "meusObjetivos" field.
  List<MetasStruct>? _meusObjetivos;
  List<MetasStruct> get meusObjetivos => _meusObjetivos ?? const [];
  set meusObjetivos(List<MetasStruct>? val) => _meusObjetivos = val;

  void updateMeusObjetivos(Function(List<MetasStruct>) updateFn) {
    updateFn(_meusObjetivos ??= []);
  }

  bool hasMeusObjetivos() => _meusObjetivos != null;

  static MetasAlunoStruct fromMap(Map<String, dynamic> data) =>
      MetasAlunoStruct(
        acompanhamentoMensal: getStructList(
          data['acompanhamentoMensal'],
          ResumoMesStruct.fromMap,
        ),
        definidosPeloPersonal: getStructList(
          data['definidosPeloPersonal'],
          MetasStruct.fromMap,
        ),
        meusObjetivos: getStructList(
          data['meusObjetivos'],
          MetasStruct.fromMap,
        ),
      );

  static MetasAlunoStruct? maybeFromMap(dynamic data) => data is Map
      ? MetasAlunoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'acompanhamentoMensal':
            _acompanhamentoMensal?.map((e) => e.toMap()).toList(),
        'definidosPeloPersonal':
            _definidosPeloPersonal?.map((e) => e.toMap()).toList(),
        'meusObjetivos': _meusObjetivos?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'acompanhamentoMensal': serializeParam(
          _acompanhamentoMensal,
          ParamType.DataStruct,
          isList: true,
        ),
        'definidosPeloPersonal': serializeParam(
          _definidosPeloPersonal,
          ParamType.DataStruct,
          isList: true,
        ),
        'meusObjetivos': serializeParam(
          _meusObjetivos,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static MetasAlunoStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetasAlunoStruct(
        acompanhamentoMensal: deserializeStructParam<ResumoMesStruct>(
          data['acompanhamentoMensal'],
          ParamType.DataStruct,
          true,
          structBuilder: ResumoMesStruct.fromSerializableMap,
        ),
        definidosPeloPersonal: deserializeStructParam<MetasStruct>(
          data['definidosPeloPersonal'],
          ParamType.DataStruct,
          true,
          structBuilder: MetasStruct.fromSerializableMap,
        ),
        meusObjetivos: deserializeStructParam<MetasStruct>(
          data['meusObjetivos'],
          ParamType.DataStruct,
          true,
          structBuilder: MetasStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'MetasAlunoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MetasAlunoStruct &&
        listEquality.equals(acompanhamentoMensal, other.acompanhamentoMensal) &&
        listEquality.equals(
            definidosPeloPersonal, other.definidosPeloPersonal) &&
        listEquality.equals(meusObjetivos, other.meusObjetivos);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([acompanhamentoMensal, definidosPeloPersonal, meusObjetivos]);
}

MetasAlunoStruct createMetasAlunoStruct() => MetasAlunoStruct();

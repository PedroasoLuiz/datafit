// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsSubcategoriasStruct extends BaseStruct {
  DsSubcategoriasStruct({
    int? subcategoriaId,
    String? subcategoria,
    List<DsSubExerciciosStruct>? exercicios,
  })  : _subcategoriaId = subcategoriaId,
        _subcategoria = subcategoria,
        _exercicios = exercicios;

  // "subcategoriaId" field.
  int? _subcategoriaId;
  int get subcategoriaId => _subcategoriaId ?? 0;
  set subcategoriaId(int? val) => _subcategoriaId = val;

  void incrementSubcategoriaId(int amount) =>
      subcategoriaId = subcategoriaId + amount;

  bool hasSubcategoriaId() => _subcategoriaId != null;

  // "subcategoria" field.
  String? _subcategoria;
  String get subcategoria => _subcategoria ?? '';
  set subcategoria(String? val) => _subcategoria = val;

  bool hasSubcategoria() => _subcategoria != null;

  // "exercicios" field.
  List<DsSubExerciciosStruct>? _exercicios;
  List<DsSubExerciciosStruct> get exercicios => _exercicios ?? const [];
  set exercicios(List<DsSubExerciciosStruct>? val) => _exercicios = val;

  void updateExercicios(Function(List<DsSubExerciciosStruct>) updateFn) {
    updateFn(_exercicios ??= []);
  }

  bool hasExercicios() => _exercicios != null;

  static DsSubcategoriasStruct fromMap(Map<String, dynamic> data) =>
      DsSubcategoriasStruct(
        subcategoriaId: castToType<int>(data['subcategoriaId']),
        subcategoria: data['subcategoria'] as String?,
        exercicios: getStructList(
          data['exercicios'],
          DsSubExerciciosStruct.fromMap,
        ),
      );

  static DsSubcategoriasStruct? maybeFromMap(dynamic data) => data is Map
      ? DsSubcategoriasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'subcategoriaId': _subcategoriaId,
        'subcategoria': _subcategoria,
        'exercicios': _exercicios?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'subcategoriaId': serializeParam(
          _subcategoriaId,
          ParamType.int,
        ),
        'subcategoria': serializeParam(
          _subcategoria,
          ParamType.String,
        ),
        'exercicios': serializeParam(
          _exercicios,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static DsSubcategoriasStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsSubcategoriasStruct(
        subcategoriaId: deserializeParam(
          data['subcategoriaId'],
          ParamType.int,
          false,
        ),
        subcategoria: deserializeParam(
          data['subcategoria'],
          ParamType.String,
          false,
        ),
        exercicios: deserializeStructParam<DsSubExerciciosStruct>(
          data['exercicios'],
          ParamType.DataStruct,
          true,
          structBuilder: DsSubExerciciosStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'DsSubcategoriasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DsSubcategoriasStruct &&
        subcategoriaId == other.subcategoriaId &&
        subcategoria == other.subcategoria &&
        listEquality.equals(exercicios, other.exercicios);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([subcategoriaId, subcategoria, exercicios]);
}

DsSubcategoriasStruct createDsSubcategoriasStruct({
  int? subcategoriaId,
  String? subcategoria,
}) =>
    DsSubcategoriasStruct(
      subcategoriaId: subcategoriaId,
      subcategoria: subcategoria,
    );

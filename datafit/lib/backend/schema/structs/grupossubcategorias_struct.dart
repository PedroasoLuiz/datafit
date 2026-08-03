// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GrupossubcategoriasStruct extends BaseStruct {
  GrupossubcategoriasStruct({
    String? subcategoria,
    List<ExerciciosStruct>? exercicios,
    int? subcategoriaId,
  })  : _subcategoria = subcategoria,
        _exercicios = exercicios,
        _subcategoriaId = subcategoriaId;

  // "subcategoria" field.
  String? _subcategoria;
  String get subcategoria => _subcategoria ?? '';
  set subcategoria(String? val) => _subcategoria = val;

  bool hasSubcategoria() => _subcategoria != null;

  // "exercicios" field.
  List<ExerciciosStruct>? _exercicios;
  List<ExerciciosStruct> get exercicios => _exercicios ?? const [];
  set exercicios(List<ExerciciosStruct>? val) => _exercicios = val;

  void updateExercicios(Function(List<ExerciciosStruct>) updateFn) {
    updateFn(_exercicios ??= []);
  }

  bool hasExercicios() => _exercicios != null;

  // "subcategoriaId" field.
  int? _subcategoriaId;
  int get subcategoriaId => _subcategoriaId ?? 0;
  set subcategoriaId(int? val) => _subcategoriaId = val;

  void incrementSubcategoriaId(int amount) =>
      subcategoriaId = subcategoriaId + amount;

  bool hasSubcategoriaId() => _subcategoriaId != null;

  static GrupossubcategoriasStruct fromMap(Map<String, dynamic> data) =>
      GrupossubcategoriasStruct(
        subcategoria: data['subcategoria'] as String?,
        exercicios: getStructList(
          data['exercicios'],
          ExerciciosStruct.fromMap,
        ),
        subcategoriaId: castToType<int>(data['subcategoriaId']),
      );

  static GrupossubcategoriasStruct? maybeFromMap(dynamic data) => data is Map
      ? GrupossubcategoriasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'subcategoria': _subcategoria,
        'exercicios': _exercicios?.map((e) => e.toMap()).toList(),
        'subcategoriaId': _subcategoriaId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'subcategoria': serializeParam(
          _subcategoria,
          ParamType.String,
        ),
        'exercicios': serializeParam(
          _exercicios,
          ParamType.DataStruct,
          isList: true,
        ),
        'subcategoriaId': serializeParam(
          _subcategoriaId,
          ParamType.int,
        ),
      }.withoutNulls;

  static GrupossubcategoriasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      GrupossubcategoriasStruct(
        subcategoria: deserializeParam(
          data['subcategoria'],
          ParamType.String,
          false,
        ),
        exercicios: deserializeStructParam<ExerciciosStruct>(
          data['exercicios'],
          ParamType.DataStruct,
          true,
          structBuilder: ExerciciosStruct.fromSerializableMap,
        ),
        subcategoriaId: deserializeParam(
          data['subcategoriaId'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'GrupossubcategoriasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is GrupossubcategoriasStruct &&
        subcategoria == other.subcategoria &&
        listEquality.equals(exercicios, other.exercicios) &&
        subcategoriaId == other.subcategoriaId;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([subcategoria, exercicios, subcategoriaId]);
}

GrupossubcategoriasStruct createGrupossubcategoriasStruct({
  String? subcategoria,
  int? subcategoriaId,
}) =>
    GrupossubcategoriasStruct(
      subcategoria: subcategoria,
      subcategoriaId: subcategoriaId,
    );

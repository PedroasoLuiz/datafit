// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TreinoPersonalStruct extends BaseStruct {
  TreinoPersonalStruct({
    int? categoriaId,
    String? categoria,
    List<ExerciciosStruct>? exercicios,
  })  : _categoriaId = categoriaId,
        _categoria = categoria,
        _exercicios = exercicios;

  // "categoriaId" field.
  int? _categoriaId;
  int get categoriaId => _categoriaId ?? 0;
  set categoriaId(int? val) => _categoriaId = val;

  void incrementCategoriaId(int amount) => categoriaId = categoriaId + amount;

  bool hasCategoriaId() => _categoriaId != null;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  set categoria(String? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  // "exercicios" field.
  List<ExerciciosStruct>? _exercicios;
  List<ExerciciosStruct> get exercicios => _exercicios ?? const [];
  set exercicios(List<ExerciciosStruct>? val) => _exercicios = val;

  void updateExercicios(Function(List<ExerciciosStruct>) updateFn) {
    updateFn(_exercicios ??= []);
  }

  bool hasExercicios() => _exercicios != null;

  static TreinoPersonalStruct fromMap(Map<String, dynamic> data) =>
      TreinoPersonalStruct(
        categoriaId: castToType<int>(data['categoriaId']),
        categoria: data['categoria'] as String?,
        exercicios: getStructList(
          data['exercicios'],
          ExerciciosStruct.fromMap,
        ),
      );

  static TreinoPersonalStruct? maybeFromMap(dynamic data) => data is Map
      ? TreinoPersonalStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'categoriaId': _categoriaId,
        'categoria': _categoria,
        'exercicios': _exercicios?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'categoriaId': serializeParam(
          _categoriaId,
          ParamType.int,
        ),
        'categoria': serializeParam(
          _categoria,
          ParamType.String,
        ),
        'exercicios': serializeParam(
          _exercicios,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static TreinoPersonalStruct fromSerializableMap(Map<String, dynamic> data) =>
      TreinoPersonalStruct(
        categoriaId: deserializeParam(
          data['categoriaId'],
          ParamType.int,
          false,
        ),
        categoria: deserializeParam(
          data['categoria'],
          ParamType.String,
          false,
        ),
        exercicios: deserializeStructParam<ExerciciosStruct>(
          data['exercicios'],
          ParamType.DataStruct,
          true,
          structBuilder: ExerciciosStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'TreinoPersonalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TreinoPersonalStruct &&
        categoriaId == other.categoriaId &&
        categoria == other.categoria &&
        listEquality.equals(exercicios, other.exercicios);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([categoriaId, categoria, exercicios]);
}

TreinoPersonalStruct createTreinoPersonalStruct({
  int? categoriaId,
  String? categoria,
}) =>
    TreinoPersonalStruct(
      categoriaId: categoriaId,
      categoria: categoria,
    );

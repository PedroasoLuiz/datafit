// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsExerciciosStruct extends BaseStruct {
  DsExerciciosStruct({
    int? categoriaId,
    String? categoria,
    int? total,
    List<DsSubcategoriasStruct>? subcategorias,
  })  : _categoriaId = categoriaId,
        _categoria = categoria,
        _total = total,
        _subcategorias = subcategorias;

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

  // "total" field.
  int? _total;
  int get total => _total ?? 0;
  set total(int? val) => _total = val;

  void incrementTotal(int amount) => total = total + amount;

  bool hasTotal() => _total != null;

  // "subcategorias" field.
  List<DsSubcategoriasStruct>? _subcategorias;
  List<DsSubcategoriasStruct> get subcategorias => _subcategorias ?? const [];
  set subcategorias(List<DsSubcategoriasStruct>? val) => _subcategorias = val;

  void updateSubcategorias(Function(List<DsSubcategoriasStruct>) updateFn) {
    updateFn(_subcategorias ??= []);
  }

  bool hasSubcategorias() => _subcategorias != null;

  static DsExerciciosStruct fromMap(Map<String, dynamic> data) =>
      DsExerciciosStruct(
        categoriaId: castToType<int>(data['categoriaId']),
        categoria: data['categoria'] as String?,
        total: castToType<int>(data['total']),
        subcategorias: getStructList(
          data['subcategorias'],
          DsSubcategoriasStruct.fromMap,
        ),
      );

  static DsExerciciosStruct? maybeFromMap(dynamic data) => data is Map
      ? DsExerciciosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'categoriaId': _categoriaId,
        'categoria': _categoria,
        'total': _total,
        'subcategorias': _subcategorias?.map((e) => e.toMap()).toList(),
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
        'total': serializeParam(
          _total,
          ParamType.int,
        ),
        'subcategorias': serializeParam(
          _subcategorias,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static DsExerciciosStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsExerciciosStruct(
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
        total: deserializeParam(
          data['total'],
          ParamType.int,
          false,
        ),
        subcategorias: deserializeStructParam<DsSubcategoriasStruct>(
          data['subcategorias'],
          ParamType.DataStruct,
          true,
          structBuilder: DsSubcategoriasStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'DsExerciciosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DsExerciciosStruct &&
        categoriaId == other.categoriaId &&
        categoria == other.categoria &&
        total == other.total &&
        listEquality.equals(subcategorias, other.subcategorias);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([categoriaId, categoria, total, subcategorias]);
}

DsExerciciosStruct createDsExerciciosStruct({
  int? categoriaId,
  String? categoria,
  int? total,
}) =>
    DsExerciciosStruct(
      categoriaId: categoriaId,
      categoria: categoria,
      total: total,
    );

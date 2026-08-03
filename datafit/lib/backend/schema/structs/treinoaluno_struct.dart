// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TreinoalunoStruct extends BaseStruct {
  TreinoalunoStruct({
    TreinoStruct? treino,
    List<ExerciciostreinoStruct>? exercicio,
  })  : _treino = treino,
        _exercicio = exercicio;

  // "treino" field.
  TreinoStruct? _treino;
  TreinoStruct get treino => _treino ?? TreinoStruct();
  set treino(TreinoStruct? val) => _treino = val;

  void updateTreino(Function(TreinoStruct) updateFn) {
    updateFn(_treino ??= TreinoStruct());
  }

  bool hasTreino() => _treino != null;

  // "exercicio" field.
  List<ExerciciostreinoStruct>? _exercicio;
  List<ExerciciostreinoStruct> get exercicio => _exercicio ?? const [];
  set exercicio(List<ExerciciostreinoStruct>? val) => _exercicio = val;

  void updateExercicio(Function(List<ExerciciostreinoStruct>) updateFn) {
    updateFn(_exercicio ??= []);
  }

  bool hasExercicio() => _exercicio != null;

  static TreinoalunoStruct fromMap(Map<String, dynamic> data) =>
      TreinoalunoStruct(
        treino: data['treino'] is TreinoStruct
            ? data['treino']
            : TreinoStruct.maybeFromMap(data['treino']),
        exercicio: getStructList(
          data['exercicio'],
          ExerciciostreinoStruct.fromMap,
        ),
      );

  static TreinoalunoStruct? maybeFromMap(dynamic data) => data is Map
      ? TreinoalunoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'treino': _treino?.toMap(),
        'exercicio': _exercicio?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'treino': serializeParam(
          _treino,
          ParamType.DataStruct,
        ),
        'exercicio': serializeParam(
          _exercicio,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static TreinoalunoStruct fromSerializableMap(Map<String, dynamic> data) =>
      TreinoalunoStruct(
        treino: deserializeStructParam(
          data['treino'],
          ParamType.DataStruct,
          false,
          structBuilder: TreinoStruct.fromSerializableMap,
        ),
        exercicio: deserializeStructParam<ExerciciostreinoStruct>(
          data['exercicio'],
          ParamType.DataStruct,
          true,
          structBuilder: ExerciciostreinoStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'TreinoalunoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TreinoalunoStruct &&
        treino == other.treino &&
        listEquality.equals(exercicio, other.exercicio);
  }

  @override
  int get hashCode => const ListEquality().hash([treino, exercicio]);
}

TreinoalunoStruct createTreinoalunoStruct({
  TreinoStruct? treino,
}) =>
    TreinoalunoStruct(
      treino: treino ?? TreinoStruct(),
    );

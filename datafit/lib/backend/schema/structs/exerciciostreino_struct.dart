// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ExerciciostreinoStruct extends BaseStruct {
  ExerciciostreinoStruct({
    int? id,
    String? nome,
    int? series,
    int? repeticoesSugeridas,
    int? cargaSugerida,
    String? observacao,
  })  : _id = id,
        _nome = nome,
        _series = series,
        _repeticoesSugeridas = repeticoesSugeridas,
        _cargaSugerida = cargaSugerida,
        _observacao = observacao;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "series" field.
  int? _series;
  int get series => _series ?? 0;
  set series(int? val) => _series = val;

  void incrementSeries(int amount) => series = series + amount;

  bool hasSeries() => _series != null;

  // "repeticoes_sugeridas" field.
  int? _repeticoesSugeridas;
  int get repeticoesSugeridas => _repeticoesSugeridas ?? 0;
  set repeticoesSugeridas(int? val) => _repeticoesSugeridas = val;

  void incrementRepeticoesSugeridas(int amount) =>
      repeticoesSugeridas = repeticoesSugeridas + amount;

  bool hasRepeticoesSugeridas() => _repeticoesSugeridas != null;

  // "carga_sugerida" field.
  int? _cargaSugerida;
  int get cargaSugerida => _cargaSugerida ?? 0;
  set cargaSugerida(int? val) => _cargaSugerida = val;

  void incrementCargaSugerida(int amount) =>
      cargaSugerida = cargaSugerida + amount;

  bool hasCargaSugerida() => _cargaSugerida != null;

  // "observacao" field.
  String? _observacao;
  String get observacao => _observacao ?? '';
  set observacao(String? val) => _observacao = val;

  bool hasObservacao() => _observacao != null;

  static ExerciciostreinoStruct fromMap(Map<String, dynamic> data) =>
      ExerciciostreinoStruct(
        id: castToType<int>(data['id']),
        nome: data['nome'] as String?,
        series: castToType<int>(data['series']),
        repeticoesSugeridas: castToType<int>(data['repeticoes_sugeridas']),
        cargaSugerida: castToType<int>(data['carga_sugerida']),
        observacao: data['observacao'] as String?,
      );

  static ExerciciostreinoStruct? maybeFromMap(dynamic data) => data is Map
      ? ExerciciostreinoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'series': _series,
        'repeticoes_sugeridas': _repeticoesSugeridas,
        'carga_sugerida': _cargaSugerida,
        'observacao': _observacao,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'series': serializeParam(
          _series,
          ParamType.int,
        ),
        'repeticoes_sugeridas': serializeParam(
          _repeticoesSugeridas,
          ParamType.int,
        ),
        'carga_sugerida': serializeParam(
          _cargaSugerida,
          ParamType.int,
        ),
        'observacao': serializeParam(
          _observacao,
          ParamType.String,
        ),
      }.withoutNulls;

  static ExerciciostreinoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ExerciciostreinoStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        series: deserializeParam(
          data['series'],
          ParamType.int,
          false,
        ),
        repeticoesSugeridas: deserializeParam(
          data['repeticoes_sugeridas'],
          ParamType.int,
          false,
        ),
        cargaSugerida: deserializeParam(
          data['carga_sugerida'],
          ParamType.int,
          false,
        ),
        observacao: deserializeParam(
          data['observacao'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ExerciciostreinoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ExerciciostreinoStruct &&
        id == other.id &&
        nome == other.nome &&
        series == other.series &&
        repeticoesSugeridas == other.repeticoesSugeridas &&
        cargaSugerida == other.cargaSugerida &&
        observacao == other.observacao;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, nome, series, repeticoesSugeridas, cargaSugerida, observacao]);
}

ExerciciostreinoStruct createExerciciostreinoStruct({
  int? id,
  String? nome,
  int? series,
  int? repeticoesSugeridas,
  int? cargaSugerida,
  String? observacao,
}) =>
    ExerciciostreinoStruct(
      id: id,
      nome: nome,
      series: series,
      repeticoesSugeridas: repeticoesSugeridas,
      cargaSugerida: cargaSugerida,
      observacao: observacao,
    );

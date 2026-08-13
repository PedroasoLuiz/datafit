// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ExerciciosStruct extends BaseStruct {
  ExerciciosStruct({
    int? execucaoId,
    String? nome,
    String? linkInstrucao,
    double? thumbSegundo,
    String? thumbUrl,
    int? series,
    int? repeticoes,
    int? tempoDescansoSeg,
    String? observacao,
    int? tempoGastoSeg,
    int? ordem,
    bool? isConcluido,
    bool? isPulado,
    int? seriesFeitas,
    int? serieAquecimento,
    String? subcategoria,
    bool? temSubstitutos,
  })  : _execucaoId = execucaoId,
        _nome = nome,
        _linkInstrucao = linkInstrucao,
        _thumbSegundo = thumbSegundo,
        _thumbUrl = thumbUrl,
        _series = series,
        _repeticoes = repeticoes,
        _tempoDescansoSeg = tempoDescansoSeg,
        _observacao = observacao,
        _tempoGastoSeg = tempoGastoSeg,
        _ordem = ordem,
        _isConcluido = isConcluido,
        _isPulado = isPulado,
        _seriesFeitas = seriesFeitas,
        _serieAquecimento = serieAquecimento,
        _subcategoria = subcategoria,
        _temSubstitutos = temSubstitutos;

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

  // "linkInstrucao" field.
  String? _linkInstrucao;
  String get linkInstrucao => _linkInstrucao ?? '';
  set linkInstrucao(String? val) => _linkInstrucao = val;

  bool hasLinkInstrucao() => _linkInstrucao != null;

  // "thumbSegundo" field.
  double? _thumbSegundo;
  double get thumbSegundo => _thumbSegundo ?? 0.0;
  set thumbSegundo(double? val) => _thumbSegundo = val;

  void incrementThumbSegundo(double amount) =>
      thumbSegundo = thumbSegundo + amount;

  bool hasThumbSegundo() => _thumbSegundo != null;

  // "thumbUrl" field.
  String? _thumbUrl;
  String get thumbUrl => _thumbUrl ?? '';
  set thumbUrl(String? val) => _thumbUrl = val;

  bool hasThumbUrl() => _thumbUrl != null;

  // "series" field.
  int? _series;
  int get series => _series ?? 0;
  set series(int? val) => _series = val;

  void incrementSeries(int amount) => series = series + amount;

  bool hasSeries() => _series != null;

  // "repeticoes" field.
  int? _repeticoes;
  int get repeticoes => _repeticoes ?? 0;
  set repeticoes(int? val) => _repeticoes = val;

  void incrementRepeticoes(int amount) => repeticoes = repeticoes + amount;

  bool hasRepeticoes() => _repeticoes != null;

  // "tempoDescansoSeg" field.
  int? _tempoDescansoSeg;
  int get tempoDescansoSeg => _tempoDescansoSeg ?? 0;
  set tempoDescansoSeg(int? val) => _tempoDescansoSeg = val;

  void incrementTempoDescansoSeg(int amount) =>
      tempoDescansoSeg = tempoDescansoSeg + amount;

  bool hasTempoDescansoSeg() => _tempoDescansoSeg != null;

  // "observacao" field.
  String? _observacao;
  String get observacao => _observacao ?? '';
  set observacao(String? val) => _observacao = val;

  bool hasObservacao() => _observacao != null;

  // "tempoGastoSeg" field.
  int? _tempoGastoSeg;
  int get tempoGastoSeg => _tempoGastoSeg ?? 0;
  set tempoGastoSeg(int? val) => _tempoGastoSeg = val;

  void incrementTempoGastoSeg(int amount) =>
      tempoGastoSeg = tempoGastoSeg + amount;

  bool hasTempoGastoSeg() => _tempoGastoSeg != null;

  // "ordem" field.
  int? _ordem;
  int get ordem => _ordem ?? 0;
  set ordem(int? val) => _ordem = val;

  void incrementOrdem(int amount) => ordem = ordem + amount;

  bool hasOrdem() => _ordem != null;

  // "isConcluido" field.
  bool? _isConcluido;
  bool get isConcluido => _isConcluido ?? false;
  set isConcluido(bool? val) => _isConcluido = val;

  bool hasIsConcluido() => _isConcluido != null;

  // "isPulado" field.
  bool? _isPulado;
  bool get isPulado => _isPulado ?? false;
  set isPulado(bool? val) => _isPulado = val;

  bool hasIsPulado() => _isPulado != null;

  // "seriesFeitas" field.
  int? _seriesFeitas;
  int get seriesFeitas => _seriesFeitas ?? 0;
  set seriesFeitas(int? val) => _seriesFeitas = val;

  void incrementSeriesFeitas(int amount) =>
      seriesFeitas = seriesFeitas + amount;

  bool hasSeriesFeitas() => _seriesFeitas != null;

  // "serieAquecimento" field.
  int? _serieAquecimento;
  int get serieAquecimento => _serieAquecimento ?? 0;
  set serieAquecimento(int? val) => _serieAquecimento = val;

  void incrementSerieAquecimento(int amount) =>
      serieAquecimento = serieAquecimento + amount;

  bool hasSerieAquecimento() => _serieAquecimento != null;

  // "subcategoria" field.
  String? _subcategoria;
  String get subcategoria => _subcategoria ?? '';
  set subcategoria(String? val) => _subcategoria = val;

  bool hasSubcategoria() => _subcategoria != null;

  // "temSubstitutos" field.
  //
  // Se ha exercicio cadastrado para trocar por este. Vem do banco junto com o
  // exercicio: o botao de substituir so aparece onde ha para onde ir.
  bool? _temSubstitutos;
  bool get temSubstitutos => _temSubstitutos ?? false;
  set temSubstitutos(bool? val) => _temSubstitutos = val;

  bool hasTemSubstitutos() => _temSubstitutos != null;

  static ExerciciosStruct fromMap(Map<String, dynamic> data) =>
      ExerciciosStruct(
        execucaoId: castToType<int>(data['execucaoId']),
        nome: data['nome'] as String?,
        linkInstrucao: data['linkInstrucao'] as String?,
        thumbSegundo: castToType<double>(data['thumbSegundo']),
        thumbUrl: data['thumbUrl'] as String?,
        series: castToType<int>(data['series']),
        repeticoes: castToType<int>(data['repeticoes']),
        tempoDescansoSeg: castToType<int>(data['tempoDescansoSeg']),
        observacao: data['observacao'] as String?,
        tempoGastoSeg: castToType<int>(data['tempoGastoSeg']),
        ordem: castToType<int>(data['ordem']),
        isConcluido: data['isConcluido'] as bool?,
        isPulado: data['isPulado'] as bool?,
        seriesFeitas: castToType<int>(data['seriesFeitas']),
        serieAquecimento: castToType<int>(data['serieAquecimento']),
        subcategoria: data['subcategoria'] as String?,
        temSubstitutos: data['temSubstitutos'] as bool?,
      );

  static ExerciciosStruct? maybeFromMap(dynamic data) => data is Map
      ? ExerciciosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'execucaoId': _execucaoId,
        'nome': _nome,
        'linkInstrucao': _linkInstrucao,
        'thumbSegundo': _thumbSegundo,
        'thumbUrl': _thumbUrl,
        'series': _series,
        'repeticoes': _repeticoes,
        'tempoDescansoSeg': _tempoDescansoSeg,
        'observacao': _observacao,
        'tempoGastoSeg': _tempoGastoSeg,
        'ordem': _ordem,
        'isConcluido': _isConcluido,
        'isPulado': _isPulado,
        'seriesFeitas': _seriesFeitas,
        'serieAquecimento': _serieAquecimento,
        'subcategoria': _subcategoria,
        'temSubstitutos': _temSubstitutos,
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
        'linkInstrucao': serializeParam(
          _linkInstrucao,
          ParamType.String,
        ),
        'thumbSegundo': serializeParam(
          _thumbSegundo,
          ParamType.double,
        ),
        'thumbUrl': serializeParam(
          _thumbUrl,
          ParamType.String,
        ),
        'series': serializeParam(
          _series,
          ParamType.int,
        ),
        'repeticoes': serializeParam(
          _repeticoes,
          ParamType.int,
        ),
        'tempoDescansoSeg': serializeParam(
          _tempoDescansoSeg,
          ParamType.int,
        ),
        'observacao': serializeParam(
          _observacao,
          ParamType.String,
        ),
        'tempoGastoSeg': serializeParam(
          _tempoGastoSeg,
          ParamType.int,
        ),
        'ordem': serializeParam(
          _ordem,
          ParamType.int,
        ),
        'isConcluido': serializeParam(
          _isConcluido,
          ParamType.bool,
        ),
        'isPulado': serializeParam(
          _isPulado,
          ParamType.bool,
        ),
        'seriesFeitas': serializeParam(
          _seriesFeitas,
          ParamType.int,
        ),
        'serieAquecimento': serializeParam(
          _serieAquecimento,
          ParamType.int,
        ),
        'subcategoria': serializeParam(
          _subcategoria,
          ParamType.String,
        ),
        'temSubstitutos': serializeParam(
          _temSubstitutos,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ExerciciosStruct fromSerializableMap(Map<String, dynamic> data) =>
      ExerciciosStruct(
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
        linkInstrucao: deserializeParam(
          data['linkInstrucao'],
          ParamType.String,
          false,
        ),
        thumbSegundo: deserializeParam(
          data['thumbSegundo'],
          ParamType.double,
          false,
        ),
        thumbUrl: deserializeParam(
          data['thumbUrl'],
          ParamType.String,
          false,
        ),
        series: deserializeParam(
          data['series'],
          ParamType.int,
          false,
        ),
        repeticoes: deserializeParam(
          data['repeticoes'],
          ParamType.int,
          false,
        ),
        tempoDescansoSeg: deserializeParam(
          data['tempoDescansoSeg'],
          ParamType.int,
          false,
        ),
        observacao: deserializeParam(
          data['observacao'],
          ParamType.String,
          false,
        ),
        tempoGastoSeg: deserializeParam(
          data['tempoGastoSeg'],
          ParamType.int,
          false,
        ),
        ordem: deserializeParam(
          data['ordem'],
          ParamType.int,
          false,
        ),
        isConcluido: deserializeParam(
          data['isConcluido'],
          ParamType.bool,
          false,
        ),
        isPulado: deserializeParam(
          data['isPulado'],
          ParamType.bool,
          false,
        ),
        seriesFeitas: deserializeParam(
          data['seriesFeitas'],
          ParamType.int,
          false,
        ),
        serieAquecimento: deserializeParam(
          data['serieAquecimento'],
          ParamType.int,
          false,
        ),
        subcategoria: deserializeParam(
          data['subcategoria'],
          ParamType.String,
          false,
        ),
        temSubstitutos: deserializeParam(
          data['temSubstitutos'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ExerciciosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ExerciciosStruct &&
        execucaoId == other.execucaoId &&
        nome == other.nome &&
        linkInstrucao == other.linkInstrucao &&
        thumbSegundo == other.thumbSegundo &&
        thumbUrl == other.thumbUrl &&
        series == other.series &&
        repeticoes == other.repeticoes &&
        tempoDescansoSeg == other.tempoDescansoSeg &&
        observacao == other.observacao &&
        tempoGastoSeg == other.tempoGastoSeg &&
        ordem == other.ordem &&
        isConcluido == other.isConcluido &&
        isPulado == other.isPulado &&
        seriesFeitas == other.seriesFeitas &&
        serieAquecimento == other.serieAquecimento &&
        subcategoria == other.subcategoria &&
        temSubstitutos == other.temSubstitutos;
  }

  @override
  int get hashCode => const ListEquality().hash([
        execucaoId,
        nome,
        linkInstrucao,
        thumbSegundo,
        thumbUrl,
        series,
        repeticoes,
        tempoDescansoSeg,
        observacao,
        tempoGastoSeg,
        ordem,
        isConcluido,
        isPulado,
        seriesFeitas,
        serieAquecimento,
        subcategoria,
        temSubstitutos
      ]);
}

ExerciciosStruct createExerciciosStruct({
  int? execucaoId,
  String? nome,
  String? linkInstrucao,
  int? series,
  int? repeticoes,
  int? tempoDescansoSeg,
  String? observacao,
  int? tempoGastoSeg,
  int? ordem,
  bool? isConcluido,
  bool? isPulado,
  int? seriesFeitas,
  int? serieAquecimento,
  String? subcategoria,
  bool? temSubstitutos,
}) =>
    ExerciciosStruct(
      execucaoId: execucaoId,
      nome: nome,
      linkInstrucao: linkInstrucao,
      series: series,
      repeticoes: repeticoes,
      tempoDescansoSeg: tempoDescansoSeg,
      observacao: observacao,
      tempoGastoSeg: tempoGastoSeg,
      ordem: ordem,
      isConcluido: isConcluido,
      isPulado: isPulado,
      seriesFeitas: seriesFeitas,
      serieAquecimento: serieAquecimento,
      subcategoria: subcategoria,
      temSubstitutos: temSubstitutos,
    );

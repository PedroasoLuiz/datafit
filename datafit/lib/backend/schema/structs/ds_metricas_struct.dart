// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DsMetricasStruct extends BaseStruct {
  DsMetricasStruct({
    int? completos,
    int? incompletos,
    int? pulados,
    int? descansoMedioSegundos,
    int? cardiosHoje,
    int? cardioMinutosHoje,
    int? totalTreinos,
    int? aderencia,
    int? descansoPrescritoSegundos,
    int? volumeKg,
    int? cardios,
    int? cardioMinutos,
    int? completosAnterior,
    int? volumeKgAnterior,
    int? cardioMinutosAnterior,
    int? descansoMedioAnteriorSegundos,
    int? seriesConcluidas,
    int? seriesConcluidasAnterior,
    int? totalTreinosAnterior,
    int? tempoTreinoMinutos,
    int? tempoTreinoMinutosAnterior,
    int? descansosTotal,
    int? descansosNoAlvo,
    int? sequenciaMaxDias,
    int? sequenciaAtualDias,
  })  : _completos = completos,
        _incompletos = incompletos,
        _pulados = pulados,
        _descansoMedioSegundos = descansoMedioSegundos,
        _cardiosHoje = cardiosHoje,
        _cardioMinutosHoje = cardioMinutosHoje,
        _totalTreinos = totalTreinos,
        _aderencia = aderencia,
        _descansoPrescritoSegundos = descansoPrescritoSegundos,
        _volumeKg = volumeKg,
        _cardios = cardios,
        _cardioMinutos = cardioMinutos,
        _completosAnterior = completosAnterior,
        _volumeKgAnterior = volumeKgAnterior,
        _cardioMinutosAnterior = cardioMinutosAnterior,
        _descansoMedioAnteriorSegundos = descansoMedioAnteriorSegundos,
        _seriesConcluidas = seriesConcluidas,
        _seriesConcluidasAnterior = seriesConcluidasAnterior,
        _totalTreinosAnterior = totalTreinosAnterior,
        _tempoTreinoMinutos = tempoTreinoMinutos,
        _tempoTreinoMinutosAnterior = tempoTreinoMinutosAnterior,
        _descansosTotal = descansosTotal,
        _descansosNoAlvo = descansosNoAlvo,
        _sequenciaMaxDias = sequenciaMaxDias,
        _sequenciaAtualDias = sequenciaAtualDias;

  // "completos" field.
  int? _completos;
  int get completos => _completos ?? 0;
  set completos(int? val) => _completos = val;

  void incrementCompletos(int amount) => completos = completos + amount;

  bool hasCompletos() => _completos != null;

  // "incompletos" field.
  int? _incompletos;
  int get incompletos => _incompletos ?? 0;
  set incompletos(int? val) => _incompletos = val;

  void incrementIncompletos(int amount) => incompletos = incompletos + amount;

  bool hasIncompletos() => _incompletos != null;

  // "pulados" field.
  int? _pulados;
  int get pulados => _pulados ?? 0;
  set pulados(int? val) => _pulados = val;

  void incrementPulados(int amount) => pulados = pulados + amount;

  bool hasPulados() => _pulados != null;

  // "descansoMedioSegundos" field.
  int? _descansoMedioSegundos;
  int get descansoMedioSegundos => _descansoMedioSegundos ?? 0;
  set descansoMedioSegundos(int? val) => _descansoMedioSegundos = val;

  void incrementDescansoMedioSegundos(int amount) =>
      descansoMedioSegundos = descansoMedioSegundos + amount;

  bool hasDescansoMedioSegundos() => _descansoMedioSegundos != null;

  // "cardiosHoje" field.
  int? _cardiosHoje;
  int get cardiosHoje => _cardiosHoje ?? 0;
  set cardiosHoje(int? val) => _cardiosHoje = val;

  void incrementCardiosHoje(int amount) => cardiosHoje = cardiosHoje + amount;

  bool hasCardiosHoje() => _cardiosHoje != null;

  // "cardioMinutosHoje" field.
  int? _cardioMinutosHoje;
  int get cardioMinutosHoje => _cardioMinutosHoje ?? 0;
  set cardioMinutosHoje(int? val) => _cardioMinutosHoje = val;

  void incrementCardioMinutosHoje(int amount) =>
      cardioMinutosHoje = cardioMinutosHoje + amount;

  bool hasCardioMinutosHoje() => _cardioMinutosHoje != null;


  /// Treinos do período, feitos ou não. É o denominador da aderência.
  int? _totalTreinos;
  int get totalTreinos => _totalTreinos ?? 0;
  set totalTreinos(int? val) => _totalTreinos = val;

  void incrementTotalTreinos(int amount) => totalTreinos = totalTreinos + amount;

  bool hasTotalTreinos() => _totalTreinos != null;

  /// Quantos por cento dos treinos do período foram fechados.
  int? _aderencia;
  int get aderencia => _aderencia ?? 0;
  set aderencia(int? val) => _aderencia = val;

  void incrementAderencia(int amount) => aderencia = aderencia + amount;

  bool hasAderencia() => _aderencia != null;

  /// Descanso médio que o personal prescreveu. Sem ele, a média do aluno não tem régua.
  int? _descansoPrescritoSegundos;
  int get descansoPrescritoSegundos => _descansoPrescritoSegundos ?? 0;
  set descansoPrescritoSegundos(int? val) => _descansoPrescritoSegundos = val;

  void incrementDescansoPrescritoSegundos(int amount) => descansoPrescritoSegundos = descansoPrescritoSegundos + amount;

  bool hasDescansoPrescritoSegundos() => _descansoPrescritoSegundos != null;

  /// Carga movimentada no período: peso vezes repetições, somado.
  int? _volumeKg;
  int get volumeKg => _volumeKg ?? 0;
  set volumeKg(int? val) => _volumeKg = val;

  void incrementVolumeKg(int amount) => volumeKg = volumeKg + amount;

  bool hasVolumeKg() => _volumeKg != null;

  /// Sessões de cárdio no período. `cardiosHoje` é o mesmo número com o nome errado, mantido porque o app publicado ainda o lê.
  int? _cardios;
  int get cardios => _cardios ?? 0;
  set cardios(int? val) => _cardios = val;

  void incrementCardios(int amount) => cardios = cardios + amount;

  bool hasCardios() => _cardios != null;

  /// Minutos de cárdio no período.
  int? _cardioMinutos;
  int get cardioMinutos => _cardioMinutos ?? 0;
  set cardioMinutos(int? val) => _cardioMinutos = val;

  void incrementCardioMinutos(int amount) => cardioMinutos = cardioMinutos + amount;

  bool hasCardioMinutos() => _cardioMinutos != null;

  /// A mesma janela, deslocada para trás — é o que transforma um número solto em comparação.
  int? _completosAnterior;
  int get completosAnterior => _completosAnterior ?? 0;
  set completosAnterior(int? val) => _completosAnterior = val;

  void incrementCompletosAnterior(int amount) => completosAnterior = completosAnterior + amount;

  bool hasCompletosAnterior() => _completosAnterior != null;

  /// Volume da janela anterior.
  int? _volumeKgAnterior;
  int get volumeKgAnterior => _volumeKgAnterior ?? 0;
  set volumeKgAnterior(int? val) => _volumeKgAnterior = val;

  void incrementVolumeKgAnterior(int amount) => volumeKgAnterior = volumeKgAnterior + amount;

  bool hasVolumeKgAnterior() => _volumeKgAnterior != null;

  /// Minutos de cárdio da janela anterior.
  int? _cardioMinutosAnterior;
  int get cardioMinutosAnterior => _cardioMinutosAnterior ?? 0;
  set cardioMinutosAnterior(int? val) => _cardioMinutosAnterior = val;

  void incrementCardioMinutosAnterior(int amount) => cardioMinutosAnterior = cardioMinutosAnterior + amount;

  bool hasCardioMinutosAnterior() => _cardioMinutosAnterior != null;

  /// Descanso médio da janela anterior.
  int? _descansoMedioAnteriorSegundos;
  int get descansoMedioAnteriorSegundos => _descansoMedioAnteriorSegundos ?? 0;
  set descansoMedioAnteriorSegundos(int? val) => _descansoMedioAnteriorSegundos = val;

  void incrementDescansoMedioAnteriorSegundos(int amount) => descansoMedioAnteriorSegundos = descansoMedioAnteriorSegundos + amount;

  bool hasDescansoMedioAnteriorSegundos() => _descansoMedioAnteriorSegundos != null;


  /// Séries fechadas no período. É o número de esforço que uma pessoa entende sem conversão.
  int? _seriesConcluidas;
  int get seriesConcluidas => _seriesConcluidas ?? 0;
  set seriesConcluidas(int? val) => _seriesConcluidas = val;

  void incrementSeriesConcluidas(int amount) => seriesConcluidas = seriesConcluidas + amount;

  bool hasSeriesConcluidas() => _seriesConcluidas != null;

  /// Séries da janela anterior.
  int? _seriesConcluidasAnterior;
  int get seriesConcluidasAnterior => _seriesConcluidasAnterior ?? 0;
  set seriesConcluidasAnterior(int? val) => _seriesConcluidasAnterior = val;

  void incrementSeriesConcluidasAnterior(int amount) => seriesConcluidasAnterior = seriesConcluidasAnterior + amount;

  bool hasSeriesConcluidasAnterior() => _seriesConcluidasAnterior != null;

  /// Treinos da janela anterior, feitos ou não.
  int? _totalTreinosAnterior;
  int get totalTreinosAnterior => _totalTreinosAnterior ?? 0;
  set totalTreinosAnterior(int? val) => _totalTreinosAnterior = val;

  void incrementTotalTreinosAnterior(int amount) => totalTreinosAnterior = totalTreinosAnterior + amount;

  bool hasTotalTreinosAnterior() => _totalTreinosAnterior != null;


  /// Minutos somados dos treinos fechados no período. Sessão sem fim gravado ou acima de 4h fica de fora — app esquecido aberto viraria treino de dez horas.
  int? _tempoTreinoMinutos;
  int get tempoTreinoMinutos => _tempoTreinoMinutos ?? 0;
  set tempoTreinoMinutos(int? val) => _tempoTreinoMinutos = val;

  void incrementTempoTreinoMinutos(int amount) => tempoTreinoMinutos = tempoTreinoMinutos + amount;

  bool hasTempoTreinoMinutos() => _tempoTreinoMinutos != null;

  /// Tempo em treino da janela anterior.
  int? _tempoTreinoMinutosAnterior;
  int get tempoTreinoMinutosAnterior => _tempoTreinoMinutosAnterior ?? 0;
  set tempoTreinoMinutosAnterior(int? val) => _tempoTreinoMinutosAnterior = val;

  void incrementTempoTreinoMinutosAnterior(int amount) => tempoTreinoMinutosAnterior = tempoTreinoMinutosAnterior + amount;

  bool hasTempoTreinoMinutosAnterior() => _tempoTreinoMinutosAnterior != null;

  /// Descansos registrados que tinham tempo prescrito para comparar.
  int? _descansosTotal;
  int get descansosTotal => _descansosTotal ?? 0;
  set descansosTotal(int? val) => _descansosTotal = val;

  void incrementDescansosTotal(int amount) => descansosTotal = descansosTotal + amount;

  bool hasDescansosTotal() => _descansosTotal != null;

  /// Quantos alcançaram pelo menos 90% do tempo prescrito do próprio exercício.
  int? _descansosNoAlvo;
  int get descansosNoAlvo => _descansosNoAlvo ?? 0;
  set descansosNoAlvo(int? val) => _descansosNoAlvo = val;

  void incrementDescansosNoAlvo(int amount) => descansosNoAlvo = descansosNoAlvo + amount;

  bool hasDescansosNoAlvo() => _descansosNoAlvo != null;


  /// A maior sequência de dias seguidos treinando, no histórico inteiro. Não obedece ao período: recortada numa janela de sete dias daria no máximo sete.
  int? _sequenciaMaxDias;
  int get sequenciaMaxDias => _sequenciaMaxDias ?? 0;
  set sequenciaMaxDias(int? val) => _sequenciaMaxDias = val;

  void incrementSequenciaMaxDias(int amount) => sequenciaMaxDias = sequenciaMaxDias + amount;

  bool hasSequenciaMaxDias() => _sequenciaMaxDias != null;

  /// A sequência que ainda está viva — terminou hoje ou ontem. Zero quando foi quebrada.
  int? _sequenciaAtualDias;
  int get sequenciaAtualDias => _sequenciaAtualDias ?? 0;
  set sequenciaAtualDias(int? val) => _sequenciaAtualDias = val;

  void incrementSequenciaAtualDias(int amount) => sequenciaAtualDias = sequenciaAtualDias + amount;

  bool hasSequenciaAtualDias() => _sequenciaAtualDias != null;

  static DsMetricasStruct fromMap(Map<String, dynamic> data) =>
      DsMetricasStruct(
        completos: castToType<int>(data['completos']),
        incompletos: castToType<int>(data['incompletos']),
        pulados: castToType<int>(data['pulados']),
        descansoMedioSegundos: castToType<int>(data['descansoMedioSegundos']),
        cardiosHoje: castToType<int>(data['cardiosHoje']),
        cardioMinutosHoje: castToType<int>(data['cardioMinutosHoje']),
        totalTreinos: castToType<int>(data['totalTreinos']),
        aderencia: castToType<int>(data['aderencia']),
        descansoPrescritoSegundos: castToType<int>(data['descansoPrescritoSegundos']),
        volumeKg: castToType<int>(data['volumeKg']),
        cardios: castToType<int>(data['cardios']),
        cardioMinutos: castToType<int>(data['cardioMinutos']),
        completosAnterior: castToType<int>(data['completosAnterior']),
        volumeKgAnterior: castToType<int>(data['volumeKgAnterior']),
        cardioMinutosAnterior: castToType<int>(data['cardioMinutosAnterior']),
        descansoMedioAnteriorSegundos: castToType<int>(data['descansoMedioAnteriorSegundos']),
        seriesConcluidas: castToType<int>(data['seriesConcluidas']),
        seriesConcluidasAnterior: castToType<int>(data['seriesConcluidasAnterior']),
        totalTreinosAnterior: castToType<int>(data['totalTreinosAnterior']),
        tempoTreinoMinutos: castToType<int>(data['tempoTreinoMinutos']),
        tempoTreinoMinutosAnterior: castToType<int>(data['tempoTreinoMinutosAnterior']),
        descansosTotal: castToType<int>(data['descansosTotal']),
        descansosNoAlvo: castToType<int>(data['descansosNoAlvo']),
        sequenciaMaxDias: castToType<int>(data['sequenciaMaxDias']),
        sequenciaAtualDias: castToType<int>(data['sequenciaAtualDias']),
      );

  static DsMetricasStruct? maybeFromMap(dynamic data) => data is Map
      ? DsMetricasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'completos': _completos,
        'incompletos': _incompletos,
        'pulados': _pulados,
        'descansoMedioSegundos': _descansoMedioSegundos,
        'cardiosHoje': _cardiosHoje,
        'cardioMinutosHoje': _cardioMinutosHoje,
        'totalTreinos': _totalTreinos,
        'aderencia': _aderencia,
        'descansoPrescritoSegundos': _descansoPrescritoSegundos,
        'volumeKg': _volumeKg,
        'cardios': _cardios,
        'cardioMinutos': _cardioMinutos,
        'completosAnterior': _completosAnterior,
        'volumeKgAnterior': _volumeKgAnterior,
        'cardioMinutosAnterior': _cardioMinutosAnterior,
        'descansoMedioAnteriorSegundos': _descansoMedioAnteriorSegundos,
        'seriesConcluidas': _seriesConcluidas,
        'seriesConcluidasAnterior': _seriesConcluidasAnterior,
        'totalTreinosAnterior': _totalTreinosAnterior,
        'tempoTreinoMinutos': _tempoTreinoMinutos,
        'tempoTreinoMinutosAnterior': _tempoTreinoMinutosAnterior,
        'descansosTotal': _descansosTotal,
        'descansosNoAlvo': _descansosNoAlvo,
        'sequenciaMaxDias': _sequenciaMaxDias,
        'sequenciaAtualDias': _sequenciaAtualDias,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'completos': serializeParam(
          _completos,
          ParamType.int,
        ),
        'incompletos': serializeParam(
          _incompletos,
          ParamType.int,
        ),
        'pulados': serializeParam(
          _pulados,
          ParamType.int,
        ),
        'descansoMedioSegundos': serializeParam(
          _descansoMedioSegundos,
          ParamType.int,
        ),
        'cardiosHoje': serializeParam(
          _cardiosHoje,
          ParamType.int,
        ),
        'cardioMinutosHoje': serializeParam(
          _cardioMinutosHoje,
          ParamType.int,
        ),
        'totalTreinos': serializeParam(
          _totalTreinos,
          ParamType.int,
        ),
        'aderencia': serializeParam(
          _aderencia,
          ParamType.int,
        ),
        'descansoPrescritoSegundos': serializeParam(
          _descansoPrescritoSegundos,
          ParamType.int,
        ),
        'volumeKg': serializeParam(
          _volumeKg,
          ParamType.int,
        ),
        'cardios': serializeParam(
          _cardios,
          ParamType.int,
        ),
        'cardioMinutos': serializeParam(
          _cardioMinutos,
          ParamType.int,
        ),
        'completosAnterior': serializeParam(
          _completosAnterior,
          ParamType.int,
        ),
        'volumeKgAnterior': serializeParam(
          _volumeKgAnterior,
          ParamType.int,
        ),
        'cardioMinutosAnterior': serializeParam(
          _cardioMinutosAnterior,
          ParamType.int,
        ),
        'descansoMedioAnteriorSegundos': serializeParam(
          _descansoMedioAnteriorSegundos,
          ParamType.int,
        ),
        'seriesConcluidas': serializeParam(
          _seriesConcluidas,
          ParamType.int,
        ),
        'seriesConcluidasAnterior': serializeParam(
          _seriesConcluidasAnterior,
          ParamType.int,
        ),
        'totalTreinosAnterior': serializeParam(
          _totalTreinosAnterior,
          ParamType.int,
        ),
        'tempoTreinoMinutos': serializeParam(
          _tempoTreinoMinutos,
          ParamType.int,
        ),
        'tempoTreinoMinutosAnterior': serializeParam(
          _tempoTreinoMinutosAnterior,
          ParamType.int,
        ),
        'descansosTotal': serializeParam(
          _descansosTotal,
          ParamType.int,
        ),
        'descansosNoAlvo': serializeParam(
          _descansosNoAlvo,
          ParamType.int,
        ),
        'sequenciaMaxDias': serializeParam(
          _sequenciaMaxDias,
          ParamType.int,
        ),
        'sequenciaAtualDias': serializeParam(
          _sequenciaAtualDias,
          ParamType.int,
        ),
      }.withoutNulls;

  static DsMetricasStruct fromSerializableMap(Map<String, dynamic> data) =>
      DsMetricasStruct(
        completos: deserializeParam(
          data['completos'],
          ParamType.int,
          false,
        ),
        incompletos: deserializeParam(
          data['incompletos'],
          ParamType.int,
          false,
        ),
        pulados: deserializeParam(
          data['pulados'],
          ParamType.int,
          false,
        ),
        descansoMedioSegundos: deserializeParam(
          data['descansoMedioSegundos'],
          ParamType.int,
          false,
        ),
        cardiosHoje: deserializeParam(
          data['cardiosHoje'],
          ParamType.int,
          false,
        ),
        cardioMinutosHoje: deserializeParam(
          data['cardioMinutosHoje'],
          ParamType.int,
          false,
        ),
        totalTreinos: deserializeParam(
          data['totalTreinos'],
          ParamType.int,
          false,
        ),
        aderencia: deserializeParam(
          data['aderencia'],
          ParamType.int,
          false,
        ),
        descansoPrescritoSegundos: deserializeParam(
          data['descansoPrescritoSegundos'],
          ParamType.int,
          false,
        ),
        volumeKg: deserializeParam(
          data['volumeKg'],
          ParamType.int,
          false,
        ),
        cardios: deserializeParam(
          data['cardios'],
          ParamType.int,
          false,
        ),
        cardioMinutos: deserializeParam(
          data['cardioMinutos'],
          ParamType.int,
          false,
        ),
        completosAnterior: deserializeParam(
          data['completosAnterior'],
          ParamType.int,
          false,
        ),
        volumeKgAnterior: deserializeParam(
          data['volumeKgAnterior'],
          ParamType.int,
          false,
        ),
        cardioMinutosAnterior: deserializeParam(
          data['cardioMinutosAnterior'],
          ParamType.int,
          false,
        ),
        descansoMedioAnteriorSegundos: deserializeParam(
          data['descansoMedioAnteriorSegundos'],
          ParamType.int,
          false,
        ),
        seriesConcluidas: deserializeParam(
          data['seriesConcluidas'],
          ParamType.int,
          false,
        ),
        seriesConcluidasAnterior: deserializeParam(
          data['seriesConcluidasAnterior'],
          ParamType.int,
          false,
        ),
        totalTreinosAnterior: deserializeParam(
          data['totalTreinosAnterior'],
          ParamType.int,
          false,
        ),
        tempoTreinoMinutos: deserializeParam(
          data['tempoTreinoMinutos'],
          ParamType.int,
          false,
        ),
        tempoTreinoMinutosAnterior: deserializeParam(
          data['tempoTreinoMinutosAnterior'],
          ParamType.int,
          false,
        ),
        descansosTotal: deserializeParam(
          data['descansosTotal'],
          ParamType.int,
          false,
        ),
        descansosNoAlvo: deserializeParam(
          data['descansosNoAlvo'],
          ParamType.int,
          false,
        ),
        sequenciaMaxDias: deserializeParam(
          data['sequenciaMaxDias'],
          ParamType.int,
          false,
        ),
        sequenciaAtualDias: deserializeParam(
          data['sequenciaAtualDias'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DsMetricasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DsMetricasStruct &&
        completos == other.completos &&
        incompletos == other.incompletos &&
        pulados == other.pulados &&
        descansoMedioSegundos == other.descansoMedioSegundos &&
        cardiosHoje == other.cardiosHoje &&
        cardioMinutosHoje == other.cardioMinutosHoje &&
        totalTreinos == other.totalTreinos &&
        aderencia == other.aderencia &&
        descansoPrescritoSegundos == other.descansoPrescritoSegundos &&
        volumeKg == other.volumeKg &&
        cardios == other.cardios &&
        cardioMinutos == other.cardioMinutos &&
        completosAnterior == other.completosAnterior &&
        volumeKgAnterior == other.volumeKgAnterior &&
        cardioMinutosAnterior == other.cardioMinutosAnterior &&
        descansoMedioAnteriorSegundos == other.descansoMedioAnteriorSegundos &&
        seriesConcluidas == other.seriesConcluidas &&
        seriesConcluidasAnterior == other.seriesConcluidasAnterior &&
        totalTreinosAnterior == other.totalTreinosAnterior &&
        tempoTreinoMinutos == other.tempoTreinoMinutos &&
        tempoTreinoMinutosAnterior == other.tempoTreinoMinutosAnterior &&
        descansosTotal == other.descansosTotal &&
        descansosNoAlvo == other.descansosNoAlvo &&
        sequenciaMaxDias == other.sequenciaMaxDias &&
        sequenciaAtualDias == other.sequenciaAtualDias;
  }

  @override
  int get hashCode => const ListEquality().hash([
        completos,
        incompletos,
        pulados,
        descansoMedioSegundos,
        cardiosHoje,
        cardioMinutosHoje,
        totalTreinos,
        aderencia,
        descansoPrescritoSegundos,
        volumeKg,
        cardios,
        cardioMinutos,
        completosAnterior,
        volumeKgAnterior,
        cardioMinutosAnterior,
        descansoMedioAnteriorSegundos,
        seriesConcluidas,
        seriesConcluidasAnterior,
        totalTreinosAnterior,
        tempoTreinoMinutos,
        tempoTreinoMinutosAnterior,
        descansosTotal,
        descansosNoAlvo,
        sequenciaMaxDias,
        sequenciaAtualDias
      ]);
}

DsMetricasStruct createDsMetricasStruct({
  int? completos,
  int? incompletos,
  int? pulados,
  int? descansoMedioSegundos,
  int? cardiosHoje,
  int? cardioMinutosHoje,
}) =>
    DsMetricasStruct(
      completos: completos,
      incompletos: incompletos,
      pulados: pulados,
      descansoMedioSegundos: descansoMedioSegundos,
      cardiosHoje: cardiosHoje,
      cardioMinutosHoje: cardioMinutosHoje,
    );

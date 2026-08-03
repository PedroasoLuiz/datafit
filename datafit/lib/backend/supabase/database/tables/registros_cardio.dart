import '../database.dart';

class RegistrosCardioTable extends SupabaseTable<RegistrosCardioRow> {
  @override
  String get tableName => 'RegistrosCardio';

  @override
  RegistrosCardioRow createRow(Map<String, dynamic> data) =>
      RegistrosCardioRow(data);
}

class RegistrosCardioRow extends SupabaseDataRow {
  RegistrosCardioRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegistrosCardioTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get perfisId => getField<String>('PerfisId')!;
  set perfisId(String value) => setField<String>('PerfisId', value);

  int? get treinosExecucaoId => getField<int>('TreinosExecucaoId');
  set treinosExecucaoId(int? value) =>
      setField<int>('TreinosExecucaoId', value);

  String get descricao => getField<String>('Descricao')!;
  set descricao(String value) => setField<String>('Descricao', value);

  int? get duracaoMinutos => getField<int>('DuracaoMinutos');
  set duracaoMinutos(int? value) => setField<int>('DuracaoMinutos', value);

  double? get distanciaKm => getField<double>('DistanciaKm');
  set distanciaKm(double? value) => setField<double>('DistanciaKm', value);

  String? get observacao => getField<String>('Observacao');
  set observacao(String? value) => setField<String>('Observacao', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get dataHoraInicio => getField<DateTime>('DataHoraInicio');
  set dataHoraInicio(DateTime? value) =>
      setField<DateTime>('DataHoraInicio', value);

  DateTime? get dataHoraFim => getField<DateTime>('DataHoraFim');
  set dataHoraFim(DateTime? value) => setField<DateTime>('DataHoraFim', value);
}

import '../database.dart';

class PerimetrosCorporaisTable extends SupabaseTable<PerimetrosCorporaisRow> {
  @override
  String get tableName => 'PerimetrosCorporais';

  @override
  PerimetrosCorporaisRow createRow(Map<String, dynamic> data) =>
      PerimetrosCorporaisRow(data);
}

class PerimetrosCorporaisRow extends SupabaseDataRow {
  PerimetrosCorporaisRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PerimetrosCorporaisTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get perfisId => getField<String>('PerfisId');
  set perfisId(String? value) => setField<String>('PerfisId', value);

  int? get tiposPerimetroId => getField<int>('TiposPerimetroId');
  set tiposPerimetroId(int? value) => setField<int>('TiposPerimetroId', value);

  double? get valorCm => getField<double>('ValorCm');
  set valorCm(double? value) => setField<double>('ValorCm', value);

  DateTime? get dataRegistro => getField<DateTime>('DataRegistro');
  set dataRegistro(DateTime? value) =>
      setField<DateTime>('DataRegistro', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get registradoPorPerfisId =>
      getField<String>('RegistradoPorPerfisId');
  set registradoPorPerfisId(String? value) =>
      setField<String>('RegistradoPorPerfisId', value);
}

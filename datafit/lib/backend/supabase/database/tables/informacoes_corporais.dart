import '../database.dart';

class InformacoesCorporaisTable extends SupabaseTable<InformacoesCorporaisRow> {
  @override
  String get tableName => 'InformacoesCorporais';

  @override
  InformacoesCorporaisRow createRow(Map<String, dynamic> data) =>
      InformacoesCorporaisRow(data);
}

class InformacoesCorporaisRow extends SupabaseDataRow {
  InformacoesCorporaisRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => InformacoesCorporaisTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get perfisId => getField<String>('PerfisId');
  set perfisId(String? value) => setField<String>('PerfisId', value);

  double? get altura => getField<double>('Altura');
  set altura(double? value) => setField<double>('Altura', value);

  double? get peso => getField<double>('Peso');
  set peso(double? value) => setField<double>('Peso', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get dataRegistro => getField<DateTime>('DataRegistro');
  set dataRegistro(DateTime? value) =>
      setField<DateTime>('DataRegistro', value);

  String? get registradoPorPerfisId =>
      getField<String>('RegistradoPorPerfisId');
  set registradoPorPerfisId(String? value) =>
      setField<String>('RegistradoPorPerfisId', value);

  double? get porcentagemGordura => getField<double>('PorcentagemGordura');
  set porcentagemGordura(double? value) =>
      setField<double>('PorcentagemGordura', value);
}

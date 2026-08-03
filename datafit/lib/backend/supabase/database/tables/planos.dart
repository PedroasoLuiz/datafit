import '../database.dart';

class PlanosTable extends SupabaseTable<PlanosRow> {
  @override
  String get tableName => 'Planos';

  @override
  PlanosRow createRow(Map<String, dynamic> data) => PlanosRow(data);
}

class PlanosRow extends SupabaseDataRow {
  PlanosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlanosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get codigo => getField<String>('Codigo')!;
  set codigo(String value) => setField<String>('Codigo', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  double? get valor => getField<double>('Valor');
  set valor(double? value) => setField<double>('Valor', value);

  int? get limiteAlunos => getField<int>('LimiteAlunos');
  set limiteAlunos(int? value) => setField<int>('LimiteAlunos', value);

  double? get percComissao => getField<double>('PercComissao');
  set percComissao(double? value) => setField<double>('PercComissao', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

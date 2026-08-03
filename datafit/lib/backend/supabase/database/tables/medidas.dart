import '../database.dart';

class MedidasTable extends SupabaseTable<MedidasRow> {
  @override
  String get tableName => 'Medidas';

  @override
  MedidasRow createRow(Map<String, dynamic> data) => MedidasRow(data);
}

class MedidasRow extends SupabaseDataRow {
  MedidasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MedidasTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get codigo => getField<String>('Codigo');
  set codigo(String? value) => setField<String>('Codigo', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

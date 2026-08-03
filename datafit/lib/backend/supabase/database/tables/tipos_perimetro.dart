import '../database.dart';

class TiposPerimetroTable extends SupabaseTable<TiposPerimetroRow> {
  @override
  String get tableName => 'TiposPerimetro';

  @override
  TiposPerimetroRow createRow(Map<String, dynamic> data) =>
      TiposPerimetroRow(data);
}

class TiposPerimetroRow extends SupabaseDataRow {
  TiposPerimetroRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TiposPerimetroTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get descricao => getField<String>('Descricao')!;
  set descricao(String value) => setField<String>('Descricao', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

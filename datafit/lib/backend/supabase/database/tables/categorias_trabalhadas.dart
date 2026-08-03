import '../database.dart';

class CategoriasTrabalhadasTable
    extends SupabaseTable<CategoriasTrabalhadasRow> {
  @override
  String get tableName => 'CategoriasTrabalhadas';

  @override
  CategoriasTrabalhadasRow createRow(Map<String, dynamic> data) =>
      CategoriasTrabalhadasRow(data);
}

class CategoriasTrabalhadasRow extends SupabaseDataRow {
  CategoriasTrabalhadasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CategoriasTrabalhadasTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

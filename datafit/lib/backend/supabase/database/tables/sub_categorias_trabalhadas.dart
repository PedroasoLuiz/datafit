import '../database.dart';

class SubCategoriasTrabalhadasTable
    extends SupabaseTable<SubCategoriasTrabalhadasRow> {
  @override
  String get tableName => 'SubCategoriasTrabalhadas';

  @override
  SubCategoriasTrabalhadasRow createRow(Map<String, dynamic> data) =>
      SubCategoriasTrabalhadasRow(data);
}

class SubCategoriasTrabalhadasRow extends SupabaseDataRow {
  SubCategoriasTrabalhadasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubCategoriasTrabalhadasTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  int? get categoriasTrabalhadasId => getField<int>('CategoriasTrabalhadasId');
  set categoriasTrabalhadasId(int? value) =>
      setField<int>('CategoriasTrabalhadasId', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

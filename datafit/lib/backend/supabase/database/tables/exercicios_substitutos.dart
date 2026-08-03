import '../database.dart';

class ExerciciosSubstitutosTable
    extends SupabaseTable<ExerciciosSubstitutosRow> {
  @override
  String get tableName => 'ExerciciosSubstitutos';

  @override
  ExerciciosSubstitutosRow createRow(Map<String, dynamic> data) =>
      ExerciciosSubstitutosRow(data);
}

class ExerciciosSubstitutosRow extends SupabaseDataRow {
  ExerciciosSubstitutosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ExerciciosSubstitutosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  int? get exerciciosId => getField<int>('ExerciciosId');
  set exerciciosId(int? value) => setField<int>('ExerciciosId', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);
}

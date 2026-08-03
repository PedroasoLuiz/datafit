import '../database.dart';

class ExerciciosConclusaoTreinosConclusaoTable
    extends SupabaseTable<ExerciciosConclusaoTreinosConclusaoRow> {
  @override
  String get tableName => 'ExerciciosConclusaoTreinosConclusao';

  @override
  ExerciciosConclusaoTreinosConclusaoRow createRow(Map<String, dynamic> data) =>
      ExerciciosConclusaoTreinosConclusaoRow(data);
}

class ExerciciosConclusaoTreinosConclusaoRow extends SupabaseDataRow {
  ExerciciosConclusaoTreinosConclusaoRow(Map<String, dynamic> data)
      : super(data);

  @override
  SupabaseTable get table => ExerciciosConclusaoTreinosConclusaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get exerciciosConclusaoId => getField<int>('ExerciciosConclusaoId');
  set exerciciosConclusaoId(int? value) =>
      setField<int>('ExerciciosConclusaoId', value);

  int? get treinosConclusaoId => getField<int>('TreinosConclusaoId');
  set treinosConclusaoId(int? value) =>
      setField<int>('TreinosConclusaoId', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

import '../database.dart';

class ExerciciosExecucaoTreinosExecucaoTable
    extends SupabaseTable<ExerciciosExecucaoTreinosExecucaoRow> {
  @override
  String get tableName => 'ExerciciosExecucaoTreinosExecucao';

  @override
  ExerciciosExecucaoTreinosExecucaoRow createRow(Map<String, dynamic> data) =>
      ExerciciosExecucaoTreinosExecucaoRow(data);
}

class ExerciciosExecucaoTreinosExecucaoRow extends SupabaseDataRow {
  ExerciciosExecucaoTreinosExecucaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ExerciciosExecucaoTreinosExecucaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get exerciciosExecucaoId => getField<int>('ExerciciosExecucaoId');
  set exerciciosExecucaoId(int? value) =>
      setField<int>('ExerciciosExecucaoId', value);

  int? get treinosExecucaoId => getField<int>('TreinosExecucaoId');
  set treinosExecucaoId(int? value) =>
      setField<int>('TreinosExecucaoId', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

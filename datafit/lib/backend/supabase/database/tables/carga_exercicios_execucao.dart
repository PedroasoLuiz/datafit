import '../database.dart';

class CargaExerciciosExecucaoTable
    extends SupabaseTable<CargaExerciciosExecucaoRow> {
  @override
  String get tableName => 'CargaExerciciosExecucao';

  @override
  CargaExerciciosExecucaoRow createRow(Map<String, dynamic> data) =>
      CargaExerciciosExecucaoRow(data);
}

class CargaExerciciosExecucaoRow extends SupabaseDataRow {
  CargaExerciciosExecucaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CargaExerciciosExecucaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get exerciciosExecucaoId => getField<int>('ExerciciosExecucaoId');
  set exerciciosExecucaoId(int? value) =>
      setField<int>('ExerciciosExecucaoId', value);

  double? get quantidade => getField<double>('Quantidade');
  set quantidade(double? value) => setField<double>('Quantidade', value);

  int? get medidasId => getField<int>('MedidasId');
  set medidasId(int? value) => setField<int>('MedidasId', value);

  double? get peso => getField<double>('Peso');
  set peso(double? value) => setField<double>('Peso', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

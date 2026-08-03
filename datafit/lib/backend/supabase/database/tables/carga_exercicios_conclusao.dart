import '../database.dart';

class CargaExerciciosConclusaoTable
    extends SupabaseTable<CargaExerciciosConclusaoRow> {
  @override
  String get tableName => 'CargaExerciciosConclusao';

  @override
  CargaExerciciosConclusaoRow createRow(Map<String, dynamic> data) =>
      CargaExerciciosConclusaoRow(data);
}

class CargaExerciciosConclusaoRow extends SupabaseDataRow {
  CargaExerciciosConclusaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CargaExerciciosConclusaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get exerciciosConclusaoId => getField<int>('ExerciciosConclusaoId');
  set exerciciosConclusaoId(int? value) =>
      setField<int>('ExerciciosConclusaoId', value);

  double? get quantidade => getField<double>('Quantidade');
  set quantidade(double? value) => setField<double>('Quantidade', value);

  int? get medidasId => getField<int>('MedidasId');
  set medidasId(int? value) => setField<int>('MedidasId', value);

  double? get peso => getField<double>('Peso');
  set peso(double? value) => setField<double>('Peso', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

import '../database.dart';

class RegistrosDescansoTable extends SupabaseTable<RegistrosDescansoRow> {
  @override
  String get tableName => 'RegistrosDescanso';

  @override
  RegistrosDescansoRow createRow(Map<String, dynamic> data) =>
      RegistrosDescansoRow(data);
}

class RegistrosDescansoRow extends SupabaseDataRow {
  RegistrosDescansoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegistrosDescansoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get perfisId => getField<String>('PerfisId')!;
  set perfisId(String value) => setField<String>('PerfisId', value);

  int? get treinosExecucaoId => getField<int>('TreinosExecucaoId');
  set treinosExecucaoId(int? value) =>
      setField<int>('TreinosExecucaoId', value);

  int? get exerciciosExecucaoId => getField<int>('ExerciciosExecucaoId');
  set exerciciosExecucaoId(int? value) =>
      setField<int>('ExerciciosExecucaoId', value);

  int get duracaoSegundos => getField<int>('DuracaoSegundos')!;
  set duracaoSegundos(int value) => setField<int>('DuracaoSegundos', value);

  bool? get isDeleted => getField<bool>('IsDeleted');
  set isDeleted(bool? value) => setField<bool>('IsDeleted', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

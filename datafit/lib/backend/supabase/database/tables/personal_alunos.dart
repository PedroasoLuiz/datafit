import '../database.dart';

class PersonalAlunosTable extends SupabaseTable<PersonalAlunosRow> {
  @override
  String get tableName => 'PersonalAlunos';

  @override
  PersonalAlunosRow createRow(Map<String, dynamic> data) =>
      PersonalAlunosRow(data);
}

class PersonalAlunosRow extends SupabaseDataRow {
  PersonalAlunosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PersonalAlunosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get personalPerfisId => getField<String>('PersonalPerfisId')!;
  set personalPerfisId(String value) =>
      setField<String>('PersonalPerfisId', value);

  String get alunoPerfisId => getField<String>('AlunoPerfisId')!;
  set alunoPerfisId(String value) => setField<String>('AlunoPerfisId', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get dataVinculo => getField<DateTime>('DataVinculo');
  set dataVinculo(DateTime? value) => setField<DateTime>('DataVinculo', value);

  DateTime? get dataDesvinculo => getField<DateTime>('DataDesvinculo');
  set dataDesvinculo(DateTime? value) =>
      setField<DateTime>('DataDesvinculo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get statusCobranca => getField<String>('StatusCobranca');
  set statusCobranca(String? value) =>
      setField<String>('StatusCobranca', value);
}

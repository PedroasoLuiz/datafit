import '../database.dart';

class MetasTable extends SupabaseTable<MetasRow> {
  @override
  String get tableName => 'Metas';

  @override
  MetasRow createRow(Map<String, dynamic> data) => MetasRow(data);
}

class MetasRow extends SupabaseDataRow {
  MetasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MetasTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get titulo => getField<String>('Titulo');
  set titulo(String? value) => setField<String>('Titulo', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  int? get progresso => getField<int>('Progresso');
  set progresso(int? value) => setField<int>('Progresso', value);

  String? get solicitantePerfisId => getField<String>('SolicitantePerfisId');
  set solicitantePerfisId(String? value) =>
      setField<String>('SolicitantePerfisId', value);

  String? get executorPerfisId => getField<String>('ExecutorPerfisId');
  set executorPerfisId(String? value) =>
      setField<String>('ExecutorPerfisId', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get urlImg => getField<String>('UrlImg');
  set urlImg(String? value) => setField<String>('UrlImg', value);
}

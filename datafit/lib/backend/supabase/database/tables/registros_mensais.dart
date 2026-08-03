import '../database.dart';

class RegistrosMensaisTable extends SupabaseTable<RegistrosMensaisRow> {
  @override
  String get tableName => 'RegistrosMensais';

  @override
  RegistrosMensaisRow createRow(Map<String, dynamic> data) =>
      RegistrosMensaisRow(data);
}

class RegistrosMensaisRow extends SupabaseDataRow {
  RegistrosMensaisRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegistrosMensaisTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get perfisId => getField<String>('PerfisId')!;
  set perfisId(String value) => setField<String>('PerfisId', value);

  String get urlImg => getField<String>('UrlImg')!;
  set urlImg(String value) => setField<String>('UrlImg', value);

  DateTime get mesAno => getField<DateTime>('MesAno')!;
  set mesAno(DateTime value) => setField<DateTime>('MesAno', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

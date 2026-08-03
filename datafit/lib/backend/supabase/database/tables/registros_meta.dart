import '../database.dart';

class RegistrosMetaTable extends SupabaseTable<RegistrosMetaRow> {
  @override
  String get tableName => 'RegistrosMeta';

  @override
  RegistrosMetaRow createRow(Map<String, dynamic> data) =>
      RegistrosMetaRow(data);
}

class RegistrosMetaRow extends SupabaseDataRow {
  RegistrosMetaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegistrosMetaTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get metasId => getField<int>('MetasId');
  set metasId(int? value) => setField<int>('MetasId', value);

  String? get urlImg => getField<String>('UrlImg');
  set urlImg(String? value) => setField<String>('UrlImg', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

import '../database.dart';

class TelefonesTable extends SupabaseTable<TelefonesRow> {
  @override
  String get tableName => 'Telefones';

  @override
  TelefonesRow createRow(Map<String, dynamic> data) => TelefonesRow(data);
}

class TelefonesRow extends SupabaseDataRow {
  TelefonesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TelefonesTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get numero => getField<String>('Numero');
  set numero(String? value) => setField<String>('Numero', value);

  bool? get isWhatsApp => getField<bool>('IsWhatsApp');
  set isWhatsApp(bool? value) => setField<bool>('IsWhatsApp', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String get perfisId => getField<String>('PerfisId')!;
  set perfisId(String value) => setField<String>('PerfisId', value);
}

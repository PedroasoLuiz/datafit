import '../database.dart';

class NotificacoesTable extends SupabaseTable<NotificacoesRow> {
  @override
  String get tableName => 'Notificacoes';

  @override
  NotificacoesRow createRow(Map<String, dynamic> data) => NotificacoesRow(data);
}

class NotificacoesRow extends SupabaseDataRow {
  NotificacoesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NotificacoesTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get destinatarioPerfisId => getField<String>('DestinatarioPerfisId')!;
  set destinatarioPerfisId(String value) =>
      setField<String>('DestinatarioPerfisId', value);

  String? get remetentePerfisId => getField<String>('RemetentePerfisId');
  set remetentePerfisId(String? value) =>
      setField<String>('RemetentePerfisId', value);

  String get titulo => getField<String>('Titulo')!;
  set titulo(String value) => setField<String>('Titulo', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  String? get tag => getField<String>('Tag');
  set tag(String? value) => setField<String>('Tag', value);

  bool? get lida => getField<bool>('Lida');
  set lida(bool? value) => setField<bool>('Lida', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

import '../database.dart';

class GruposTreinoTable extends SupabaseTable<GruposTreinoRow> {
  @override
  String get tableName => 'GruposTreino';

  @override
  GruposTreinoRow createRow(Map<String, dynamic> data) => GruposTreinoRow(data);
}

class GruposTreinoRow extends SupabaseDataRow {
  GruposTreinoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GruposTreinoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get descricao => getField<String>('Descricao')!;
  set descricao(String value) => setField<String>('Descricao', value);

  String get criadorPerfisId => getField<String>('CriadorPerfisId')!;
  set criadorPerfisId(String value) =>
      setField<String>('CriadorPerfisId', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

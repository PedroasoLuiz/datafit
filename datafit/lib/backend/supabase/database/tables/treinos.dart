import '../database.dart';

class TreinosTable extends SupabaseTable<TreinosRow> {
  @override
  String get tableName => 'Treinos';

  @override
  TreinosRow createRow(Map<String, dynamic> data) => TreinosRow(data);
}

class TreinosRow extends SupabaseDataRow {
  TreinosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TreinosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  int? get niveisTreinoId => getField<int>('NiveisTreinoId');
  set niveisTreinoId(int? value) => setField<int>('NiveisTreinoId', value);

  int? get categoriasTrabalhadasId => getField<int>('CategoriasTrabalhadasId');
  set categoriasTrabalhadasId(int? value) =>
      setField<int>('CategoriasTrabalhadasId', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  bool? get isDeleted => getField<bool>('IsDeleted');
  set isDeleted(bool? value) => setField<bool>('IsDeleted', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get criadorPerfisId => getField<String>('CriadorPerfisId');
  set criadorPerfisId(String? value) =>
      setField<String>('CriadorPerfisId', value);

  int? get gruposTreinoId => getField<int>('GruposTreinoId');
  set gruposTreinoId(int? value) => setField<int>('GruposTreinoId', value);
}

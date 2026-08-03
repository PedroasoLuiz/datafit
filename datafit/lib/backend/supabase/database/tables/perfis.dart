import '../database.dart';

class PerfisTable extends SupabaseTable<PerfisRow> {
  @override
  String get tableName => 'Perfis';

  @override
  PerfisRow createRow(Map<String, dynamic> data) => PerfisRow(data);
}

class PerfisRow extends SupabaseDataRow {
  PerfisRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PerfisTable();

  String? get nome => getField<String>('Nome');
  set nome(String? value) => setField<String>('Nome', value);

  String? get nickName => getField<String>('NickName');
  set nickName(String? value) => setField<String>('NickName', value);

  DateTime? get dataNascimento => getField<DateTime>('DataNascimento');
  set dataNascimento(DateTime? value) =>
      setField<DateTime>('DataNascimento', value);

  int? get tiposPerfilId => getField<int>('TiposPerfilId');
  set tiposPerfilId(int? value) => setField<int>('TiposPerfilId', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  bool? get isDeleted => getField<bool>('IsDeleted');
  set isDeleted(bool? value) => setField<bool>('IsDeleted', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String get idUser => getField<String>('idUser')!;
  set idUser(String value) => setField<String>('idUser', value);

  String? get urlImgPerfil => getField<String>('UrlImgPerfil');
  set urlImgPerfil(String? value) => setField<String>('UrlImgPerfil', value);

  String? get cpf => getField<String>('Cpf');
  set cpf(String? value) => setField<String>('Cpf', value);

  String? get bio => getField<String>('Bio');
  set bio(String? value) => setField<String>('Bio', value);

  String? get cref => getField<String>('Cref');
  set cref(String? value) => setField<String>('Cref', value);

  String? get unidade => getField<String>('Unidade');
  set unidade(String? value) => setField<String>('Unidade', value);
}

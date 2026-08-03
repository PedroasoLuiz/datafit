import '../database.dart';

class ExerciciosTable extends SupabaseTable<ExerciciosRow> {
  @override
  String get tableName => 'Exercicios';

  @override
  ExerciciosRow createRow(Map<String, dynamic> data) => ExerciciosRow(data);
}

class ExerciciosRow extends SupabaseDataRow {
  ExerciciosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ExerciciosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String? get descricao => getField<String>('Descricao');
  set descricao(String? value) => setField<String>('Descricao', value);

  int? get subCategoriasTrabalhadasId =>
      getField<int>('SubCategoriasTrabalhadasId');
  set subCategoriasTrabalhadasId(int? value) =>
      setField<int>('SubCategoriasTrabalhadasId', value);

  String? get linkInstrucao => getField<String>('LinkInstrucao');
  set linkInstrucao(String? value) => setField<String>('LinkInstrucao', value);

  String? get observacoes => getField<String>('Observacoes');
  set observacoes(String? value) => setField<String>('Observacoes', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  bool? get isDeleted => getField<bool>('IsDeleted');
  set isDeleted(bool? value) => setField<bool>('IsDeleted', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get criadorPerfisId => getField<String>('CriadorPerfisId');
  set criadorPerfisId(String? value) =>
      setField<String>('CriadorPerfisId', value);
}

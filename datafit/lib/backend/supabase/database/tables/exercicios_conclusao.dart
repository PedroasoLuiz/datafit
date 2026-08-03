import '../database.dart';

class ExerciciosConclusaoTable extends SupabaseTable<ExerciciosConclusaoRow> {
  @override
  String get tableName => 'ExerciciosConclusao';

  @override
  ExerciciosConclusaoRow createRow(Map<String, dynamic> data) =>
      ExerciciosConclusaoRow(data);
}

class ExerciciosConclusaoRow extends SupabaseDataRow {
  ExerciciosConclusaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ExerciciosConclusaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get exerciciosExecucaoId => getField<int>('ExerciciosExecucaoId');
  set exerciciosExecucaoId(int? value) =>
      setField<int>('ExerciciosExecucaoId', value);

  int? get serieAquecimento => getField<int>('SerieAquecimento');
  set serieAquecimento(int? value) => setField<int>('SerieAquecimento', value);

  int? get repeticaoAquecimento => getField<int>('RepeticaoAquecimento');
  set repeticaoAquecimento(int? value) =>
      setField<int>('RepeticaoAquecimento', value);

  int? get serieExecucao => getField<int>('SerieExecucao');
  set serieExecucao(int? value) => setField<int>('SerieExecucao', value);

  int? get repeticaoExecucao => getField<int>('RepeticaoExecucao');
  set repeticaoExecucao(int? value) =>
      setField<int>('RepeticaoExecucao', value);

  bool? get isConcluido => getField<bool>('IsConcluido');
  set isConcluido(bool? value) => setField<bool>('IsConcluido', value);

  bool? get isPulado => getField<bool>('IsPulado');
  set isPulado(bool? value) => setField<bool>('IsPulado', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

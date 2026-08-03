import '../database.dart';

class ExerciciosExecucaoTable extends SupabaseTable<ExerciciosExecucaoRow> {
  @override
  String get tableName => 'ExerciciosExecucao';

  @override
  ExerciciosExecucaoRow createRow(Map<String, dynamic> data) =>
      ExerciciosExecucaoRow(data);
}

class ExerciciosExecucaoRow extends SupabaseDataRow {
  ExerciciosExecucaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ExerciciosExecucaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get exerciciosId => getField<int>('ExerciciosId');
  set exerciciosId(int? value) => setField<int>('ExerciciosId', value);

  String? get observacao => getField<String>('Observacao');
  set observacao(String? value) => setField<String>('Observacao', value);

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

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  bool? get isDeleted => getField<bool>('IsDeleted');
  set isDeleted(bool? value) => setField<bool>('IsDeleted', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get solicitantePerfisId => getField<String>('SolicitantePerfisId');
  set solicitantePerfisId(String? value) =>
      setField<String>('SolicitantePerfisId', value);

  int? get tempoDescansoSegundos => getField<int>('TempoDescansoSegundos');
  set tempoDescansoSegundos(int? value) =>
      setField<int>('TempoDescansoSegundos', value);

  int? get ordem => getField<int>('Ordem');
  set ordem(int? value) => setField<int>('Ordem', value);

  bool? get isPulado => getField<bool>('IsPulado');
  set isPulado(bool? value) => setField<bool>('IsPulado', value);
}

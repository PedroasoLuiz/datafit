import '../database.dart';

class ExerciciosTreinosTable extends SupabaseTable<ExerciciosTreinosRow> {
  @override
  String get tableName => 'ExerciciosTreinos';

  @override
  ExerciciosTreinosRow createRow(Map<String, dynamic> data) =>
      ExerciciosTreinosRow(data);
}

class ExerciciosTreinosRow extends SupabaseDataRow {
  ExerciciosTreinosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ExerciciosTreinosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get exerciciosId => getField<int>('ExerciciosId');
  set exerciciosId(int? value) => setField<int>('ExerciciosId', value);

  int? get treinosId => getField<int>('TreinosId');
  set treinosId(int? value) => setField<int>('TreinosId', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get serieExecucao => getField<int>('SerieExecucao');
  set serieExecucao(int? value) => setField<int>('SerieExecucao', value);

  int? get repeticaoExecucao => getField<int>('RepeticaoExecucao');
  set repeticaoExecucao(int? value) =>
      setField<int>('RepeticaoExecucao', value);

  int? get serieAquecimento => getField<int>('SerieAquecimento');
  set serieAquecimento(int? value) => setField<int>('SerieAquecimento', value);

  int? get repeticaoAquecimento => getField<int>('RepeticaoAquecimento');
  set repeticaoAquecimento(int? value) =>
      setField<int>('RepeticaoAquecimento', value);

  int? get tempoDescansoSegundos => getField<int>('TempoDescansoSegundos');
  set tempoDescansoSegundos(int? value) =>
      setField<int>('TempoDescansoSegundos', value);

  String? get observacao => getField<String>('Observacao');
  set observacao(String? value) => setField<String>('Observacao', value);

  int? get ordem => getField<int>('Ordem');
  set ordem(int? value) => setField<int>('Ordem', value);
}

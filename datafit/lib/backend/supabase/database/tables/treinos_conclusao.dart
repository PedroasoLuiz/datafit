import '../database.dart';

class TreinosConclusaoTable extends SupabaseTable<TreinosConclusaoRow> {
  @override
  String get tableName => 'TreinosConclusao';

  @override
  TreinosConclusaoRow createRow(Map<String, dynamic> data) =>
      TreinosConclusaoRow(data);
}

class TreinosConclusaoRow extends SupabaseDataRow {
  TreinosConclusaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TreinosConclusaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get treinosExecucaoId => getField<int>('TreinosExecucaoId');
  set treinosExecucaoId(int? value) =>
      setField<int>('TreinosExecucaoId', value);

  DateTime? get dataHoraInicio => getField<DateTime>('DataHoraInicio');
  set dataHoraInicio(DateTime? value) =>
      setField<DateTime>('DataHoraInicio', value);

  DateTime? get dataHoraConclusao => getField<DateTime>('DataHoraConclusao');
  set dataHoraConclusao(DateTime? value) =>
      setField<DateTime>('DataHoraConclusao', value);

  bool? get isTreinoConcluido => getField<bool>('IsTreinoConcluido');
  set isTreinoConcluido(bool? value) =>
      setField<bool>('IsTreinoConcluido', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get feedback => getField<String>('Feedback');
  set feedback(String? value) => setField<String>('Feedback', value);
}

import '../database.dart';

class TreinosExecucaoTable extends SupabaseTable<TreinosExecucaoRow> {
  @override
  String get tableName => 'TreinosExecucao';

  @override
  TreinosExecucaoRow createRow(Map<String, dynamic> data) =>
      TreinosExecucaoRow(data);
}

class TreinosExecucaoRow extends SupabaseDataRow {
  TreinosExecucaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TreinosExecucaoTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int? get treinosId => getField<int>('TreinosId');
  set treinosId(int? value) => setField<int>('TreinosId', value);

  DateTime? get dataHoraInicio => getField<DateTime>('DataHoraInicio');
  set dataHoraInicio(DateTime? value) =>
      setField<DateTime>('DataHoraInicio', value);

  DateTime? get dataHoraConclusao => getField<DateTime>('DataHoraConclusao');
  set dataHoraConclusao(DateTime? value) =>
      setField<DateTime>('DataHoraConclusao', value);

  DateTime? get dataValidade => getField<DateTime>('DataValidade');
  set dataValidade(DateTime? value) =>
      setField<DateTime>('DataValidade', value);

  bool? get ativo => getField<bool>('Ativo');
  set ativo(bool? value) => setField<bool>('Ativo', value);

  bool? get isDeleted => getField<bool>('IsDeleted');
  set isDeleted(bool? value) => setField<bool>('IsDeleted', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get solicitantePerfisId => getField<String>('SolicitantePerfisId');
  set solicitantePerfisId(String? value) =>
      setField<String>('SolicitantePerfisId', value);

  String? get executorPerfisId => getField<String>('ExecutorPerfisId');
  set executorPerfisId(String? value) =>
      setField<String>('ExecutorPerfisId', value);

  int? get diaSemana => getField<int>('DiaSemana');
  set diaSemana(int? value) => setField<int>('DiaSemana', value);

  int? get treinoTemplateId => getField<int>('TreinoTemplateId');
  set treinoTemplateId(int? value) => setField<int>('TreinoTemplateId', value);

  int? get gruposTreinoExecucaoId => getField<int>('GruposTreinoExecucaoId');
  set gruposTreinoExecucaoId(int? value) =>
      setField<int>('GruposTreinoExecucaoId', value);

  int? get ordem => getField<int>('Ordem');
  set ordem(int? value) => setField<int>('Ordem', value);

  int? get cicloNumero => getField<int>('CicloNumero');
  set cicloNumero(int? value) => setField<int>('CicloNumero', value);

  String? get status => getField<String>('Status');
  set status(String? value) => setField<String>('Status', value);
}

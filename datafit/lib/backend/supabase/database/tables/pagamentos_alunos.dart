import '../database.dart';

class PagamentosAlunosTable extends SupabaseTable<PagamentosAlunosRow> {
  @override
  String get tableName => 'PagamentosAlunos';

  @override
  PagamentosAlunosRow createRow(Map<String, dynamic> data) =>
      PagamentosAlunosRow(data);
}

class PagamentosAlunosRow extends SupabaseDataRow {
  PagamentosAlunosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PagamentosAlunosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int get personalAlunosId => getField<int>('PersonalAlunosId')!;
  set personalAlunosId(int value) => setField<int>('PersonalAlunosId', value);

  String get descricao => getField<String>('Descricao')!;
  set descricao(String value) => setField<String>('Descricao', value);

  double get valor => getField<double>('Valor')!;
  set valor(double value) => setField<double>('Valor', value);

  String get tipoPagamento => getField<String>('TipoPagamento')!;
  set tipoPagamento(String value) => setField<String>('TipoPagamento', value);

  DateTime get dataVencimento => getField<DateTime>('DataVencimento')!;
  set dataVencimento(DateTime value) =>
      setField<DateTime>('DataVencimento', value);

  DateTime? get dataPagamento => getField<DateTime>('DataPagamento');
  set dataPagamento(DateTime? value) =>
      setField<DateTime>('DataPagamento', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

import '../database.dart';

class PagamentosTable extends SupabaseTable<PagamentosRow> {
  @override
  String get tableName => 'Pagamentos';

  @override
  PagamentosRow createRow(Map<String, dynamic> data) => PagamentosRow(data);
}

class PagamentosRow extends SupabaseDataRow {
  PagamentosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PagamentosTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  int get assinaturasId => getField<int>('AssinaturasId')!;
  set assinaturasId(int value) => setField<int>('AssinaturasId', value);

  double get valor => getField<double>('Valor')!;
  set valor(double value) => setField<double>('Valor', value);

  String? get status => getField<String>('Status');
  set status(String? value) => setField<String>('Status', value);

  DateTime? get dataPagamento => getField<DateTime>('DataPagamento');
  set dataPagamento(DateTime? value) =>
      setField<DateTime>('DataPagamento', value);

  String? get gatewayPagamentoId => getField<String>('GatewayPagamentoId');
  set gatewayPagamentoId(String? value) =>
      setField<String>('GatewayPagamentoId', value);

  String? get metodoPagamento => getField<String>('MetodoPagamento');
  set metodoPagamento(String? value) =>
      setField<String>('MetodoPagamento', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

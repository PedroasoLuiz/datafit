import '../database.dart';

class AssinaturasTable extends SupabaseTable<AssinaturasRow> {
  @override
  String get tableName => 'Assinaturas';

  @override
  AssinaturasRow createRow(Map<String, dynamic> data) => AssinaturasRow(data);
}

class AssinaturasRow extends SupabaseDataRow {
  AssinaturasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AssinaturasTable();

  int get id => getField<int>('Id')!;
  set id(int value) => setField<int>('Id', value);

  String get perfisId => getField<String>('PerfisId')!;
  set perfisId(String value) => setField<String>('PerfisId', value);

  int get planosId => getField<int>('PlanosId')!;
  set planosId(int value) => setField<int>('PlanosId', value);

  String? get status => getField<String>('Status');
  set status(String? value) => setField<String>('Status', value);

  DateTime? get dataInicio => getField<DateTime>('DataInicio');
  set dataInicio(DateTime? value) => setField<DateTime>('DataInicio', value);

  DateTime? get dataVencimento => getField<DateTime>('DataVencimento');
  set dataVencimento(DateTime? value) =>
      setField<DateTime>('DataVencimento', value);

  DateTime? get dataCancelamento => getField<DateTime>('DataCancelamento');
  set dataCancelamento(DateTime? value) =>
      setField<DateTime>('DataCancelamento', value);

  String? get indicadoPorPerfisId => getField<String>('IndicadoPorPerfisId');
  set indicadoPorPerfisId(String? value) =>
      setField<String>('IndicadoPorPerfisId', value);

  String? get gatewaySubscriptionId =>
      getField<String>('GatewaySubscriptionId');
  set gatewaySubscriptionId(String? value) =>
      setField<String>('GatewaySubscriptionId', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

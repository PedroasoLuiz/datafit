// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PagamentosStruct extends BaseStruct {
  PagamentosStruct({
    int? id,
    String? descricao,
    double? valor,
    String? tipoPagamento,
    String? status,
    String? dataVencimento,
    String? dataPagamento,
    String? dataPagamentoAluno,
  })  : _id = id,
        _descricao = descricao,
        _valor = valor,
        _tipoPagamento = tipoPagamento,
        _status = status,
        _dataVencimento = dataVencimento,
        _dataPagamento = dataPagamento,
        _dataPagamentoAluno = dataPagamentoAluno;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "tipoPagamento" field.
  String? _tipoPagamento;
  String get tipoPagamento => _tipoPagamento ?? '';
  set tipoPagamento(String? val) => _tipoPagamento = val;

  bool hasTipoPagamento() => _tipoPagamento != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "dataVencimento" field.
  String? _dataVencimento;
  String get dataVencimento => _dataVencimento ?? '';
  set dataVencimento(String? val) => _dataVencimento = val;

  bool hasDataVencimento() => _dataVencimento != null;

  // "dataPagamento" field.
  String? _dataPagamento;
  String get dataPagamento => _dataPagamento ?? '';
  set dataPagamento(String? val) => _dataPagamento = val;

  bool hasDataPagamento() => _dataPagamento != null;

  // "dataPagamentoAluno" field.
  String? _dataPagamentoAluno;
  String get dataPagamentoAluno => _dataPagamentoAluno ?? '';
  set dataPagamentoAluno(String? val) => _dataPagamentoAluno = val;

  bool hasDataPagamentoAluno() => _dataPagamentoAluno != null;

  static PagamentosStruct fromMap(Map<String, dynamic> data) =>
      PagamentosStruct(
        id: castToType<int>(data['id']),
        descricao: data['descricao'] as String?,
        valor: castToType<double>(data['valor']),
        tipoPagamento: data['tipoPagamento'] as String?,
        status: data['status'] as String?,
        dataVencimento: data['dataVencimento'] as String?,
        dataPagamento: data['dataPagamento'] as String?,
        dataPagamentoAluno: data['dataPagamentoAluno'] as String?,
      );

  static PagamentosStruct? maybeFromMap(dynamic data) => data is Map
      ? PagamentosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'descricao': _descricao,
        'valor': _valor,
        'tipoPagamento': _tipoPagamento,
        'status': _status,
        'dataVencimento': _dataVencimento,
        'dataPagamento': _dataPagamento,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'tipoPagamento': serializeParam(
          _tipoPagamento,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'dataVencimento': serializeParam(
          _dataVencimento,
          ParamType.String,
        ),
        'dataPagamento': serializeParam(
          _dataPagamento,
          ParamType.String,
        ),
      }.withoutNulls;

  static PagamentosStruct fromSerializableMap(Map<String, dynamic> data) =>
      PagamentosStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        tipoPagamento: deserializeParam(
          data['tipoPagamento'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        dataVencimento: deserializeParam(
          data['dataVencimento'],
          ParamType.String,
          false,
        ),
        dataPagamento: deserializeParam(
          data['dataPagamento'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PagamentosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PagamentosStruct &&
        id == other.id &&
        descricao == other.descricao &&
        valor == other.valor &&
        tipoPagamento == other.tipoPagamento &&
        status == other.status &&
        dataVencimento == other.dataVencimento &&
        dataPagamento == other.dataPagamento;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        descricao,
        valor,
        tipoPagamento,
        status,
        dataVencimento,
        dataPagamento
      ]);
}

PagamentosStruct createPagamentosStruct({
  int? id,
  String? descricao,
  double? valor,
  String? tipoPagamento,
  String? status,
  String? dataVencimento,
  String? dataPagamento,
}) =>
    PagamentosStruct(
      id: id,
      descricao: descricao,
      valor: valor,
      tipoPagamento: tipoPagamento,
      status: status,
      dataVencimento: dataVencimento,
      dataPagamento: dataPagamento,
    );

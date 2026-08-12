// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PersonalpagamentosStruct extends BaseStruct {
  PersonalpagamentosStruct({
    int? id,
    String? descricao,
    String? nome,
    String? tipoPagamento,
    double? valor,
    String? status,
    String? dataVencimento,
    String? dataPagamento,
    String? createdAt,
    String? alunoUuid,
    bool? alunoAtivo,
  })  : _id = id,
        _descricao = descricao,
        _nome = nome,
        _tipoPagamento = tipoPagamento,
        _valor = valor,
        _status = status,
        _dataVencimento = dataVencimento,
        _dataPagamento = dataPagamento,
        _createdAt = createdAt,
        _alunoUuid = alunoUuid,
        _alunoAtivo = alunoAtivo;

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

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "tipoPagamento" field.
  String? _tipoPagamento;
  String get tipoPagamento => _tipoPagamento ?? '';
  set tipoPagamento(String? val) => _tipoPagamento = val;

  bool hasTipoPagamento() => _tipoPagamento != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

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

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "alunoUuid" field.
  String? _alunoUuid;
  String get alunoUuid => _alunoUuid ?? '';
  set alunoUuid(String? val) => _alunoUuid = val;

  bool hasAlunoUuid() => _alunoUuid != null;

  // "alunoAtivo" field.
  bool? _alunoAtivo;
  bool get alunoAtivo => _alunoAtivo ?? true;
  set alunoAtivo(bool? val) => _alunoAtivo = val;

  bool hasAlunoAtivo() => _alunoAtivo != null;

  static PersonalpagamentosStruct fromMap(Map<String, dynamic> data) =>
      PersonalpagamentosStruct(
        id: castToType<int>(data['id']),
        descricao: data['descricao'] as String?,
        nome: data['nome'] as String?,
        tipoPagamento: data['tipoPagamento'] as String?,
        valor: castToType<double>(data['valor']),
        status: data['status'] as String?,
        dataVencimento: data['dataVencimento'] as String?,
        dataPagamento: data['dataPagamento'] as String?,
        createdAt: data['created_at'] as String?,
        alunoUuid: data['alunoUuid'] as String?,
        alunoAtivo: data['alunoAtivo'] as bool?,
      );

  static PersonalpagamentosStruct? maybeFromMap(dynamic data) => data is Map
      ? PersonalpagamentosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'descricao': _descricao,
        'nome': _nome,
        'tipoPagamento': _tipoPagamento,
        'valor': _valor,
        'status': _status,
        'dataVencimento': _dataVencimento,
        'dataPagamento': _dataPagamento,
        'created_at': _createdAt,
        'alunoUuid': _alunoUuid,
        'alunoAtivo': _alunoAtivo,
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
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'tipoPagamento': serializeParam(
          _tipoPagamento,
          ParamType.String,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
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
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'alunoUuid': serializeParam(
          _alunoUuid,
          ParamType.String,
        ),
        'alunoAtivo': serializeParam(
          _alunoAtivo,
          ParamType.bool,
        ),
      }.withoutNulls;

  static PersonalpagamentosStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PersonalpagamentosStruct(
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
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        tipoPagamento: deserializeParam(
          data['tipoPagamento'],
          ParamType.String,
          false,
        ),
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
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
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        alunoUuid: deserializeParam(
          data['alunoUuid'],
          ParamType.String,
          false,
        ),
        alunoAtivo: deserializeParam(
          data['alunoAtivo'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'PersonalpagamentosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PersonalpagamentosStruct &&
        id == other.id &&
        descricao == other.descricao &&
        nome == other.nome &&
        tipoPagamento == other.tipoPagamento &&
        valor == other.valor &&
        status == other.status &&
        dataVencimento == other.dataVencimento &&
        dataPagamento == other.dataPagamento &&
        createdAt == other.createdAt &&
        alunoUuid == other.alunoUuid &&
        alunoAtivo == other.alunoAtivo;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        descricao,
        nome,
        tipoPagamento,
        valor,
        status,
        dataVencimento,
        dataPagamento,
        createdAt,
        alunoUuid,
        alunoAtivo,
      ]);
}

PersonalpagamentosStruct createPersonalpagamentosStruct({
  int? id,
  String? descricao,
  String? nome,
  String? tipoPagamento,
  double? valor,
  String? status,
  String? dataVencimento,
  String? dataPagamento,
  String? createdAt,
  String? alunoUuid,
}) =>
    PersonalpagamentosStruct(
      id: id,
      descricao: descricao,
      nome: nome,
      tipoPagamento: tipoPagamento,
      valor: valor,
      status: status,
      dataVencimento: dataVencimento,
      dataPagamento: dataPagamento,
      createdAt: createdAt,
      alunoUuid: alunoUuid,
    );

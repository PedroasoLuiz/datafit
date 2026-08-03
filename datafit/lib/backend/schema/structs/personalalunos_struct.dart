// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PersonalalunosStruct extends BaseStruct {
  PersonalalunosStruct({
    String? createdAt,
    String? nome,
    String? nascimento,
    String? telefone,
    bool? whatsapp,
    String? cpf,
    String? bio,
    double? pesoAtual,
    double? altura,
    String? fkUser,
    bool? ativo,
    String? fotoUrl,
    bool? atrasado,
    String? nikname,
    String? email,
    String? alunoUuid,
    String? status,
    String? dataVinculo,
  })  : _createdAt = createdAt,
        _nome = nome,
        _nascimento = nascimento,
        _telefone = telefone,
        _whatsapp = whatsapp,
        _cpf = cpf,
        _bio = bio,
        _pesoAtual = pesoAtual,
        _altura = altura,
        _fkUser = fkUser,
        _ativo = ativo,
        _fotoUrl = fotoUrl,
        _atrasado = atrasado,
        _nikname = nikname,
        _email = email,
        _alunoUuid = alunoUuid,
        _status = status,
        _dataVinculo = dataVinculo;

  // "createdAt" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "nascimento" field.
  String? _nascimento;
  String get nascimento => _nascimento ?? '';
  set nascimento(String? val) => _nascimento = val;

  bool hasNascimento() => _nascimento != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "whatsapp" field.
  bool? _whatsapp;
  bool get whatsapp => _whatsapp ?? false;
  set whatsapp(bool? val) => _whatsapp = val;

  bool hasWhatsapp() => _whatsapp != null;

  // "cpf" field.
  String? _cpf;
  String get cpf => _cpf ?? '';
  set cpf(String? val) => _cpf = val;

  bool hasCpf() => _cpf != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  set bio(String? val) => _bio = val;

  bool hasBio() => _bio != null;

  // "pesoAtual" field.
  double? _pesoAtual;
  double get pesoAtual => _pesoAtual ?? 0.0;
  set pesoAtual(double? val) => _pesoAtual = val;

  void incrementPesoAtual(double amount) => pesoAtual = pesoAtual + amount;

  bool hasPesoAtual() => _pesoAtual != null;

  // "altura" field.
  double? _altura;
  double get altura => _altura ?? 0.0;
  set altura(double? val) => _altura = val;

  void incrementAltura(double amount) => altura = altura + amount;

  bool hasAltura() => _altura != null;

  // "fkUser" field.
  String? _fkUser;
  String get fkUser => _fkUser ?? '';
  set fkUser(String? val) => _fkUser = val;

  bool hasFkUser() => _fkUser != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  // "fotoUrl" field.
  String? _fotoUrl;
  String get fotoUrl => _fotoUrl ?? '';
  set fotoUrl(String? val) => _fotoUrl = val;

  bool hasFotoUrl() => _fotoUrl != null;

  // "atrasado" field.
  bool? _atrasado;
  bool get atrasado => _atrasado ?? false;
  set atrasado(bool? val) => _atrasado = val;

  bool hasAtrasado() => _atrasado != null;

  // "nikname" field.
  String? _nikname;
  String get nikname => _nikname ?? '';
  set nikname(String? val) => _nikname = val;

  bool hasNikname() => _nikname != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "alunoUuid" field.
  String? _alunoUuid;
  String get alunoUuid => _alunoUuid ?? '';
  set alunoUuid(String? val) => _alunoUuid = val;

  bool hasAlunoUuid() => _alunoUuid != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "dataVinculo" field.
  String? _dataVinculo;
  String get dataVinculo => _dataVinculo ?? '';
  set dataVinculo(String? val) => _dataVinculo = val;

  bool hasDataVinculo() => _dataVinculo != null;

  static PersonalalunosStruct fromMap(Map<String, dynamic> data) =>
      PersonalalunosStruct(
        createdAt: data['createdAt'] as String?,
        nome: data['nome'] as String?,
        nascimento: data['nascimento'] as String?,
        telefone: data['telefone'] as String?,
        whatsapp: data['whatsapp'] as bool?,
        cpf: data['cpf'] as String?,
        bio: data['bio'] as String?,
        pesoAtual: castToType<double>(data['pesoAtual']),
        altura: castToType<double>(data['altura']),
        fkUser: data['fkUser'] as String?,
        ativo: data['ativo'] as bool?,
        fotoUrl: data['fotoUrl'] as String?,
        atrasado: data['atrasado'] as bool?,
        nikname: data['nikname'] as String?,
        email: data['email'] as String?,
        alunoUuid: data['alunoUuid'] as String?,
        status: data['status'] as String?,
        dataVinculo: data['dataVinculo'] as String?,
      );

  static PersonalalunosStruct? maybeFromMap(dynamic data) => data is Map
      ? PersonalalunosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'createdAt': _createdAt,
        'nome': _nome,
        'nascimento': _nascimento,
        'telefone': _telefone,
        'whatsapp': _whatsapp,
        'cpf': _cpf,
        'bio': _bio,
        'pesoAtual': _pesoAtual,
        'altura': _altura,
        'fkUser': _fkUser,
        'ativo': _ativo,
        'fotoUrl': _fotoUrl,
        'atrasado': _atrasado,
        'nikname': _nikname,
        'email': _email,
        'alunoUuid': _alunoUuid,
        'status': _status,
        'dataVinculo': _dataVinculo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'createdAt': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'nascimento': serializeParam(
          _nascimento,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
        'whatsapp': serializeParam(
          _whatsapp,
          ParamType.bool,
        ),
        'cpf': serializeParam(
          _cpf,
          ParamType.String,
        ),
        'bio': serializeParam(
          _bio,
          ParamType.String,
        ),
        'pesoAtual': serializeParam(
          _pesoAtual,
          ParamType.double,
        ),
        'altura': serializeParam(
          _altura,
          ParamType.double,
        ),
        'fkUser': serializeParam(
          _fkUser,
          ParamType.String,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
        'fotoUrl': serializeParam(
          _fotoUrl,
          ParamType.String,
        ),
        'atrasado': serializeParam(
          _atrasado,
          ParamType.bool,
        ),
        'nikname': serializeParam(
          _nikname,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'alunoUuid': serializeParam(
          _alunoUuid,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'dataVinculo': serializeParam(
          _dataVinculo,
          ParamType.String,
        ),
      }.withoutNulls;

  static PersonalalunosStruct fromSerializableMap(Map<String, dynamic> data) =>
      PersonalalunosStruct(
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        nascimento: deserializeParam(
          data['nascimento'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
        whatsapp: deserializeParam(
          data['whatsapp'],
          ParamType.bool,
          false,
        ),
        cpf: deserializeParam(
          data['cpf'],
          ParamType.String,
          false,
        ),
        bio: deserializeParam(
          data['bio'],
          ParamType.String,
          false,
        ),
        pesoAtual: deserializeParam(
          data['pesoAtual'],
          ParamType.double,
          false,
        ),
        altura: deserializeParam(
          data['altura'],
          ParamType.double,
          false,
        ),
        fkUser: deserializeParam(
          data['fkUser'],
          ParamType.String,
          false,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
        fotoUrl: deserializeParam(
          data['fotoUrl'],
          ParamType.String,
          false,
        ),
        atrasado: deserializeParam(
          data['atrasado'],
          ParamType.bool,
          false,
        ),
        nikname: deserializeParam(
          data['nikname'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        alunoUuid: deserializeParam(
          data['alunoUuid'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        dataVinculo: deserializeParam(
          data['dataVinculo'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PersonalalunosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PersonalalunosStruct &&
        createdAt == other.createdAt &&
        nome == other.nome &&
        nascimento == other.nascimento &&
        telefone == other.telefone &&
        whatsapp == other.whatsapp &&
        cpf == other.cpf &&
        bio == other.bio &&
        pesoAtual == other.pesoAtual &&
        altura == other.altura &&
        fkUser == other.fkUser &&
        ativo == other.ativo &&
        fotoUrl == other.fotoUrl &&
        atrasado == other.atrasado &&
        nikname == other.nikname &&
        email == other.email &&
        alunoUuid == other.alunoUuid &&
        status == other.status &&
        dataVinculo == other.dataVinculo;
  }

  @override
  int get hashCode => const ListEquality().hash([
        createdAt,
        nome,
        nascimento,
        telefone,
        whatsapp,
        cpf,
        bio,
        pesoAtual,
        altura,
        fkUser,
        ativo,
        fotoUrl,
        atrasado,
        nikname,
        email,
        alunoUuid,
        status,
        dataVinculo
      ]);
}

PersonalalunosStruct createPersonalalunosStruct({
  String? createdAt,
  String? nome,
  String? nascimento,
  String? telefone,
  bool? whatsapp,
  String? cpf,
  String? bio,
  double? pesoAtual,
  double? altura,
  String? fkUser,
  bool? ativo,
  String? fotoUrl,
  bool? atrasado,
  String? nikname,
  String? email,
  String? alunoUuid,
  String? status,
  String? dataVinculo,
}) =>
    PersonalalunosStruct(
      createdAt: createdAt,
      nome: nome,
      nascimento: nascimento,
      telefone: telefone,
      whatsapp: whatsapp,
      cpf: cpf,
      bio: bio,
      pesoAtual: pesoAtual,
      altura: altura,
      fkUser: fkUser,
      ativo: ativo,
      fotoUrl: fotoUrl,
      atrasado: atrasado,
      nikname: nikname,
      email: email,
      alunoUuid: alunoUuid,
      status: status,
      dataVinculo: dataVinculo,
    );

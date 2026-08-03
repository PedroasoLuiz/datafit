// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlunosimplesStruct extends BaseStruct {
  AlunosimplesStruct({
    int? id,
    String? createdAt,
    String? nome,
    String? nascimento,
    String? telefone,
    bool? whatsapp,
    String? cpf,
    String? bio,
    int? pesoatual,
    String? altura,
    String? fkUser,
    bool? ativo,
    String? fotoUrl,
    bool? atrasado,
    String? nikname,
    String? visualizacao,
    String? email,
  })  : _id = id,
        _createdAt = createdAt,
        _nome = nome,
        _nascimento = nascimento,
        _telefone = telefone,
        _whatsapp = whatsapp,
        _cpf = cpf,
        _bio = bio,
        _pesoatual = pesoatual,
        _altura = altura,
        _fkUser = fkUser,
        _ativo = ativo,
        _fotoUrl = fotoUrl,
        _atrasado = atrasado,
        _nikname = nikname,
        _visualizacao = visualizacao,
        _email = email;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "created_at" field.
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

  // "pesoatual" field.
  int? _pesoatual;
  int get pesoatual => _pesoatual ?? 0;
  set pesoatual(int? val) => _pesoatual = val;

  void incrementPesoatual(int amount) => pesoatual = pesoatual + amount;

  bool hasPesoatual() => _pesoatual != null;

  // "altura" field.
  String? _altura;
  String get altura => _altura ?? '';
  set altura(String? val) => _altura = val;

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

  // "visualizacao" field.
  String? _visualizacao;
  String get visualizacao => _visualizacao ?? '';
  set visualizacao(String? val) => _visualizacao = val;

  bool hasVisualizacao() => _visualizacao != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  static AlunosimplesStruct fromMap(Map<String, dynamic> data) =>
      AlunosimplesStruct(
        id: castToType<int>(data['id']),
        createdAt: data['created_at'] as String?,
        nome: data['nome'] as String?,
        nascimento: data['nascimento'] as String?,
        telefone: data['telefone'] as String?,
        whatsapp: data['whatsapp'] as bool?,
        cpf: data['cpf'] as String?,
        bio: data['bio'] as String?,
        pesoatual: castToType<int>(data['pesoatual']),
        altura: data['altura'] as String?,
        fkUser: data['fkUser'] as String?,
        ativo: data['ativo'] as bool?,
        fotoUrl: data['fotoUrl'] as String?,
        atrasado: data['atrasado'] as bool?,
        nikname: data['nikname'] as String?,
        visualizacao: data['visualizacao'] as String?,
        email: data['email'] as String?,
      );

  static AlunosimplesStruct? maybeFromMap(dynamic data) => data is Map
      ? AlunosimplesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'nome': _nome,
        'nascimento': _nascimento,
        'telefone': _telefone,
        'whatsapp': _whatsapp,
        'cpf': _cpf,
        'bio': _bio,
        'pesoatual': _pesoatual,
        'altura': _altura,
        'fkUser': _fkUser,
        'ativo': _ativo,
        'fotoUrl': _fotoUrl,
        'atrasado': _atrasado,
        'nikname': _nikname,
        'visualizacao': _visualizacao,
        'email': _email,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'created_at': serializeParam(
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
        'pesoatual': serializeParam(
          _pesoatual,
          ParamType.int,
        ),
        'altura': serializeParam(
          _altura,
          ParamType.String,
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
        'visualizacao': serializeParam(
          _visualizacao,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
      }.withoutNulls;

  static AlunosimplesStruct fromSerializableMap(Map<String, dynamic> data) =>
      AlunosimplesStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
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
        pesoatual: deserializeParam(
          data['pesoatual'],
          ParamType.int,
          false,
        ),
        altura: deserializeParam(
          data['altura'],
          ParamType.String,
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
        visualizacao: deserializeParam(
          data['visualizacao'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AlunosimplesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AlunosimplesStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        nome == other.nome &&
        nascimento == other.nascimento &&
        telefone == other.telefone &&
        whatsapp == other.whatsapp &&
        cpf == other.cpf &&
        bio == other.bio &&
        pesoatual == other.pesoatual &&
        altura == other.altura &&
        fkUser == other.fkUser &&
        ativo == other.ativo &&
        fotoUrl == other.fotoUrl &&
        atrasado == other.atrasado &&
        nikname == other.nikname &&
        visualizacao == other.visualizacao &&
        email == other.email;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        nome,
        nascimento,
        telefone,
        whatsapp,
        cpf,
        bio,
        pesoatual,
        altura,
        fkUser,
        ativo,
        fotoUrl,
        atrasado,
        nikname,
        visualizacao,
        email
      ]);
}

AlunosimplesStruct createAlunosimplesStruct({
  int? id,
  String? createdAt,
  String? nome,
  String? nascimento,
  String? telefone,
  bool? whatsapp,
  String? cpf,
  String? bio,
  int? pesoatual,
  String? altura,
  String? fkUser,
  bool? ativo,
  String? fotoUrl,
  bool? atrasado,
  String? nikname,
  String? visualizacao,
  String? email,
}) =>
    AlunosimplesStruct(
      id: id,
      createdAt: createdAt,
      nome: nome,
      nascimento: nascimento,
      telefone: telefone,
      whatsapp: whatsapp,
      cpf: cpf,
      bio: bio,
      pesoatual: pesoatual,
      altura: altura,
      fkUser: fkUser,
      ativo: ativo,
      fotoUrl: fotoUrl,
      atrasado: atrasado,
      nikname: nikname,
      visualizacao: visualizacao,
      email: email,
    );

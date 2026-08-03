// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfilStruct extends BaseStruct {
  PerfilStruct({
    String? id,
    String? createdAt,
    String? email,
    bool? ativo,
    String? fotoUrl,
    String? nickName,
    int? tipoPerfilId,
    String? nome,
    String? dataNascimento,
    List<PerfiltelefoneStruct>? telefones,
    String? cpf,
    String? bio,
    String? cref,
    double? pesoAtual,
    double? altura,
    String? tipoPerfil,
    double? imc,
    PerfilassinaturaStruct? assinatura,
    double? porcentagemGordura,
    String? chavePix,
    String? tipoPix,
  })  : _id = id,
        _createdAt = createdAt,
        _email = email,
        _ativo = ativo,
        _fotoUrl = fotoUrl,
        _nickName = nickName,
        _tipoPerfilId = tipoPerfilId,
        _nome = nome,
        _dataNascimento = dataNascimento,
        _telefones = telefones,
        _cpf = cpf,
        _bio = bio,
        _cref = cref,
        _pesoAtual = pesoAtual,
        _altura = altura,
        _tipoPerfil = tipoPerfil,
        _imc = imc,
        _assinatura = assinatura,
        _porcentagemGordura = porcentagemGordura,
        _chavePix = chavePix,
        _tipoPix = tipoPix;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "createdAt" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

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

  // "nickName" field.
  String? _nickName;
  String get nickName => _nickName ?? '';
  set nickName(String? val) => _nickName = val;

  bool hasNickName() => _nickName != null;

  // "tipoPerfilId" field.
  int? _tipoPerfilId;
  int get tipoPerfilId => _tipoPerfilId ?? 0;
  set tipoPerfilId(int? val) => _tipoPerfilId = val;

  void incrementTipoPerfilId(int amount) =>
      tipoPerfilId = tipoPerfilId + amount;

  bool hasTipoPerfilId() => _tipoPerfilId != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "dataNascimento" field.
  String? _dataNascimento;
  String get dataNascimento => _dataNascimento ?? '';
  set dataNascimento(String? val) => _dataNascimento = val;

  bool hasDataNascimento() => _dataNascimento != null;

  // "telefones" field.
  List<PerfiltelefoneStruct>? _telefones;
  List<PerfiltelefoneStruct> get telefones => _telefones ?? const [];
  set telefones(List<PerfiltelefoneStruct>? val) => _telefones = val;

  void updateTelefones(Function(List<PerfiltelefoneStruct>) updateFn) {
    updateFn(_telefones ??= []);
  }

  bool hasTelefones() => _telefones != null;

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

  // "cref" field.
  String? _cref;
  String get cref => _cref ?? '';
  set cref(String? val) => _cref = val;

  bool hasCref() => _cref != null;

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

  // "tipoPerfil" field.
  String? _tipoPerfil;
  String get tipoPerfil => _tipoPerfil ?? '';
  set tipoPerfil(String? val) => _tipoPerfil = val;

  bool hasTipoPerfil() => _tipoPerfil != null;

  // "imc" field.
  double? _imc;
  double get imc => _imc ?? 0.0;
  set imc(double? val) => _imc = val;

  void incrementImc(double amount) => imc = imc + amount;

  bool hasImc() => _imc != null;

  // "assinatura" field.
  PerfilassinaturaStruct? _assinatura;
  PerfilassinaturaStruct get assinatura =>
      _assinatura ?? PerfilassinaturaStruct();
  set assinatura(PerfilassinaturaStruct? val) => _assinatura = val;

  void updateAssinatura(Function(PerfilassinaturaStruct) updateFn) {
    updateFn(_assinatura ??= PerfilassinaturaStruct());
  }

  bool hasAssinatura() => _assinatura != null;

  // "porcentagemGordura" field.
  double? _porcentagemGordura;
  double get porcentagemGordura => _porcentagemGordura ?? 0.0;
  set porcentagemGordura(double? val) => _porcentagemGordura = val;

  void incrementPorcentagemGordura(double amount) =>
      porcentagemGordura = porcentagemGordura + amount;

  bool hasPorcentagemGordura() => _porcentagemGordura != null;

  // "chavePix" field.
  String? _chavePix;
  String get chavePix => _chavePix ?? '';
  set chavePix(String? val) => _chavePix = val;

  bool hasChavePix() => _chavePix != null && _chavePix!.isNotEmpty;

  // "tipoPix" field.
  String? _tipoPix;
  String get tipoPix => _tipoPix ?? '';
  set tipoPix(String? val) => _tipoPix = val;

  bool hasTipoPix() => _tipoPix != null && _tipoPix!.isNotEmpty;

  static PerfilStruct fromMap(Map<String, dynamic> data) => PerfilStruct(
        id: data['id'] as String?,
        createdAt: data['createdAt'] as String?,
        email: data['email'] as String?,
        ativo: data['ativo'] as bool?,
        fotoUrl: data['fotoUrl'] as String?,
        nickName: data['nickName'] as String?,
        tipoPerfilId: castToType<int>(data['tipoPerfilId']),
        nome: data['nome'] as String?,
        dataNascimento: data['dataNascimento'] as String?,
        telefones: getStructList(
          data['telefones'],
          PerfiltelefoneStruct.fromMap,
        ),
        cpf: data['cpf'] as String?,
        bio: data['bio'] as String?,
        cref: data['cref'] as String?,
        pesoAtual: castToType<double>(data['pesoAtual']),
        altura: castToType<double>(data['altura']),
        tipoPerfil: data['tipoPerfil'] as String?,
        imc: castToType<double>(data['imc']),
        assinatura: data['assinatura'] is PerfilassinaturaStruct
            ? data['assinatura']
            : PerfilassinaturaStruct.maybeFromMap(data['assinatura']),
        porcentagemGordura: castToType<double>(data['porcentagemGordura']),
        chavePix: data['chavePix'] as String?,
        tipoPix: data['tipoPix'] as String?,
      );

  static PerfilStruct? maybeFromMap(dynamic data) =>
      data is Map ? PerfilStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'createdAt': _createdAt,
        'email': _email,
        'ativo': _ativo,
        'fotoUrl': _fotoUrl,
        'nickName': _nickName,
        'tipoPerfilId': _tipoPerfilId,
        'nome': _nome,
        'dataNascimento': _dataNascimento,
        'telefones': _telefones?.map((e) => e.toMap()).toList(),
        'cpf': _cpf,
        'bio': _bio,
        'cref': _cref,
        'pesoAtual': _pesoAtual,
        'altura': _altura,
        'tipoPerfil': _tipoPerfil,
        'imc': _imc,
        'assinatura': _assinatura?.toMap(),
        'porcentagemGordura': _porcentagemGordura,
        'chavePix': _chavePix,
        'tipoPix': _tipoPix,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
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
        'nickName': serializeParam(
          _nickName,
          ParamType.String,
        ),
        'tipoPerfilId': serializeParam(
          _tipoPerfilId,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'dataNascimento': serializeParam(
          _dataNascimento,
          ParamType.String,
        ),
        'telefones': serializeParam(
          _telefones,
          ParamType.DataStruct,
          isList: true,
        ),
        'cpf': serializeParam(
          _cpf,
          ParamType.String,
        ),
        'bio': serializeParam(
          _bio,
          ParamType.String,
        ),
        'cref': serializeParam(
          _cref,
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
        'tipoPerfil': serializeParam(
          _tipoPerfil,
          ParamType.String,
        ),
        'imc': serializeParam(
          _imc,
          ParamType.double,
        ),
        'assinatura': serializeParam(
          _assinatura,
          ParamType.DataStruct,
        ),
        'porcentagemGordura': serializeParam(
          _porcentagemGordura,
          ParamType.double,
        ),
        'chavePix': serializeParam(
          _chavePix,
          ParamType.String,
        ),
        'tipoPix': serializeParam(
          _tipoPix,
          ParamType.String,
        ),
      }.withoutNulls;

  static PerfilStruct fromSerializableMap(Map<String, dynamic> data) =>
      PerfilStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
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
        nickName: deserializeParam(
          data['nickName'],
          ParamType.String,
          false,
        ),
        tipoPerfilId: deserializeParam(
          data['tipoPerfilId'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        dataNascimento: deserializeParam(
          data['dataNascimento'],
          ParamType.String,
          false,
        ),
        telefones: deserializeStructParam<PerfiltelefoneStruct>(
          data['telefones'],
          ParamType.DataStruct,
          true,
          structBuilder: PerfiltelefoneStruct.fromSerializableMap,
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
        cref: deserializeParam(
          data['cref'],
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
        tipoPerfil: deserializeParam(
          data['tipoPerfil'],
          ParamType.String,
          false,
        ),
        imc: deserializeParam(
          data['imc'],
          ParamType.double,
          false,
        ),
        assinatura: deserializeStructParam(
          data['assinatura'],
          ParamType.DataStruct,
          false,
          structBuilder: PerfilassinaturaStruct.fromSerializableMap,
        ),
        porcentagemGordura: deserializeParam(
          data['porcentagemGordura'],
          ParamType.double,
          false,
        ),
        chavePix: deserializeParam(
          data['chavePix'],
          ParamType.String,
          false,
        ),
        tipoPix: deserializeParam(
          data['tipoPix'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PerfilStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PerfilStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        email == other.email &&
        ativo == other.ativo &&
        fotoUrl == other.fotoUrl &&
        nickName == other.nickName &&
        tipoPerfilId == other.tipoPerfilId &&
        nome == other.nome &&
        dataNascimento == other.dataNascimento &&
        listEquality.equals(telefones, other.telefones) &&
        cpf == other.cpf &&
        bio == other.bio &&
        cref == other.cref &&
        pesoAtual == other.pesoAtual &&
        altura == other.altura &&
        tipoPerfil == other.tipoPerfil &&
        imc == other.imc &&
        assinatura == other.assinatura &&
        porcentagemGordura == other.porcentagemGordura &&
        chavePix == other.chavePix &&
        tipoPix == other.tipoPix;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        email,
        ativo,
        fotoUrl,
        nickName,
        tipoPerfilId,
        nome,
        dataNascimento,
        telefones,
        cpf,
        bio,
        cref,
        pesoAtual,
        altura,
        tipoPerfil,
        imc,
        assinatura,
        porcentagemGordura,
        chavePix,
        tipoPix,
      ]);
}

PerfilStruct createPerfilStruct({
  String? id,
  String? createdAt,
  String? email,
  bool? ativo,
  String? fotoUrl,
  String? nickName,
  int? tipoPerfilId,
  String? nome,
  String? dataNascimento,
  String? cpf,
  String? bio,
  String? cref,
  double? pesoAtual,
  double? altura,
  String? tipoPerfil,
  double? imc,
  PerfilassinaturaStruct? assinatura,
  double? porcentagemGordura,
  String? chavePix,
  String? tipoPix,
}) =>
    PerfilStruct(
      id: id,
      createdAt: createdAt,
      email: email,
      ativo: ativo,
      fotoUrl: fotoUrl,
      nickName: nickName,
      tipoPerfilId: tipoPerfilId,
      nome: nome,
      dataNascimento: dataNascimento,
      cpf: cpf,
      bio: bio,
      cref: cref,
      pesoAtual: pesoAtual,
      altura: altura,
      tipoPerfil: tipoPerfil,
      imc: imc,
      assinatura: assinatura ?? PerfilassinaturaStruct(),
      porcentagemGordura: porcentagemGordura,
      chavePix: chavePix,
      tipoPix: tipoPix,
    );

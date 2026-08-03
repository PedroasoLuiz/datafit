// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfilAlunoStruct extends BaseStruct {
  PerfilAlunoStruct({
    String? alunoUuid,
    String? nome,
    String? nickname,
    String? fotoUrl,
    String? bio,
    String? unidade,
    String? email,
    int? idade,
    String? ultimoAcesso,
    String? statusCobranca,
    String? dataVinculo,
    String? telefone,
    bool? isWhatsapp,
    double? pesoAtual,
    double? altura,
    double? imc,
    GrupostreinosStruct? grupoTreino,
    List<MetasStruct>? metas,
    MetricasStruct? metricas,
    List<PagamentosStruct>? pagamentos,
    bool? ativo,
  })  : _alunoUuid = alunoUuid,
        _nome = nome,
        _nickname = nickname,
        _fotoUrl = fotoUrl,
        _bio = bio,
        _unidade = unidade,
        _email = email,
        _idade = idade,
        _ultimoAcesso = ultimoAcesso,
        _statusCobranca = statusCobranca,
        _dataVinculo = dataVinculo,
        _telefone = telefone,
        _isWhatsapp = isWhatsapp,
        _pesoAtual = pesoAtual,
        _altura = altura,
        _imc = imc,
        _grupoTreino = grupoTreino,
        _metas = metas,
        _metricas = metricas,
        _pagamentos = pagamentos,
        _ativo = ativo;

  // "alunoUuid" field.
  String? _alunoUuid;
  String get alunoUuid => _alunoUuid ?? '';
  set alunoUuid(String? val) => _alunoUuid = val;

  bool hasAlunoUuid() => _alunoUuid != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "nickname" field.
  String? _nickname;
  String get nickname => _nickname ?? '';
  set nickname(String? val) => _nickname = val;

  bool hasNickname() => _nickname != null;

  // "fotoUrl" field.
  String? _fotoUrl;
  String get fotoUrl => _fotoUrl ?? '';
  set fotoUrl(String? val) => _fotoUrl = val;

  bool hasFotoUrl() => _fotoUrl != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  set bio(String? val) => _bio = val;

  bool hasBio() => _bio != null;

  // "unidade" field.
  String? _unidade;
  String get unidade => _unidade ?? '';
  set unidade(String? val) => _unidade = val;

  bool hasUnidade() => _unidade != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "idade" field.
  int? _idade;
  int get idade => _idade ?? 0;
  set idade(int? val) => _idade = val;

  void incrementIdade(int amount) => idade = idade + amount;

  bool hasIdade() => _idade != null;

  // "ultimoAcesso" field.
  String? _ultimoAcesso;
  String get ultimoAcesso => _ultimoAcesso ?? '';
  set ultimoAcesso(String? val) => _ultimoAcesso = val;

  bool hasUltimoAcesso() => _ultimoAcesso != null;

  // "statusCobranca" field.
  String? _statusCobranca;
  String get statusCobranca => _statusCobranca ?? '';
  set statusCobranca(String? val) => _statusCobranca = val;

  bool hasStatusCobranca() => _statusCobranca != null;

  // "dataVinculo" field.
  String? _dataVinculo;
  String get dataVinculo => _dataVinculo ?? '';
  set dataVinculo(String? val) => _dataVinculo = val;

  bool hasDataVinculo() => _dataVinculo != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "isWhatsapp" field.
  bool? _isWhatsapp;
  bool get isWhatsapp => _isWhatsapp ?? false;
  set isWhatsapp(bool? val) => _isWhatsapp = val;

  bool hasIsWhatsapp() => _isWhatsapp != null;

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

  // "imc" field.
  double? _imc;
  double get imc => _imc ?? 0.0;
  set imc(double? val) => _imc = val;

  void incrementImc(double amount) => imc = imc + amount;

  bool hasImc() => _imc != null;

  // "grupoTreino" field.
  GrupostreinosStruct? _grupoTreino;
  GrupostreinosStruct get grupoTreino => _grupoTreino ?? GrupostreinosStruct();
  set grupoTreino(GrupostreinosStruct? val) => _grupoTreino = val;

  void updateGrupoTreino(Function(GrupostreinosStruct) updateFn) {
    updateFn(_grupoTreino ??= GrupostreinosStruct());
  }

  bool hasGrupoTreino() => _grupoTreino != null;

  // "metas" field.
  List<MetasStruct>? _metas;
  List<MetasStruct> get metas => _metas ?? const [];
  set metas(List<MetasStruct>? val) => _metas = val;

  void updateMetas(Function(List<MetasStruct>) updateFn) {
    updateFn(_metas ??= []);
  }

  bool hasMetas() => _metas != null;

  // "metricas" field.
  MetricasStruct? _metricas;
  MetricasStruct get metricas => _metricas ?? MetricasStruct();
  set metricas(MetricasStruct? val) => _metricas = val;

  void updateMetricas(Function(MetricasStruct) updateFn) {
    updateFn(_metricas ??= MetricasStruct());
  }

  bool hasMetricas() => _metricas != null;

  // "pagamentos" field.
  List<PagamentosStruct>? _pagamentos;
  List<PagamentosStruct> get pagamentos => _pagamentos ?? const [];
  set pagamentos(List<PagamentosStruct>? val) => _pagamentos = val;

  void updatePagamentos(Function(List<PagamentosStruct>) updateFn) {
    updateFn(_pagamentos ??= []);
  }

  bool hasPagamentos() => _pagamentos != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  static PerfilAlunoStruct fromMap(Map<String, dynamic> data) =>
      PerfilAlunoStruct(
        alunoUuid: data['alunoUuid'] as String?,
        nome: data['nome'] as String?,
        nickname: data['nickname'] as String?,
        fotoUrl: data['fotoUrl'] as String?,
        bio: data['bio'] as String?,
        unidade: data['unidade'] as String?,
        email: data['email'] as String?,
        idade: castToType<int>(data['idade']),
        ultimoAcesso: data['ultimoAcesso'] as String?,
        statusCobranca: data['statusCobranca'] as String?,
        dataVinculo: data['dataVinculo'] as String?,
        telefone: data['telefone'] as String?,
        isWhatsapp: data['isWhatsapp'] as bool?,
        pesoAtual: castToType<double>(data['pesoAtual']),
        altura: castToType<double>(data['altura']),
        imc: castToType<double>(data['imc']),
        grupoTreino: data['grupoTreino'] is GrupostreinosStruct
            ? data['grupoTreino']
            : GrupostreinosStruct.maybeFromMap(data['grupoTreino']),
        metas: getStructList(
          data['metas'],
          MetasStruct.fromMap,
        ),
        metricas: data['metricas'] is MetricasStruct
            ? data['metricas']
            : MetricasStruct.maybeFromMap(data['metricas']),
        pagamentos: getStructList(
          data['pagamentos'],
          PagamentosStruct.fromMap,
        ),
        ativo: data['ativo'] as bool?,
      );

  static PerfilAlunoStruct? maybeFromMap(dynamic data) => data is Map
      ? PerfilAlunoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'alunoUuid': _alunoUuid,
        'nome': _nome,
        'nickname': _nickname,
        'fotoUrl': _fotoUrl,
        'bio': _bio,
        'unidade': _unidade,
        'email': _email,
        'idade': _idade,
        'ultimoAcesso': _ultimoAcesso,
        'statusCobranca': _statusCobranca,
        'dataVinculo': _dataVinculo,
        'telefone': _telefone,
        'isWhatsapp': _isWhatsapp,
        'pesoAtual': _pesoAtual,
        'altura': _altura,
        'imc': _imc,
        'grupoTreino': _grupoTreino?.toMap(),
        'metas': _metas?.map((e) => e.toMap()).toList(),
        'metricas': _metricas?.toMap(),
        'pagamentos': _pagamentos?.map((e) => e.toMap()).toList(),
        'ativo': _ativo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'alunoUuid': serializeParam(
          _alunoUuid,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'nickname': serializeParam(
          _nickname,
          ParamType.String,
        ),
        'fotoUrl': serializeParam(
          _fotoUrl,
          ParamType.String,
        ),
        'bio': serializeParam(
          _bio,
          ParamType.String,
        ),
        'unidade': serializeParam(
          _unidade,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'idade': serializeParam(
          _idade,
          ParamType.int,
        ),
        'ultimoAcesso': serializeParam(
          _ultimoAcesso,
          ParamType.String,
        ),
        'statusCobranca': serializeParam(
          _statusCobranca,
          ParamType.String,
        ),
        'dataVinculo': serializeParam(
          _dataVinculo,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
        'isWhatsapp': serializeParam(
          _isWhatsapp,
          ParamType.bool,
        ),
        'pesoAtual': serializeParam(
          _pesoAtual,
          ParamType.double,
        ),
        'altura': serializeParam(
          _altura,
          ParamType.double,
        ),
        'imc': serializeParam(
          _imc,
          ParamType.double,
        ),
        'grupoTreino': serializeParam(
          _grupoTreino,
          ParamType.DataStruct,
        ),
        'metas': serializeParam(
          _metas,
          ParamType.DataStruct,
          isList: true,
        ),
        'metricas': serializeParam(
          _metricas,
          ParamType.DataStruct,
        ),
        'pagamentos': serializeParam(
          _pagamentos,
          ParamType.DataStruct,
          isList: true,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
      }.withoutNulls;

  static PerfilAlunoStruct fromSerializableMap(Map<String, dynamic> data) =>
      PerfilAlunoStruct(
        alunoUuid: deserializeParam(
          data['alunoUuid'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        nickname: deserializeParam(
          data['nickname'],
          ParamType.String,
          false,
        ),
        fotoUrl: deserializeParam(
          data['fotoUrl'],
          ParamType.String,
          false,
        ),
        bio: deserializeParam(
          data['bio'],
          ParamType.String,
          false,
        ),
        unidade: deserializeParam(
          data['unidade'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        idade: deserializeParam(
          data['idade'],
          ParamType.int,
          false,
        ),
        ultimoAcesso: deserializeParam(
          data['ultimoAcesso'],
          ParamType.String,
          false,
        ),
        statusCobranca: deserializeParam(
          data['statusCobranca'],
          ParamType.String,
          false,
        ),
        dataVinculo: deserializeParam(
          data['dataVinculo'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
        isWhatsapp: deserializeParam(
          data['isWhatsapp'],
          ParamType.bool,
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
        imc: deserializeParam(
          data['imc'],
          ParamType.double,
          false,
        ),
        grupoTreino: deserializeStructParam(
          data['grupoTreino'],
          ParamType.DataStruct,
          false,
          structBuilder: GrupostreinosStruct.fromSerializableMap,
        ),
        metas: deserializeStructParam<MetasStruct>(
          data['metas'],
          ParamType.DataStruct,
          true,
          structBuilder: MetasStruct.fromSerializableMap,
        ),
        metricas: deserializeStructParam(
          data['metricas'],
          ParamType.DataStruct,
          false,
          structBuilder: MetricasStruct.fromSerializableMap,
        ),
        pagamentos: deserializeStructParam<PagamentosStruct>(
          data['pagamentos'],
          ParamType.DataStruct,
          true,
          structBuilder: PagamentosStruct.fromSerializableMap,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'PerfilAlunoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PerfilAlunoStruct &&
        alunoUuid == other.alunoUuid &&
        nome == other.nome &&
        nickname == other.nickname &&
        fotoUrl == other.fotoUrl &&
        bio == other.bio &&
        unidade == other.unidade &&
        email == other.email &&
        idade == other.idade &&
        ultimoAcesso == other.ultimoAcesso &&
        statusCobranca == other.statusCobranca &&
        dataVinculo == other.dataVinculo &&
        telefone == other.telefone &&
        isWhatsapp == other.isWhatsapp &&
        pesoAtual == other.pesoAtual &&
        altura == other.altura &&
        imc == other.imc &&
        grupoTreino == other.grupoTreino &&
        listEquality.equals(metas, other.metas) &&
        metricas == other.metricas &&
        listEquality.equals(pagamentos, other.pagamentos) &&
        ativo == other.ativo;
  }

  @override
  int get hashCode => const ListEquality().hash([
        alunoUuid,
        nome,
        nickname,
        fotoUrl,
        bio,
        unidade,
        email,
        idade,
        ultimoAcesso,
        statusCobranca,
        dataVinculo,
        telefone,
        isWhatsapp,
        pesoAtual,
        altura,
        imc,
        grupoTreino,
        metas,
        metricas,
        pagamentos,
        ativo
      ]);
}

PerfilAlunoStruct createPerfilAlunoStruct({
  String? alunoUuid,
  String? nome,
  String? nickname,
  String? fotoUrl,
  String? bio,
  String? unidade,
  String? email,
  int? idade,
  String? ultimoAcesso,
  String? statusCobranca,
  String? dataVinculo,
  String? telefone,
  bool? isWhatsapp,
  double? pesoAtual,
  double? altura,
  double? imc,
  GrupostreinosStruct? grupoTreino,
  MetricasStruct? metricas,
  bool? ativo,
}) =>
    PerfilAlunoStruct(
      alunoUuid: alunoUuid,
      nome: nome,
      nickname: nickname,
      fotoUrl: fotoUrl,
      bio: bio,
      unidade: unidade,
      email: email,
      idade: idade,
      ultimoAcesso: ultimoAcesso,
      statusCobranca: statusCobranca,
      dataVinculo: dataVinculo,
      telefone: telefone,
      isWhatsapp: isWhatsapp,
      pesoAtual: pesoAtual,
      altura: altura,
      imc: imc,
      grupoTreino: grupoTreino ?? GrupostreinosStruct(),
      metricas: metricas ?? MetricasStruct(),
      ativo: ativo,
    );

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfilPersonalStruct extends BaseStruct {
  PerfilPersonalStruct({
    String? id,
    String? nome,
    String? nickName,
    String? bio,
    String? cref,
    String? fotoUrl,
    String? email,
    String? ultimoAcesso,
    String? whatsapp,
    String? chavePix,
    String? tipoPix,
    double? notaMedia,
    int? totalAvaliacoes,
    int? minhaNota,
    double? emAberto,
    int? qtdEmAberto,
    int? diasAtraso,
    int? totalPagamentos,
    int? totalAlunos,
    List<TreinoPersonalStruct>? treinos,
    List<PagamentosStruct>? pagamentos,
    int? totalTreinos,
    int? totalExercicios,
  })  : _id = id,
        _nome = nome,
        _nickName = nickName,
        _bio = bio,
        _cref = cref,
        _fotoUrl = fotoUrl,
        _email = email,
        _ultimoAcesso = ultimoAcesso,
        _whatsapp = whatsapp,
        _chavePix = chavePix,
        _tipoPix = tipoPix,
        _totalAlunos = totalAlunos,
        _treinos = treinos,
        _pagamentos = pagamentos,
        _totalTreinos = totalTreinos,
        _totalExercicios = totalExercicios,
        _notaMedia = notaMedia,
        _totalAvaliacoes = totalAvaliacoes,
        _minhaNota = minhaNota,
        _emAberto = emAberto,
        _qtdEmAberto = qtdEmAberto,
        _diasAtraso = diasAtraso,
        _totalPagamentos = totalPagamentos;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "nickName" field.
  String? _nickName;
  String get nickName => _nickName ?? '';
  set nickName(String? val) => _nickName = val;

  bool hasNickName() => _nickName != null;

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

  // "fotoUrl" field.
  String? _fotoUrl;
  String get fotoUrl => _fotoUrl ?? '';
  set fotoUrl(String? val) => _fotoUrl = val;

  bool hasFotoUrl() => _fotoUrl != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "ultimoAcesso" field.
  String? _ultimoAcesso;
  String get ultimoAcesso => _ultimoAcesso ?? '';
  set ultimoAcesso(String? val) => _ultimoAcesso = val;

  bool hasUltimoAcesso() => _ultimoAcesso != null;

  // "whatsapp" field.
  String? _whatsapp;
  String get whatsapp => _whatsapp ?? '';
  set whatsapp(String? val) => _whatsapp = val;

  bool hasWhatsapp() => _whatsapp != null;

  // "totalAlunos" field.
  int? _totalAlunos;
  int get totalAlunos => _totalAlunos ?? 0;
  set totalAlunos(int? val) => _totalAlunos = val;

  void incrementTotalAlunos(int amount) => totalAlunos = totalAlunos + amount;

  bool hasTotalAlunos() => _totalAlunos != null;

  // "treinos" field.
  List<TreinoPersonalStruct>? _treinos;
  List<TreinoPersonalStruct> get treinos => _treinos ?? const [];
  set treinos(List<TreinoPersonalStruct>? val) => _treinos = val;

  void updateTreinos(Function(List<TreinoPersonalStruct>) updateFn) {
    updateFn(_treinos ??= []);
  }

  bool hasTreinos() => _treinos != null;

  // "pagamentos" field.
  List<PagamentosStruct>? _pagamentos;
  List<PagamentosStruct> get pagamentos => _pagamentos ?? const [];
  set pagamentos(List<PagamentosStruct>? val) => _pagamentos = val;

  void updatePagamentos(Function(List<PagamentosStruct>) updateFn) {
    updateFn(_pagamentos ??= []);
  }

  bool hasPagamentos() => _pagamentos != null;

  // "totalTreinos" field.
  int? _totalTreinos;
  int get totalTreinos => _totalTreinos ?? 0;
  set totalTreinos(int? val) => _totalTreinos = val;

  void incrementTotalTreinos(int amount) =>
      totalTreinos = totalTreinos + amount;

  bool hasTotalTreinos() => _totalTreinos != null;

  // "totalExercicios" field.
  int? _totalExercicios;
  int get totalExercicios => _totalExercicios ?? 0;
  set totalExercicios(int? val) => _totalExercicios = val;

  void incrementTotalExercicios(int amount) =>
      totalExercicios = totalExercicios + amount;

  bool hasTotalExercicios() => _totalExercicios != null;

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

  // "notaMedia" field.
  double? _notaMedia;
  double get notaMedia => _notaMedia ?? 0.0;
  set notaMedia(double? val) => _notaMedia = val;

  bool hasNotaMedia() => _notaMedia != null;

  // "totalAvaliacoes" field.
  int? _totalAvaliacoes;
  int get totalAvaliacoes => _totalAvaliacoes ?? 0;
  set totalAvaliacoes(int? val) => _totalAvaliacoes = val;

  bool hasTotalAvaliacoes() => _totalAvaliacoes != null;

  // "minhaNota" field.
  int? _minhaNota;
  int get minhaNota => _minhaNota ?? 0;
  set minhaNota(int? val) => _minhaNota = val;

  bool hasMinhaNota() => _minhaNota != null;

  // "emAberto" field.
  double? _emAberto;
  double get emAberto => _emAberto ?? 0.0;
  set emAberto(double? val) => _emAberto = val;

  bool hasEmAberto() => _emAberto != null;

  // "qtdEmAberto" field.
  int? _qtdEmAberto;
  int get qtdEmAberto => _qtdEmAberto ?? 0;
  set qtdEmAberto(int? val) => _qtdEmAberto = val;

  bool hasQtdEmAberto() => _qtdEmAberto != null;

  // "diasAtraso" field.
  int? _diasAtraso;
  int get diasAtraso => _diasAtraso ?? 0;
  set diasAtraso(int? val) => _diasAtraso = val;

  bool hasDiasAtraso() => _diasAtraso != null;

  // "totalPagamentos" field.
  int? _totalPagamentos;
  int get totalPagamentos => _totalPagamentos ?? 0;
  set totalPagamentos(int? val) => _totalPagamentos = val;

  bool hasTotalPagamentos() => _totalPagamentos != null;

  static PerfilPersonalStruct fromMap(Map<String, dynamic> data) =>
      PerfilPersonalStruct(
        id: data['id'] as String?,
        nome: data['nome'] as String?,
        nickName: data['nickName'] as String?,
        bio: data['bio'] as String?,
        cref: data['cref'] as String?,
        fotoUrl: data['fotoUrl'] as String?,
        email: data['email'] as String?,
        ultimoAcesso: data['ultimoAcesso'] as String?,
        whatsapp: data['whatsapp'] as String?,
        chavePix: data['chavePix'] as String?,
        tipoPix: data['tipoPix'] as String?,
        notaMedia: castToType<double>(data['notaMedia']),
        totalAvaliacoes: castToType<int>(data['totalAvaliacoes']),
        minhaNota: castToType<int>(data['minhaNota']),
        emAberto: castToType<double>(data['emAberto']),
        qtdEmAberto: castToType<int>(data['qtdEmAberto']),
        diasAtraso: castToType<int>(data['diasAtraso']),
        totalPagamentos: castToType<int>(data['totalPagamentos']),
        totalAlunos: castToType<int>(data['totalAlunos']),
        treinos: getStructList(
          data['treinos'],
          TreinoPersonalStruct.fromMap,
        ),
        pagamentos: getStructList(
          data['pagamentos'],
          PagamentosStruct.fromMap,
        ),
        totalTreinos: castToType<int>(data['totalTreinos']),
        totalExercicios: castToType<int>(data['totalExercicios']),
      );

  static PerfilPersonalStruct? maybeFromMap(dynamic data) => data is Map
      ? PerfilPersonalStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'nickName': _nickName,
        'bio': _bio,
        'cref': _cref,
        'fotoUrl': _fotoUrl,
        'email': _email,
        'ultimoAcesso': _ultimoAcesso,
        'whatsapp': _whatsapp,
        'chavePix': _chavePix,
        'tipoPix': _tipoPix,
        'notaMedia': _notaMedia,
        'totalAvaliacoes': _totalAvaliacoes,
        'minhaNota': _minhaNota,
        'emAberto': _emAberto,
        'qtdEmAberto': _qtdEmAberto,
        'diasAtraso': _diasAtraso,
        'totalPagamentos': _totalPagamentos,
        'totalAlunos': _totalAlunos,
        'treinos': _treinos?.map((e) => e.toMap()).toList(),
        'pagamentos': _pagamentos?.map((e) => e.toMap()).toList(),
        'totalTreinos': _totalTreinos,
        'totalExercicios': _totalExercicios,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'nickName': serializeParam(
          _nickName,
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
        'fotoUrl': serializeParam(
          _fotoUrl,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'ultimoAcesso': serializeParam(
          _ultimoAcesso,
          ParamType.String,
        ),
        'whatsapp': serializeParam(
          _whatsapp,
          ParamType.String,
        ),
        'chavePix': serializeParam(
          _chavePix,
          ParamType.String,
        ),
        'tipoPix': serializeParam(
          _tipoPix,
          ParamType.String,
        ),
        'notaMedia': serializeParam(
          _notaMedia,
          ParamType.double,
        ),
        'totalAvaliacoes': serializeParam(
          _totalAvaliacoes,
          ParamType.int,
        ),
        'minhaNota': serializeParam(
          _minhaNota,
          ParamType.int,
        ),
        'emAberto': serializeParam(
          _emAberto,
          ParamType.double,
        ),
        'qtdEmAberto': serializeParam(
          _qtdEmAberto,
          ParamType.int,
        ),
        'diasAtraso': serializeParam(
          _diasAtraso,
          ParamType.int,
        ),
        'totalPagamentos': serializeParam(
          _totalPagamentos,
          ParamType.int,
        ),
        'totalAlunos': serializeParam(
          _totalAlunos,
          ParamType.int,
        ),
        'treinos': serializeParam(
          _treinos,
          ParamType.DataStruct,
          isList: true,
        ),
        'pagamentos': serializeParam(
          _pagamentos,
          ParamType.DataStruct,
          isList: true,
        ),
        'totalTreinos': serializeParam(
          _totalTreinos,
          ParamType.int,
        ),
        'totalExercicios': serializeParam(
          _totalExercicios,
          ParamType.int,
        ),
      }.withoutNulls;

  static PerfilPersonalStruct fromSerializableMap(Map<String, dynamic> data) =>
      PerfilPersonalStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        nickName: deserializeParam(
          data['nickName'],
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
        fotoUrl: deserializeParam(
          data['fotoUrl'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        ultimoAcesso: deserializeParam(
          data['ultimoAcesso'],
          ParamType.String,
          false,
        ),
        whatsapp: deserializeParam(
          data['whatsapp'],
          ParamType.String,
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
        notaMedia: deserializeParam(
          data['notaMedia'],
          ParamType.double,
          false,
        ),
        totalAvaliacoes: deserializeParam(
          data['totalAvaliacoes'],
          ParamType.int,
          false,
        ),
        minhaNota: deserializeParam(
          data['minhaNota'],
          ParamType.int,
          false,
        ),
        emAberto: deserializeParam(
          data['emAberto'],
          ParamType.double,
          false,
        ),
        qtdEmAberto: deserializeParam(
          data['qtdEmAberto'],
          ParamType.int,
          false,
        ),
        diasAtraso: deserializeParam(
          data['diasAtraso'],
          ParamType.int,
          false,
        ),
        totalPagamentos: deserializeParam(
          data['totalPagamentos'],
          ParamType.int,
          false,
        ),
        totalAlunos: deserializeParam(
          data['totalAlunos'],
          ParamType.int,
          false,
        ),
        treinos: deserializeStructParam<TreinoPersonalStruct>(
          data['treinos'],
          ParamType.DataStruct,
          true,
          structBuilder: TreinoPersonalStruct.fromSerializableMap,
        ),
        pagamentos: deserializeStructParam<PagamentosStruct>(
          data['pagamentos'],
          ParamType.DataStruct,
          true,
          structBuilder: PagamentosStruct.fromSerializableMap,
        ),
        totalTreinos: deserializeParam(
          data['totalTreinos'],
          ParamType.int,
          false,
        ),
        totalExercicios: deserializeParam(
          data['totalExercicios'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PerfilPersonalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PerfilPersonalStruct &&
        id == other.id &&
        nome == other.nome &&
        nickName == other.nickName &&
        bio == other.bio &&
        cref == other.cref &&
        fotoUrl == other.fotoUrl &&
        email == other.email &&
        ultimoAcesso == other.ultimoAcesso &&
        whatsapp == other.whatsapp &&
        chavePix == other.chavePix &&
        tipoPix == other.tipoPix &&
        notaMedia == other.notaMedia &&
        totalAvaliacoes == other.totalAvaliacoes &&
        minhaNota == other.minhaNota &&
        emAberto == other.emAberto &&
        qtdEmAberto == other.qtdEmAberto &&
        diasAtraso == other.diasAtraso &&
        totalPagamentos == other.totalPagamentos &&
        totalAlunos == other.totalAlunos &&
        listEquality.equals(treinos, other.treinos) &&
        listEquality.equals(pagamentos, other.pagamentos) &&
        totalTreinos == other.totalTreinos &&
        totalExercicios == other.totalExercicios;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        nome,
        nickName,
        bio,
        cref,
        fotoUrl,
        email,
        ultimoAcesso,
        whatsapp,
        chavePix,
        tipoPix,
        totalAlunos,
        treinos,
        pagamentos,
        totalTreinos,
        totalExercicios,
        notaMedia,
        totalAvaliacoes,
        minhaNota,
        emAberto,
        qtdEmAberto,
        diasAtraso,
        totalPagamentos
      ]);
}

PerfilPersonalStruct createPerfilPersonalStruct({
  String? id,
  String? nome,
  String? nickName,
  String? bio,
  String? cref,
  String? fotoUrl,
  String? email,
  String? ultimoAcesso,
  String? whatsapp,
  int? totalAlunos,
  int? totalTreinos,
  int? totalExercicios,
}) =>
    PerfilPersonalStruct(
      id: id,
      nome: nome,
      nickName: nickName,
      bio: bio,
      cref: cref,
      fotoUrl: fotoUrl,
      email: email,
      ultimoAcesso: ultimoAcesso,
      whatsapp: whatsapp,
      totalAlunos: totalAlunos,
      totalTreinos: totalTreinos,
      totalExercicios: totalExercicios,
    );

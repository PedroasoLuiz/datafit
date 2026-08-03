// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MetasStruct extends BaseStruct {
  MetasStruct({
    int? metaId,
    String? titulo,
    String? descricao,
    int? progresso,
    String? urlImg,
    List<RegistrosStruct>? registros,
  })  : _metaId = metaId,
        _titulo = titulo,
        _descricao = descricao,
        _progresso = progresso,
        _urlImg = urlImg,
        _registros = registros;

  // "metaId" field.
  int? _metaId;
  int get metaId => _metaId ?? 0;
  set metaId(int? val) => _metaId = val;

  void incrementMetaId(int amount) => metaId = metaId + amount;

  bool hasMetaId() => _metaId != null;

  // "titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? '';
  set titulo(String? val) => _titulo = val;

  bool hasTitulo() => _titulo != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "progresso" field.
  int? _progresso;
  int get progresso => _progresso ?? 0;
  set progresso(int? val) => _progresso = val;

  void incrementProgresso(int amount) => progresso = progresso + amount;

  bool hasProgresso() => _progresso != null;

  // "urlImg" field.
  String? _urlImg;
  String get urlImg => _urlImg ?? '';
  set urlImg(String? val) => _urlImg = val;

  bool hasUrlImg() => _urlImg != null;

  // "registros" field.
  List<RegistrosStruct>? _registros;
  List<RegistrosStruct> get registros => _registros ?? const [];
  set registros(List<RegistrosStruct>? val) => _registros = val;

  void updateRegistros(Function(List<RegistrosStruct>) updateFn) {
    updateFn(_registros ??= []);
  }

  bool hasRegistros() => _registros != null;

  static MetasStruct fromMap(Map<String, dynamic> data) => MetasStruct(
        metaId: castToType<int>(data['metaId']),
        titulo: data['titulo'] as String?,
        descricao: data['descricao'] as String?,
        progresso: castToType<int>(data['progresso']),
        urlImg: data['urlImg'] as String?,
        registros: getStructList(
          data['registros'],
          RegistrosStruct.fromMap,
        ),
      );

  static MetasStruct? maybeFromMap(dynamic data) =>
      data is Map ? MetasStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'metaId': _metaId,
        'titulo': _titulo,
        'descricao': _descricao,
        'progresso': _progresso,
        'urlImg': _urlImg,
        'registros': _registros?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'metaId': serializeParam(
          _metaId,
          ParamType.int,
        ),
        'titulo': serializeParam(
          _titulo,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'progresso': serializeParam(
          _progresso,
          ParamType.int,
        ),
        'urlImg': serializeParam(
          _urlImg,
          ParamType.String,
        ),
        'registros': serializeParam(
          _registros,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static MetasStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetasStruct(
        metaId: deserializeParam(
          data['metaId'],
          ParamType.int,
          false,
        ),
        titulo: deserializeParam(
          data['titulo'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        progresso: deserializeParam(
          data['progresso'],
          ParamType.int,
          false,
        ),
        urlImg: deserializeParam(
          data['urlImg'],
          ParamType.String,
          false,
        ),
        registros: deserializeStructParam<RegistrosStruct>(
          data['registros'],
          ParamType.DataStruct,
          true,
          structBuilder: RegistrosStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'MetasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MetasStruct &&
        metaId == other.metaId &&
        titulo == other.titulo &&
        descricao == other.descricao &&
        progresso == other.progresso &&
        urlImg == other.urlImg &&
        listEquality.equals(registros, other.registros);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([metaId, titulo, descricao, progresso, urlImg, registros]);
}

MetasStruct createMetasStruct({
  int? metaId,
  String? titulo,
  String? descricao,
  int? progresso,
  String? urlImg,
}) =>
    MetasStruct(
      metaId: metaId,
      titulo: titulo,
      descricao: descricao,
      progresso: progresso,
      urlImg: urlImg,
    );

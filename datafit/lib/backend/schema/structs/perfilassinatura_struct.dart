// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfilassinaturaStruct extends BaseStruct {
  PerfilassinaturaStruct({
    int? assinaturaId,
    String? assinaturaStatus,
    String? assinaturaDataInicio,
    String? assinaturaDataVencimento,
    String? planoCodigo,
    String? planoDescricao,
    double? planoValor,
    int? planoLimiteAlunos,
    double? planoPercComissao,
  })  : _assinaturaId = assinaturaId,
        _assinaturaStatus = assinaturaStatus,
        _assinaturaDataInicio = assinaturaDataInicio,
        _assinaturaDataVencimento = assinaturaDataVencimento,
        _planoCodigo = planoCodigo,
        _planoDescricao = planoDescricao,
        _planoValor = planoValor,
        _planoLimiteAlunos = planoLimiteAlunos,
        _planoPercComissao = planoPercComissao;

  // "assinatura_id" field.
  int? _assinaturaId;
  int get assinaturaId => _assinaturaId ?? 0;
  set assinaturaId(int? val) => _assinaturaId = val;

  void incrementAssinaturaId(int amount) =>
      assinaturaId = assinaturaId + amount;

  bool hasAssinaturaId() => _assinaturaId != null;

  // "assinatura_status" field.
  String? _assinaturaStatus;
  String get assinaturaStatus => _assinaturaStatus ?? '';
  set assinaturaStatus(String? val) => _assinaturaStatus = val;

  bool hasAssinaturaStatus() => _assinaturaStatus != null;

  // "assinatura_data_inicio" field.
  String? _assinaturaDataInicio;
  String get assinaturaDataInicio => _assinaturaDataInicio ?? '';
  set assinaturaDataInicio(String? val) => _assinaturaDataInicio = val;

  bool hasAssinaturaDataInicio() => _assinaturaDataInicio != null;

  // "assinatura_data_vencimento" field.
  String? _assinaturaDataVencimento;
  String get assinaturaDataVencimento => _assinaturaDataVencimento ?? '';
  set assinaturaDataVencimento(String? val) => _assinaturaDataVencimento = val;

  bool hasAssinaturaDataVencimento() => _assinaturaDataVencimento != null;

  // "plano_codigo" field.
  String? _planoCodigo;
  String get planoCodigo => _planoCodigo ?? '';
  set planoCodigo(String? val) => _planoCodigo = val;

  bool hasPlanoCodigo() => _planoCodigo != null;

  // "plano_descricao" field.
  String? _planoDescricao;
  String get planoDescricao => _planoDescricao ?? '';
  set planoDescricao(String? val) => _planoDescricao = val;

  bool hasPlanoDescricao() => _planoDescricao != null;

  // "plano_valor" field.
  double? _planoValor;
  double get planoValor => _planoValor ?? 0.0;
  set planoValor(double? val) => _planoValor = val;

  void incrementPlanoValor(double amount) => planoValor = planoValor + amount;

  bool hasPlanoValor() => _planoValor != null;

  // "plano_limite_alunos" field.
  int? _planoLimiteAlunos;
  int get planoLimiteAlunos => _planoLimiteAlunos ?? 0;
  set planoLimiteAlunos(int? val) => _planoLimiteAlunos = val;

  void incrementPlanoLimiteAlunos(int amount) =>
      planoLimiteAlunos = planoLimiteAlunos + amount;

  bool hasPlanoLimiteAlunos() => _planoLimiteAlunos != null;

  // "plano_perc_comissao" field.
  double? _planoPercComissao;
  double get planoPercComissao => _planoPercComissao ?? 0.0;
  set planoPercComissao(double? val) => _planoPercComissao = val;

  void incrementPlanoPercComissao(double amount) =>
      planoPercComissao = planoPercComissao + amount;

  bool hasPlanoPercComissao() => _planoPercComissao != null;

  static PerfilassinaturaStruct fromMap(Map<String, dynamic> data) =>
      PerfilassinaturaStruct(
        assinaturaId: castToType<int>(data['assinatura_id']),
        assinaturaStatus: data['assinatura_status'] as String?,
        assinaturaDataInicio: data['assinatura_data_inicio'] as String?,
        assinaturaDataVencimento: data['assinatura_data_vencimento'] as String?,
        planoCodigo: data['plano_codigo'] as String?,
        planoDescricao: data['plano_descricao'] as String?,
        planoValor: castToType<double>(data['plano_valor']),
        planoLimiteAlunos: castToType<int>(data['plano_limite_alunos']),
        planoPercComissao: castToType<double>(data['plano_perc_comissao']),
      );

  static PerfilassinaturaStruct? maybeFromMap(dynamic data) => data is Map
      ? PerfilassinaturaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'assinatura_id': _assinaturaId,
        'assinatura_status': _assinaturaStatus,
        'assinatura_data_inicio': _assinaturaDataInicio,
        'assinatura_data_vencimento': _assinaturaDataVencimento,
        'plano_codigo': _planoCodigo,
        'plano_descricao': _planoDescricao,
        'plano_valor': _planoValor,
        'plano_limite_alunos': _planoLimiteAlunos,
        'plano_perc_comissao': _planoPercComissao,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'assinatura_id': serializeParam(
          _assinaturaId,
          ParamType.int,
        ),
        'assinatura_status': serializeParam(
          _assinaturaStatus,
          ParamType.String,
        ),
        'assinatura_data_inicio': serializeParam(
          _assinaturaDataInicio,
          ParamType.String,
        ),
        'assinatura_data_vencimento': serializeParam(
          _assinaturaDataVencimento,
          ParamType.String,
        ),
        'plano_codigo': serializeParam(
          _planoCodigo,
          ParamType.String,
        ),
        'plano_descricao': serializeParam(
          _planoDescricao,
          ParamType.String,
        ),
        'plano_valor': serializeParam(
          _planoValor,
          ParamType.double,
        ),
        'plano_limite_alunos': serializeParam(
          _planoLimiteAlunos,
          ParamType.int,
        ),
        'plano_perc_comissao': serializeParam(
          _planoPercComissao,
          ParamType.double,
        ),
      }.withoutNulls;

  static PerfilassinaturaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PerfilassinaturaStruct(
        assinaturaId: deserializeParam(
          data['assinatura_id'],
          ParamType.int,
          false,
        ),
        assinaturaStatus: deserializeParam(
          data['assinatura_status'],
          ParamType.String,
          false,
        ),
        assinaturaDataInicio: deserializeParam(
          data['assinatura_data_inicio'],
          ParamType.String,
          false,
        ),
        assinaturaDataVencimento: deserializeParam(
          data['assinatura_data_vencimento'],
          ParamType.String,
          false,
        ),
        planoCodigo: deserializeParam(
          data['plano_codigo'],
          ParamType.String,
          false,
        ),
        planoDescricao: deserializeParam(
          data['plano_descricao'],
          ParamType.String,
          false,
        ),
        planoValor: deserializeParam(
          data['plano_valor'],
          ParamType.double,
          false,
        ),
        planoLimiteAlunos: deserializeParam(
          data['plano_limite_alunos'],
          ParamType.int,
          false,
        ),
        planoPercComissao: deserializeParam(
          data['plano_perc_comissao'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'PerfilassinaturaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PerfilassinaturaStruct &&
        assinaturaId == other.assinaturaId &&
        assinaturaStatus == other.assinaturaStatus &&
        assinaturaDataInicio == other.assinaturaDataInicio &&
        assinaturaDataVencimento == other.assinaturaDataVencimento &&
        planoCodigo == other.planoCodigo &&
        planoDescricao == other.planoDescricao &&
        planoValor == other.planoValor &&
        planoLimiteAlunos == other.planoLimiteAlunos &&
        planoPercComissao == other.planoPercComissao;
  }

  @override
  int get hashCode => const ListEquality().hash([
        assinaturaId,
        assinaturaStatus,
        assinaturaDataInicio,
        assinaturaDataVencimento,
        planoCodigo,
        planoDescricao,
        planoValor,
        planoLimiteAlunos,
        planoPercComissao
      ]);
}

PerfilassinaturaStruct createPerfilassinaturaStruct({
  int? assinaturaId,
  String? assinaturaStatus,
  String? assinaturaDataInicio,
  String? assinaturaDataVencimento,
  String? planoCodigo,
  String? planoDescricao,
  double? planoValor,
  int? planoLimiteAlunos,
  double? planoPercComissao,
}) =>
    PerfilassinaturaStruct(
      assinaturaId: assinaturaId,
      assinaturaStatus: assinaturaStatus,
      assinaturaDataInicio: assinaturaDataInicio,
      assinaturaDataVencimento: assinaturaDataVencimento,
      planoCodigo: planoCodigo,
      planoDescricao: planoDescricao,
      planoValor: planoValor,
      planoLimiteAlunos: planoLimiteAlunos,
      planoPercComissao: planoPercComissao,
    );

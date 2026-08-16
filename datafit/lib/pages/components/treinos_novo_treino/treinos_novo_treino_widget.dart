import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/database/database.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'treinos_novo_treino_model.dart';
export 'treinos_novo_treino_model.dart';

class TreinosNovoTreinoWidget extends StatefulWidget {
  const TreinosNovoTreinoWidget({
    super.key,
    this.grupoTreinoId,
    this.nomeInicial,
  });

  final int? grupoTreinoId;
  final String? nomeInicial;

  @override
  State<TreinosNovoTreinoWidget> createState() =>
      _TreinosNovoTreinoWidgetState();
}

class _TreinosNovoTreinoWidgetState extends State<TreinosNovoTreinoWidget> {
  late TreinosNovoTreinoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosNovoTreinoModel());

    _model.txtNomeTextController ??=
        TextEditingController(text: widget.nomeInicial ?? '');
    _model.txtNomeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  bool get _ehEdicao => widget.grupoTreinoId != null;

  /// Devolve `true` quando gravou; `null` mantém a folha aberta.
  ///
  /// Nome vazio nao fecha nem avisa: o campo esta a vista e o visto so nao
  /// responde. Um aviso aqui seria uma folha por cima de outra para dizer o
  /// que a tela ja mostra.
  Future<Object?> _gravar() async {
    final nome = _model.txtNomeTextController?.text.trim() ?? '';
    if (nome.isEmpty) return null;

    if (_ehEdicao) {
      await GruposTreinoTable().update(
        data: {'Descricao': nome},
        matchingRows: (q) => q
            .eqOrNull('Id', widget.grupoTreinoId)
            .eqOrNull('CriadorPerfisId', currentUserUid),
      );
    } else {
      await GruposTreinoTable().insert({
        'Descricao': nome,
        'CriadorPerfisId': currentUserUid,
        'Ativo': true,
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        CabecaFolha(
          titulo: _ehEdicao ? 'Editar treino' : 'Novo treino',
          apoio: 'O nome que agrupa os treinos A, B, C deste plano.',
          icone: FFIcons.kproperty1FiRrGym,
        ),
        CampoFolha(
          primeiro: true,
          rotulo: 'Nome do plano',
          dica: 'Ex: Hipertrofia, FullBody...',
          controlador: _model.txtNomeTextController,
          foco: _model.txtNomeFocusNode,
          autofoco: true,
          validador: _model.txtNomeTextControllerValidator,
        ),
      ],
    );
  }
}

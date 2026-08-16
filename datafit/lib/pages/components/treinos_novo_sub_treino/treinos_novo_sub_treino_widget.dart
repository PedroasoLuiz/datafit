import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'treinos_novo_sub_treino_model.dart';
export 'treinos_novo_sub_treino_model.dart';

class TreinosNovoSubTreinoWidget extends StatefulWidget {
  const TreinosNovoSubTreinoWidget({
    super.key,
    required this.grupoTreinoId,
    this.treinoId,
    this.nomeInicial,
  });

  final int grupoTreinoId;
  final int? treinoId;
  final String? nomeInicial;

  @override
  State<TreinosNovoSubTreinoWidget> createState() =>
      _TreinosNovoSubTreinoWidgetState();
}

class _TreinosNovoSubTreinoWidgetState
    extends State<TreinosNovoSubTreinoWidget> {
  late TreinosNovoSubTreinoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinosNovoSubTreinoModel());

    _model.txtNomeTextController ??=
        TextEditingController(text: widget.nomeInicial ?? '');
    _model.txtNomeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  bool get _ehEdicao => widget.treinoId != null;

  Future<Object?> _gravar() async {
    final nome = _model.txtNomeTextController?.text.trim() ?? '';
    if (nome.isEmpty) return null;

    if (_ehEdicao) {
      await SupaFlow.client
          .from('Treinos')
          .update({'Descricao': nome}).eq('Id', widget.treinoId!);
    } else {
      // `Ativo` e `IsDeleted` explicitos: sem eles a linha nascia com null, e
      // a atribuicao ao aluno filtrava por `Ativo = true` — que em SQL nao
      // casa com null. O treino era criado, aparecia na tela do personal e
      // nunca chegava a aluno nenhum. A coluna ganhou default no banco, e
      // aqui fica escrito para quem ler o insert saber o que a linha precisa.
      await SupaFlow.client.from('Treinos').insert({
        'Descricao': nome,
        'GruposTreinoId': widget.grupoTreinoId,
        'CriadorPerfisId': currentUserUid,
        'Ativo': true,
        'IsDeleted': false,
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
          apoio: 'Cada treino é um dia do ciclo — A, B, C.',
          icone: FFIcons.kproperty1FiRrGym,
        ),
        CampoFolha(
          primeiro: true,
          rotulo: 'Nome do treino',
          dica: 'Ex: Treino A, Superiores...',
          controlador: _model.txtNomeTextController,
          foco: _model.txtNomeFocusNode,
          autofoco: true,
          validador: _model.txtNomeTextControllerValidator,
        ),
      ],
    );
  }
}

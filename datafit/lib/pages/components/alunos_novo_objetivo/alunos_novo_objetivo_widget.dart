import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'alunos_novo_objetivo_model.dart';
export 'alunos_novo_objetivo_model.dart';

class AlunosNovoObjetivoWidget extends StatefulWidget {
  const AlunosNovoObjetivoWidget({
    super.key,
    bool? pessoal,
  }) : pessoal = pessoal ?? false;

  /// `true` quando o aluno cria a própria meta; `false` quando o personal
  /// cria para ele. Muda de quem é o objetivo, não o que se pergunta.
  final bool pessoal;

  @override
  State<AlunosNovoObjetivoWidget> createState() =>
      _AlunosNovoObjetivoWidgetState();
}

class _AlunosNovoObjetivoWidgetState extends State<AlunosNovoObjetivoWidget> {
  late AlunosNovoObjetivoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlunosNovoObjetivoModel());

    _model.txtTituloTextController ??= TextEditingController();
    _model.txtTituloFocusNode ??= FocusNode();
    _model.txtDescricaoTextController ??= TextEditingController();
    _model.txtDescricaoFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<Object?> _gravar() async {
    final titulo = _model.txtTituloTextController?.text.trim() ?? '';
    if (titulo.isEmpty) return null;

    await MetasTable().insert({
      'Titulo': titulo,
      'Descricao': _model.txtDescricaoTextController?.text.trim() ?? '',
      'Progresso': 0,
      'SolicitantePerfisId': currentUserUid,
      'ExecutorPerfisId':
          widget.pessoal ? currentUserUid : FFAppState().alunotemp.alunoUuid,
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        CabecaFolha(
          titulo: 'Novo objetivo',
          apoio: widget.pessoal
              ? 'Você acompanha o progresso e edita quando quiser.'
              : 'O aluno vê este objetivo no perfil dele.',
          icone: Icons.flag_rounded,
        ),
        CampoFolha(
          primeiro: true,
          rotulo: 'Título',
          dica: 'Ex: Ganhar 3kg de massa',
          controlador: _model.txtTituloTextController,
          foco: _model.txtTituloFocusNode,
          autofoco: true,
          validador: _model.txtTituloTextControllerValidator,
        ),
        CampoFolha(
          rotulo: 'Descrição',
          dica: 'O que precisa acontecer para chegar lá',
          controlador: _model.txtDescricaoTextController,
          foco: _model.txtDescricaoFocusNode,
          linhas: 3,
          validador: _model.txtDescricaoTextControllerValidator,
        ),
      ],
    );
  }
}

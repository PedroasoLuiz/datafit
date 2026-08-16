import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'alunos_editar_objetivo_model.dart';
export 'alunos_editar_objetivo_model.dart';

class AlunosEditarObjetivoWidget extends StatefulWidget {
  const AlunosEditarObjetivoWidget({
    super.key,
    required this.metas,
    bool? pessoal,
  }) : pessoal = pessoal ?? false;

  final MetasStruct? metas;

  /// `true` quando é o próprio dono editando. Muda só a cor de destaque.
  final bool pessoal;

  @override
  State<AlunosEditarObjetivoWidget> createState() =>
      _AlunosEditarObjetivoWidgetState();
}

class _AlunosEditarObjetivoWidgetState
    extends State<AlunosEditarObjetivoWidget> {
  late AlunosEditarObjetivoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlunosEditarObjetivoModel());

    _model.txtTituloTextController ??=
        TextEditingController(text: widget.metas?.titulo ?? '');
    _model.txtTituloFocusNode ??= FocusNode();
    _model.txtDescricaoTextController ??=
        TextEditingController(text: widget.metas?.descricao ?? '');
    _model.txtDescricaoFocusNode ??= FocusNode();
    _model.sliderValue ??= (widget.metas?.progresso ?? 0).toDouble();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<Object?> _gravar() async {
    final titulo = _model.txtTituloTextController?.text.trim() ?? '';
    if (titulo.isEmpty) return null;

    await MetasTable().update(
      data: {
        'Titulo': titulo,
        'Descricao': _model.txtDescricaoTextController?.text.trim() ?? '',
        'Progresso': (_model.sliderValue ?? 0).clamp(0, 100).toInt(),
      },
      matchingRows: (linhas) => linhas.eqOrNull('Id', widget.metas?.metaId),
    );

    return true;
  }

  /// Excluir passa pela folha de confirmação do app.
  ///
  /// A meta some da lista do aluno junto com o histórico de progresso, e não
  /// há como desfazer. Uma pergunta antes é o mínimo que a ação pede.
  Future<void> _excluir() async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (folha) => WebViewAware(
        child: MensagemWidget(
          texto: 'Excluir meta?',
          textoauxiliar: 'Essa ação é irreversível.',
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: true,
          action: () async {
            await MetasTable().delete(
              matchingRows: (linhas) =>
                  linhas.eqOrNull('Id', widget.metas?.metaId),
            );
            if (!mounted) return;
            await FolhaPadrao.fechar(context, true);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final destaque = widget.pessoal ? tema.primary : tema.secondary;

    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        CabecaFolha(
          titulo: 'Editar objetivo',
          apoio: 'Ajuste o texto e marque quanto já andou.',
          icone: Icons.flag_rounded,
          corIcone: destaque,
        ),
        CampoFolha(
          primeiro: true,
          rotulo: 'Título',
          dica: 'Ex: Ganhar 3kg de massa',
          controlador: _model.txtTituloTextController,
          foco: _model.txtTituloFocusNode,
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
        ProgressoFolha(
          rotulo: 'Conclusão',
          valor: _model.sliderValue ?? 0.0,
          cor: destaque,
          aoMudar: (novo) => safeSetState(() => _model.sliderValue = novo),
        ),
        AcaoDestrutivaFolha(texto: 'Excluir meta', aoTocar: _excluir),
      ],
    );
  }
}

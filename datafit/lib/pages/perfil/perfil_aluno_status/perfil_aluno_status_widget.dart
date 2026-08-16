import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'perfil_aluno_status_model.dart';
export 'perfil_aluno_status_model.dart';

class PerfilAlunoStatusWidget extends StatefulWidget {
  const PerfilAlunoStatusWidget({super.key});

  @override
  State<PerfilAlunoStatusWidget> createState() =>
      _PerfilAlunoStatusWidgetState();
}

class _PerfilAlunoStatusWidgetState extends State<PerfilAlunoStatusWidget> {
  late PerfilAlunoStatusModel _model;

  /// Trava enquanto a troca corre. Dois toques seguidos mandavam dois toggles
  /// e o vínculo voltava ao que era, dando a impressão de que nada mudou.
  bool _trocando = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilAlunoStatusModel());
    _model.switchValue = FFAppState().alunotemp.ativo;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  /// Liga e desliga o vínculo com este aluno.
  ///
  /// A RPC do banco é um toggle: ela lê o estado gravado e inverte. Por isso o
  /// que a tela manda não é o valor novo, e sim "inverta". Depois ela relê o
  /// perfil, para o botão refletir o que ficou gravado e não o que se supunha
  /// que ficaria.
  Future<void> _trocarStatus(bool novo) async {
    if (_trocando) return;
    safeSetState(() {
      _trocando = true;
      _model.switchValue = novo;
    });

    final resposta = await PersonalGroup.statusAlunoCall.call(
      uuidPersonal: currentUserUid,
      uuidAluno: FFAppState().alunotemp.alunoUuid,
    );

    if (!mounted) return;

    // `?? true` era o que escondia a falha: uma resposta nula passava por
    // sucesso, a folha fechava e o vínculo continuava como estava.
    if (resposta.succeeded != true) {
      safeSetState(() {
        _trocando = false;
        _model.switchValue = !novo;
      });
      await _avisar('Não consegui alterar o status agora. Tente de novo.');
      return;
    }

    await action_blocks.getPerfilAluno(
      context,
      alunoId: FFAppState().alunotemp.alunoUuid,
    );
    if (!mounted) return;

    await action_blocks.alunosdopersonal(context, uuidpersonal: currentUserUid);
    if (!mounted) return;

    safeSetState(() {
      _trocando = false;
      _model.switchValue = FFAppState().alunotemp.ativo;
    });
  }

  Future<void> _avisar(String texto) async {
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (folha) => WebViewAware(
        child: MensagemWidget(
          texto: texto,
          tipo: '2',
          fechasozinho: false,
          mostrabotoes: false,
          action: () async {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final ativo = _model.switchValue ?? true;
    final aluno = FFAppState().alunotemp;

    return FolhaPadrao(
      // Sem visto: a chave já grava sozinha. Um botão de confirmar pediria
      // uma segunda decisão sobre algo que a tela mostra como já resolvido.
      filhos: [
        CabecaFolha(
          titulo: 'Status do aluno',
          apoio: aluno.nome.isEmpty ? null : aluno.nome,
          icone: FFIcons.kproperty1FiRrSettings,
          corIcone: ativo ? tema.success : tema.error,
        ),
        ChaveFolha(
          titulo: ativo ? 'Aluno ativo' : 'Aluno inativo',
          apoio: ativo
              ? 'Ele vê os treinos e recebe suas cobranças.'
              : 'Ele perde o acesso aos treinos até você reativar.',
          ligada: ativo,
          aoMudar: _trocando ? (_) {} : _trocarStatus,
        ),
        if (_trocando)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                MedidasFolha.lado, 14.0, MedidasFolha.lado, 0.0),
            child: Row(
              children: [
                SizedBox(
                  width: 14.0,
                  height: 14.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(tema.primary),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Salvando...',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/unidade_carga.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

/// Abre a folha de preferências.
Future<void> abrirPreferencias(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (folha) => const WebViewAware(child: _FolhaPreferencias()),
  );
}

class _FolhaPreferencias extends StatefulWidget {
  const _FolhaPreferencias();

  @override
  State<_FolhaPreferencias> createState() => _FolhaPreferenciasState();
}

class _FolhaPreferenciasState extends State<_FolhaPreferencias> {
  late bool _libras = usaLibras;
  late bool _treino = FFAppState().perfil.pushTreino;
  late bool _cobranca = FFAppState().perfil.pushCobranca;
  late bool _convite = FFAppState().perfil.pushConvite;

  bool _salvando = false;
  bool _falhou = false;

  /// Grava a mudança na hora, sem botão de salvar.
  ///
  /// São preferências de um toque: um botão "salvar" no rodapé faria a pessoa
  /// mexer no controle e ainda ter de confirmar. Falhando, o valor volta e o
  /// aviso aparece; o contrário deixaria a tela dizendo uma coisa e o banco
  /// guardando outra.
  Future<void> _gravar(
      Map<String, dynamic> campos, VoidCallback desfazer) async {
    setState(() {
      _salvando = true;
      _falhou = false;
    });
    try {
      await PerfisTable().update(
        data: campos,
        matchingRows: (linhas) => linhas.eqOrNull('idUser', currentUserUid),
      );
      FFAppState().update(() {
        if (campos.containsKey('Unidade')) {
          FFAppState().perfil.unidade = campos['Unidade'] as String;
        }
        if (campos.containsKey('PushTreino')) {
          FFAppState().perfil.pushTreino = campos['PushTreino'] as bool;
        }
        if (campos.containsKey('PushCobranca')) {
          FFAppState().perfil.pushCobranca = campos['PushCobranca'] as bool;
        }
        if (campos.containsKey('PushConvite')) {
          FFAppState().perfil.pushConvite = campos['PushConvite'] as bool;
        }
      });
    } catch (_) {
      if (!mounted) return;
      desfazer();
      setState(() => _falhou = true);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _trocarUnidade(String opcao) {
    if (_salvando) return;
    final novoLibras = opcao.startsWith('Libras');
    if (novoLibras == _libras) return;

    final anterior = _libras;
    setState(() => _libras = novoLibras);
    _gravar(
      {'Unidade': novoLibras ? 'lb' : 'kg'},
      () => setState(() => _libras = anterior),
    );
  }

  void _trocarAviso(String campo, bool valor, void Function(bool) aplicar) {
    if (_salvando) return;
    final anterior = !valor;
    setState(() => aplicar(valor));
    _gravar({campo: valor}, () => setState(() => aplicar(anterior)));
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return FolhaPadrao(
      // Sem visto: cada controle já grava sozinho.
      filhos: [
        const CabecaFolha(
          titulo: 'Preferências',
          apoio: 'Valem só para você, neste aparelho e nos próximos.',
          icone: Icons.tune_rounded,
        ),
        EscolhaFolha(
          primeiro: true,
          rotulo: 'Unidade de carga',
          opcoes: const ['Quilos (kg)', 'Libras (lb)'],
          escolhida: _libras ? 'Libras (lb)' : 'Quilos (kg)',
          aoEscolher: _trocarUnidade,
        ),
        _apoio(
            tema,
            'Vale para o que você vê. O histórico continua guardado em quilos, '
            'então trocar aqui não bagunça os gráficos.'),
        const DivisoriaFolha(),
        _secao(tema, 'Avisos no celular'),
        _apoio(
            tema,
            'Desligar aqui não desliga o app: você continua vendo tudo na tela '
            'de notificações.'),
        ChaveFolha(
          titulo: 'Treinos',
          apoio: 'Treino novo e lembrete do dia',
          ligada: _treino,
          aoMudar: (v) => _trocarAviso('PushTreino', v, (x) => _treino = x),
        ),
        ChaveFolha(
          titulo: 'Cobranças',
          apoio: 'Vencimento e confirmação de pagamento',
          ligada: _cobranca,
          aoMudar: (v) => _trocarAviso('PushCobranca', v, (x) => _cobranca = x),
        ),
        ChaveFolha(
          titulo: 'Convites',
          apoio: 'Quando um personal te convida',
          ligada: _convite,
          aoMudar: (v) => _trocarAviso('PushConvite', v, (x) => _convite = x),
        ),
        if (_falhou)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                MedidasFolha.lado, 16.0, MedidasFolha.lado, 0.0),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
              decoration: BoxDecoration(
                color: tema.error.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Não consegui salvar. Verifique sua conexão e tente de novo.',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  color: tema.error,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  lineHeight: 1.35,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _secao(FlutterFlowTheme tema, String texto) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            MedidasFolha.lado, 4.0, MedidasFolha.lado, 0.0),
        child: Text(
          texto,
          style: tema.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
            color: tema.primaryText,
            fontSize: 15.0,
            letterSpacing: -0.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _apoio(FlutterFlowTheme tema, String texto) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            MedidasFolha.lado, 6.0, MedidasFolha.lado, 0.0),
        child: Text(
          texto,
          style: tema.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w400),
            color: tema.secondaryText,
            fontSize: 11.5,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w400,
            lineHeight: 1.4,
          ),
        ),
      );
}

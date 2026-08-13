/// Preferências do app: unidade de carga e avisos por push.
///
/// As duas moram no perfil e já eram lidas pelo app — a unidade pela tela de
/// execução, o push pelo servidor no momento do envio —, mas nenhuma tinha
/// onde ser mudada. A unidade só podia ser trocada no seletor ao lado do
/// campo de peso, que vale para aquela digitação e não para o perfil; o push
/// só podia ser desligado no sistema operacional, o que derrubava todos os
/// tipos de aviso de uma vez.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/unidade_carga.dart';

/// Abre a folha de preferências.
Future<void> abrirPreferencias(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _FolhaPreferencias(),
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
  /// aviso aparece — o contrário deixaria a tela dizendo uma coisa e o banco
  /// guardando outra.
  Future<void> _gravar(Map<String, dynamic> campos, VoidCallback desfazer) async {
    setState(() {
      _salvando = true;
      _falhou = false;
    });
    try {
      await PerfisTable().update(
        data: campos,
        matchingRows: (rows) => rows.eqOrNull('idUser', currentUserUid),
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

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Preferências',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primaryText,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded,
                      color: tema.secondaryText, size: 22.0),
                ),
              ],
            ),

            _titulo(tema, 'Unidade de carga'),
            Text(
              'Vale para o que você vê. O histórico continua guardado em quilos, então trocar aqui não bagunça os gráficos.',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                lineHeight: 1.35,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: _Opcao(
                    texto: 'Quilos (kg)',
                    selecionado: !_libras,
                    onTap: _salvando
                        ? null
                        : () {
                            final antes = _libras;
                            setState(() => _libras = false);
                            _gravar({'Unidade': 'kg'},
                                () => setState(() => _libras = antes));
                          },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _Opcao(
                    texto: 'Libras (lb)',
                    selecionado: _libras,
                    onTap: _salvando
                        ? null
                        : () {
                            final antes = _libras;
                            setState(() => _libras = true);
                            _gravar({'Unidade': 'lb'},
                                () => setState(() => _libras = antes));
                          },
                  ),
                ),
              ],
            ),

            _titulo(tema, 'Avisos no celular'),
            Text(
              'Desligar aqui não desliga o app — você continua vendo tudo na tela de notificações.',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                lineHeight: 1.35,
              ),
            ),
            const SizedBox(height: 4.0),
            _Chave(
              texto: 'Treinos',
              detalhe: 'Treino novo e lembrete do dia',
              valor: _treino,
              onChanged: _salvando
                  ? null
                  : (v) {
                      final antes = _treino;
                      setState(() => _treino = v);
                      _gravar({'PushTreino': v},
                          () => setState(() => _treino = antes));
                    },
            ),
            _Chave(
              texto: 'Cobranças',
              detalhe: 'Vencimento e confirmação de pagamento',
              valor: _cobranca,
              onChanged: _salvando
                  ? null
                  : (v) {
                      final antes = _cobranca;
                      setState(() => _cobranca = v);
                      _gravar({'PushCobranca': v},
                          () => setState(() => _cobranca = antes));
                    },
            ),
            _Chave(
              texto: 'Convites',
              detalhe: 'Quando um personal te convida',
              valor: _convite,
              onChanged: _salvando
                  ? null
                  : (v) {
                      final antes = _convite;
                      setState(() => _convite = v);
                      _gravar({'PushConvite': v},
                          () => setState(() => _convite = antes));
                    },
            ),

            if (_falhou)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Text(
                  'Não consegui salvar agora. Tente de novo.',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: tema.error,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _titulo(FlutterFlowTheme tema, String texto) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 6.0),
        child: Text(
          texto,
          style: tema.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            color: tema.primaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

/// Uma das duas unidades.
class _Opcao extends StatelessWidget {
  const _Opcao({
    required this.texto,
    required this.selecionado,
    required this.onTap,
  });

  final String texto;
  final bool selecionado;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 44.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selecionado ? tema.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: selecionado ? tema.primary : tema.alternate,
              width: 1.0,
            ),
          ),
          child: Text(
            texto,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: selecionado ? Colors.white : tema.primaryText,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Uma linha com chave liga/desliga.
class _Chave extends StatelessWidget {
  const _Chave({
    required this.texto,
    required this.detalhe,
    required this.valor,
    required this.onChanged,
  });

  final String texto;
  final String detalhe;
  final bool valor;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  texto,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: tema.primaryText,
                    fontSize: 13.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detalhe,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 11.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: valor,
            onChanged: onChanged,
            activeColor: tema.primary,
          ),
        ],
      ),
    );
  }
}

/// Folha para escrever o feedback do treino.
///
/// O campo morava numa seção própria no fim da tela de detalhes, depois da
/// lista inteira de exercícios: para escrever era preciso rolar por tudo, e
/// quem chegava até lá já tinha passado pelo botão de concluir. Numa folha,
/// ele é chamado de onde o convite está — no cartão de progresso — e some
/// quando termina.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FolhaFeedbackTreino extends StatefulWidget {
  const FolhaFeedbackTreino({
    super.key,
    required this.controlador,
    required this.aoSalvar,
  });

  final TextEditingController controlador;

  /// Devolve `true` se o banco aceitou. Falhando, a folha continua aberta com
  /// o texto — fechar levaria embora o que a pessoa acabou de escrever.
  final Future<bool> Function(String texto) aoSalvar;

  @override
  State<FolhaFeedbackTreino> createState() => _FolhaFeedbackTreinoState();
}

class _FolhaFeedbackTreinoState extends State<FolhaFeedbackTreino> {
  bool _salvando = false;
  bool _falhou = false;

  Future<void> _salvar() async {
    setState(() {
      _salvando = true;
      _falhou = false;
    });
    final ok = await widget.aoSalvar(widget.controlador.text.trim());
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _salvando = false;
      _falhou = true;
    });
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
                    'Como foi este treino?',
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
            const SizedBox(height: 4.0),
            Text(
              'O que você escrever aqui vai para o seu personal.',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 12.5,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: tema.primaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: tema.alternate, width: 1.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: TextFormField(
                controller: widget.controlador,
                autofocus: true,
                maxLines: 5,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Pesos, dores, o que rendeu, o que travou...',
                  hintStyle: tema.labelMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                  ),
                ),
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  color: tema.primaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (_falhou)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Text(
                  'Não consegui salvar agora. Tente de novo.',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.error,
                    fontSize: 12.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 44.0,
              child: Material(
                color: tema.primary,
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: _salvando ? null : _salvar,
                  child: Center(
                    child: _salvando
                        ? const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Salvar',
                            style: tema.titleSmall.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: Colors.white,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

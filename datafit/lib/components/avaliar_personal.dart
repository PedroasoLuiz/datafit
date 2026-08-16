/// O aluno dá a nota ao personal.
///
/// Uma folha, não uma tela: avaliar é um ato curto, e tirar a pessoa da ficha
/// para isso faria a nota parecer um formulário. Ao voltar, a ficha já mostra
/// a nota nova.
///
/// Reavaliar é permitido de propósito. Uma nota dada no primeiro mês não vale
/// para sempre, e travar a mudança só empurraria quem mudou de opinião para o
/// silêncio. No banco é a mesma linha sendo atualizada — por isso a chave
/// única por par, e não um histórico.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/components/perfil_kit.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Abre a folha. Devolve a nota gravada, ou nulo se a pessoa desistiu.
Future<int?> avaliarPersonal(
  BuildContext context, {
  required String personalUuid,
  required String personalNome,
  int notaAtual = 0,
}) {
  return showModalBottomSheet<int>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FolhaAvaliar(
      personalUuid: personalUuid,
      personalNome: personalNome,
      notaAtual: notaAtual,
    ),
  );
}

class _FolhaAvaliar extends StatefulWidget {
  const _FolhaAvaliar({
    required this.personalUuid,
    required this.personalNome,
    required this.notaAtual,
  });

  final String personalUuid;
  final String personalNome;
  final int notaAtual;

  @override
  State<_FolhaAvaliar> createState() => _FolhaAvaliarState();
}

class _FolhaAvaliarState extends State<_FolhaAvaliar> {
  late int _nota = widget.notaAtual;
  late final TextEditingController _comentario = TextEditingController();
  bool _enviando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    if (widget.notaAtual > 0) _carregarComentarioAnterior();
  }

  /// Traz de volta o que a pessoa escreveu da última vez.
  ///
  /// Sem isto, reavaliar apagava o comentário anterior: o campo abria vazio e,
  /// ao salvar, o texto antigo era substituído por nada — a pessoa perdia o
  /// que escreveu sem ter pedido para apagar.
  ///
  /// Buscado aqui, e não trazido no payload da ficha: comentário é texto
  /// longo, só interessa a quem abre esta folha, e carregá-lo em toda abertura
  /// de perfil seria pagar por ele o tempo todo.
  Future<void> _carregarComentarioAnterior() async {
    try {
      final r = await SupaFlow.client.rpc('minha_avaliacao_personal',
          params: {'p_personal_uuid': widget.personalUuid});
      final mapa = (r as Map?)?.cast<String, dynamic>();
      final texto = mapa?['comentario'];
      if (!mounted || texto == null) return;
      // Só preenche se a pessoa ainda não começou a escrever: a busca pode
      // voltar depois de ela ter digitado, e sobrescrever seria pior que
      // abrir vazio.
      if (_comentario.text.isEmpty) _comentario.text = '$texto';
    } catch (_) {
      // Sem o texto anterior a folha abre vazia, como abria antes.
    }
  }

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  /// O que cada nota quer dizer, escrito.
  ///
  /// Sem isto, cinco estrelas são cinco pontos sem régua: o que é 3 para uma
  /// pessoa é 4 para outra, e a média deixa de significar a mesma coisa.
  static const _leituras = [
    '',
    'Muito abaixo do que eu esperava',
    'Abaixo do que eu esperava',
    'Atendeu o combinado',
    'Acima do que eu esperava',
    'Muito acima do que eu esperava',
  ];

  Future<void> _enviar() async {
    if (_nota < 1 || _enviando) return;
    setState(() {
      _enviando = true;
      _erro = null;
    });

    try {
      final resposta = await SupaFlow.client.rpc('avaliar_personal', params: {
        'p_personal_uuid': widget.personalUuid,
        'p_nota': _nota,
        'p_comentario': _comentario.text.trim(),
      });

      final mapa = (resposta as Map?)?.cast<String, dynamic>() ?? {};
      if (mapa['sucesso'] != true) {
        if (!mounted) return;
        setState(() {
          _enviando = false;
          // Mensagens por causa, nao uma so generica: "sem vinculo" e um
          // impedimento permanente e "falhou" e para tentar de novo — mandar
          // as duas para o mesmo texto faria alguem tentar para sempre.
          _erro = mapa['erro'] == 'SEM_VINCULO'
              ? 'Só quem treina ou já treinou com este personal pode avaliar.'
              : 'Não consegui enviar sua avaliação. Tente de novo.';
        });
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop(_nota);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _erro = 'Não consegui enviar sua avaliação. Tente de novo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      // O teclado empurra a folha em vez de cobrir o campo de comentário.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: tema.alternate,
                      borderRadius: BorderRadius.circular(999.0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 2.0),
                  child: Text(
                    widget.notaAtual > 0
                        ? 'Mudar sua avaliação'
                        : 'Avaliar ${widget.personalNome}',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primaryText,
                      fontSize: 17.0,
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Sua nota aparece no perfil dele, junto com as demais.',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                    color: tema.secondaryText,
                    fontSize: 12.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                // As estrelas grandes, centradas: é a única decisão da folha.
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 22.0, 0.0, 0.0),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 1; i <= 5; i++)
                          InkWell(
                            onTap: () => setState(() => _nota = i),
                            borderRadius: BorderRadius.circular(999.0),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                // Contorno nas cinco: quem marca a nota e a
                                // cor, como no resto do app.
                                Icons.star_rounded,
                                size: 38.0,
                                color: i <= _nota ? corEstrela : tema.alternate,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 22.0,
                  child: Center(
                    child: Text(
                      _leituras[_nota],
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: tema.warning,
                        fontSize: 12.5,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tema.primaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [tema.designToken.shadow.lg],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: TextFormField(
                      controller: _comentario,
                      maxLines: 3,
                      minLines: 2,
                      maxLength: 300,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Conte o que fez a diferença (opcional)',
                        counterText: '',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 14.0, 0.0, 14.0),
                        hintStyle: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                          color: tema.secondaryText,
                          fontSize: 13.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        color: tema.primaryText,
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                if (_erro != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        2.0, 12.0, 2.0, 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: tema.error, size: 16.0),
                        const SizedBox(width: 7.0),
                        Expanded(
                          child: Text(
                            _erro!,
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500),
                              color: tema.error,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: InkWell(
                    onTap: _nota < 1 ? null : _enviar,
                    borderRadius: BorderRadius.circular(13.0),
                    child: Container(
                      height: 46.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // Apagado enquanto nao ha nota: o botao so promete
                        // enviar quando existe algo para enviar.
                        color: _nota < 1 ? tema.alternate : tema.primary,
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: _enviando
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              widget.notaAtual > 0
                                  ? 'Salvar avaliação'
                                  : 'Enviar avaliação',
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                color: _nota < 1
                                    ? tema.secondaryText
                                    : Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

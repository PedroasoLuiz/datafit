import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/components/perfil_kit.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

/// Folha de avaliação do personal pelo aluno. Devolve a nota dada.
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
    builder: (folha) => WebViewAware(
      child: Padding(
        padding: MediaQuery.viewInsetsOf(folha),
        child: _FolhaAvaliar(
          personalUuid: personalUuid,
          personalNome: personalNome,
          notaAtual: notaAtual,
        ),
      ),
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
  String? _erro;

  @override
  void initState() {
    super.initState();
    if (widget.notaAtual > 0) _carregarComentarioAnterior();
  }

  /// Traz de volta o que a pessoa escreveu da última vez.
  ///
  /// Sem isto, reavaliar apagava o comentário anterior: o campo abria vazio e,
  /// ao salvar, o texto antigo era substituído por nada. A pessoa perdia o que
  /// escreveu sem ter pedido para apagar.
  ///
  /// Buscado aqui, e não trazido no payload da ficha: comentário é texto
  /// longo, só interessa a quem abre esta folha, e carregá-lo em toda abertura
  /// de perfil seria pagar por ele o tempo todo.
  Future<void> _carregarComentarioAnterior() async {
    try {
      final resposta = await SupaFlow.client.rpc('minha_avaliacao_personal',
          params: {'p_personal_uuid': widget.personalUuid});
      final mapa = (resposta as Map?)?.cast<String, dynamic>();
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

  Future<Object?> _enviar() async {
    // Sem nota não há avaliação: o comentário sozinho não entra na média e
    // não teria onde aparecer.
    if (_nota < 1) return null;

    setState(() => _erro = null);

    try {
      final resposta = await SupaFlow.client.rpc('avaliar_personal', params: {
        'p_personal_uuid': widget.personalUuid,
        'p_nota': _nota,
        'p_comentario': _comentario.text.trim(),
      });

      final mapa = (resposta as Map?)?.cast<String, dynamic>() ?? {};
      if (mapa['sucesso'] == true) return _nota;

      if (!mounted) return null;
      setState(() {
        // Mensagens por causa, não uma só genérica: "sem vínculo" é um
        // impedimento permanente e "falhou" é para tentar de novo. Mandar as
        // duas para o mesmo texto faria alguém tentar para sempre.
        _erro = mapa['erro'] == 'SEM_VINCULO'
            ? 'Só quem treina ou já treinou com este personal pode avaliar.'
            : 'Não consegui enviar sua avaliação. Tente de novo.';
      });
      return null;
    } catch (_) {
      if (!mounted) return null;
      setState(
          () => _erro = 'Não consegui enviar sua avaliação. Tente de novo.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return FolhaPadrao(
      aoConfirmar: _enviar,
      filhos: [
        CabecaFolha(
          titulo:
              widget.notaAtual > 0 ? 'Editar avaliação' : 'Avaliar personal',
          apoio: widget.personalNome,
          icone: Icons.star_rounded,
          corIcone: corEstrela,
        ),
        // As estrelas grandes e centralizadas: são a pergunta da folha, e o
        // comentário é opcional. Alinhadas à esquerda como um campo comum,
        // elas pesavam o mesmo que o texto de apoio.
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              MedidasFolha.lado, 4.0, MedidasFolha.lado, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    InkWell(
                      onTap: () => setState(() => _nota = i),
                      borderRadius: BorderRadius.circular(999.0),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.star_rounded,
                          size: 38.0,
                          color: i <= _nota ? corEstrela : tema.alternate,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6.0),
              // Altura reservada: sem nota o texto some, e a folha inteira
              // saltava para cima no primeiro toque.
              SizedBox(
                height: 18.0,
                child: Text(
                  _nota > 0 ? _leituras[_nota] : 'Toque nas estrelas',
                  textAlign: TextAlign.center,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(
                        fontWeight:
                            _nota > 0 ? FontWeight.w600 : FontWeight.w400),
                    color: _nota > 0 ? tema.primaryText : tema.secondaryText,
                    fontSize: 12.5,
                    letterSpacing: 0.0,
                    fontWeight: _nota > 0 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        CampoFolha(
          rotulo: 'Comentário (opcional)',
          dica: 'O que funcionou, o que faltou...',
          controlador: _comentario,
          linhas: 3,
        ),
        if (_erro != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                MedidasFolha.lado, 14.0, MedidasFolha.lado, 0.0),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
              decoration: BoxDecoration(
                color: tema.error.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                _erro!,
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
}

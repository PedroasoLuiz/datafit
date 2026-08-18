/// Feedback sobre o app, aberto pelo menu do usuário.
///
/// Não confundir com `avaliar_personal.dart`: lá o aluno dá nota ao personal
/// dele, e a nota é pública no perfil do personal. Aqui a pessoa fala do
/// Datafit, e o que ela escreve só volta para ela e para a triagem.
///
/// O que vai junto sem ser digitado: plataforma e versão do app. Sem isso um
/// "trava ao salvar o treino" não diz em qual build travou, e a mesma frase
/// pode ser de uma versão já corrigida.
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/folha_kit.dart';
import '/components/mensagem_widget.dart';
import '/components/perfil_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

/// Abre a folha de feedback. Devolve `true` quando algo foi enviado.
Future<bool> abrirFeedbackApp(BuildContext context) async {
  final enviado = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (folha) => WebViewAware(
      child: Padding(
        padding: MediaQuery.viewInsetsOf(folha),
        child: const _FolhaFeedback(),
      ),
    ),
  );

  if (enviado != true || !context.mounted) return false;

  // O agradecimento vem depois da folha fechar, e não dentro dela: a folha
  // some no mesmo gesto do envio, e um aviso desenhado por cima do que já
  // está saindo pisca e desaparece.
  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (aviso) => MensagemWidget(
      texto: 'Recebido. Obrigado por escrever.',
      textoauxiliar: 'Lemos tudo o que chega por aqui.',
      tipo: '1',
      action: () async {},
      fechasozinho: true,
      mostrabotoes: false,
    ),
  );
  return true;
}

/// Os assuntos, na ordem em que costumam aparecer.
///
/// Rótulo e código separados: o rótulo é o que a pessoa lê e pode mudar; o
/// código é o que fica gravado e pelo qual a triagem filtra.
const _tipos = <String, String>{
  'Sugestão': 'sugestao',
  'Problema': 'problema',
  'Elogio': 'elogio',
  'Outro': 'outro',
};

/// A dica do campo muda com o assunto: "conte o que aconteceu" não ajuda quem
/// veio elogiar, e uma dica genérica não ajuda ninguém.
const _dicas = <String, String>{
  'sugestao': 'O que faria o app servir melhor pra você?',
  'problema': 'O que você fez, o que esperava e o que aconteceu.',
  'elogio': 'O que está funcionando bem?',
  'outro': 'Escreva à vontade.',
};

/// Teto do texto. Acima disso não é mais um recado, e a caixa de triagem
/// deixa de ser legível.
const _limiteMensagem = 1000;

class _FolhaFeedback extends StatefulWidget {
  const _FolhaFeedback();

  @override
  State<_FolhaFeedback> createState() => _FolhaFeedbackState();
}

class _FolhaFeedbackState extends State<_FolhaFeedback> {
  String _tipo = 'Sugestão';
  int _nota = 0;
  final TextEditingController _mensagem = TextEditingController();
  late final TextEditingController _contato =
      TextEditingController(text: currentUserEmail);

  String? _erro;
  int _escrito = 0;

  List<Map<String, dynamic>> _anteriores = const [];

  /// Plataforma e versão, montadas uma vez na abertura.
  ///
  /// Buscadas aqui e não no momento do envio: `PackageInfo.fromPlatform` é
  /// assíncrono, e esperar por ele com o dedo já no visto atrasaria o envio
  /// por um dado que não é o assunto.
  String? _versao;
  final String _plataforma = kIsWeb
      ? 'web'
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => 'android',
          TargetPlatform.iOS => 'ios',
          final outra => outra.name,
        };

  @override
  void initState() {
    super.initState();
    _mensagem.addListener(_contarEscrito);
    _carregarVersao();
    _carregarAnteriores();
  }

  @override
  void dispose() {
    _mensagem.removeListener(_contarEscrito);
    _mensagem.dispose();
    _contato.dispose();
    super.dispose();
  }

  void _contarEscrito() {
    final agora = _mensagem.text.characters.length;
    if (!mounted || agora == _escrito) return;
    setState(() => _escrito = agora);
  }

  Future<void> _carregarVersao() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _versao = '${info.version}+${info.buildNumber}');
    } catch (_) {
      // Sem a versão o feedback ainda vale; a triagem só perde o build.
    }
  }

  Future<void> _carregarAnteriores() async {
    try {
      final resposta = await SupaFlow.client.rpc('meus_feedbacks_app');
      final lista = (resposta as List?) ?? const [];
      if (!mounted) return;
      setState(() => _anteriores = [
            for (final item in lista)
              if (item is Map) item.cast<String, dynamic>(),
          ]);
    } catch (_) {
      // Sem o histórico a folha abre só com o formulário, que é o essencial.
    }
  }

  Future<Object?> _enviar() async {
    final texto = _mensagem.text.trim();

    // Sem texto não há feedback: a nota sozinha diz que algo está bom ou ruim
    // e não diz o quê, e não daria para agir sobre ela.
    if (texto.isEmpty) {
      setState(() => _erro = 'Escreva o que você quer contar.');
      return null;
    }
    if (texto.characters.length > _limiteMensagem) {
      setState(() => _erro = 'Reduza para até $_limiteMensagem caracteres.');
      return null;
    }

    setState(() => _erro = null);

    try {
      final resposta = await SupaFlow.client.rpc('enviar_feedback_app', params: {
        'p_tipo': _tipos[_tipo],
        'p_mensagem': texto,
        'p_nota': _nota > 0 ? _nota : null,
        'p_contato': _contato.text.trim(),
        'p_plataforma': _plataforma,
        'p_versao': _versao,
      });

      final mapa = (resposta as Map?)?.cast<String, dynamic>() ?? {};
      if (mapa['sucesso'] == true) return true;

      if (!mounted) return null;
      debugPrint('feedback_app: servidor recusou com ${mapa['erro']}');
      setState(() {
        // Mensagem por causa: o limite diário é um "volte amanhã", sessão
        // perdida é "entre de novo", e o resto é "tente de novo".
        //
        // O motivo vai escrito no caso desconhecido. Sem ele, a recusa do
        // servidor e a exceção de rede mostravam a mesma frase, e não dava
        // para saber qual das duas aconteceu sem instrumentar de novo.
        _erro = switch (mapa['erro']) {
          'LIMITE_DIARIO' =>
            'Você já enviou 5 feedbacks hoje. Amanhã dá para escrever de novo.',
          'MENSAGEM_VAZIA' => 'Escreva o que você quer contar.',
          'SEM_SESSAO' =>
            'Sua sessão expirou. Saia e entre de novo para enviar.',
          final motivo =>
            'Não consegui enviar seu feedback ($motivo). Tente de novo.',
        };
      });
      return null;
    } on PostgrestException catch (erro) {
      if (!mounted) return null;
      // O código do Postgrest vai junto do texto: sem ele, "tente de novo" é a
      // mesma frase para função ausente, permissão negada e rede caída, e o
      // teste seguinte recomeça do zero. `debugPrint` para o log completo.
      debugPrint('feedback_app: ${erro.code} ${erro.message} ${erro.details}');
      setState(() => _erro =
          'Não consegui enviar seu feedback (${erro.code ?? 'postgrest'}). Tente de novo.');
      return null;
    } catch (erro) {
      if (!mounted) return null;
      debugPrint('feedback_app: $erro');
      setState(() => _erro =
          'Não consegui enviar seu feedback (${erro.runtimeType}). Tente de novo.');
      return null;
    }
  }

  /// O que cada nota quer dizer, escrito — a mesma régua da avaliação do
  /// personal, para que 3 signifique a mesma coisa nos dois lugares.
  static const _leituras = [
    '',
    'Muito abaixo do que eu esperava',
    'Abaixo do que eu esperava',
    'Atende o que preciso',
    'Acima do que eu esperava',
    'Muito acima do que eu esperava',
  ];

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final codigo = _tipos[_tipo] ?? 'outro';

    return FolhaPadrao(
      aoConfirmar: _enviar,
      filhos: [
        CabecaFolha(
          titulo: 'Enviar feedback',
          apoio: 'Sobre o app Datafit',
          icone: FFIcons.kproperty1FiRrComment,
          corIcone: tema.primary,
        ),
        EscolhaFolha(
          rotulo: 'Sobre o que é',
          opcoes: _tipos.keys.toList(),
          escolhida: _tipo,
          aoEscolher: (escolha) => setState(() => _tipo = escolha),
          primeiro: true,
        ),
        _estrelas(tema),
        CampoFolha(
          rotulo: 'Sua mensagem',
          dica: _dicas[codigo],
          controlador: _mensagem,
          linhas: 4,
          abaixo: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                '$_escrito/$_limiteMensagem',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: _escrito > _limiteMensagem
                      ? tema.error
                      : tema.secondaryText,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ),
        ),
        CampoFolha(
          rotulo: 'E-mail para resposta (opcional)',
          dica: 'seuemail@exemplo.com',
          controlador: _contato,
          teclado: TextInputType.emailAddress,
        ),
        if (_erro != null) _aviso(tema, _erro!),
        if (_anteriores.isNotEmpty) ...[
          const DivisoriaFolha(),
          _historico(tema),
        ],
      ],
    );
  }

  /// A nota é opcional e fica abaixo do assunto: quem veio relatar um problema
  /// não deveria ser barrado por não querer dar estrelas.
  Widget _estrelas(FlutterFlowTheme tema) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, MedidasFolha.entreCampos, MedidasFolha.lado, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RotuloFolha('Nota para o app (opcional)', ativo: _nota > 0),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                InkWell(
                  // Tocar de novo na estrela acesa apaga a nota: sem isso, quem
                  // tocou por engano não tinha como voltar ao "sem nota".
                  onTap: () => setState(() => _nota = _nota == i ? 0 : i),
                  borderRadius: BorderRadius.circular(999.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.star_rounded,
                      size: 34.0,
                      color: i <= _nota ? corEstrela : tema.alternate,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4.0),
          // Altura reservada: sem nota o texto some, e a folha inteira saltava
          // para cima no primeiro toque.
          SizedBox(
            width: double.infinity,
            height: 18.0,
            child: Text(
              _nota > 0 ? _leituras[_nota] : 'Toque nas estrelas',
              textAlign: TextAlign.center,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(
                    fontWeight: _nota > 0 ? FontWeight.w600 : FontWeight.w400),
                color: _nota > 0 ? tema.primaryText : tema.secondaryText,
                fontSize: 12.5,
                letterSpacing: 0.0,
                fontWeight: _nota > 0 ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aviso(FlutterFlowTheme tema, String texto) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, 14.0, MedidasFolha.lado, 0.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
        decoration: BoxDecoration(
          color: tema.error.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          texto,
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
    );
  }

  /// O que a pessoa já mandou, com o estado de cada envio.
  ///
  /// É o que evita a pergunta "será que chegou?" e o reenvio do mesmo texto
  /// três dias seguidos.
  Widget _historico(FlutterFlowTheme tema) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, 0.0, MedidasFolha.lado, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seus envios',
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: tema.primaryText,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10.0),
          for (final item in _anteriores) _linhaHistorico(tema, item),
        ],
      ),
    );
  }

  Widget _linhaHistorico(FlutterFlowTheme tema, Map<String, dynamic> item) {
    final status = '${item['status'] ?? 'novo'}';
    final (rotulo, cor) = switch (status) {
      'lido' => ('Lido', tema.primary),
      'respondido' => ('Respondido', tema.success),
      'arquivado' => ('Arquivado', tema.secondaryText),
      _ => ('Enviado', tema.secondaryText),
    };

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item['criadoEm'] ?? ''}',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(),
                    color: tema.secondaryText,
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                child: Text(
                  rotulo,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: cor,
                    fontSize: 10.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3.0),
          Text(
            '${item['mensagem'] ?? ''}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(),
              color: tema.primaryText,
              fontSize: 12.5,
              letterSpacing: 0.0,
              lineHeight: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

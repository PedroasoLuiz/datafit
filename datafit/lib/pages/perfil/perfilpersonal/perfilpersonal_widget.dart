/// A ficha do personal, vista pelo aluno.
///
/// A pergunta que traz alguém aqui é "posso confiar nesta pessoa, e como falo
/// e pago com ela?". Tudo na tela responde a isso, nessa ordem.
///
/// O que mudou em relação ao desenho anterior, e por quê:
///
/// **O CREF subiu para debaixo do nome**, em texto puro. É a credencial — o
/// único dado que sustenta confiança — e estava guardado no struct sem nunca
/// ser exibido. No lugar dele havia "Ativo há 2 horas", que é dado de sistema
/// ocupando a linha mais valiosa da tela.
///
/// **A nota tomou o lugar de "Exercícios" no trio.** Ninguém escolhe um
/// personal por ele ter 64 exercícios cadastrados. A quantidade de avaliações
/// vai junto do número: 5,0 com uma avaliação e 4,8 com vinte e três não são a
/// mesma informação.
///
/// **As abas viraram chips e o filtro saiu delas.** Antes a aba ativa virava
/// um dropdown e a inativa um botão, o que fazia navegação e filtro parecerem
/// a mesma coisa. Agora os chips são a navegação; o filtro por grupo muscular
/// mora no cabeçalho da grade e abre uma folha.
///
/// **A chave Pix saiu da lista de cobranças.** A chave é ferramenta
/// permanente, as cobranças são histórico. Misturadas, a chave parecia uma
/// cobrança sem valor.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/cache_curto.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/components/avaliar_personal.dart';
import '/components/foto_tela_cheia.dart';
import '/components/mensagem_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/components/perfil_kit.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/custom_code/functions/achatar_exercicios.dart';
import '/custom_code/functions/extrair_subcategorias.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/informar_pagamento/informar_pagamento_widget.dart';
import 'perfilpersonal_model.dart';

export 'perfilpersonal_model.dart';

class PerfilpersonalWidget extends StatefulWidget {
  const PerfilpersonalWidget({super.key, this.perosnal});

  /// Mantém o nome com o erro de digitação: é o parâmetro da rota, e renomear
  /// quebraria os links que já existem.
  final PerfilPersonalStruct? perosnal;

  static String routeName = 'perfilpersonal';
  static String routePath = '/perfilpersonal';

  @override
  State<PerfilpersonalWidget> createState() => _PerfilpersonalWidgetState();
}

/// "Avaliar" na capa, no lugar do "Editar perfil" da rede social.
///
/// Depois de avaliado ele passa a mostrar a propria nota e segue tocavel: a
/// pessoa precisa poder mudar de ideia sem procurar onde.
class _BotaoAvaliar extends StatelessWidget {
  const _BotaoAvaliar({required this.nota, required this.aoTocar});

  final int nota;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(999.0),
      child: Container(
        height: 34.0,
        padding: const EdgeInsetsDirectional.fromSTEB(11.0, 0.0, 12.0, 0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tema.primaryBackground,
          borderRadius: BorderRadius.circular(999.0),
          boxShadow: [tema.designToken.shadow.sm],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, color: corEstrela, size: 14.0),
            const SizedBox(width: 5.0),
            Text(
              nota > 0 ? 'Sua nota: $nota' : 'Avaliar',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.primaryText,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// O que está em aberto e como pagar, num cartão só.
///
/// O valor ocupa o corpo do cartão porque é a única coisa que traz alguém a
/// esta aba; a chave Pix fica no rodapé, separada por um risco, porque é o
/// caminho para resolver o que o número acabou de dizer — não outro assunto.
///
/// Antes eram duas linhas de lista iguais, e linha de lista trata tudo com o
/// mesmo peso: "R$ 250 em aberto" e "Chave Pix" pareciam dois itens de um
/// menu, quando um é o problema e o outro é a solução dele.
class _CartaoCobranca extends StatelessWidget {
  const _CartaoCobranca({
    this.valor,
    this.resumo,
    this.atrasado = false,
    this.chavePix = '',
    this.tipoPix = '',
    required this.aoCopiar,
  });

  final String? valor;
  final String? resumo;
  final bool atrasado;
  final String chavePix;
  final String tipoPix;
  final VoidCallback aoCopiar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    // O valor fica preto sempre. Quem conta o atraso e a flag ao lado do
    // rotulo — pintar tambem o numero dizia a mesma coisa duas vezes, e ainda
    // tirava do saldo a neutralidade que um numero de dinheiro precisa ter.

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (valor != null)
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Em aberto',
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: tema.secondaryText,
                          fontSize: 11.5,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (atrasado) ...[
                        const SizedBox(width: 7.0),
                        Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              7.0, 2.0, 7.0, 3.0),
                          decoration: BoxDecoration(
                            // Vermelho: atraso e a unica situacao da ficha
                            // com consequencia real, e o laranja daqui ja e a
                            // cor da sequencia de treinos.
                            color: tema.error.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          child: Text(
                            'Atrasado',
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: tema.error,
                              fontSize: 9.5,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 4.0, 0.0, 0.0),
                    child: Text.rich(
                      TextSpan(children: [
                        // O cifrao menor que o numero: ele nao e o dado, so a
                        // unidade dele.
                        TextSpan(
                          text: 'R\$ ',
                          style: tema.bodyMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w600),
                            color: tema.primaryText,
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: valor,
                          style: tema.bodyMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                            color: tema.primaryText,
                            fontSize: 30.0,
                            letterSpacing: -1.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  if ((resumo ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        resumo!,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                          color: tema.secondaryText,
                          fontSize: 11.5,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (chavePix.isNotEmpty)
            InkWell(
              onTap: aoCopiar,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(valor == null ? 16.0 : 0.0),
                bottom: const Radius.circular(16.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 16.0, 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tipoPix.isEmpty
                                ? 'Chave Pix'
                                : 'Chave Pix · $tipoPix',
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500),
                              color: tema.secondaryText,
                              fontSize: 10.5,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            chavePix,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: tema.primaryText,
                              fontSize: 13.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    // Icone, e nao a palavra: "Copiar" ao lado de uma chave ja
                    // truncada disputava largura com o proprio dado que se
                    // quer copiar.
                    Icon(FFIcons.kproperty1FiRrCopy,
                        color: tema.primary, size: 18.0),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PerfilpersonalWidgetState extends State<PerfilpersonalWidget> {
  late PerfilpersonalModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// 0 = vídeos, 1 = pagamento.
  int _aba = 0;

  /// Grupo muscular escolhido no filtro da grade.
  String _grupo = 'Todos';

  /// A ficha inteira, mantida aqui para a nota e as cobranças se atualizarem
  /// depois de avaliar ou informar um pagamento, sem sair da tela.
  late PerfilPersonalStruct _p = widget.perosnal ?? PerfilPersonalStruct();

  /// O histórico completo, carregado só quando pedido.
  List<PagamentosStruct>? _historicoCompleto;
  bool _carregandoHistorico = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilpersonalModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Recarrega a ficha depois de uma ação que muda o que ela mostra.
  Future<void> _recarregar() async {
    // Sem cache aqui: este metodo so roda depois de avaliar ou informar
    // pagamento, e o ponto dele e justamente ver o que mudou.
    CacheCurto.invalidar('perfil:');
    try {
      final resposta =
          await SupaFlow.client.rpc('get_perfil_personal_publico', params: {
        'p_personal_uuid': _p.id,
        'p_aluno_uuid': currentUserUid,
      });
      final novo = PerfilPersonalStruct.maybeFromMap(resposta);
      if (!mounted || novo == null) return;
      setState(() {
        _p = novo;
        // O histórico completo pode ter mudado junto; descartar força a
        // próxima abertura a buscar de novo em vez de mostrar o antigo.
        _historicoCompleto = null;
      });
    } catch (_) {
      // Recarregar é conveniência: se falhar, a tela segue com o que tem.
    }
  }

  Future<void> _verHistoricoCompleto() async {
    if (_carregandoHistorico) return;
    setState(() => _carregandoHistorico = true);
    try {
      final resposta =
          await SupaFlow.client.rpc('get_pagamentos_do_personal', params: {
        'p_personal_uuid': _p.id,
        'p_aluno_uuid': currentUserUid,
      });
      final lista = (resposta as List? ?? [])
          .map((e) => PagamentosStruct.maybeFromMap(e))
          .whereType<PagamentosStruct>()
          .toList();
      if (!mounted) return;
      setState(() {
        _historicoCompleto = lista;
        _carregandoHistorico = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregandoHistorico = false);
    }
  }

  Future<void> _avaliar() async {
    final nota = await avaliarPersonal(
      context,
      personalUuid: _p.id,
      personalNome: _p.nome,
      notaAtual: _p.minhaNota,
    );
    if (nota == null) return;
    await _recarregar();
  }

  Future<void> _copiarPix() async {
    await Clipboard.setData(ClipboardData(text: _p.chavePix));
    if (!mounted) return;
    await showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WebViewAware(
        child: MensagemWidget(
          texto: 'Chave Pix copiada!',
          tipo: '1',
          fechasozinho: true,
          mostrabotoes: false,
          action: () async {},
        ),
      ),
    );
  }

  /// Abre a folha do filtro por grupo muscular.
  ///
  /// Folha, e não uma segunda fileira de chips: duas fileiras empilhadas
  /// parecem as duas navegação, e ninguém descobre qual manda.
  Future<void> _escolherGrupo() async {
    final tema = FlutterFlowTheme.of(context);
    final grupos = ['Todos', ...extrairSubcategorias(_p.treinos)];

    final escolhido = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (contexto) => Container(
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
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      2.0, 18.0, 2.0, 12.0),
                  child: Text(
                    'Filtrar por grupo',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primaryText,
                      fontSize: 17.0,
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: CartaoPerfil(
                      filhos: [
                        for (final g in grupos)
                          LinhaPerfil(
                            titulo: g,
                            icone: g == _grupo
                                ? Icons.check_circle_outline_rounded
                                : Icons.circle_outlined,
                            corIcone:
                                g == _grupo ? tema.primary : tema.secondaryText,
                            fundoIcone: g == _grupo
                                ? tema.accent1
                                : tema.alternate.withValues(alpha: 0.35),
                            aoTocar: () => Navigator.of(contexto).pop(g),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (escolhido != null && mounted) setState(() => _grupo = escolhido);
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: tema.secondaryBackground,
        // O cabecalho flutua sobre a rolagem, sem fundo proprio.
        //
        // Antes havia uma faixa azul fixa no topo, para a capa alcancar a barra
        // de status. Faixa fixa nao rola: subindo o conteudo, sobrava um azul
        // parado atras do cabecalho — que nao e como capa se comporta. Agora
        // quem passa por tras da barra e a propria capa, e ela sobe junto.
        body: Stack(
          children: [
            // `top: false`: a rolagem comeca no topo absoluto, senao a capa
            // pararia embaixo da barra de status e o efeito se perderia.
            SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      // Sem recuo lateral: e o que deixa a capa e a grade de
                      // videos encostarem na borda. Cada secao aplica o seu.
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 140.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CapaPerfil(
                            // A capa cresce para tras da barra de status e do
                            // cabecalho, e rola junto com o conteudo.
                            alturaExtraTopo:
                                MediaQuery.paddingOf(context).top + 52.0,
                            nome: _p.nome,
                            foto: _p.fotoUrl,
                            // Nick e CREF na mesma linha, sob o nome. O nick
                            // identifica a pessoa e o CREF a credencia — juntos
                            // respondem "quem e" e "posso confiar" numa linha so.
                            // O CREF vai em primary porque e ele que carrega a
                            // confianca; sem ele cadastrado, some sozinho.
                            linha: TextSpan(children: [
                              if (_p.nickName.isNotEmpty)
                                TextSpan(text: '@${_p.nickName}'),
                              if (_p.nickName.isNotEmpty && _p.cref.isNotEmpty)
                                const TextSpan(text: '  ·  '),
                              if (_p.cref.isNotEmpty)
                                TextSpan(
                                  text: 'CREF ${_p.cref}',
                                  style: TextStyle(
                                    color: tema.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ]),
                            bio: _p.bio,
                            aoTocarFoto: _p.fotoUrl.isEmpty
                                ? null
                                : () => mostrarFotoEmTelaCheia(
                                      context,
                                      url: _p.fotoUrl,
                                      titulo: _p.nome,
                                    ),
                            // Contato à esquerda, avaliar à direita — a ação que a
                            // ficha quer que aconteça fica na ponta, onde o
                            // polegar chega primeiro.
                            acoes: [
                              if (_p.whatsapp.isNotEmpty) ...[
                                AcaoIconePerfil(
                                  // O glifo oficial do WhatsApp: o balao generico nao
                                  // diz para onde o toque leva, e aqui ele
                                  // leva para fora do app.
                                  desenho: FaIcon(FontAwesomeIcons.whatsapp,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 15.0),
                                  aoTocar: () => launchURL(
                                      'https://wa.me/55${_p.whatsapp}'),
                                ),
                                const SizedBox(width: 8.0),
                              ],
                              if (_p.email.isNotEmpty) ...[
                                AcaoIconePerfil(
                                  icone: FFIcons.kproperty1FiRrEnvelope,
                                  aoTocar: () => launchUrl(
                                      Uri(scheme: 'mailto', path: _p.email)),
                                ),
                                const SizedBox(width: 8.0),
                              ],
                              _BotaoAvaliar(
                                  nota: _p.minhaNota, aoTocar: _avaliar),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: EstatisticasPerfil(
                              alunos: _p.totalAlunos,
                              treinos: _p.totalTreinos,
                              nota: _p.notaMedia,
                              avaliacoes: _p.totalAvaliacoes,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: ChipsPerfil(
                              rotulos: const ['Vídeos', 'Pagamento'],
                              selecionado: _aba,
                              aoSelecionar: (i) => setState(() => _aba = i),
                            ),
                          ),
                          const SizedBox(height: 14.0),
                          // A aba de video traz a propria grade sangrada; a de
                          // pagamento e toda cartao, e recua como as demais.
                          if (_aba == 0)
                            _abaVideos(tema)
                          else
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: _abaPagamento(tema),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // A barra por cima da rolagem, sem fundo: a capa passa por baixo
            // dela e some ao subir, como qualquer conteudo.
            SafeArea(
              bottom: false,
              child: CabecalhoPerfil(
                // Sem titulo: "Personal" descrevia o tipo de ficha, nao a
                // pessoa — e o nome dela esta logo abaixo, na capa.
                sobreCapa: true,
                aVoltar: () => context.safePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Altura exata de uma grade de tres colunas em 9:16.
  ///
  /// Calculada para a grade nao precisar rolar por dentro: com altura menor
  /// que o conteudo, ela vira uma segunda area rolavel dentro da pagina.
  double _alturaDaGrade(int quantos) {
    if (quantos == 0) return 0.0;
    final largura = MediaQuery.sizeOf(context).width;
    final ladoItem = (largura - 4.0) / 3.0;
    final linhas = (quantos / 3).ceil();
    return linhas * (ladoItem * 16 / 9) + (linhas - 1) * 2.0;
  }

  Widget _abaVideos(FlutterFlowTheme tema) {
    final exercicios = achatarExercicios(_p.treinos, _grupo);
    final grupos = extrairSubcategorias(_p.treinos);

    if (exercicios.isEmpty) {
      return _aviso(
        tema,
        FFIcons.kproperty1FiRrPlay,
        _grupo == 'Todos' ? 'Nenhum vídeo por aqui' : 'Nenhum vídeo em $_grupo',
        _grupo == 'Todos'
            ? 'Quando seu personal adicionar vídeos aos exercícios, eles aparecem aqui.'
            : 'Experimente outro grupo muscular.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: CabecaSecao(
            titulo:
                '${exercicios.length} ${exercicios.length == 1 ? 'vídeo' : 'vídeos'}',
            // O filtro só aparece quando há mais de um grupo para escolher.
            filtro: grupos.length > 1 ? _grupo : null,
            aoTocarFiltro: _escolherGrupo,
          ),
        ),
        const SizedBox(height: 10.0),
        // Sem OverflowBox: ele deixa o filho transbordar mas nao cresce com
        // ele, entao a coluna media a grade como se fosse pequena — a pagina
        // parava de rolar e a grade pintava por cima do resto. Agora a grade
        // ocupa a largura real porque quem recua sao as outras secoes, nao a
        // rolagem inteira.
        SizedBox(
          width: double.infinity,
          height: _alturaDaGrade(exercicios.length),
          child: custom_widgets.ReelsVideoGrid(
            width: MediaQuery.sizeOf(context).width,
            height: _alturaDaGrade(exercicios.length),
            exercicios: exercicios,
          ),
        ),
      ],
    );
  }

  Widget _abaPagamento(FlutterFlowTheme tema) {
    final lista = _historicoCompleto ?? _p.pagamentos.toList();
    final mostrandoTudo = _historicoCompleto != null;
    final faltam = _p.totalPagamentos - lista.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // O cartao de cobranca: o valor e o assunto, o Pix e o rodape.
        //
        // Eram duas linhas de lista iguais — "Em aberto R$ 250" e "Chave Pix"
        // —, e linha de lista trata tudo com o mesmo peso. Aqui o valor sobe
        // para corpo 30, porque e a unica coisa que a pessoa veio conferir, e
        // a chave vira a acao no pe do cartao: o caminho para resolver o que o
        // numero acabou de dizer.
        if (_p.qtdEmAberto > 0 || _p.chavePix.isNotEmpty) ...[
          _CartaoCobranca(
            // O total vem do banco, nao da soma da lista: a lista chega
            // cortada em seis, e soma-la daria um valor errado justamente no
            // numero que a pessoa veio conferir.
            valor: _p.qtdEmAberto > 0 ? _valor(_p.emAberto) : null,
            resumo: _p.qtdEmAberto > 0 ? _resumoEmAberto() : null,
            atrasado: _p.diasAtraso > 0,
            chavePix: _p.chavePix,
            tipoPix: _p.tipoPix,
            aoCopiar: _copiarPix,
          ),
          const SizedBox(height: 12.0),
        ],

        if (lista.isEmpty)
          _aviso(tema, FFIcons.kproperty1FiRrDollar, 'Nenhuma cobrança ainda',
              'Quando seu personal registrar uma cobrança, ela aparece aqui.')
        else ...[
          const CabecaSecao(titulo: 'Seu histórico'),
          const SizedBox(height: 10.0),
          CartaoPerfil(
            divisoriaNoTexto: true,
            filhos: [
              for (final pg in lista) _linhaPagamento(tema, pg),
              if (!mostrandoTudo && faltam > 0)
                InkWell(
                  onTap: _verHistoricoCompleto,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    child: Center(
                      child: _carregandoHistorico
                          ? SizedBox(
                              width: 16.0,
                              height: 16.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(tema.primary),
                              ),
                            )
                          : Text(
                              'Ver todo o histórico',
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                color: tema.primary,
                                fontSize: 12.5,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// "1 cobrança · atrasada há 9 dias", só com o que for verdade.
  String _resumoEmAberto() {
    final quantas =
        '${_p.qtdEmAberto} ${_p.qtdEmAberto == 1 ? 'cobrança' : 'cobranças'}';
    if (_p.diasAtraso <= 0) return quantas;
    return '$quantas · ${_p.qtdEmAberto == 1 ? 'atrasada' : 'a mais antiga'} há ${_p.diasAtraso} ${_p.diasAtraso == 1 ? 'dia' : 'dias'}';
  }

  Widget _linhaPagamento(FlutterFlowTheme tema, PagamentosStruct pg) {
    final ({IconData icone, Color cor, Color fundo, String texto}) visual =
        switch (pg.status) {
      'pago' => (
          icone: Icons.check_rounded,
          cor: tema.success,
          fundo: tema.success.withValues(alpha: 0.13),
          texto: 'Pago',
        ),
      'atrasado' => (
          icone: Icons.priority_high_rounded,
          cor: tema.secondary,
          fundo: tema.secondary.withValues(alpha: 0.14),
          texto: 'Venceu ${_data(pg.dataVencimento)}',
        ),
      'aguardando' => (
          icone: Icons.hourglass_empty_rounded,
          cor: tema.primary,
          fundo: tema.accent1,
          texto: 'Aguardando confirmação',
        ),
      _ => (
          icone: Icons.schedule_rounded,
          cor: tema.secondaryText,
          fundo: tema.alternate.withValues(alpha: 0.4),
          texto: 'Vence ${_data(pg.dataVencimento)}',
        ),
    };

    // Só o que ainda não foi pago nem está aguardando pode ser informado.
    final podeInformar = pg.status != 'pago' && pg.status != 'aguardando';

    return LinhaPerfil(
      icone: visual.icone,
      corIcone: visual.cor,
      fundoIcone: visual.fundo,
      titulo: pg.descricao.isEmpty ? 'Cobrança' : pg.descricao,
      subtitulo: visual.texto,
      valor: 'R\$ ${_valor(pg.valor)}',
      // Seta em vez da palavra "informar": ela fica ao lado do valor, que e
      // onde o olho ja esta, e diz "tem mais aqui" sem competir com o numero.
      mostraSeta: podeInformar,
      aoTocar: !podeInformar
          ? null
          : () async {
              final ok = await showModalBottomSheet<bool>(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) =>
                    WebViewAware(child: InformarPagamentoWidget(pagamento: pg)),
              );
              if (ok == true) await _recarregar();
            },
    );
  }

  Widget _aviso(
      FlutterFlowTheme tema, IconData icone, String titulo, String texto) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: tema.accent1, shape: BoxShape.circle),
            child: Icon(icone, color: tema.primary, size: 24.0),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 4.0),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: tema.primaryText,
                fontSize: 14.0,
                letterSpacing: -0.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w400),
              color: tema.secondaryText,
              fontSize: 12.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w400,
              lineHeight: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  /// "1.234,50" — vírgula decimal e ponto de milhar, como se lê em português.
  String _valor(double v) {
    final partes = v.toStringAsFixed(2).split('.');
    final inteiro = partes[0];
    final buffer = StringBuffer();
    for (var i = 0; i < inteiro.length; i++) {
      if (i > 0 && (inteiro.length - i) % 3 == 0) buffer.write('.');
      buffer.write(inteiro[i]);
    }
    return '$buffer,${partes[1]}';
  }

  String _data(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }
}

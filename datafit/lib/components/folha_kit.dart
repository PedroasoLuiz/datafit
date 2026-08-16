/// O desenho das folhas que sobem do rodapé: formulários e listagens.
///
/// Cada uma tinha o seu: faixa azul-clara no topo com o título em preto e um
/// ícone solto na direita, campos com caixa arredondada e contorno cinza, e a
/// animação dos botões redeclarada linha por linha em todo componente. Eram
/// quinze desenhos parecidos, nenhum igual.
///
/// O que ficou:
///
/// - **Fundo branco.** A faixa colorida dava ao título o peso de um alerta e
///   competia com o próprio conteúdo. O título agora se sustenta pelo corpo.
/// - **Campo com linha embaixo.** A caixa arredondada em volta de cada campo
///   desenhava uma segunda moldura dentro da folha, e um formulário virava
///   uma pilha de caixinhas. A linha marca onde se escreve e some quando não
///   é a vez daquele campo.
/// - **Os dois botões redondos**, com a mesma animação de sempre.
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Espaçamentos da folha. Um número por medida, e o mesmo em toda folha.
abstract final class MedidasFolha {
  /// Recuo lateral do conteúdo dentro do cartão.
  static const double lado = 20.0;

  /// Do topo do cartão até o título.
  static const double topo = 22.0;

  /// Do último campo até a borda de baixo.
  static const double base = 24.0;

  /// Entre um campo e o seguinte.
  static const double entreCampos = 18.0;

  /// Raio do cartão.
  static const double raio = 22.0;
}

/// Cabeçalho da folha: título, apoio e o ícone à direita.
///
/// O ícone perdeu o azul cheio e ganhou um quadrado claro, como os atalhos:
/// solto sobre o branco ele parecia um botão que não fazia nada.
class CabecaFolha extends StatelessWidget {
  const CabecaFolha({
    super.key,
    required this.titulo,
    this.apoio,
    this.icone,
    this.corIcone,
  });

  final String titulo;
  final String? apoio;
  final IconData? icone;
  final Color? corIcone;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final cor = corIcone ?? tema.primary;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        MedidasFolha.lado,
        MedidasFolha.topo,
        MedidasFolha.lado,
        18.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: tema.primaryText,
                    fontSize: 19.0,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if ((apoio ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      apoio!,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                        color: tema.secondaryText,
                        fontSize: 12.5,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
                        lineHeight: 1.35,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (icone != null) ...[
            const SizedBox(width: 14.0),
            Container(
              width: 38.0,
              height: 38.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icone, color: cor, size: 18.0),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rótulo de campo: pequeno, colado no campo que nomeia.
///
/// Em foco ele vira azul e engorda meio ponto. É a única cor que a folha
/// gasta, e ela marca onde a pessoa está: num campo de linha fina, sem essa
/// resposta nada na tela reage ao toque.
class RotuloFolha extends StatelessWidget {
  const RotuloFolha(this.texto, {super.key, this.ativo = false});

  final String texto;
  final bool ativo;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        style: tema.bodyMedium.override(
          font: GoogleFonts.inter(
              fontWeight: ativo ? FontWeight.w600 : FontWeight.w500),
          color: ativo ? tema.primary : tema.secondaryText,
          fontSize: 12.0,
          letterSpacing: ativo ? 0.2 : 0.0,
          fontWeight: ativo ? FontWeight.w600 : FontWeight.w500,
        ),
        child: Text(texto),
      ),
    );
  }
}

/// A decoração dos campos: linha embaixo, e só.
///
/// A linha é cinza em repouso e azul em foco: é assim que o campo diz de quem
/// é a vez sem precisar de fundo nem de contorno.
InputDecoration decoracaoCampo(
  BuildContext context, {
  String? dica,
  Widget? sufixo,
  Widget? prefixo,
}) {
  final tema = FlutterFlowTheme.of(context);

  UnderlineInputBorder linha(Color cor, double largura) => UnderlineInputBorder(
        borderSide: BorderSide(color: cor, width: largura),
        borderRadius: BorderRadius.zero,
      );

  return InputDecoration(
    isDense: true,
    hintText: dica,
    hintStyle: tema.bodyMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w400),
      color: tema.secondaryText.withValues(alpha: 0.7),
      fontSize: 15.0,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w400,
    ),
    suffixIcon: sufixo,
    prefixIcon: prefixo,
    contentPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 9.0),
    enabledBorder: linha(tema.alternate, 1.0),
    focusedBorder: linha(tema.primary, 1.6),
    errorBorder: linha(tema.error, 1.0),
    focusedErrorBorder: linha(tema.error, 1.6),
    filled: false,
  );
}

/// O estilo do texto digitado. Corpo 15: o campo é o que se lê primeiro.
TextStyle estiloCampo(BuildContext context) =>
    FlutterFlowTheme.of(context).bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
          color: FlutterFlowTheme.of(context).primaryText,
          fontSize: 15.0,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        );

/// Divisória entre blocos da folha, recuada como o conteúdo.
class DivisoriaFolha extends StatelessWidget {
  const DivisoriaFolha({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            MedidasFolha.lado, 6.0, MedidasFolha.lado, 6.0),
        child: Divider(
          height: 1.0,
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate,
        ),
      );
}

/// A folha inteira: cartão branco que sobe, e os dois botões redondos.
///
/// A animação mora aqui. Cada componente declarava os mesmos três
/// `AnimationInfo` e o mesmo `Future.wait` de fechamento: cinquenta linhas
/// repetidas quinze vezes, e bastava uma delas divergir para uma folha fechar
/// diferente das outras.
///
/// [aoConfirmar] devolve o que será entregue ao `Navigator.pop`. Devolver
/// `null` mantém a folha aberta: é como um campo inválido se defende.
class FolhaPadrao extends StatefulWidget {
  const FolhaPadrao({
    super.key,
    required this.filhos,

    /// O que fica parado acima da rolagem: cabeçalho e busca.
    ///
    /// Numa listagem, deixar o campo de busca rolar com os resultados obriga
    /// a subir tudo para corrigir uma letra.
    this.fixos = const [],
    this.aoConfirmar,
    this.iconeConfirmar = Icons.check_rounded,

    /// Sem os botões: listagens em que o toque num item já resolve.
    this.mostraBotoes = true,

    /// Teto do cartão, em fração da altura da tela.
    this.alturaMaxima = 0.86,
  });

  /// Fecha a folha com a animação de saída e devolve [resultado].
  ///
  /// É o caminho para quem fecha por dentro: tocar num item de listagem, por
  /// exemplo. Chamar `Navigator.pop` direto funciona, mas a folha some de
  /// uma vez em vez de descer pelo caminho por onde subiu.
  static Future<void> fechar(BuildContext context, [Object? resultado]) async {
    final estado = context.findAncestorStateOfType<_FolhaPadraoState>();
    if (estado == null) {
      Navigator.pop(context, resultado);
      return;
    }
    await estado.fecharCom(resultado);
  }

  final List<Widget> filhos;
  final List<Widget> fixos;
  final Future<Object?> Function()? aoConfirmar;
  final IconData iconeConfirmar;
  final bool mostraBotoes;
  final double alturaMaxima;

  @override
  State<FolhaPadrao> createState() => _FolhaPadraoState();
}

class _FolhaPadraoState extends State<FolhaPadrao>
    with TickerProviderStateMixin {
  final animacoes = <String, AnimationInfo>{};

  var cartaoEntrou = false;
  var confirmarEntrou = false;
  var fecharEntrou = false;

  /// Trava o toque enquanto a confirmação corre: dois toques no visto
  /// gravavam duas vezes.
  var _ocupado = false;

  /// O visto só existe com uma ação para confirmar.
  bool get mostraConfirmar => widget.mostraBotoes && widget.aoConfirmar != null;

  @override
  void initState() {
    super.initState();

    animacoes.addAll({
      'cartao': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOutQuint,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(-5.0, -5.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      // Só entra quando o botão existe. O `AnimationController` do FF nasce
      // sem `duration`: quem a define é o `Animate` ao se conectar —, e
      // mandar `forward` ou `reverse` num controller solto lança. O erro
      // subia pelo `Future.wait` do fechamento e o `Navigator.pop` nunca
      // rodava: o cartão sumia e o fundo preto ficava na tela.
      if (mostraConfirmar)
        'confirmar': AnimationInfo(
          trigger: AnimationTrigger.onActionTrigger,
          applyInitialState: true,
          effectsBuilder: () => [
            VisibilityEffect(duration: 650.ms),
            MoveEffect(
              curve: Curves.bounceOut,
              delay: 650.0.ms,
              duration: 600.0.ms,
              begin: const Offset(-40.0, 0.0),
              end: const Offset(0.0, 0.0),
            ),
          ],
        ),
      if (widget.mostraBotoes)
        'fechar': AnimationInfo(
          trigger: AnimationTrigger.onActionTrigger,
          applyInitialState: true,
          effectsBuilder: () => [
            VisibilityEffect(duration: 1.ms),
            RotateEffect(
              curve: Curves.linear,
              delay: 0.0.ms,
              duration: 600.0.ms,
              begin: 0.0,
              end: -0.25,
            ),
            MoveEffect(
              curve: Curves.easeInOut,
              delay: 100.0.ms,
              duration: 600.0.ms,
              begin: const Offset(0.0, -100.0),
              end: const Offset(0.0, 0.0),
            ),
          ],
        ),
    });

    setupAnimations(animacoes.values, this);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _abrir('cartao', () => cartaoEntrou = true),
        _abrir('confirmar', () => confirmarEntrou = true),
        _abrir('fechar', () => fecharEntrou = true),
      ]);
    });
  }

  Future<void> _abrir(String nome, VoidCallback marcar) async {
    final anim = animacoes[nome];
    if (anim == null) return;
    safeSetState(marcar);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        await anim.controller.forward(from: 0.0);
      } catch (_) {
        // Uma folha que não anima ainda é uma folha; travar aqui seria pior.
      }
    });
  }

  /// Desfaz a entrada antes de fechar, para a folha sair pelo caminho por
  /// onde entrou.
  ///
  /// Nada aqui pode lançar: quem chama fecha a folha logo depois, e um erro
  /// na animação deixaria a rota aberta com o fundo preto por cima da tela.
  Future<void> _recolher() async {
    await Future.wait([
      for (final nome in const ['cartao', 'fechar', 'confirmar'])
        Future(() async {
          try {
            await animacoes[nome]?.controller.reverse();
          } catch (_) {}
        }),
    ]);
  }

  Future<void> _confirmar() async {
    if (_ocupado) return;
    final acao = widget.aoConfirmar;
    if (acao == null) return;

    _ocupado = true;
    try {
      final resultado = await acao();
      if (resultado == null || !mounted) return;
      await _recolher();
      if (!mounted) return;
      Navigator.pop(context, resultado);
    } finally {
      _ocupado = false;
    }
  }

  Future<void> _fechar() => fecharCom(null);

  Future<void> fecharCom(Object? resultado) async {
    await _recolher();
    if (!mounted) return;
    Navigator.pop(context, resultado);
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final tela = MediaQuery.of(context);

    // Quanto a folha gasta fora do cartao: as duas folgas de 40, o vao de 16
    // e a fileira de botoes.
    final reservado = 96.0 + (widget.mostraBotoes ? 72.0 : 0.0);

    // O teto real: a altura da tela menos as bordas do sistema, o teclado e o
    // que a folha ja gasta em volta.
    //
    // So a fracao de `alturaMaxima` nao bastava: ela media a tela inteira, e o
    // que sobrava por cima empurrava o topo do cartao para debaixo da barra de
    // status. A altura pedida continua valendo, mas nunca acima deste teto.
    final sobra = tela.size.height -
        tela.padding.top -
        tela.padding.bottom -
        tela.viewInsets.bottom -
        reservado;
    final pedida = tela.size.height * widget.alturaMaxima;
    final teto = sobra < 200.0 ? 200.0 : (pedida < sobra ? pedida : sobra);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: teto),
              child: Container(
                decoration: BoxDecoration(
                  color: tema.primaryBackground,
                  borderRadius: BorderRadius.circular(MedidasFolha.raio),
                  boxShadow: [tema.designToken.shadow.lg],
                ),
                // `ClipRRect` por dentro do Container, e nao em volta: o clipe
                // recorta a sombra junto, e o cartao ficava sem relevo.
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(MedidasFolha.raio),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...widget.fixos,
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.filhos,
                              const SizedBox(height: MedidasFolha.base),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animateOnActionTrigger(animacoes['cartao']!,
                hasBeenTriggered: cartaoEntrou),
          ),
        ),
        if (widget.mostraBotoes)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (mostraConfirmar)
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 56.0,
                    fillColor: tema.primary,
                    icon: Icon(
                      widget.iconeConfirmar,
                      color: tema.primaryBackground,
                      size: 24.0,
                    ),
                    onPressed: _confirmar,
                  ).animateOnActionTrigger(animacoes['confirmar']!,
                      hasBeenTriggered: confirmarEntrou),
                ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 20.0,
                  buttonSize: 56.0,
                  fillColor: tema.secondaryBackground,
                  icon: Icon(
                    FFIcons.kproperty1FiRrCrossSmall,
                    color: tema.secondaryText,
                    size: 24.0,
                  ),
                  onPressed: _fechar,
                ).animateOnActionTrigger(animacoes['fechar']!,
                    hasBeenTriggered: fecharEntrou),
              ),
            ],
          ),
      ]
          .divide(const SizedBox(height: 16.0))
          .addToStart(const SizedBox(height: 40.0))
          .addToEnd(const SizedBox(height: 40.0)),
    );
  }
}

/// Um campo dentro da folha, já com o rótulo e os recuos laterais.
class CampoFolha extends StatefulWidget {
  const CampoFolha({
    super.key,
    required this.rotulo,
    required this.controlador,
    this.foco,
    this.dica,
    this.validador,
    this.teclado,
    this.autofoco = false,
    this.linhas = 1,
    this.formatadores,
    this.sufixo,
    this.aoMudar,
    this.abaixo,
    this.primeiro = false,
  });

  final String rotulo;
  final TextEditingController? controlador;
  final FocusNode? foco;
  final String? dica;
  final String? Function(BuildContext, String?)? validador;
  final TextInputType? teclado;
  final bool autofoco;
  final int linhas;
  final List<TextInputFormatter>? formatadores;
  final Widget? sufixo;
  final void Function(String)? aoMudar;

  /// O que vem colado sob o campo: um aviso, uma contagem, uma dica que só
  /// aparece às vezes.
  final Widget? abaixo;

  /// O primeiro campo não leva folga acima: o cabeçalho já a deu.
  final bool primeiro;

  @override
  State<CampoFolha> createState() => _CampoFolhaState();
}

class _CampoFolhaState extends State<CampoFolha> {
  /// Nó próprio quando a tela não passa um: sem nó não há como saber que o
  /// campo está em foco, e o rótulo nunca acenderia.
  FocusNode? _meuFoco;
  FocusNode get _foco => widget.foco ?? (_meuFoco ??= FocusNode());

  bool _ativo = false;

  @override
  void initState() {
    super.initState();
    _foco.addListener(_aoTrocarFoco);
  }

  void _aoTrocarFoco() {
    if (!mounted || _ativo == _foco.hasFocus) return;
    setState(() => _ativo = _foco.hasFocus);
  }

  @override
  void dispose() {
    _foco.removeListener(_aoTrocarFoco);
    // Só descarta o que foi criado aqui: o nó da tela pertence ao model dela.
    _meuFoco?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MedidasFolha.lado,
        widget.primeiro ? 0.0 : MedidasFolha.entreCampos,
        MedidasFolha.lado,
        0.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RotuloFolha(widget.rotulo, ativo: _ativo),
          TextFormField(
            controller: widget.controlador,
            focusNode: _foco,
            autofocus: widget.autofoco,
            obscureText: false,
            keyboardType: widget.teclado,
            maxLines: widget.linhas,
            minLines: 1,
            inputFormatters: widget.formatadores,
            onChanged: widget.aoMudar,
            decoration: decoracaoCampo(context,
                dica: widget.dica, sufixo: widget.sufixo),
            style: estiloCampo(context),
            cursorColor: FlutterFlowTheme.of(context).primary,
            validator: widget.validador?.asValidator(context),
          ),
          if (widget.abaixo != null) widget.abaixo!,
        ],
      ),
    );
  }
}

/// Campo de busca da folha: mesma linha dos demais, com a lupa na frente.
class BuscaFolha extends StatelessWidget {
  const BuscaFolha({
    super.key,
    required this.controlador,
    required this.aoMudar,
    this.foco,
    this.dica = 'Buscar...',
  });

  final TextEditingController? controlador;
  final void Function(String) aoMudar;
  final FocusNode? foco;
  final String dica;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, 0.0, MedidasFolha.lado, 6.0),
      child: TextFormField(
        controller: controlador,
        focusNode: foco,
        onChanged: aoMudar,
        textInputAction: TextInputAction.search,
        decoration: decoracaoCampo(
          context,
          dica: dica,
          prefixo: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            child: Icon(Icons.search_rounded,
                color: tema.secondaryText, size: 19.0),
          ),
        ).copyWith(
          // A lupa nao precisa da caixa de 48 que o Material reserva: sem
          // isto o texto do campo comecava longe da margem dos demais.
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        ),
        style: estiloCampo(context),
        cursorColor: tema.primary,
      ),
    );
  }
}

/// Uma linha de listagem: quadrado do ícone, nome e a seta.
class ItemFolha extends StatelessWidget {
  const ItemFolha({
    super.key,
    required this.titulo,
    this.apoio,
    this.icone,
    this.corIcone,
    this.aoTocar,
    this.selecionado = false,
  });

  final String titulo;
  final String? apoio;
  final IconData? icone;
  final Color? corIcone;
  final VoidCallback? aoTocar;

  /// Marca o item já escolhido com um visto no lugar da seta.
  final bool selecionado;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final cor = corIcone ?? tema.primary;

    return InkWell(
      onTap: aoTocar,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            MedidasFolha.lado, 12.0, MedidasFolha.lado, 12.0),
        child: Row(
          children: [
            if (icone != null) ...[
              Container(
                width: 36.0,
                height: 36.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: Icon(icone, color: cor, size: 17.0),
              ),
              const SizedBox(width: 12.0),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: tema.primaryText,
                      fontSize: 14.0,
                      letterSpacing: -0.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if ((apoio ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 2.0, 0.0, 0.0),
                      child: Text(
                        apoio!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            const SizedBox(width: 8.0),
            Icon(
              selecionado
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: selecionado ? tema.primary : tema.secondaryText,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

/// A lista da folha: carregando, vazio, itens e "ver mais".
///
/// Ela nao rola por conta propria: quem rola e a folha. Duas areas rolaveis
/// empilhadas disputam o mesmo gesto, e o dedo nunca sabe qual respondeu.
///
/// A pagina e local: os itens ja vieram todos da chamada —, mas desenhar
/// oitocentos exercicios de uma vez custa quase o mesmo que busca-los.
class ListaFolha<T> extends StatelessWidget {
  const ListaFolha({
    super.key,
    required this.itens,
    required this.construir,
    required this.visiveis,
    required this.aoVerMais,
    this.carregando = false,
    this.textoVazio = 'Nada por aqui ainda.',
  });

  final List<T> itens;
  final Widget Function(BuildContext, T) construir;

  /// Quantos itens mostrar. O componente guarda o número; a lista só o lê.
  final int visiveis;
  final VoidCallback aoVerMais;
  final bool carregando;
  final String textoVazio;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    if (carregando) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: SizedBox(
            width: 22.0,
            height: 22.0,
            child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(tema.primary)),
          ),
        ),
      );
    }

    if (itens.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(28.0, 20.0, 28.0, 24.0),
        child: Center(
          child: Text(
            textoVazio,
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w400),
              color: tema.secondaryText,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w400,
              lineHeight: 1.4,
            ),
          ),
        ),
      );
    }

    final quantos = visiveis.clamp(0, itens.length);
    final faltam = itens.length - quantos;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < quantos; i++) ...[
          construir(context, itens[i]),
          if (i < quantos - 1)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  MedidasFolha.lado, 0.0, MedidasFolha.lado, 0.0),
              child:
                  Divider(height: 1.0, thickness: 1.0, color: tema.alternate),
            ),
        ],
        if (faltam > 0)
          InkWell(
            onTap: aoVerMais,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Center(
                child: Text(
                  'Ver mais ($faltam restantes)',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
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
    );
  }
}

/// Campo que não se digita: mostra o valor escolhido e abre algo ao toque.
///
/// Data, hora, uma folha de escolha. Tem a mesma linha embaixo dos campos de
/// texto porque faz o mesmo papel na leitura: é um lugar onde falta uma
/// resposta —, e o ícone à direita é o que diz que a resposta vem de outro
/// lugar em vez do teclado.
class CampoToqueFolha extends StatelessWidget {
  const CampoToqueFolha({
    super.key,
    required this.rotulo,
    required this.aoTocar,
    this.valor,
    this.vazio = 'Selecione',
    this.icone = Icons.expand_more_rounded,
    this.primeiro = false,
  });

  final String rotulo;
  final VoidCallback aoTocar;

  /// Nulo enquanto ninguém escolheu: aí vale [vazio], em cinza claro.
  final String? valor;
  final String vazio;
  final IconData icone;
  final bool primeiro;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final preenchido = (valor ?? '').isNotEmpty;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MedidasFolha.lado,
        primeiro ? 0.0 : MedidasFolha.entreCampos,
        MedidasFolha.lado,
        0.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RotuloFolha(rotulo, ativo: preenchido),
          InkWell(
            onTap: aoTocar,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 9.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: preenchido ? tema.primary : tema.alternate,
                    width: preenchido ? 1.6 : 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      preenchido ? valor! : vazio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(
                            fontWeight:
                                preenchido ? FontWeight.w500 : FontWeight.w400),
                        color: preenchido
                            ? tema.primaryText
                            : tema.secondaryText.withValues(alpha: 0.7),
                        fontSize: 15.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            preenchido ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(icone,
                      color: preenchido ? tema.primary : tema.secondaryText,
                      size: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Escolha entre poucas opções curtas, em pastilhas.
///
/// Um dropdown esconderia as alternativas atrás de um toque, e são poucas o
/// bastante para caberem à vista: ver "Pix" ao lado de "Dinheiro" é o que
/// faz a escolha ser imediata.
class EscolhaFolha extends StatelessWidget {
  const EscolhaFolha({
    super.key,
    required this.rotulo,
    required this.opcoes,
    required this.escolhida,
    required this.aoEscolher,
    this.primeiro = false,
  });

  final String rotulo;
  final List<String> opcoes;
  final String? escolhida;
  final void Function(String) aoEscolher;
  final bool primeiro;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MedidasFolha.lado,
        primeiro ? 0.0 : MedidasFolha.entreCampos,
        MedidasFolha.lado,
        0.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RotuloFolha(rotulo, ativo: escolhida != null),
          const SizedBox(height: 3.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (final opcao in opcoes)
                Builder(builder: (context) {
                  final ativa = opcao == escolhida;
                  return InkWell(
                    onTap: () => aoEscolher(opcao),
                    borderRadius: BorderRadius.circular(999.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          14.0, 8.0, 14.0, 8.0),
                      decoration: BoxDecoration(
                        color: ativa ? tema.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(999.0),
                        border: Border.all(
                          color: ativa ? tema.primary : tema.alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        opcao,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(
                              fontWeight:
                                  ativa ? FontWeight.w600 : FontWeight.w500),
                          color: ativa ? Colors.white : tema.primaryText,
                          fontSize: 12.5,
                          letterSpacing: 0.0,
                          fontWeight: ativa ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ],
      ),
    );
  }
}

/// Resumo de leitura no topo da folha: o que a ação vai afetar.
///
/// Fica antes dos campos porque responde "sobre o quê?": sem ele, informar
/// um pagamento é preencher data e forma sem ver de qual cobrança se trata.
class ResumoFolha extends StatelessWidget {
  const ResumoFolha({
    super.key,
    required this.titulo,
    required this.destaque,
    this.apoio,
    this.cor,
  });

  final String titulo;
  final String destaque;
  final String? apoio;
  final Color? cor;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final tinta = cor ?? tema.primary;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, 0.0, MedidasFolha.lado, 4.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 13.0),
        decoration: BoxDecoration(
          color: tinta.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3.0),
            Text(
              destaque,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                color: tinta,
                fontSize: 24.0,
                letterSpacing: -0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
            if ((apoio ?? '').isNotEmpty)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 3.0, 0.0, 0.0),
                child: Text(
                  apoio!,
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
    );
  }
}

/// Barra de progresso ajustavel, com o numero ao lado do rotulo.
///
/// O valor aparece no cabecalho e nao sob o dedo: arrastando, o polegar tapa
/// justamente o ponto onde o Slider desenha o proprio rotulo, e a pessoa
/// larga para ler quanto marcou.
class ProgressoFolha extends StatelessWidget {
  const ProgressoFolha({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.aoMudar,
    this.cor,
    this.primeiro = false,
  });

  final String rotulo;
  final double valor;
  final void Function(double) aoMudar;
  final Color? cor;
  final bool primeiro;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final tinta = cor ?? tema.primary;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MedidasFolha.lado,
        primeiro ? 0.0 : MedidasFolha.entreCampos,
        MedidasFolha.lado,
        0.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: RotuloFolha(rotulo, ativo: valor > 0)),
              Text(
                '${valor.round()}%',
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: valor > 0 ? tinta : tema.secondaryText,
                  fontSize: 15.0,
                  letterSpacing: -0.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              activeTrackColor: tinta,
              inactiveTrackColor: tema.alternate,
              thumbColor: tinta,
              overlayColor: tinta.withValues(alpha: 0.12),
              // Sem o balao de valor: ele ja esta escrito acima, e o balao
              // aparecia por cima do rotulo tapando a mesma informacao.
              showValueIndicator: ShowValueIndicator.never,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18.0),
            ),
            child: Slider(
              value: valor.clamp(0.0, 100.0),
              min: 0.0,
              max: 100.0,
              divisions: 20,
              onChanged: aoMudar,
            ),
          ),
        ],
      ),
    );
  }
}

/// Acao secundaria no pe da folha: excluir, desvincular, encerrar.
///
/// Em vermelho e sozinha, longe do visto: e a unica coisa da folha que nao se
/// desfaz, e ela nao pode dividir a linha com o botao que so grava.
class AcaoDestrutivaFolha extends StatelessWidget {
  const AcaoDestrutivaFolha({
    super.key,
    required this.texto,
    required this.aoTocar,
    this.icone = Icons.delete_outline_rounded,
  });

  final String texto;
  final VoidCallback aoTocar;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, 22.0, MedidasFolha.lado, 0.0),
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11.0),
          decoration: BoxDecoration(
            color: tema.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: tema.error, size: 17.0),
              const SizedBox(width: 7.0),
              Text(
                texto,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: tema.error,
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dropdown da folha, com a mesma linha embaixo dos campos de texto.
///
/// O `FlutterFlowDropDown` vem com contorno, preenchimento e elevacao
/// proprios. Aqui todos sao zerados e a linha fica por conta do envoltorio,
/// para o seletor pesar o mesmo que um campo digitavel: escolher e digitar
/// respondem a mesma pergunta, e um nao deve parecer mais importante.
class DropFolha<T> extends StatelessWidget {
  const DropFolha({
    super.key,
    required this.rotulo,
    required this.controlador,
    required this.opcoes,
    required this.aoMudar,
    this.rotulos,
    this.dica = 'Selecione',
    this.preenchido = false,
    this.primeiro = false,
  });

  final String rotulo;
  final FormFieldController<T?> controlador;
  final List<T> opcoes;
  final List<String>? rotulos;
  final void Function(T?) aoMudar;
  final String dica;

  /// Acende o rotulo e a linha. Quem sabe se ha escolha e a tela, porque o
  /// "nenhum" de cada seletor tem um valor diferente.
  final bool preenchido;
  final bool primeiro;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MedidasFolha.lado,
        primeiro ? 0.0 : MedidasFolha.entreCampos,
        MedidasFolha.lado,
        0.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RotuloFolha(rotulo, ativo: preenchido),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: preenchido ? tema.primary : tema.alternate,
                  width: preenchido ? 1.6 : 1.0,
                ),
              ),
            ),
            child: FlutterFlowDropDown<T>(
              controller: controlador,
              options: opcoes,
              optionLabels: rotulos,
              onChanged: aoMudar,
              width: double.infinity,
              height: 42.0,
              maxHeight: 260.0,
              hintText: dica,
              textStyle: estiloCampo(context),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: preenchido ? tema.primary : tema.secondaryText,
                  size: 22.0),
              // Botao sem fundo, menu com fundo e sombra: sao duas
              // superficies diferentes, e o `fillColor` sozinho pintava as
              // duas com a mesma tinta.
              fillColor: Colors.transparent,
              menuFillColor: tema.primaryBackground,
              elevation: 0.0,
              menuElevation: 3.0,
              borderColor: Colors.transparent,
              borderWidth: 0.0,
              borderRadius: 0.0,
              margin: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              hidesUnderline: true,
              isOverButton: false,
              isSearchable: false,
              isMultiSelect: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo sem recuo lateral, para viver dentro de uma [LinhaCamposFolha].
///
/// Series, repeticoes e descanso sao tres numeros de dois digitos. Um por
/// linha esticava o formulario por uma tela inteira e fazia cada um parecer
/// uma pergunta separada, quando na verdade sao a mesma: como e a serie.
class CampoCompacto extends StatefulWidget {
  const CampoCompacto({
    super.key,
    required this.rotulo,
    required this.controlador,
    this.foco,
    this.dica,
    this.teclado,
    this.formatadores,
    this.aoMudar,
    this.autofoco = false,
  });

  final String rotulo;
  final TextEditingController? controlador;
  final FocusNode? foco;
  final String? dica;
  final TextInputType? teclado;
  final List<TextInputFormatter>? formatadores;
  final void Function(String)? aoMudar;
  final bool autofoco;

  @override
  State<CampoCompacto> createState() => _CampoCompactoState();
}

class _CampoCompactoState extends State<CampoCompacto> {
  FocusNode? _meuFoco;
  FocusNode get _foco => widget.foco ?? (_meuFoco ??= FocusNode());
  bool _ativo = false;

  @override
  void initState() {
    super.initState();
    _foco.addListener(_aoTrocarFoco);
  }

  void _aoTrocarFoco() {
    if (!mounted || _ativo == _foco.hasFocus) return;
    setState(() => _ativo = _foco.hasFocus);
  }

  @override
  void dispose() {
    _foco.removeListener(_aoTrocarFoco);
    _meuFoco?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotuloFolha(widget.rotulo, ativo: _ativo),
        TextFormField(
          controller: widget.controlador,
          focusNode: _foco,
          autofocus: widget.autofoco,
          keyboardType: widget.teclado,
          inputFormatters: widget.formatadores,
          onChanged: widget.aoMudar,
          decoration: decoracaoCampo(context, dica: widget.dica),
          style: estiloCampo(context),
          cursorColor: FlutterFlowTheme.of(context).primary,
        ),
      ],
    );
  }
}

/// Dois ou tres campos lado a lado, dividindo a largura em partes iguais.
class LinhaCamposFolha extends StatelessWidget {
  const LinhaCamposFolha({
    super.key,
    required this.campos,
    this.primeiro = false,
  });

  final List<Widget> campos;
  final bool primeiro;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MedidasFolha.lado,
        primeiro ? 0.0 : MedidasFolha.entreCampos,
        MedidasFolha.lado,
        0.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < campos.length; i++) ...[
            if (i > 0) const SizedBox(width: 16.0),
            Expanded(child: campos[i]),
          ],
        ],
      ),
    );
  }
}

/// Chave de liga e desliga com um texto de apoio.
///
/// O que ela liga costuma revelar campos abaixo. Por isso ela mora numa linha
/// propria e nao ao lado de um titulo: quem a aciona precisa ver o que
/// apareceu logo em seguida.
class ChaveFolha extends StatelessWidget {
  const ChaveFolha({
    super.key,
    required this.titulo,
    required this.ligada,
    required this.aoMudar,
    this.apoio,
  });

  final String titulo;
  final String? apoio;
  final bool ligada;
  final void Function(bool) aoMudar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          MedidasFolha.lado, MedidasFolha.entreCampos, MedidasFolha.lado, 0.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: tema.primaryText,
                    fontSize: 13.5,
                    letterSpacing: -0.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((apoio ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 2.0, 0.0, 0.0),
                    child: Text(
                      apoio!,
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
          const SizedBox(width: 12.0),
          Switch.adaptive(
            value: ligada,
            onChanged: aoMudar,
            activeTrackColor: tema.primary,
            activeThumbColor: Colors.white,
            inactiveTrackColor: tema.alternate,
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

/// Escolha em pastilhas sem recuo lateral, para viver dentro de uma
/// [LinhaCamposFolha] ao lado de um campo.
///
/// É o caso da unidade ao lado da distância: separá-las em duas linhas faria
/// o número e a unidade dele parecerem duas perguntas.
class EscolhaFolhaSimples extends StatelessWidget {
  const EscolhaFolhaSimples({
    super.key,
    required this.rotulo,
    required this.opcoes,
    required this.escolhida,
    required this.aoEscolher,
  });

  final String rotulo;
  final List<String> opcoes;
  final String? escolhida;
  final void Function(String) aoEscolher;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotuloFolha(rotulo, ativo: escolhida != null),
        const SizedBox(height: 3.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (final opcao in opcoes)
              Builder(builder: (context) {
                final ativa = opcao == escolhida;
                return InkWell(
                  onTap: () => aoEscolher(opcao),
                  borderRadius: BorderRadius.circular(999.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        14.0, 7.0, 14.0, 7.0),
                    decoration: BoxDecoration(
                      color: ativa ? tema.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(999.0),
                      border: Border.all(
                        color: ativa ? tema.primary : tema.alternate,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      opcao,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(
                            fontWeight:
                                ativa ? FontWeight.w600 : FontWeight.w500),
                        color: ativa ? Colors.white : tema.primaryText,
                        fontSize: 12.5,
                        letterSpacing: 0.0,
                        fontWeight: ativa ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ],
    );
  }
}

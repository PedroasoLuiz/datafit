/// O que aconteceu enquanto a pessoa esteve fora.
///
/// Era uma folha por baixo, um baralho de cartões brancos que se arrastava de
/// lado. Funcionava, mas pedia um gesto que ninguém tinha motivo para adivinhar
/// e entregava as novidades uma de cada vez — quem tinha cinco só descobria a
/// quinta arrastando quatro vezes.
///
/// Agora é a mesma abertura das comemorações e dos dias treinados: um círculo
/// que cresce e toma a tela, e o conteúdo se monta por cima. Lá é laranja, a
/// cor da chama; aqui é o azul da marca, porque não é conquista de ninguém —
/// é o app falando. E a lista vem inteira, rolando: o número no título e os
/// itens embaixo contam a mesma história sem depender de gesto nenhum.
library;

import 'dart:math' as math;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/actions/actions.dart' as action_blocks;
import '/components/autoria_notificacao.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

typedef ItemNovidade = ({NotificacoesStruct noti, int indice});

/// Abre a tela das novidades da sessão.
Future<void> mostrarNovidades(
  BuildContext context, {
  required List<ItemNovidade> itens,
}) async {
  await Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      // Zero na entrada porque quem anima é o círculo, por dentro. Uma
      // transição de rota por cima disso seria uma segunda animação
      // disputando com a primeira.
      transitionDuration: Duration.zero,
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => _TelaNovidades(itens: itens),
      transitionsBuilder: (_, animacao, __, filho) =>
          FadeTransition(opacity: animacao, child: filho),
    ),
  );
}

class _TelaNovidades extends StatefulWidget {
  const _TelaNovidades({required this.itens});

  final List<ItemNovidade> itens;

  @override
  State<_TelaNovidades> createState() => _TelaNovidadesState();
}

class _TelaNovidadesState extends State<_TelaNovidades>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final Animation<double> _circulo = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _conteudo = CurvedAnimation(
    parent: _controle,
    curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
  );

  /// Quais já foram lidas nesta tela. Guardado aqui, e não relido do estado
  /// global a cada quadro, para o item não piscar entre o toque e a resposta
  /// do servidor.
  final _lidas = <int>{};

  /// Convite sendo respondido agora, para não aceitar duas vezes no duplo
  /// toque.
  int? _respondendo;

  @override
  void initState() {
    super.initState();
    _controle.forward();
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  Future<void> _marcarLida(ItemNovidade item) async {
    if (item.noti.lida || _lidas.contains(item.noti.id)) return;
    setState(() => _lidas.add(item.noti.id));

    final res = await PerfilGroup.marcarNotiComoLidaCall.call(
      notificacaoId: item.noti.id,
      user: currentUserUid,
    );
    if (!res.succeeded) {
      // Desfaz: dizer "lida" e o servidor não ter registrado faria a novidade
      // voltar na próxima abertura sem explicação.
      if (mounted) setState(() => _lidas.remove(item.noti.id));
      return;
    }
    FFAppState().updateNotificacoesAtIndex(
      item.indice,
      (e) => e..lida = getJsonField(res.jsonBody, r'''$.lida'''),
    );
    if (mounted) setState(() {});
  }

  /// Aceitar ou recusar um convite de personal.
  ///
  /// Usa `remetenteId`, nunca o nome: dois personais podem se chamar igual, e
  /// o vínculo é criado pelo UUID.
  Future<void> _responder(ItemNovidade item, bool aceitar) async {
    if (_respondendo != null || item.noti.remetenteId.isEmpty) return;
    setState(() => _respondendo = item.noti.id);

    await action_blocks.responderConvite(
      context,
      personalUuid: item.noti.remetenteId,
      aceitar: aceitar,
    );
    if (!mounted) return;

    FFAppState().updateNotificacoesAtIndex(item.indice, (e) => e..lida = true);
    setState(() {
      _respondendo = null;
      _lidas.add(item.noti.id);
    });
  }

  bool _estaLida(ItemNovidade item) =>
      item.noti.lida || _lidas.contains(item.noti.id);

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final medida = MediaQuery.sizeOf(context);

    // Sem toque de origem: esta tela abre sozinha, então o círculo nasce do
    // alto do centro, de onde vem o sino, e não de um ponto arbitrário.
    final origem = Offset(medida.width / 2, medida.height * 0.28);

    double distancia(Offset canto) => (canto - origem).distance;
    final raio = [
      distancia(Offset.zero),
      distancia(Offset(medida.width, 0.0)),
      distancia(Offset(0.0, medida.height)),
      distancia(Offset(medida.width, medida.height)),
    ].reduce(math.max);

    // A animacao nao reconstroi mais a tela: antes um `AnimatedBuilder` em
    // volta de tudo remontava a lista inteira — e cada imagem de rede dentro
    // dela — a cada quadro, umas cinquenta vezes seguidas, para mover um
    // circulo. Agora o circulo tem seu proprio `ScaleTransition` e o conteudo
    // entra por `FadeTransition`/`SlideTransition`: os tres agem direto no
    // objeto de renderizacao, sem passar pelo `build`. A lista e montada uma
    // vez so.
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned(
            left: origem.dx - raio,
            top: origem.dy - raio,
            // Camada propria: o circulo cresce sozinho sem sujar o conteudo
            // que ja esta desenhado por cima dele.
            child: RepaintBoundary(
              child: ScaleTransition(
                scale: _circulo,
                child: Container(
                  width: raio * 2,
                  height: raio * 2,
                  decoration: BoxDecoration(
                    // O azul da marca. As comemorações usam verde para o que
                    // a pessoa fez e vermelho para o que falhou; recado do
                    // app não é nem uma coisa nem outra.
                    color: tema.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _conteudo,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.025),
                end: Offset.zero,
              ).animate(_conteudo),
              child: SafeArea(child: _corpo(tema)),
            ),
          ),
          // O X preso ao canto, fora do corpo: dentro da coluna ele
          // disputaria a linha com o título.
          Positioned(
            top: 0.0,
            right: 0.0,
            child: SafeArea(
              child: FadeTransition(
                opacity: _conteudo,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 26.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _corpo(FlutterFlowTheme tema) {
    final altura = MediaQuery.sizeOf(context).height;
    final total = widget.itens.length;

    // Mesma divisão dos dias treinados: o selo e o título ocupam a metade de
    // cima, a lista rola dentro da metade de baixo. Em `Expanded` a lista
    // comeria a tela e empurraria o cabeçalho para fora.
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88.0,
                height: 88.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white, size: 46.0),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Enquanto você esteve fora',
                  textAlign: TextAlign.center,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: Colors.white,
                    fontSize: 22.0,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.bold,
                    lineHeight: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  total == 1
                      ? 'Uma novidade chegou para você.'
                      : '$total novidades chegaram para você.',
                  textAlign: TextAlign.center,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: altura * 0.5, child: _lista(tema)),
      ],
    );
  }

  Widget _lista(FlutterFlowTheme tema) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
      itemCount: widget.itens.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8.0),
      itemBuilder: (context, i) => _item(tema, widget.itens[i]),
    );
  }

  Widget _item(FlutterFlowTheme tema, ItemNovidade item) {
    final noti = item.noti;
    final lida = _estaLida(item);
    final ehConvitePendente = noti.tag == 'convite' && !lida;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.0),
        onTap: () => _marcarLida(item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            // A já lida recua para o fundo em vez de sumir: sumir apagaria a
            // prova de que o toque fez alguma coisa, e a pessoa tocaria de
            // novo procurando o item que ela mesma acabou de resolver.
            color: Colors.white.withValues(alpha: lida ? 0.08 : 0.18),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarNotificacao(
                foto: noti.remetenteFoto,
                nome: noti.remetente,
                sobreEscuro: true,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            noti.titulo,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight:
                                    lida ? FontWeight.w500 : FontWeight.w600,
                              ),
                              color: Colors.white,
                              fontSize: 13.5,
                              letterSpacing: 0.0,
                              fontWeight:
                                  lida ? FontWeight.w500 : FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 1.0, 0.0, 0.0),
                          child: Text(
                            tempoRelativo(noti.criadoEm),
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500),
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 11.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // O ponto é o sinal de "ainda não vi". Branco, e não azul
                        // como na listagem: sobre o azul da tela ele desapareceria.
                        if (!lida) ...[
                          const SizedBox(width: 8.0),
                          Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.only(top: 5.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (noti.descricao.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 4.0, 0.0, 0.0),
                        child: Text(
                          noti.descricao,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: tema.bodyMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w400),
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    // O convite continua respondível daqui. Mandar a pessoa procurar
                    // a tela de notificações para aceitar seria abrir com a novidade
                    // mais importante do app e não deixar fazer nada com ela.
                    if (ehConvitePendente)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _respondendo != null
                                    ? null
                                    : () => _responder(item, false),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                      color:
                                          Colors.white.withValues(alpha: 0.55)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  'Recusar',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _respondendo != null
                                    ? null
                                    : () => _responder(item, true),
                                style: ElevatedButton.styleFrom(
                                  // Branco sobre o azul: o primary do botão sumiria
                                  // no fundo, e aceitar é a ação principal da tela.
                                  backgroundColor: Colors.white,
                                  foregroundColor: tema.primary,
                                  disabledBackgroundColor:
                                      Colors.white.withValues(alpha: 0.5),
                                  elevation: 0.0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  'Aceitar',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                    color: tema.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lista de notificações do app, em cartões.
///
/// Existia uma cópia do mesmo desenho em cada tela que mostrava notificações —
/// a gaveta de "Meus alunos", o bloco de Metas — e elas foram se afastando com
/// o tempo. Este arquivo é o desenho único: quem precisar da lista monta este
/// componente.
///
/// A fonte é sempre `FFAppState().notificacoes`, então marcar uma como lida
/// aqui reflete em todo mundo que estiver lendo o mesmo estado.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/actions/actions.dart' as action_blocks;
import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Ícone e cor de cada tag, num lugar só.
///
/// Antes esta escolha era uma escada de ternários repetida em cada tela: mudar
/// a cor de "pagamento" pedia achar todas as cópias.
({IconData icone, Color fundo, Color cor}) _visualDaTag(
  BuildContext context,
  String tag,
) {
  final tema = FlutterFlowTheme.of(context);

  // Todas as tags seguem a mesma fórmula: a cor vem do tema e o fundo é ela
  // própria a 12% de opacidade. Antes duas usavam `accent1`/`accent2` e duas
  // traziam hexadecimais soltos (um verde-claro e um roxo) que não existem em
  // lugar nenhum do app — o resultado é que "treino" e "outros" pareciam de
  // outro produto, e trocar a cor da marca deixaria as duas para trás.
  ({IconData icone, Color fundo, Color cor}) daCor(IconData i, Color c) =>
      (icone: i, fundo: c.withValues(alpha: 0.12), cor: c);

  switch (tag) {
    case 'pagamento':
      return daCor(Icons.payments_rounded, tema.primary);
    case 'convite':
      return daCor(Icons.person_add_rounded, tema.primary);
    case 'treino':
      return daCor(Icons.fitness_center_rounded, tema.success);
    case 'meta':
      return daCor(Icons.flag_rounded, tema.secondary);
    default:
      // Sem tag conhecida, o sino no azul da marca: o roxo de antes era a
      // única cor do app que não vinha do tema.
      return daCor(FFIcons.kproperty1FiRrBell, tema.primary);
  }
}

class ListaNotificacoes extends StatefulWidget {
  const ListaNotificacoes({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  State<ListaNotificacoes> createState() => _ListaNotificacoesState();
}

class _ListaNotificacoesState extends State<ListaNotificacoes> {
  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final notis = FFAppState().notificacoes.toList();

    if (notis.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FFIcons.kproperty1FiRrBell,
              color: tema.secondaryText,
              size: 32.0,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Nenhuma notificação por aqui',
              textAlign: TextAlign.center,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: widget.padding ??
          const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 24.0),
      shrinkWrap: true,
      itemCount: notis.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
        child: CardNotificacao(noti: notis[i], indice: i),
      ),
    );
  }
}

/// Um cartão de notificação.
///
/// Fica público porque as telas que ainda montam a própria lista podem trocar
/// só o item, sem reescrever a rolagem em volta.
class CardNotificacao extends StatefulWidget {
  const CardNotificacao({
    super.key,
    required this.noti,
    required this.indice,
  });

  final NotificacoesStruct noti;
  final int indice;

  @override
  State<CardNotificacao> createState() => _CardNotificacaoState();
}

class _CardNotificacaoState extends State<CardNotificacao> {
  bool _respondendo = false;

  Future<void> _marcarLida() async {
    if (widget.noti.lida) return;
    final res = await PerfilGroup.marcarNotiComoLidaCall.call(
      notificacaoId: widget.noti.id,
      user: currentUserUid,
    );
    if (!res.succeeded || !mounted) return;
    FFAppState().updateNotificacoesAtIndex(
      widget.indice,
      (e) => e..lida = getJsonField(res.jsonBody, r'''$.lida'''),
    );
    safeSetState(() {});
  }

  /// Aceitar ou recusar um convite de personal.
  ///
  /// Usa `remetenteId`, nunca o nome: dois personais podem se chamar igual, e
  /// o vínculo é criado pelo UUID.
  Future<void> _responder(bool aceitar) async {
    if (_respondendo || widget.noti.remetenteId.isEmpty) return;
    safeSetState(() => _respondendo = true);
    await action_blocks.responderConvite(
      context,
      personalUuid: widget.noti.remetenteId,
      aceitar: aceitar,
    );
    if (!mounted) return;
    FFAppState().updateNotificacoesAtIndex(
      widget.indice,
      (e) => e..lida = true,
    );
    safeSetState(() => _respondendo = false);
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final noti = widget.noti;
    final visual = _visualDaTag(context, noti.tag);
    final ehConvitePendente = noti.tag == 'convite' && !noti.lida;

    // A cor e a sombra moram no mesmo BoxDecoration de propósito.
    //
    // Antes o branco estava no `Material` e a sombra num `Container` filho
    // sem cor: sem preenchimento para tapá-la, a sombra era desenhada por
    // cima do branco e o borrão cinza tomava o cartão inteiro. É por isso
    // que os cartões saíam cinza em vez de brancos.
    return Container(
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [tema.designToken.shadow.sm],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          onTap: _marcarLida,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: visual.fundo,
                  shape: BoxShape.circle,
                ),
                child: Icon(visual.icone, color: visual.cor, size: 18.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            noti.titulo,
                            style: tema.bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: noti.lida
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                              ),
                              color: tema.primaryText,
                              fontSize: 13.5,
                              letterSpacing: 0.0,
                              fontWeight:
                                  noti.lida ? FontWeight.w500 : FontWeight.w600,
                            ),
                          ),
                        ),
                        // O ponto é o único sinal de "ainda não vi": some no
                        // toque, junto com o peso do título.
                        if (!noti.lida) ...[
                          const SizedBox(width: 6.0),
                          Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.only(top: 4.0),
                            decoration: BoxDecoration(
                              color: tema.primary,
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
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w400),
                            color: tema.secondaryText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    if (ehConvitePendente)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    _respondendo ? null : () => _responder(false),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: tema.error,
                                  side: BorderSide(color: tema.error),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  'Recusar',
                                  style: tema.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    color: tema.error,
                                    fontSize: 12.5,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    _respondendo ? null : () => _responder(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: tema.primary,
                                  foregroundColor: Colors.white,
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
                                    color: Colors.white,
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
      ),
    );
  }
}

/// Folha de boas-vindas com as notificações não lidas.
///
/// Aparece uma vez por sessão, na primeira tela depois do login, para o que
/// chegou enquanto a pessoa estava fora não depender de ela lembrar de abrir
/// o sino. É um baralho — mesma ideia dos treinos do dia: arrasta para o lado
/// e a próxima aparece.
class _BaralhoNotificacoes extends StatefulWidget {
  const _BaralhoNotificacoes({required this.naoLidas});

  final List<({NotificacoesStruct noti, int indice})> naoLidas;

  @override
  State<_BaralhoNotificacoes> createState() => _BaralhoNotificacoesState();
}

class _BaralhoNotificacoesState extends State<_BaralhoNotificacoes> {
  /// Quantas já foram passadas. Quando chega ao fim, a folha se fecha.
  int _topo = 0;
  double _arraste = 0.0;

  void _proxima() {
    if (_topo + 1 >= widget.naoLidas.length) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _topo += 1;
      _arraste = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final total = widget.naoLidas.length;

    return Container(
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 16.0),
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
                    const EdgeInsetsDirectional.fromSTEB(4.0, 16.0, 4.0, 2.0),
                child: Text(
                  total == 1
                      ? 'Você tem 1 novidade'
                      : 'Você tem $total novidades',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: tema.primaryText,
                    fontSize: 17.0,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 14.0),
                child: Text(
                  'Arraste para o lado para ver a próxima.',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                    color: tema.secondaryText,
                    fontSize: 12.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, restricoes) {
                  final largura = restricoes.maxWidth;
                  // A da frente mais uma atrás, para dar profundidade sem
                  // virar pilha de papel.
                  final restantes = total - _topo;
                  final camadas = restantes < 2 ? restantes : 2;

                  return SizedBox(
                    // 118: com 150 sobrava um vao de ar sob o texto do
                    // cartao, e a folha inteira ficava mais alta do que o
                    // conteudo pedia.
                    height: 118.0,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        for (var camada = camadas - 1; camada >= 0; camada--)
                          _carta(context, camada, largura),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Ver depois',
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: tema.secondaryText,
                        fontSize: 13.5,
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
    );
  }

  Widget _carta(BuildContext context, int camada, double largura) {
    final item = widget.naoLidas[_topo + camada];
    final daFrente = camada == 0;

    // Quanto do gesto ja foi feito, de 0 a 1. E o que transforma a troca em
    // movimento: antes a carta de tras ficava parada em 0.94 e pulava para
    // 1.0 no ultimo quadro, entao o baralho trocava de carta sem que nada
    // tivesse se mexido — o mesmo defeito que o baralho de treinos tinha.
    final avanco = (_arraste.abs() / largura).clamp(0.0, 1.0);

    final carta = Transform.translate(
      offset: Offset(
        daFrente ? _arraste : 0.0,
        daFrente ? 0.0 : 10.0 * (1 - avanco),
      ),
      child: Transform.scale(
        // A da frente encolhe saindo; a de tras cresce entrando.
        scale: daFrente ? 1.0 - 0.06 * avanco : 0.94 + 0.06 * avanco,
        child: Opacity(
          opacity: daFrente ? 1.0 - 0.45 * avanco : 0.6 + 0.4 * avanco,
          child: CardNotificacao(noti: item.noti, indice: item.indice),
        ),
      ),
    );

    if (!daFrente) return IgnorePointer(child: carta);

    return GestureDetector(
      onHorizontalDragUpdate: (d) =>
          setState(() => _arraste += d.delta.dx),
      onHorizontalDragEnd: (d) {
        if (_arraste.abs() > largura / 4 ||
            d.velocity.pixelsPerSecond.dx.abs() > 700) {
          _proxima();
        } else {
          setState(() => _arraste = 0.0);
        }
      },
      child: carta,
    );
  }
}

/// Controla o "uma vez por sessão".
///
/// É um estático de propósito: o objetivo é não repetir a folha a cada troca
/// de aba, e uma variável de processo já resolve isso. [limparAvisoDeSessao]
/// existe para o logout, senão o próximo login herdaria o "já mostrei".
bool _jaMostrouNaSessao = false;

void limparAvisoDeSessao() => _jaMostrouNaSessao = false;

/// Mostra a folha das não lidas, se houver e se ainda não tiver aparecido.
Future<void> mostrarNotificacoesNaoLidas(BuildContext context) async {
  if (_jaMostrouNaSessao) return;

  final naoLidas = <({NotificacoesStruct noti, int indice})>[];
  final todas = FFAppState().notificacoes;
  for (var i = 0; i < todas.length; i++) {
    if (!todas[i].lida) naoLidas.add((noti: todas[i], indice: i));
  }

  // Marca antes de abrir: mesmo sem nada por ler, a sessão já foi conferida.
  _jaMostrouNaSessao = true;
  if (naoLidas.isEmpty || !context.mounted) return;

  await showModalBottomSheet(
    context: context,
    // Fora do shell de rotas, senão a folha nasce por baixo da navbar.
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BaralhoNotificacoes(naoLidas: naoLidas),
  );
}

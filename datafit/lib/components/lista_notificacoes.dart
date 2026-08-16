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
import '/components/autoria_notificacao.dart';
import '/components/novidades_sessao.dart';
import '/flutter_flow/flutter_flow_util.dart';

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
            // O disco de icone por tag saiu daqui: repetia num simbolo o que
            // o titulo ja diz em palavras. No lugar dele o rosto de quem
            // mandou, que e a unica coisa que o texto nao conta — e sem ela
            // todo aviso parece vir do app, inclusive os que vem do personal.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarNotificacao(
                  foto: noti.remetenteFoto,
                  nome: noti.remetente,
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
                              // Tres linhas, como a descricao: sem teto, um
                              // titulo longo sozinho empurrava o cartao para
                              // fora da folha.
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: noti.lida
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                ),
                                color: tema.primaryText,
                                fontSize: 13.5,
                                letterSpacing: 0.0,
                                fontWeight: noti.lida
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          // "há 3 sem" ao lado do titulo. Sem data a lista faz
                          // tudo parecer recente, e um "pagamento pendente" de maio
                          // le igual ao de hoje — e a data que decide se aquilo
                          // ainda importa.
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 1.0, 0.0, 0.0),
                            child: Text(
                              tempoRelativo(noti.criadoEm),
                              style: tema.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500),
                                color: tema.secondaryText,
                                fontSize: 11.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
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
                                  onPressed: _respondendo
                                      ? null
                                      : () => _responder(false),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: tema.error,
                                    side: BorderSide(color: tema.error),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
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
                                  onPressed: _respondendo
                                      ? null
                                      : () => _responder(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tema.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
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

  await mostrarNovidades(context, itens: naoLidas);
}

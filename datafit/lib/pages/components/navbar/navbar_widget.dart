/// Barra de navegação flutuante.
///
/// Antes cada aba era um par de blocos escritos à mão (um para o estado
/// selecionado, outro para o não selecionado), dez blocos no total, e a aba
/// ativa se distinguia só por um retângulo cinza-claro atrás do ícone —
/// contraste fraco demais para dizer onde o usuário está.
///
/// Agora a barra é uma pílula flutuante: a aba ativa vira uma pílula azul com
/// ícone **e** rótulo lado a lado; as inativas são só o ícone, sem fundo
/// nenhum. As abas viraram dados (`_Aba`), então acrescentar ou reordenar é
/// mexer numa lista, não duplicar blocos de layout.
library;

import '/flutter_flow/transicoes_datafit.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cupertino_time_picker_hiuzb7/app_state.dart'
    as cupertino_time_picker_hiuzb7_app_state;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navbar_model.dart';
export 'navbar_model.dart';

/// Uma aba da barra. `indice` é o mesmo número que as páginas passam em
/// `NavbarWidget(index: ...)`: por isso os valores não são sequenciais.
class _Aba {
  const _Aba({
    required this.indice,
    required this.rota,
    required this.icone,
    required this.rotulo,
  });

  final int indice;
  final String rota;
  final IconData icone;
  final String rotulo;
}

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({
    super.key,
    required this.index,
  });

  final int? index;

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget>
    with TickerProviderStateMixin {
  late NavbarModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavbarModel());

    animationsMap.addAll({
      'barOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeOutCubic,
            delay: 0.0.ms,
            duration: 420.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 320.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  /// Troca de aba com a transicao direcional do app: o conteudo entra
  /// pelo lado em que a aba esta na navbar.
  void _irParaAba(String rota, int destino) {
    final atual = widget.index ?? 0;
    if (destino == atual) {
      return;
    }
    // goNamed e nao pushNamed: aba substitui aba. Com push a pilha crescia a
    // cada toque, o app segurava todas as telas visitadas na memoria e o botao
    // voltar percorria o historico inteiro de abas.
    context.goNamed(
      rota,
      extra: extraDaAba(paraDireita: destino > atual),
    );
  }

  /// Abas do papel logado. Aluno e personal têm quatro cada, e só o Perfil é
  /// comum aos dois.
  List<_Aba> get _abas {
    final ehAluno = FFAppState().perfil.tipoPerfilId == 2;

    if (ehAluno) {
      return [
        _Aba(
          indice: 0,
          rota: TreinosWidget.routeName,
          icone: FFIcons.kproperty1FiRrGym,
          rotulo: 'Treino',
        ),
        _Aba(
          indice: 1,
          rota: MetasWidget.routeName,
          icone: Icons.star_border,
          rotulo: 'Metas',
        ),
        _Aba(
          indice: 3,
          rota: MetricasWidget.routeName,
          // `leaderboard_outlined`, e não `bar_chart_outlined`: este último
          // é um dos ícones do Material que não tem variante vazada de
          // verdade: o "_outlined" desenha exatamente o mesmo glifo cheio.
          // As barras aqui são de contorno como as dos vizinhos, senão a aba
          // parece selecionada o tempo todo.
          icone: Icons.leaderboard_outlined,
          rotulo: 'Métricas',
        ),
        _Aba(
          indice: 4,
          rota: PerfilWidget.routeName,
          icone: FFIcons.kproperty1FiRrUser,
          rotulo: 'Perfil',
        ),
      ];
    }

    return [
      _Aba(
        indice: 5,
        rota: TreinosPersonalWidget.routeName,
        icone: FFIcons.kproperty1FiRrGym,
        rotulo: 'Treinos',
      ),
      _Aba(
        indice: 2,
        rota: AlunoWidget.routeName,
        icone: FFIcons.kproperty1FiRrGraduationCap,
        rotulo: 'Alunos',
      ),
      _Aba(
        indice: 3,
        rota: PagamentosWidget.routeName,
        icone: Icons.add_card,
        rotulo: 'Cobrança',
      ),
      _Aba(
        indice: 4,
        rota: PerfilWidget.routeName,
        icone: FFIcons.kproperty1FiRrUser,
        rotulo: 'Perfil',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    context.watch<cupertino_time_picker_hiuzb7_app_state.FFAppState>();

    final tema = FlutterFlowTheme.of(context);
    final atual = widget.index ?? 0;

    final barra = Container(
      decoration: BoxDecoration(
        // No iPhone o fundo é translúcido para o conteúdo aparecer por trás
        // do desfoque; nas outras plataformas fica sólido, já que sem o
        // BackdropFilter a transparência só mostraria o fundo cru.
        //
        // 0.58 em vez de 0.72: com o desfoque de 18 por trás, o conteúdo
        // continua ilegível através da barra, então dá para deixá-la mais
        // aberta sem perder o contraste dos ícones.
        color: isiOS
            ? tema.primaryBackground.withValues(alpha: 0.58)
            : tema.primaryBackground,
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: tema.primaryText.withValues(alpha: 0.06),
          width: 1.0,
        ),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < _abas.length; i++) ...[
            // As abas estavam encostadas uma na outra.
            if (i > 0) SizedBox(width: 4.0),
            _ItemNavbar(
              aba: _abas[i],
              selecionada: _abas[i].indice == atual,
              onTap: () => _irParaAba(_abas[i].rota, _abas[i].indice),
            ),
          ],
        ],
      ),
    );

    // `Material` nao e enfeite: sem ele o Flutter desenha o sublinhado duplo
    // de "texto sem estilo" sob o rotulo, e o InkWell perde o respingo. A
    // barra e irma da pagina no ShellRoute, entao nao herda o Scaffold dela.
    return Padding(
      // A barra flutua: respira nas laterais e fica acima do indicador do
      // iPhone em vez de encostar na borda.
      padding: EdgeInsetsDirectional.fromSTEB(
        16.0,
        0.0,
        16.0,
        MediaQuery.paddingOf(context).bottom + 10.0,
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 1.0),
        child: Material(
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999.0),
            // O desfoque do que passa por trás só existe no iPhone. É uma
            // aproximação do vidro do sistema, não o efeito nativo: o Flutter
            // 3.44 não expõe a API de Liquid Glass do iOS 26.
            child: isiOS
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                    child: barra,
                  )
                : barra,
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['barOnPageLoadAnimation']!);
  }
}

/// Um item da barra.
///
/// Selecionado: pílula azul com ícone e rótulo lado a lado.
/// Não selecionado: só o ícone, sem fundo: é o que faz a aba ativa saltar.
class _ItemNavbar extends StatelessWidget {
  const _ItemNavbar({
    required this.aba,
    required this.selecionada,
    required this.onTap,
  });

  final _Aba aba;
  final bool selecionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 380),
        // easeOutBack passa um pouco do alvo e volta. E o que da a sensacao
        // de massa: a pilula assenta em vez de parar seco.
        curve: Curves.easeOutBack,
        height: 44.0,
        padding: EdgeInsetsDirectional.fromSTEB(
          selecionada ? 16.0 : 14.0,
          0.0,
          selecionada ? 18.0 : 14.0,
          0.0,
        ),
        decoration: BoxDecoration(
          color: selecionada ? tema.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              aba.icone,
              color: selecionada ? Colors.white : tema.secondaryText,
              size: 20.0,
            ),
            // O rótulo só existe na aba ativa: mostrar os quatro encheria a
            // barra e tiraria o contraste que faz a pílula funcionar.
            //
            // O `AnimatedSize` é o que faz a troca parecer contínua: antes o
            // texto aparecia de estalo enquanto só a pílula animava, e era
            // isso que dava a sensação de corte. Agora ele nasce com largura
            // zero e cresce junto, dentro de um `ClipRect` para não vazar
            // enquanto não cabe.
            ClipRect(
              child: AnimatedSize(
                duration: Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                child: !selecionada
                    ? SizedBox(height: 20.0)
                    : Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                        child: Text(
                          aba.rotulo,
                          style: tema.bodyMedium.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w600),
                            color: Colors.white,
                            fontSize: 13.0,
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
    );
  }
}

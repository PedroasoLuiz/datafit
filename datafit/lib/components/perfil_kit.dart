/// As peças de que as fichas de perfil são feitas.
///
/// Antes cada tela de perfil montava a própria barra de topo, o próprio bloco
/// de identidade e a própria lista — três desenhos que foram se afastando com
/// o tempo, a ponto de duas delas equilibrarem o título com um ícone da Apple
/// pintado da cor do fundo, servindo de espaçador invisível.
///
/// Aqui as peças são únicas e as fichas só as compõem. Duas regras atravessam
/// todas elas:
///
/// **Cartão é fundo claro com sombra, nunca borda.** É a sombra que separa o
/// cartão do cinza da tela; um contorno achata tudo e tira a profundidade.
///
/// **Ícone é sempre de contorno.** Ícone cheio pesa como se fosse conteúdo, e
/// numa ficha o conteúdo é o texto — o ícone só orienta.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// O amarelo das estrelas.
///
/// Nao vem do tema: o `warning` (#CF9900) e mostarda, escuro demais para uma
/// estrela — ela some no branco do cartao. Este e o ouro claro que as pessoas
/// esperam numa nota.
const Color corEstrela = Color(0xFFFFC529);

/// Barra de topo das fichas.
///
/// Uma só, com três encaixes. O do meio é o título; os das pontas aceitam
/// qualquer botão, e quando um deles falta o espaço fica reservado — é isso
/// que mantém o título no centro sem precisar de ícone invisível.
class CabecalhoPerfil extends StatelessWidget {
  const CabecalhoPerfil({
    super.key,
    this.titulo = '',
    this.aVoltar,
    this.esquerda,
    this.direita,
    this.sobreCapa = false,
  });

  /// A barra fica por cima da capa colorida: título em branco e botão
  /// translúcido, senão o texto escuro some no azul.
  final bool sobreCapa;

  final String titulo;

  /// Quando presente, desenha o botão de voltar à esquerda.
  final VoidCallback? aVoltar;

  /// Substitui o botão de voltar, para telas que abrem outra coisa ali.
  final Widget? esquerda;
  final Widget? direita;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final aEsquerda = esquerda ??
        (aVoltar == null
            ? null
            : BotaoCirculoPerfil(
                // Seta pequena: a `ArrowLeft` tem a haste longa e, num
                // botao de 36, ela atravessa o circulo de ponta a ponta.
                icone: FFIcons.kproperty1FiRrArrowSmallLeft,
                aoTocar: aVoltar!,
                claro: sobreCapa,
              ));

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        children: [
          // Largura fixa nas pontas: sem ela o título anda para os lados
          // conforme o texto do botão, e a barra "treme" entre telas.
          SizedBox(width: 40.0, child: aEsquerda),
          Expanded(
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: sobreCapa ? Colors.white : tema.primaryText,
                fontSize: 15.0,
                letterSpacing: -0.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 40.0,
            child: direita == null
                ? null
                : Align(
                    alignment: AlignmentDirectional.centerEnd, child: direita),
          ),
        ],
      ),
    );
  }
}

/// Botão redondo de barra: fundo claro, sombra leve, ícone de contorno.
class BotaoCirculoPerfil extends StatelessWidget {
  const BotaoCirculoPerfil({
    super.key,
    required this.icone,
    required this.aoTocar,
    this.badge = 0,
    this.claro = false,
    this.cor,
    this.tamanhoIcone = 20.0,
  });

  /// Cor do ícone. Sem ela, a tinta padrão das fichas.
  final Color? cor;
  final double tamanhoIcone;

  /// Sobre a capa colorida: fundo translúcido e ícone branco.
  final bool claro;

  final IconData icone;
  final VoidCallback aoTocar;

  /// Contador de não lidas. Zero esconde o selo.
  final int badge;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(999.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Circulo, e nao quadrado arredondado: os botoes da barra ficam
          // sobre a capa, ao lado de um avatar redondo, e o canto quadrado
          // destoava do unico outro elemento daquela faixa.
          Container(
            width: 36.0,
            height: 36.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // Preto translucido, e nao branco: sobre o azul da capa o
              // branco a 22% quase nao aparecia, e o botao sumia junto com o
              // caminho de volta.
              color: claro
                  ? Colors.black.withValues(alpha: 0.28)
                  : tema.primaryBackground,
              shape: BoxShape.circle,
              boxShadow: claro ? const [] : [tema.designToken.shadow.sm],
            ),
            child: Icon(icone,
                color: claro ? Colors.white : (cor ?? tema.primaryText),
                size: tamanhoIcone),
          ),
          if (badge > 0)
            Positioned(
              top: -3.0,
              right: -3.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                constraints: const BoxConstraints(minWidth: 17.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // Vermelho: selo de contagem e aviso de coisa nao vista,
                  // e aviso no app e vermelho. Em azul ele se confundia
                  // com os botoes de acao, que sao da mesma cor.
                  color: tema.error,
                  borderRadius: BorderRadius.circular(999.0),
                  border:
                      Border.all(color: tema.secondaryBackground, width: 1.5),
                ),
                child: Text(
                  badge > 9 ? '9+' : '$badge',
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    color: Colors.white,
                    fontSize: 9.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Foto, nome e a linha que qualifica.
///
/// Sem cartão em volta: a identidade **é** a página, não um item dela. A
/// hierarquia vem do tamanho do nome e do ar em volta — que é como um sistema
/// operacional resolve isso —, não de uma moldura branca.
///
/// A linha de baixo é texto puro, nunca pílula. Uma pílula colorida ali
/// recorta a informação da identidade em vez de fazer parte dela.
class IdentidadePerfil extends StatelessWidget {
  const IdentidadePerfil({
    super.key,
    required this.nome,
    required this.foto,
    this.linha,
    this.aoTocarFoto,
  });

  final String nome;
  final String foto;

  /// Rich text para permitir uma palavra colorida no meio — "Ativa" em verde,
  /// por exemplo — sem precisar de fundo.
  final InlineSpan? linha;

  final VoidCallback? aoTocarFoto;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Row(
      children: [
        InkWell(
          onTap: aoTocarFoto,
          borderRadius: BorderRadius.circular(999.0),
          child: AvatarPerfil(foto: foto, nome: nome, tamanho: 62.0),
        ),
        const SizedBox(width: 13.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: tema.primaryText,
                  // 17, e nao 20: com duas linhas de apoio embaixo (credencial
                  // e bio) o nome em corpo 20 dominava o topo inteiro e
                  // empurrava tudo para baixo da dobra.
                  fontSize: 17.0,
                  letterSpacing: -0.4,
                  fontWeight: FontWeight.bold,
                  lineHeight: 1.2,
                ),
              ),
              if (linha != null)
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 3.0, 0.0, 0.0),
                  child: Text.rich(
                    linha!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      color: tema.secondaryText,
                      fontSize: 12.5,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Capa sólida, avatar cavalgando a borda e ações à direita.
///
/// A ficha antes abria com avatar e nome lado a lado, e nada dizia onde o
/// cabeçalho terminava. A faixa de cor resolve isso sem imagem nenhuma: ela
/// fecha o topo, dá à foto um fundo próprio e cria a linha em que o avatar se
/// apoia — que é o mesmo recurso que redes sociais usam, só que sem pedir uma
/// foto de capa que ninguém vai subir.
///
/// O nome vai abaixo da foto, não ao lado: com as ações ocupando a direita,
/// sobrariam poucos centímetros para ele, e nome truncado é o pior lugar para
/// economizar espaço numa ficha de pessoa.
class CapaPerfil extends StatelessWidget {
  const CapaPerfil({
    super.key,
    required this.nome,
    required this.foto,
    this.linha,
    this.bio,
    this.acoes = const [],
    this.aoTocarFoto,
    this.alturaExtraTopo = 0.0,
    this.acaoCapa,
    this.extra,
  });

  /// Bloco livre entre a linha de identidade e a bio — "ativo desde", medidas,
  /// o que a ficha precisar acrescentar sem virar mais um cartão.
  final Widget? extra;

  /// Botão no canto da capa — trocar a foto, por exemplo.
  final Widget? acaoCapa;

  /// Quanto a capa precisa subir para passar por tras da barra de status e do
  /// cabecalho.
  ///
  /// A capa cresce para cima em vez de existir uma faixa fixa no topo da tela:
  /// faixa fixa nao rola, entao ao subir o conteudo sobrava um azul parado
  /// atras do cabecalho — que nao e como uma capa se comporta.
  final double alturaExtraTopo;

  final String nome;
  final String foto;
  final InlineSpan? linha;
  final String? bio;

  /// Botões alinhados à direita, na altura da borda da capa.
  final List<Widget> acoes;

  final VoidCallback? aoTocarFoto;

  static const double _capa = 92.0;
  static const double _avatar = 76.0;
  static const double _borda = 4.0;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _capa + alturaExtraTopo + 54.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // A capa sangra para fora do recuo da ficha: faixa de cor que
              // para antes da borda vira um retangulo solto, nao uma capa.
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: _capa + alturaExtraTopo,
                child: Container(color: tema.primary),
              ),
              // Metade dentro da capa, metade fora — e o encaixe que faz a
              // foto pertencer as duas faixas.
              Positioned(
                top: _capa + alturaExtraTopo - (_avatar + _borda * 2) / 2,
                left: 16.0,
                child: InkWell(
                  onTap: aoTocarFoto,
                  borderRadius: BorderRadius.circular(999.0),
                  child: Container(
                    padding: const EdgeInsets.all(_borda),
                    decoration: BoxDecoration(
                      // O anel e da cor do fundo da tela, nao branco: e ele
                      // que recorta a foto das duas faixas atras dela.
                      color: tema.secondaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child:
                        AvatarPerfil(foto: foto, nome: nome, tamanho: _avatar),
                  ),
                ),
              ),
              if (acaoCapa != null)
                Positioned(
                  // Dentro da capa, colado no rodape dela: e uma acao sobre a
                  // capa, nao sobre a ficha.
                  top: _capa + alturaExtraTopo - 46.0,
                  right: 16.0,
                  child: acaoCapa!,
                ),
              if (acoes.isNotEmpty)
                Positioned(
                  top: _capa + alturaExtraTopo + 8.0,
                  right: 16.0,
                  child: Row(mainAxisSize: MainAxisSize.min, children: acoes),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Text(
            nome,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: tema.primaryText,
              fontSize: 17.0,
              letterSpacing: -0.4,
              fontWeight: FontWeight.bold,
              lineHeight: 1.2,
            ),
          ),
        ),
        if (linha != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 3.0, 16.0, 0.0),
            child: Text.rich(
              linha!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 12.5,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if ((bio ?? '').isNotEmpty)
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
            child: Text(
              bio!,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                color: tema.secondaryText,
                fontSize: 12.5,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
                lineHeight: 1.5,
              ),
            ),
          ),
        if (extra != null)
          Padding(
            // Mais ar que o normal: o nick fecha a identidade, e o que vem
            // depois e outro assunto — colados, os dois se liam como uma
            // legenda de tres linhas.
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
            child: extra!,
          ),
      ],
    );
  }
}

/// Foto redonda com recuo para iniciais.
///
/// As iniciais existem porque a alternativa que estava no ar era pior: duas
/// das telas caíam numa foto genérica hospedada num domínio de terceiros,
/// dentro da nossa identidade e fora do nosso controle.
class AvatarPerfil extends StatelessWidget {
  const AvatarPerfil({
    super.key,
    required this.foto,
    required this.nome,
    this.tamanho = 40.0,
  });

  final String foto;
  final String nome;
  final double tamanho;

  String get _iniciais {
    final partes =
        nome.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    Widget semFoto() => Container(
          width: tamanho,
          height: tamanho,
          alignment: Alignment.center,
          color: tema.accent1,
          child: _iniciais.isEmpty
              ? Icon(FFIcons.kproperty1FiRrUser,
                  color: tema.primary, size: tamanho * 0.45)
              : Text(
                  _iniciais,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    color: tema.primary,
                    fontSize: tamanho * 0.32,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        );

    return ClipOval(
      child: SizedBox(
        width: tamanho,
        height: tamanho,
        child: foto.isEmpty
            ? semFoto()
            : CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: foto,
                width: tamanho,
                height: tamanho,
                fit: BoxFit.cover,
                // Enquanto carrega e se falhar, as iniciais: um quadrado cinza
                // piscando no lugar do rosto chama mais atencao que a pessoa.
                placeholder: (_, __) => semFoto(),
                errorWidget: (_, __, ___) => semFoto(),
              ),
      ),
    );
  }
}

/// O cartão branco que agrupa linhas.
///
/// Sem borda: fundo claro e a sombra `lg` do tema, que é o que o resto do app
/// usa. As divisórias entre linhas são desenhadas aqui, não pelos filhos —
/// assim nenhuma lista termina com um risco solto no rodapé.
class CartaoPerfil extends StatelessWidget {
  const CartaoPerfil({
    super.key,
    required this.filhos,
    this.padding,
    this.divisoriaNoTexto = false,
  });

  final List<Widget> filhos;
  final EdgeInsetsGeometry? padding;

  /// Recua a divisória até onde o texto começa, passando por baixo do ícone.
  ///
  /// Numa lista em que toda linha tem ícone, o risco que atravessa por baixo
  /// deles corta a coluna de ícones ao meio; começando junto do texto, ele
  /// separa os itens sem cruzar nada.
  final bool divisoriaNoTexto;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    if (filhos.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < filhos.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1.0,
                thickness: 1.0,
                indent: divisoriaNoTexto ? 57.0 : 14.0,
                endIndent: 14.0,
                color: tema.alternate.withValues(alpha: 0.45),
              ),
            filhos[i],
          ],
        ],
      ),
    );
  }
}

/// Uma linha dentro do [CartaoPerfil].
class LinhaPerfil extends StatelessWidget {
  const LinhaPerfil({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.icone,
    this.corIcone,
    this.fundoIcone,
    this.textoIcone,
    this.valor,
    this.apoioValor,
    this.aoTocar,
    this.mostraSeta = false,
    this.acao,
    this.destrutiva = false,
  });

  final String titulo;
  final String? subtitulo;

  /// Ícone de contorno à esquerda. Sem ele e sem [textoIcone], a linha começa
  /// no texto — é o que as listas de medida usam.
  final IconData? icone;
  final Color? corIcone;
  final Color? fundoIcone;

  /// Alternativa ao ícone: duas ou três letras no mesmo quadrado.
  final String? textoIcone;

  /// Valor à direita, em destaque.
  final String? valor;

  /// Linha de apoio sob o valor.
  final String? apoioValor;

  final VoidCallback? aoTocar;
  final bool mostraSeta;

  /// Palavra de ação à direita, no azul — "trocar", "copiar", "informar".
  final String? acao;

  /// Vermelho para sair e excluir conta.
  final bool destrutiva;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final temMarca = icone != null || textoIcone != null;

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 12.0),
        child: Row(
          children: [
            if (temMarca) ...[
              Container(
                width: 32.0,
                height: 32.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: fundoIcone ?? tema.accent1,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: textoIcone != null
                    ? Text(
                        textoIcone!,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                          color: corIcone ?? tema.primary,
                          fontSize: 11.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Icon(icone, color: corIcone ?? tema.primary, size: 18.0),
              ),
              const SizedBox(width: 11.0),
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
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      color: destrutiva ? tema.error : tema.primaryText,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if ((subtitulo ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 1.0, 0.0, 0.0),
                      child: Text(
                        subtitulo!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                          color: tema.secondaryText,
                          fontSize: 11.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (valor != null || acao != null || apoioValor != null) ...[
              const SizedBox(width: 10.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (valor != null)
                    Text(
                      valor!,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        color: tema.primaryText,
                        fontSize: 13.5,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (acao != null)
                    Text(
                      acao!,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: tema.primary,
                        fontSize: 11.5,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (apoioValor != null)
                    Text(
                      apoioValor!,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w400),
                        color: tema.secondaryText,
                        fontSize: 10.5,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
            if (mostraSeta) ...[
              const SizedBox(width: 2.0),
              Icon(FFIcons.kproperty1FiRrAngleSmallRight,
                  color: tema.alternate, size: 20.0),
            ],
          ],
        ),
      ),
    );
  }
}

/// Cabeçalho de seção: o título à esquerda e, se houver, um filtro à direita.
///
/// O filtro fica **aqui**, e não numa segunda fileira de chips. Duas fileiras
/// empilhadas parecem as duas navegação, e ninguém descobre qual manda.
class CabecaSecao extends StatelessWidget {
  const CabecaSecao({
    super.key,
    required this.titulo,
    this.filtro,
    this.aoTocarFiltro,
  });

  final String titulo;
  final String? filtro;
  final VoidCallback? aoTocarFiltro;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: tema.primaryText,
              fontSize: 13.0,
              letterSpacing: -0.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Sem acao, sem cara de botao: o contorno e a seta prometiam um menu,
        // e "4 de 12" nao abre nada — e so a contagem da secao.
        if (filtro != null && aoTocarFiltro == null)
          Text(
            filtro!,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 11.5,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          )
        else if (filtro != null)
          InkWell(
            onTap: aoTocarFiltro,
            borderRadius: BorderRadius.circular(999.0),
            child: Container(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 5.0, 9.0, 5.0),
              // So contorno, como o chip nao selecionado: com fundo e sombra
              // ele competia com os chips de navegacao logo acima e parecia
              // uma terceira aba.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.0),
                border: Border.all(color: tema.alternate, width: 1.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filtro!,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      color: tema.secondaryText,
                      fontSize: 11.5,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(FFIcons.kproperty1FiRrAngleSmallDown,
                      color: tema.secondaryText, size: 14.0),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Os três contadores públicos do personal.
///
/// Este desenho fica reservado à prova social. Ele já foi usado também para
/// idade, peso e altura — mesma forma para significados opostos, e quem
/// aprendia a ler um lia o outro errado.
class TrioPerfil extends StatelessWidget {
  const TrioPerfil({super.key, required this.itens});

  /// Valor, rótulo e se o valor leva a estrela ao lado.
  final List<({String valor, String rotulo, bool nota})> itens;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [tema.designToken.shadow.lg],
      ),
      // Mais alto que as linhas comuns: e o cartao que carrega a prova
      // social, e altura e o jeito mais barato de dar peso sem cor.
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        children: [
          for (final item in itens)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.valor,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: tema.primaryText,
                          fontSize: 18.0,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.nota) ...[
                        const SizedBox(width: 3.0),
                        // Amarelo, e nao o laranja da marca: estrela de
                        // avaliacao e um simbolo que as pessoas ja leem em
                        // ouro, e o laranja aqui competia com o foguinho da
                        // sequencia, que usa a mesma cor para outra coisa.
                        Icon(Icons.star_rounded, color: corEstrela, size: 15.0),
                      ],
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        4.0, 2.0, 4.0, 0.0),
                    child: Text(
                      item.rotulo,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        color: tema.secondaryText,
                        fontSize: 10.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Os números públicos do personal, em texto corrido.
///
/// Saíram do cartão: um bloco branco com três colunas dava a eles peso de
/// seção, quando são uma legenda da identidade. Em texto, com só os números em
/// negrito, eles se leem junto do nome — que é onde a pergunta "quem é essa
/// pessoa" ainda está aberta.
class EstatisticasPerfil extends StatelessWidget {
  const EstatisticasPerfil({
    super.key,
    required this.alunos,
    required this.treinos,
    required this.nota,
    required this.avaliacoes,
  });

  final int alunos;
  final int treinos;
  final double nota;
  final int avaliacoes;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final forte = tema.bodyMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
      color: tema.primaryText,
      fontSize: 13.5,
      letterSpacing: -0.2,
      fontWeight: FontWeight.bold,
    );
    // Menor e mais leve que o numero: a palavra so nomeia o que o numero ja
    // disse, e com o mesmo peso os dois competiam.
    final fraco = tema.bodyMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w400),
      color: tema.secondaryText,
      fontSize: 12.0,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w400,
    );

    // Uma linha so, com a nota no fim.
    //
    // A nota estava numa linha acima, e isso lhe dava peso de titulo — quando
    // ela e mais um numero da mesma familia. Em sequencia, os tres se leem de
    // uma vez e o bloco encolhe pela metade, que e o que a identidade pedia.
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 14.0,
      runSpacing: 4.0,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: '$alunos', style: forte),
          TextSpan(text: alunos == 1 ? ' aluno' : ' alunos', style: fraco),
        ])),
        Text.rich(TextSpan(children: [
          TextSpan(text: '$treinos', style: forte),
          TextSpan(text: treinos == 1 ? ' treino' : ' treinos', style: fraco),
        ])),
        if (avaliacoes > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: corEstrela, size: 15.0),
              const SizedBox(width: 4.0),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: nota.toStringAsFixed(1).replaceAll('.', ','),
                    style: forte),
                TextSpan(
                    text: avaliacoes == 1
                        ? '  1 avaliação'
                        : '  $avaliacoes avaliações',
                    style: fraco),
              ])),
            ],
          ),
      ],
    );
  }
}

/// O cartão de número do kit de métricas, reaproveitado nas fichas.
///
/// Mesmo desenho da home e do painel: rótulo em cima, número grande, leitura
/// embaixo, disco à direita. Inventar um terceiro jeito de mostrar um número
/// seria criar dialeto dentro da própria casa.
class CartaoValorPerfil extends StatelessWidget {
  const CartaoValorPerfil({
    super.key,
    required this.rotulo,
    required this.valor,
    this.comparacao,
    this.icone,
    this.realce = false,
    this.aoTocar,
  });

  final String rotulo;
  final String valor;
  final String? comparacao;
  final IconData? icone;

  /// Pinta o número de laranja. Para o que exige atenção — valor em aberto,
  /// sequência alta.
  final bool realce;

  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: tema.primaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [tema.designToken.shadow.lg],
        ),
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rotulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 11.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
              child: Row(
                // `spaceBetween`, e nao um Spacer: o texto e o Spacer sao os
                // dois flexiveis da linha e dividiriam a folga meio a meio,
                // deixando o disco parado no meio do cartao.
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      valor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tema.bodyMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        color: realce ? tema.secondary : tema.primaryText,
                        fontSize: 24.0,
                        letterSpacing: -0.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (icone != null) ...[
                    const SizedBox(width: 6.0),
                    Container(
                      width: 34.0,
                      height: 34.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: realce
                            ? tema.secondary.withValues(alpha: 0.14)
                            : tema.accent1,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icone,
                          color: realce ? tema.secondary : tema.primary,
                          size: 18.0),
                    ),
                  ],
                ],
              ),
            ),
            if ((comparacao ?? '').isNotEmpty)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                child: Text(
                  comparacao!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 10.5,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Cinco estrelas cheias, amarelas até a nota e cinzas depois.
///
/// A estrela é o único ícone preenchido das fichas, e é assim de propósito:
/// nota é símbolo antes de ser dado, e estrela vazada perde a leitura
/// instantânea que faz a nota funcionar de relance. Por isso vem do Material e
/// não da família de contorno do app.
class EstrelasPerfil extends StatelessWidget {
  const EstrelasPerfil({
    super.key,
    required this.nota,
    this.tamanho = 16.0,
  });

  final int nota;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            Icons.star_rounded,
            size: tamanho,
            color: i <= nota ? corEstrela : tema.alternate,
          ),
      ],
    );
  }
}

/// A fileira de chips que divide o conteúdo da ficha.
///
/// Uma só por tela. É a navegação; qualquer outro filtro mora no cabeçalho da
/// seção.
class ChipsPerfil extends StatelessWidget {
  const ChipsPerfil({
    super.key,
    required this.rotulos,
    required this.selecionado,
    required this.aoSelecionar,
  });

  final List<String> rotulos;
  final int selecionado;
  final void Function(int) aoSelecionar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    // `Align` por fora: a rolagem horizontal encolhe ate o tamanho dos chips,
    // e uma Column alinha os filhos pelo centro por padrao — entao a fileira
    // nascia centralizada por mais que ninguem tivesse pedido. O Align ocupa a
    // largura toda e encosta o conteudo na esquerda.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < rotulos.length; i++) ...[
              if (i > 0) const SizedBox(width: 7.0),
              InkWell(
                onTap: () => aoSelecionar(i),
                borderRadius: BorderRadius.circular(999.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  height: 34.0,
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      15.0, 0.0, 15.0, 0.0),
                  decoration: BoxDecoration(
                    color: i == selecionado ? tema.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(999.0),
                    border: Border.all(
                      color: i == selecionado ? tema.primary : tema.alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    rotulos[i],
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: i == selecionado
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      color:
                          i == selecionado ? Colors.white : tema.secondaryText,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          i == selecionado ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Botão de ícone das fichas: largura mínima, sombra, ícone de contorno.
///
/// Contato é atalho, não ação principal — e três botões de mesma largura
/// diziam que as três ações pesavam igual.
class AcaoIconePerfil extends StatelessWidget {
  const AcaoIconePerfil({
    super.key,
    this.icone,
    this.desenho,
    required this.aoTocar,
  }) : assert(icone != null || desenho != null);

  final IconData? icone;

  /// Para glifos que não são `IconData` — o do WhatsApp, por exemplo, é
  /// `FaIconData` e precisa do `FaIcon` para ser desenhado.
  final Widget? desenho;

  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(999.0),
      // Fundo claro com icone azul, e nao o contrario: estes botoes ficam
      // sobre a capa, e um circulo azul sobre fundo azul desaparece.
      child: Container(
        width: 34.0,
        height: 34.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tema.primaryBackground,
          shape: BoxShape.circle,
          boxShadow: [tema.designToken.shadow.sm],
        ),
        // Preto, como os demais icones das fichas: o azul aqui repetia a cor
        // da capa logo atras e fazia o botao parecer parte dela.
        child: desenho ?? Icon(icone, color: tema.primaryText, size: 15.0),
      ),
    );
  }
}

/// Botão largo das fichas. Cheio para a ação principal, claro para o resto.
class AcaoPerfil extends StatelessWidget {
  const AcaoPerfil({
    super.key,
    required this.rotulo,
    required this.aoTocar,
    this.icone,
    this.principal = false,
  });

  final String rotulo;
  final VoidCallback aoTocar;
  final IconData? icone;
  final bool principal;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(13.0),
      child: Container(
        height: 38.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: principal ? tema.primary : tema.primaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            principal ? tema.designToken.shadow.sm : tema.designToken.shadow.lg
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icone != null) ...[
              Icon(icone,
                  color: principal ? Colors.white : tema.primaryText,
                  size: 16.0),
              const SizedBox(width: 7.0),
            ],
            Flexible(
              child: Text(
                rotulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tema.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: principal ? Colors.white : tema.primaryText,
                  fontSize: 12.5,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

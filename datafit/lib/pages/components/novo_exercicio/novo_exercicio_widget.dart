import '/auth/supabase_auth/auth_util.dart';
import '/backend/diagnostico.dart';
import '/backend/supabase/supabase.dart';
import '/components/mensagem_widget.dart';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

import '/components/video_exercicio.dart';
import '/custom_code/widgets/dashed_button.dart';
import '/backend/supabase/storage/storage.dart';
import '/flutter_flow/upload_data.dart';
import '/components/folha_kit.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'novo_exercicio_model.dart';
export 'novo_exercicio_model.dart';

class NovoExercicioWidget extends StatefulWidget {
  const NovoExercicioWidget({
    super.key,
    this.exercicioId,
    this.nomeInicial,
    this.subcatIdInicial,
    this.linkInicial,
  });

  final int? exercicioId;
  final String? nomeInicial;
  final int? subcatIdInicial;
  final String? linkInicial;

  @override
  State<NovoExercicioWidget> createState() => _NovoExercicioWidgetState();
}

class _NovoExercicioWidgetState extends State<NovoExercicioWidget>
    with TickerProviderStateMixin {
  late NovoExercicioModel _model;

  /// Le a capa ja escolhida quando se abre um exercicio para editar.
  ///
  /// Nao vem por parametro porque as telas que abrem esta folha so conhecem
  /// nome, link e subcategoria — passar mais um campo obrigaria a mexer em
  /// todos os pontos de chamada por um dado que so esta folha usa.
  Future<void> _carregarCapaAtual() async {
    if (widget.exercicioId == null) return;
    try {
      final linha = await SupaFlow.client
          .from('Exercicios')
          .select('ThumbSegundo')
          .eq('Id', widget.exercicioId!)
          .maybeSingle();
      final v = (linha as Map?)?['ThumbSegundo'];
      if (v == null || !mounted) return;
      safeSetState(() => _thumbSegundo = (v as num).toDouble());
    } catch (_) {
      // Sem a capa salva a regua comeca no zero, que e o padrao.
    }
  }

  /// Video escolhido, ainda no aparelho.
  ///
  /// Nulo nao quer dizer "sem video": ao editar um exercicio que ja tem
  /// video, o arquivo segue no storage e este campo continua nulo.
  String? _videoLocal;

  /// Verdadeiro so durante o envio, que agora acontece ao salvar.
  bool _enviandoVideo = false;

  /// Segundo do video escolhido como capa, em `SeletorCapaVideo`.
  ///
  /// Nulo quer dizer "primeiro quadro", que e o padrao de quem nao mexeu na
  /// regua. Vai para a coluna `ThumbSegundo` de Exercicios.
  double? _thumbSegundo;

  /// Escolhe o video. Nao envia nada: so guarda o caminho no aparelho.
  ///
  /// Antes o arquivo subia para o bucket no instante da escolha. Quem abria a
  /// folha, mandava um video e desistia deixava o arquivo la para sempre —
  /// sem nenhuma linha no banco apontando para ele, ou seja, sem como achar
  /// nem limpar depois.
  Future<void> _escolherVideo() async {
    if (_enviandoVideo) return;

    final selecionados = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: currentUserUid,
      allowPhoto: false,
      allowVideo: true,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      textColor: FlutterFlowTheme.of(context).primaryText,
    );
    if (selecionados == null || selecionados.isEmpty) return;

    final caminho = selecionados.first.filePath;
    if (caminho == null || caminho.isEmpty) {
      await _avisar('Não consegui ler este arquivo. Tente outro vídeo.');
      return;
    }

    if (!mounted) return;
    safeSetState(() {
      _videoLocal = caminho;
      // Video novo, capa nova: o instante do anterior nao quer dizer nada
      // neste arquivo.
      _thumbSegundo = null;
      // O campo de link guarda a URL do storage. Com video local ele nao vale
      // mais, e o antigo continuaria mandando na previa.
      _model.txtLinkTextController?.text = '';
    });
  }

  /// Sobe o video e a capa. Roda no salvar, nao na escolha.
  ///
  /// Devolve `(urlVideo, urlCapa)`. Nulo quer dizer que o envio falhou e o
  /// exercicio nao deve ser gravado apontando para lugar nenhum.
  Future<(String, String?)?> _subirVideoECapa() async {
    final caminho = _videoLocal;
    if (caminho == null) return null;

    try {
      final urls = await uploadSupabaseStorageFiles(
        bucketName: 'Videos',
        selectedFiles: [
          SelectedFile(
            storagePath: '$currentUserUid/'
                '${DateTime.now().microsecondsSinceEpoch}'
                '${p.extension(caminho)}',
            filePath: caminho,
            bytes: await File(caminho).readAsBytes(),
          ),
        ],
      );
      final urlVideo = urls.firstOrNull;
      if (urlVideo == null || urlVideo.isEmpty) return null;

      return (urlVideo, await _subirCapa(caminho));
    } catch (e) {
      await anotarDiagnostico('video_erro', '$e');
      return null;
    }
  }

  /// Gera a imagem de capa no instante escolhido e sobe junto do video.
  ///
  /// Guardar a IMAGEM, e nao so o instante, e o que deixa a grade de videos
  /// ser imagem pura: com o instante, cada celula precisaria manter um player
  /// de video vivo so para pintar o quadro — nao escala e nao tem cache.
  ///
  /// Falhar aqui nao derruba o exercicio: sem capa a celula cai no fundo
  /// escuro, que era o comportamento anterior.
  Future<String?> _subirCapa(String caminhoVideo) async {
    if (kIsWeb) return null;

    // Cada saida anota onde parou. A capa vinha falhando calada — o exercicio
    // gravava com `ThumbSegundo` preenchido e `ThumbUrl` nulo, e desse lado
    // nao dava para distinguir plugin ausente, formato recusado e upload
    // barrado.
    final timeMs = ((_thumbSegundo ?? 0.0) * 1000).round();
    await anotarDiagnostico(
        'capa_inicio', '${p.extension(caminhoVideo)} em ${timeMs}ms');
    try {
      final capa = await VideoThumbnail.thumbnailFile(
        video: caminhoVideo,
        imageFormat: ImageFormat.JPEG,
        timeMs: timeMs,
        quality: 80,
        maxWidth: 720,
      );
      if (capa == null) {
        await anotarDiagnostico('capa_sem_arquivo', 'thumbnailFile deu nulo');
        return null;
      }

      final bytes = await File(capa).readAsBytes();
      final urls = await uploadSupabaseStorageFiles(
        bucketName: 'Videos',
        selectedFiles: [
          SelectedFile(
            storagePath: '$currentUserUid/capa_'
                '${DateTime.now().microsecondsSinceEpoch}.jpg',
            filePath: capa,
            bytes: bytes,
          ),
        ],
      );
      final url = urls.firstOrNull;
      if (url == null || url.isEmpty) {
        await anotarDiagnostico('capa_sem_url',
            'gerou ${bytes.length} bytes mas o upload nao voltou url');
        return null;
      }
      await anotarDiagnostico('capa_ok', url);
      return url;
    } catch (e) {
      await anotarDiagnostico('capa_erro', '$e');
      return null;
    }
  }

  Future<void> _avisar(String texto) async {
    await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => MensagemWidget(
        texto: texto,
        tipo: '2',
        action: () async {},
        fechasozinho: true,
        mostrabotoes: false,
      ),
    );
  }

  List<SubcatOption> _subcats = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovoExercicioModel());

    _carregarCapaAtual();

    _model.txtNomeTextController ??=
        TextEditingController(text: widget.nomeInicial ?? '');
    _model.txtNomeFocusNode ??= FocusNode();

    _model.txtLinkTextController ??=
        TextEditingController(text: widget.linkInicial ?? '');
    _model.txtLinkFocusNode ??= FocusNode();

    _model.columnController ??= ScrollController();

    _carregarSubcats();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _carregarSubcats() async {
    try {
      final rows = await SupaFlow.client
          .from('SubCategoriasTrabalhadas')
          .select('Id, Descricao')
          .order('Descricao', ascending: true);
      final list = (rows as List)
          .map((r) => SubcatOption(
                id: (r['Id'] as num).toInt(),
                nome: r['Descricao'] as String? ?? '',
              ))
          .toList();
      if (mounted) safeSetState(() => _subcats = list);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final ehEdicao = widget.exercicioId != null;
    final temVideo = _videoLocal != null ||
        ehVideoDaPlataforma(_model.txtLinkTextController?.text);
    final subcat = _model.subcatController ??=
        FormFieldController<int>(widget.subcatIdInicial ?? 0);

    return FolhaPadrao(
      aoConfirmar: _gravar,
      filhos: [
        CabecaFolha(
          titulo: ehEdicao ? 'Editar exercício' : 'Novo exercício',
          apoio: 'Ele fica na sua biblioteca e serve a todos os alunos.',
          icone: FFIcons.kproperty1FiRrGym,
        ),
        // O video vem primeiro, e nao depois do nome: enterrado no fim, a
        // previa ficava pequena e fora de vista.
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              MedidasFolha.lado, 0.0, MedidasFolha.lado, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RotuloFolha('Vídeo de demonstração (opcional)'),
              DashedButton(
                width: double.infinity,
                height: 46.0,
                label: _enviandoVideo
                    ? 'Enviando…'
                    : (temVideo ? 'Trocar vídeo' : 'Escolher vídeo'),
                labelSize: 14.0,
                labelColor: FlutterFlowTheme.of(context).primary,
                fontWeight: 'semibold',
                icon: Icon(_enviandoVideo
                    ? Icons.cloud_upload_rounded
                    : Icons.videocam_rounded),
                iconSize: 18.0,
                borderColor: FlutterFlowTheme.of(context).primary,
                borderRadius: 12.0,
                // Sem preenchimento: a borda tracejada e o desenho de "aqui
                // ainda nao tem nada". O azul claro por tras fazia o botao
                // parecer uma acao ja resolvida.
                onPressed: _enviandoVideo ? null : _escolherVideo,
              ),
              if (temVideo)
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: SeletorCapaVideo(
                    // A chave amarra o seletor a origem: trocar o video recria
                    // o widget em vez de reaproveitar o player apontando para
                    // o arquivo antigo.
                    key: ValueKey(
                        _videoLocal ?? _model.txtLinkTextController!.text),
                    caminhoLocal: _videoLocal,
                    url: _model.txtLinkTextController?.text,
                    segundoInicial: _thumbSegundo,
                    aoEscolher: (s) => _thumbSegundo = s,
                  ),
                ),
            ],
          ),
        ),
        CampoFolha(
          rotulo: 'Nome do exercício',
          dica: 'Ex: Supino reto com barra',
          controlador: _model.txtNomeTextController,
          foco: _model.txtNomeFocusNode,
          autofoco: true,
        ),
        DropFolha<int>(
          rotulo: 'Grupo muscular (opcional)',
          dica: 'Selecionar grupo...',
          controlador: subcat,
          opcoes: [0, ..._subcats.map((s) => s.id)],
          rotulos: ['Nenhum', ..._subcats.map((s) => s.nome)],
          preenchido: (subcat.value ?? 0) > 0,
          aoMudar: (valor) => safeSetState(() => subcat.value = valor),
        ),
        // O link so aparece sem video enviado. Com video, este campo mostraria
        // a URL do storage: um texto enorme que nao diz nada ao personal e que
        // ele nao deve editar.
        if (!temVideo)
          CampoFolha(
            rotulo: 'ou link do YouTube (opcional)',
            dica: 'https://youtube.com/...',
            controlador: _model.txtLinkTextController,
            foco: _model.txtLinkFocusNode,
            teclado: TextInputType.url,
          ),
      ],
    );
  }

  /// Grava o exercicio. Devolve `null` sem fechar quando algo barra.
  Future<Object?> _gravar() async {
    final nome = _model.txtNomeTextController?.text.trim() ?? '';
    if (nome.isEmpty) return null;

    final ehEdicao = widget.exercicioId != null;

    // Nome repetido barra antes de subir video: nao adianta gastar o upload
    // de quem vai receber uma recusa em seguida.
    final existentes = await SupaFlow.client
        .from('Exercicios')
        .select('Id')
        .or('CriadorPerfisId.is.null,CriadorPerfisId.eq.$currentUserUid')
        .or('IsDeleted.is.null,IsDeleted.eq.false')
        .ilike('Descricao', nome);

    final duplicatas = List<Map<String, dynamic>>.from(existentes as List);
    if (ehEdicao) {
      duplicatas
          .removeWhere((e) => (e['Id'] as num).toInt() == widget.exercicioId);
    }
    if (duplicatas.isNotEmpty) {
      await _avisar('Já existe um exercício com este nome');
      return null;
    }

    // O video so vai para o storage aqui, com o exercicio ja validado: assim
    // nao sobra arquivo orfao de quem escolheu um video e desistiu antes de
    // salvar.
    String? link = _model.txtLinkTextController?.text.trim();
    String? capaUrl;
    if (_videoLocal != null) {
      safeSetState(() => _enviandoVideo = true);
      final enviado = await _subirVideoECapa();
      if (!mounted) return null;
      safeSetState(() => _enviandoVideo = false);
      if (enviado == null) {
        await _avisar('Não consegui enviar o vídeo. '
            'Veja se ele tem menos de 100 MB.');
        return null;
      }
      link = enviado.$1;
      capaUrl = enviado.$2;
    }

    final subcatCru = _model.subcatController?.value ?? 0;
    final subcatId = subcatCru > 0 ? subcatCru : null;

    if (ehEdicao) {
      await SupaFlow.client.from('Exercicios').update({
        'Descricao': nome,
        'SubCategoriasTrabalhadasId': subcatId,
        'LinkInstrucao': (link != null && link.isNotEmpty) ? link : null,
        'ThumbSegundo': _thumbSegundo,
        // Sem capa nova, mantem a que ja estava gravada.
        if (capaUrl != null) 'ThumbUrl': capaUrl,
      }).eq('Id', widget.exercicioId!);
    } else {
      await SupaFlow.client.from('Exercicios').insert({
        'Descricao': nome,
        'CriadorPerfisId': currentUserUid,
        if (subcatId != null) 'SubCategoriasTrabalhadasId': subcatId,
        if (link != null && link.isNotEmpty) 'LinkInstrucao': link,
        if (_thumbSegundo != null) 'ThumbSegundo': _thumbSegundo,
        if (capaUrl != null) 'ThumbUrl': capaUrl,
      });
    }

    return true;
  }
}

/// Triagem de primeiro acesso, para quem se cadastrou sozinho (e-mail ou Google).
///
/// Duas etapas:
///   1. Papel — cria o registro em `Perfis`. Sem isso o `tipoPerfilId` vem 0, o
///      `loading_widget` cai no `else` e a pessoa aterrissa na lista de alunos
///      do personal, vazia.
///   2. Apresentação — foto e bio, ambas opcionais. Serve aos dois papéis: o
///      personal aparece para os alunos, o aluno aparece para o personal.
///
/// Quem já tem perfil (o aluno convidado antes de se cadastrar) não passa por
/// aqui: o `loading_widget` só roteia pra cá quando não há perfil, e a RPC de
/// criação é idempotente de qualquer forma.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';

class EscolherPapelWidget extends StatefulWidget {
  const EscolherPapelWidget({super.key});

  static String routeName = 'escolherPapel';
  static String routePath = '/escolher-papel';

  @override
  State<EscolherPapelWidget> createState() => _EscolherPapelWidgetState();
}

class _EscolherPapelWidgetState extends State<EscolherPapelWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// 0 = escolher papel · 1 = foto e bio
  int _etapa = 0;

  bool _ocupado = false;
  String? _erro;

  String? _papelEscolhido;
  String? _fotoUrl;
  bool _enviandoFoto = false;

  late final TextEditingController _nomeController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: _nomeDoProvedor ?? '');
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// Nome que o provedor social já entregou, pra não pedir de novo.
  String? get _nomeDoProvedor {
    final meta = SupaFlow.client.auth.currentUser?.userMetadata;
    final nome = (meta?['full_name'] ?? meta?['name']) as String?;
    final limpo = nome?.trim();
    return (limpo == null || limpo.isEmpty) ? null : limpo;
  }

  // ---------------------------------------------------------------- etapa 1

  Future<void> _escolher(String papel) async {
    if (_ocupado) return;
    safeSetState(() {
      _ocupado = true;
      _erro = null;
    });

    try {
      // SupaFlow.client.rpc porque a RPC depende de auth.uid(): as calls
      // geradas pelo FlutterFlow mandam a anon key e o uid chegaria nulo.
      final resposta = await SupaFlow.client.rpc(
        'criar_perfil_inicial',
        params: {'p_papel': papel, 'p_nome': _nomeDoProvedor},
      );

      final mapa = (resposta as Map?)?.cast<String, dynamic>() ?? {};
      if (mapa['ok'] != true) {
        safeSetState(() {
          _ocupado = false;
          _erro = 'Não foi possível concluir o cadastro. Tente de novo.';
        });
        return;
      }

      safeSetState(() {
        _ocupado = false;
        _papelEscolhido = papel;
        _etapa = 1;
      });
    } catch (_) {
      safeSetState(() {
        _ocupado = false;
        _erro = 'Falha de conexão. Confira sua internet e tente de novo.';
      });
    }
  }

  // ---------------------------------------------------------------- etapa 2

  Future<void> _escolherFoto() async {
    if (_enviandoFoto) return;

    final selecionadas = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
    );
    if (selecionadas == null || selecionadas.isEmpty) return;
    if (!selecionadas
        .every((m) => validateFileFormat(m.storagePath, context))) {
      return;
    }

    safeSetState(() {
      _enviandoFoto = true;
      _erro = null;
    });

    try {
      final urls = await uploadSupabaseStorageFiles(
        bucketName: 'Imagens',
        selectedFiles: selecionadas,
      );
      final url = urls.firstOrNull;
      safeSetState(() {
        _enviandoFoto = false;
        if (url != null && url.isNotEmpty) {
          _fotoUrl = url;
        } else {
          _erro = 'Não consegui enviar a foto. Tente outra imagem.';
        }
      });
    } catch (_) {
      safeSetState(() {
        _enviandoFoto = false;
        _erro = 'Não consegui enviar a foto. Tente de novo.';
      });
    }
  }

  Future<void> _concluir({required bool pulando}) async {
    if (_ocupado || _enviandoFoto) return;
    safeSetState(() {
      _ocupado = true;
      _erro = null;
    });

    try {
      if (!pulando) {
        final resposta = await SupaFlow.client.rpc(
          'atualizar_perfil_inicial',
          params: {
            'p_nome': _nomeController.text,
            'p_bio': _bioController.text,
            'p_foto_url': _fotoUrl,
          },
        );
        final mapa = (resposta as Map?)?.cast<String, dynamic>() ?? {};
        if (mapa['ok'] != true) {
          safeSetState(() {
            _ocupado = false;
            _erro = 'Não foi possível salvar. Tente de novo.';
          });
          return;
        }
      }

      if (!mounted) return;
      // O Loading carrega o perfil recém-criado e roteia pelo papel.
      context.goNamed(LoadingWidget.routeName);
    } catch (_) {
      safeSetState(() {
        _ocupado = false;
        _erro = 'Falha de conexão. Confira sua internet e tente de novo.';
      });
    }
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: tema.secondaryBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                child: Image.asset(
                  'assets/images/logodatafitazul.png',
                  width: 160.0,
                  height: 38.0,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: _Passos(etapa: _etapa),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: _etapa == 0
                      ? _etapaPapel(tema)
                      : _etapaApresentacao(tema),
                ),
              ),
              if (_erro != null)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                  child: Text(
                    _erro!,
                    textAlign: TextAlign.center,
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      color: tema.error,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (_etapa == 0)
                Text(
                  'Você pode pedir a troca depois pelo suporte.',
                  textAlign: TextAlign.center,
                  style: tema.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: tema.secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (_etapa == 1) _botoesFinais(tema),
            ],
          ),
        ),
      ),
    );
  }

  Widget _etapaPapel(FlutterFlowTheme tema) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 0.0),
          child: Text(
            'Como você vai usar o Datafit?',
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: tema.primaryText,
              fontSize: 20.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 28.0),
          child: Text(
            'Escolha uma opção para continuar.',
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _CartaoPapel(
          icone: Icons.fitness_center_rounded,
          titulo: 'Sou aluno',
          descricao: 'Treino com um personal e acompanho minha evolução.',
          habilitado: !_ocupado,
          onTap: () => _escolher('aluno'),
        ),
        SizedBox(height: 12.0),
        _CartaoPapel(
          icone: Icons.assignment_ind_rounded,
          titulo: 'Sou personal',
          descricao: 'Monto treinos e acompanho meus alunos.',
          habilitado: !_ocupado,
          onTap: () => _escolher('personal'),
        ),
        if (_ocupado)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: SizedBox(
              width: 22.0,
              height: 22.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(tema.primary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _etapaApresentacao(FlutterFlowTheme tema) {
    final ehPersonal = _papelEscolhido == 'personal';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 0.0),
          child: Text(
            'Vamos te apresentar',
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: tema.primaryText,
              fontSize: 20.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 24.0),
          child: Text(
            ehPersonal
                ? 'É o que seus alunos veem no seu perfil. Tudo opcional.'
                : 'É o que seu personal vê sobre você. Tudo opcional.',
            textAlign: TextAlign.center,
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: tema.secondaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // ---- foto ----
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: _escolherFoto,
          child: Stack(
            alignment: AlignmentDirectional(0.0, 0.0),
            children: [
              Container(
                width: 96.0,
                height: 96.0,
                decoration: BoxDecoration(
                  color: tema.primaryBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: tema.alternate, width: 1.0),
                  image: (_fotoUrl != null && _fotoUrl!.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(_fotoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (_fotoUrl == null || _fotoUrl!.isEmpty)
                    ? Icon(Icons.person_rounded,
                        color: tema.secondaryText, size: 44.0)
                    : null,
              ),
              if (_enviandoFoto)
                SizedBox(
                  width: 26.0,
                  height: 26.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(tema.primary),
                  ),
                ),
              Align(
                alignment: AlignmentDirectional(1.0, 1.0),
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: tema.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: tema.secondaryBackground, width: 2.0),
                  ),
                  child: Icon(Icons.photo_camera_rounded,
                      color: Colors.white, size: 15.0),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 24.0),
          child: Text(
            _fotoUrl == null ? 'Adicionar foto' : 'Trocar foto',
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: tema.primary,
              fontSize: 13.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ---- nome ----
        _Campo(
          rotulo: 'Seu nome',
          child: TextFormField(
            controller: _nomeController,
            textCapitalization: TextCapitalization.words,
            decoration: _decoracao(tema, 'Como quer ser chamado'),
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(),
              letterSpacing: 0.0,
            ),
          ),
        ),
        SizedBox(height: 16.0),

        // ---- bio ----
        _Campo(
          rotulo: 'Bio',
          child: TextFormField(
            controller: _bioController,
            maxLines: 3,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            decoration: _decoracao(
              tema,
              ehPersonal
                  ? 'Sua formação, especialidade, tempo de experiência...'
                  : 'Seu objetivo, tempo de treino, o que gosta de fazer...',
            ),
            style: tema.bodyMedium.override(
              font: GoogleFonts.inter(),
              letterSpacing: 0.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _botoesFinais(FlutterFlowTheme tema) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 44.0,
            child: ElevatedButton(
              onPressed: (_ocupado || _enviandoFoto)
                  ? null
                  : () => _concluir(pulando: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: tema.primary,
                disabledBackgroundColor: tema.alternate,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: _ocupado
                  ? SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Concluir',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          TextButton(
            onPressed: (_ocupado || _enviandoFoto)
                ? null
                : () => _concluir(pulando: true),
            child: Text(
              'Pular por enquanto',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
                color: tema.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracao(FlutterFlowTheme tema, String hint) {
    OutlineInputBorder borda(Color cor) => OutlineInputBorder(
          borderSide: BorderSide(color: cor, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        );

    return InputDecoration(
      isDense: true,
      hintText: hint,
      counterText: '',
      hintStyle: tema.labelMedium.override(
        font: GoogleFonts.inter(fontWeight: FontWeight.normal),
        color: tema.secondaryText,
        fontSize: 13.5,
        letterSpacing: 0.0,
        fontWeight: FontWeight.normal,
      ),
      enabledBorder: borda(Color(0x00000000)),
      focusedBorder: borda(tema.primary),
      errorBorder: borda(tema.error),
      focusedErrorBorder: borda(tema.error),
      filled: true,
      fillColor: tema.primaryBackground,
      contentPadding: EdgeInsets.all(14.0),
    );
  }
}

/// Indicador de etapa: duas barrinhas.
class _Passos extends StatelessWidget {
  const _Passos({required this.etapa});

  final int etapa;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    Widget barra(bool ativa) => Expanded(
          child: Container(
            height: 3.0,
            decoration: BoxDecoration(
              color: ativa ? tema.primary : tema.alternate,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        );

    return Row(
      children: [
        barra(true),
        SizedBox(width: 6.0),
        barra(etapa >= 1),
      ],
    );
  }
}

class _Campo extends StatelessWidget {
  const _Campo({required this.rotulo, required this.child});

  final String rotulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rotulo,
          style: tema.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
            color: tema.secondaryText,
            fontSize: 13.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        child,
      ],
    );
  }
}

class _CartaoPapel extends StatelessWidget {
  const _CartaoPapel({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.habilitado,
    required this.onTap,
  });

  final IconData icone;
  final String titulo;
  final String descricao;
  final bool habilitado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    return Opacity(
      opacity: habilitado ? 1.0 : 0.5,
      child: Material(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: habilitado ? onTap : null,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: tema.alternate),
            ),
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: tema.accent1,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(icone, color: tema.primary, size: 22.0),
                ),
                SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titulo,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: tema.primaryText,
                          fontSize: 15.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        descricao,
                        style: tema.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: tema.secondaryText,
                          fontSize: 12.5,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: tema.secondaryText, size: 22.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

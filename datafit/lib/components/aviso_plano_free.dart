/// Aviso de plano gratuito na home do personal, com atalho para contratar.
///
/// Os planos são vendidos no site, não dentro do app. Sem este aviso o personal
/// que baixa o app e cria conta sozinho cai no plano free (1 aluno, criado pelo
/// trigger `trg_auto_assinatura_free`) sem nenhuma pista de como liberar o
/// resto.
///
/// ⚠️ Oculto no iOS de propósito. A Guideline 3.1.1 da Apple não permite
/// direcionar para compra externa de conteúdo digital — é o mesmo motivo pelo
/// qual a tabela de preços em `perfil_widget.dart` está atrás de `!isiOS`.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';

const String kUrlPlanos = 'https://godata.fit/';

class AvisoPlanoFree extends StatefulWidget {
  const AvisoPlanoFree({super.key});

  @override
  State<AvisoPlanoFree> createState() => _AvisoPlanoFreeState();
}

class _AvisoPlanoFreeState extends State<AvisoPlanoFree> {
  Map<String, dynamic>? _plano;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      // SupaFlow.client.rpc porque a RPC depende de auth.uid().
      final resposta = await SupaFlow.client.rpc('meu_plano');
      if (!mounted) return;
      safeSetState(() {
        _plano = (resposta as Map?)?.cast<String, dynamic>();
      });
    } catch (_) {
      // Aviso é acessório: se falhar, some em silêncio.
    }
  }

  Future<void> _abrirSite() async {
    final uri = Uri.parse(kUrlPlanos);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final plano = _plano;
    if (plano == null || plano['ok'] != true || isiOS) {
      return SizedBox.shrink();
    }
    if (plano['codigo'] != 'free') {
      return SizedBox.shrink();
    }

    final tema = FlutterFlowTheme.of(context);
    final limite = (plano['limite'] as num?)?.toInt() ?? 1;
    final alunos = (plano['alunos'] as num?)?.toInt() ?? 0;
    final noLimite = alunos >= limite;

    return Padding(
      // 4, e nao 12: a linha de chips ja traz 8 de folga embaixo, e os dois
      // somavam 20 — o cartao ficava boiando longe do filtro que ele comenta.
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: tema.accent1,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: tema.primary.withValues(alpha: 0.25)),
        ),
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium_rounded,
                    color: tema.primary, size: 18.0),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Plano gratuito · $alunos de $limite '
                    '${limite == 1 ? "aluno" : "alunos"}',
                    style: tema.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      color: tema.primaryText,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.0),
            Text(
              noLimite
                  ? 'Você atingiu o limite do plano gratuito. Assine para '
                      'cadastrar mais alunos.'
                  : 'Assine um plano para ter alunos ilimitados.',
              style: tema.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: tema.secondaryText,
                fontSize: 12.5,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              height: 36.0,
              child: ElevatedButton.icon(
                onPressed: _abrirSite,
                icon: Icon(Icons.open_in_new_rounded, size: 15.0),
                label: Text(
                  'Assinar em godata.fit',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tema.primary,
                  foregroundColor: Colors.white,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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

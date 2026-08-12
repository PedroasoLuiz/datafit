/// Campo de busca das listas.
///
/// Cada tela tinha o seu, montado a mão, com alturas diferentes: o
/// `contentPadding` ficava no default do Flutter, que reserva espaço para
/// label flutuante e deixa o campo bem mais alto do que uma busca precisa ser.
///
/// Aqui a altura é fixa em 40 — a mesma dos botões primários do app — e o
/// respiro vertical do texto é zerado, já que o campo não tem label.
library;

import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CampoBusca extends StatelessWidget {
  const CampoBusca({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText = 'Pesquisar...',
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);

    final borda = OutlineInputBorder(
      borderSide: BorderSide(color: tema.alternate, width: 1.0),
      borderRadius: BorderRadius.circular(12.0),
    );

    return SizedBox(
      height: 40.0,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        autofocus: false,
        obscureText: false,
        textAlignVertical: TextAlignVertical.center,
        style: tema.bodyMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w400),
          color: tema.primaryText,
          fontSize: 14.0,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: tema.primaryText,
        decoration: InputDecoration(
          isDense: true,
          // Zero na vertical: a altura quem manda e o SizedBox. Deixar o
          // default aqui e o que fazia o campo crescer.
          contentPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
          hintText: hintText,
          hintStyle: tema.labelMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w400),
            color: tema.secondaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: tema.primaryBackground,
          prefixIcon: Icon(
            FFIcons.kproperty1FiRrSearch,
            color: tema.secondaryText,
            size: 16.0,
          ),
          prefixIconConstraints:
              BoxConstraints(minWidth: 38.0, minHeight: 38.0),
          enabledBorder: borda,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: tema.primary, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: borda,
          focusedErrorBorder: borda,
        ),
      ),
    );
  }
}

import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'gestao_exercicios_widget.dart';
export 'gestao_exercicios_widget.dart';

class GestaoExerciciosModel
    extends FlutterFlowModel<GestaoExerciciosWidget> {
  bool isLoading = true;
  List<SubcatGestaoGroup> grupos = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class ExercicioGestaoRow {
  final int id;
  final String nome;
  final int? subcatId;
  final String subcatNome;
  final String? link;
  final bool isGlobal;

  const ExercicioGestaoRow({
    required this.id,
    required this.nome,
    this.subcatId,
    required this.subcatNome,
    this.link,
    required this.isGlobal,
  });
}

class SubcatGestaoGroup {
  final int? id;
  final String nome;
  final List<ExercicioGestaoRow> exercicios;

  SubcatGestaoGroup(this.id, this.nome, this.exercicios);
}

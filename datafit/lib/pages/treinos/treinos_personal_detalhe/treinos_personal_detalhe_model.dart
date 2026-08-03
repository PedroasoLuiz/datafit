import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'treinos_personal_detalhe_widget.dart';
export 'treinos_personal_detalhe_widget.dart';

class ExercicioDetalhePersonal {
  final int etId;
  final int exercicioId;
  final String nome;
  final String? linkInstrucao;
  final int series;
  final int repeticoes;
  final int? serieAquecimento;
  final int? repeticaoAquecimento;
  final String? observacao;
  final int? tempoDescansoSeg;
  final int ordem;

  const ExercicioDetalhePersonal({
    required this.etId,
    required this.exercicioId,
    required this.nome,
    this.linkInstrucao,
    required this.series,
    required this.repeticoes,
    this.serieAquecimento,
    this.repeticaoAquecimento,
    this.observacao,
    this.tempoDescansoSeg,
    required this.ordem,
  });
}

class SubcatGrupoPersonal {
  final int id;
  final String nome;
  final List<ExercicioDetalhePersonal> exercicios;

  SubcatGrupoPersonal(this.id, this.nome, this.exercicios);
}

class TreinosPersonalDetalheModel
    extends FlutterFlowModel<TreinosPersonalDetalheWidget> {
  bool isLoading = true;
  List<SubcatGrupoPersonal> grupos = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:ff_commons/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      if (prefs.containsKey('ff_perfil')) {
        try {
          final serializedData = prefs.getString('ff_perfil') ?? '{}';
          _perfil =
              PerfilStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _alunosdopersonal = prefs
              .getStringList('ff_alunosdopersonal')
              ?.map((x) {
                try {
                  return PersonalalunosStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _alunosdopersonal;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_alunosimples')) {
        try {
          final serializedData = prefs.getString('ff_alunosimples') ?? '{}';
          _alunosimples = AlunosimplesStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _pagamentos = prefs
              .getStringList('ff_pagamentos')
              ?.map((x) {
                try {
                  return PersonalpagamentosStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _pagamentos;
    });
    _safeInit(() {
      _musculos = prefs
              .getStringList('ff_musculos')
              ?.map((x) {
                try {
                  return MusculosStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _musculos;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_metasTemp')) {
        try {
          final serializedData = prefs.getString('ff_metasTemp') ?? '{}';
          _metasTemp =
              MetasAlunoStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_metricasTemp')) {
        try {
          final serializedData = prefs.getString('ff_metricasTemp') ?? '{}';
          _metricasTemp = DashMetricasStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_treinosTemp')) {
        try {
          final serializedData = prefs.getString('ff_treinosTemp') ?? '{}';
          _treinosTemp = GrupostreinosStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _exercicioEmAndamento =
          prefs.getBool('ff_exercicioEmAndamento') ?? _exercicioEmAndamento;
    });
    _safeInit(() {
      _treinoExecucaoIdAtivo =
          prefs.getInt('ff_treinoExecucaoIdAtivo') ?? _treinoExecucaoIdAtivo;
    });
    _safeInit(() {
      _timerDescansando =
          prefs.getBool('ff_timerDescansando') ?? _timerDescansando;
    });
    _safeInit(() {
      _timerResetTrigger =
          prefs.getInt('ff_timerResetTrigger') ?? _timerResetTrigger;
    });
    _safeInit(() {
      _descansoinicio = prefs.getString('ff_descansoinicio') ?? _descansoinicio;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_registro1')) {
        try {
          final serializedData = prefs.getString('ff_registro1') ?? '{}';
          _registro1 =
              ResumoMesStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_resumo2')) {
        try {
          final serializedData = prefs.getString('ff_resumo2') ?? '{}';
          _resumo2 =
              ResumoMesStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _notificacoes = prefs
              .getStringList('ff_notificacoes')
              ?.map((x) {
                try {
                  return NotificacoesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _notificacoes;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  PerfilStruct _perfil = PerfilStruct();
  PerfilStruct get perfil => _perfil;
  set perfil(PerfilStruct value) {
    _perfil = value;
    prefs.setString('ff_perfil', value.serialize());
  }

  void updatePerfilStruct(Function(PerfilStruct) updateFn) {
    updateFn(_perfil);
    prefs.setString('ff_perfil', _perfil.serialize());
  }

  List<PersonalalunosStruct> _alunosdopersonal = [];
  List<PersonalalunosStruct> get alunosdopersonal => _alunosdopersonal;
  set alunosdopersonal(List<PersonalalunosStruct> value) {
    _alunosdopersonal = value;
    prefs.setStringList(
        'ff_alunosdopersonal', value.map((x) => x.serialize()).toList());
  }

  void addToAlunosdopersonal(PersonalalunosStruct value) {
    alunosdopersonal.add(value);
    prefs.setStringList('ff_alunosdopersonal',
        _alunosdopersonal.map((x) => x.serialize()).toList());
  }

  void removeFromAlunosdopersonal(PersonalalunosStruct value) {
    alunosdopersonal.remove(value);
    prefs.setStringList('ff_alunosdopersonal',
        _alunosdopersonal.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAlunosdopersonal(int index) {
    alunosdopersonal.removeAt(index);
    prefs.setStringList('ff_alunosdopersonal',
        _alunosdopersonal.map((x) => x.serialize()).toList());
  }

  void updateAlunosdopersonalAtIndex(
    int index,
    PersonalalunosStruct Function(PersonalalunosStruct) updateFn,
  ) {
    alunosdopersonal[index] = updateFn(_alunosdopersonal[index]);
    prefs.setStringList('ff_alunosdopersonal',
        _alunosdopersonal.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAlunosdopersonal(int index, PersonalalunosStruct value) {
    alunosdopersonal.insert(index, value);
    prefs.setStringList('ff_alunosdopersonal',
        _alunosdopersonal.map((x) => x.serialize()).toList());
  }

  List<ConviteStruct> _convitesPendentes = [];
  List<ConviteStruct> get convitesPendentes => _convitesPendentes;
  set convitesPendentes(List<ConviteStruct> value) {
    _convitesPendentes = value;
  }

  String _startDate = '';
  String get startDate => _startDate;
  set startDate(String value) {
    _startDate = value;
  }

  String _endDate = '';
  String get endDate => _endDate;
  set endDate(String value) {
    _endDate = value;
  }

  AlunosimplesStruct _alunosimples = AlunosimplesStruct();
  AlunosimplesStruct get alunosimples => _alunosimples;
  set alunosimples(AlunosimplesStruct value) {
    _alunosimples = value;
    prefs.setString('ff_alunosimples', value.serialize());
  }

  void updateAlunosimplesStruct(Function(AlunosimplesStruct) updateFn) {
    updateFn(_alunosimples);
    prefs.setString('ff_alunosimples', _alunosimples.serialize());
  }

  List<TreinoalunoStruct> _treinoalunos = [];
  List<TreinoalunoStruct> get treinoalunos => _treinoalunos;
  set treinoalunos(List<TreinoalunoStruct> value) {
    _treinoalunos = value;
  }

  void addToTreinoalunos(TreinoalunoStruct value) {
    treinoalunos.add(value);
  }

  void removeFromTreinoalunos(TreinoalunoStruct value) {
    treinoalunos.remove(value);
  }

  void removeAtIndexFromTreinoalunos(int index) {
    treinoalunos.removeAt(index);
  }

  void updateTreinoalunosAtIndex(
    int index,
    TreinoalunoStruct Function(TreinoalunoStruct) updateFn,
  ) {
    treinoalunos[index] = updateFn(_treinoalunos[index]);
  }

  void insertAtIndexInTreinoalunos(int index, TreinoalunoStruct value) {
    treinoalunos.insert(index, value);
  }

  TreinoStruct _treinoaluno = TreinoStruct();
  TreinoStruct get treinoaluno => _treinoaluno;
  set treinoaluno(TreinoStruct value) {
    _treinoaluno = value;
  }

  void updateTreinoalunoStruct(Function(TreinoStruct) updateFn) {
    updateFn(_treinoaluno);
  }

  List<ExerciciostreinoStruct> _exerciciosaluno = [];
  List<ExerciciostreinoStruct> get exerciciosaluno => _exerciciosaluno;
  set exerciciosaluno(List<ExerciciostreinoStruct> value) {
    _exerciciosaluno = value;
  }

  void addToExerciciosaluno(ExerciciostreinoStruct value) {
    exerciciosaluno.add(value);
  }

  void removeFromExerciciosaluno(ExerciciostreinoStruct value) {
    exerciciosaluno.remove(value);
  }

  void removeAtIndexFromExerciciosaluno(int index) {
    exerciciosaluno.removeAt(index);
  }

  void updateExerciciosalunoAtIndex(
    int index,
    ExerciciostreinoStruct Function(ExerciciostreinoStruct) updateFn,
  ) {
    exerciciosaluno[index] = updateFn(_exerciciosaluno[index]);
  }

  void insertAtIndexInExerciciosaluno(int index, ExerciciostreinoStruct value) {
    exerciciosaluno.insert(index, value);
  }

  /// Id do usuário da tabela de usuários "users" gerenciada pelo Supabase
  dynamic _usuarioLogadoSupId;
  dynamic get usuarioLogadoSupId => _usuarioLogadoSupId;
  set usuarioLogadoSupId(dynamic value) {
    _usuarioLogadoSupId = value;
  }

  List<PersonalpagamentosStruct> _pagamentos = [];
  List<PersonalpagamentosStruct> get pagamentos => _pagamentos;
  set pagamentos(List<PersonalpagamentosStruct> value) {
    _pagamentos = value;
    prefs.setStringList(
        'ff_pagamentos', value.map((x) => x.serialize()).toList());
  }

  void addToPagamentos(PersonalpagamentosStruct value) {
    pagamentos.add(value);
    prefs.setStringList(
        'ff_pagamentos', _pagamentos.map((x) => x.serialize()).toList());
  }

  void removeFromPagamentos(PersonalpagamentosStruct value) {
    pagamentos.remove(value);
    prefs.setStringList(
        'ff_pagamentos', _pagamentos.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromPagamentos(int index) {
    pagamentos.removeAt(index);
    prefs.setStringList(
        'ff_pagamentos', _pagamentos.map((x) => x.serialize()).toList());
  }

  void updatePagamentosAtIndex(
    int index,
    PersonalpagamentosStruct Function(PersonalpagamentosStruct) updateFn,
  ) {
    pagamentos[index] = updateFn(_pagamentos[index]);
    prefs.setStringList(
        'ff_pagamentos', _pagamentos.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInPagamentos(int index, PersonalpagamentosStruct value) {
    pagamentos.insert(index, value);
    prefs.setStringList(
        'ff_pagamentos', _pagamentos.map((x) => x.serialize()).toList());
  }

  dynamic _existeCadastro;
  dynamic get existeCadastro => _existeCadastro;
  set existeCadastro(dynamic value) {
    _existeCadastro = value;
  }

  PerfilAlunoStruct _alunotemp = PerfilAlunoStruct();
  PerfilAlunoStruct get alunotemp => _alunotemp;
  set alunotemp(PerfilAlunoStruct value) {
    _alunotemp = value;
  }

  void updateAlunotempStruct(Function(PerfilAlunoStruct) updateFn) {
    updateFn(_alunotemp);
  }

  int _updatingvariable = 0;
  int get updatingvariable => _updatingvariable;
  set updatingvariable(int value) {
    _updatingvariable = value;
  }

  List<MusculosStruct> _musculos = [];
  List<MusculosStruct> get musculos => _musculos;
  set musculos(List<MusculosStruct> value) {
    _musculos = value;
    prefs.setStringList(
        'ff_musculos', value.map((x) => x.serialize()).toList());
  }

  void addToMusculos(MusculosStruct value) {
    musculos.add(value);
    prefs.setStringList(
        'ff_musculos', _musculos.map((x) => x.serialize()).toList());
  }

  void removeFromMusculos(MusculosStruct value) {
    musculos.remove(value);
    prefs.setStringList(
        'ff_musculos', _musculos.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromMusculos(int index) {
    musculos.removeAt(index);
    prefs.setStringList(
        'ff_musculos', _musculos.map((x) => x.serialize()).toList());
  }

  void updateMusculosAtIndex(
    int index,
    MusculosStruct Function(MusculosStruct) updateFn,
  ) {
    musculos[index] = updateFn(_musculos[index]);
    prefs.setStringList(
        'ff_musculos', _musculos.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInMusculos(int index, MusculosStruct value) {
    musculos.insert(index, value);
    prefs.setStringList(
        'ff_musculos', _musculos.map((x) => x.serialize()).toList());
  }

  MetasAlunoStruct _metasTemp = MetasAlunoStruct();
  MetasAlunoStruct get metasTemp => _metasTemp;
  set metasTemp(MetasAlunoStruct value) {
    _metasTemp = value;
    prefs.setString('ff_metasTemp', value.serialize());
  }

  void updateMetasTempStruct(Function(MetasAlunoStruct) updateFn) {
    updateFn(_metasTemp);
    prefs.setString('ff_metasTemp', _metasTemp.serialize());
  }

  DashMetricasStruct _metricasTemp = DashMetricasStruct();
  DashMetricasStruct get metricasTemp => _metricasTemp;
  set metricasTemp(DashMetricasStruct value) {
    _metricasTemp = value;
    prefs.setString('ff_metricasTemp', value.serialize());
  }

  void updateMetricasTempStruct(Function(DashMetricasStruct) updateFn) {
    updateFn(_metricasTemp);
    prefs.setString('ff_metricasTemp', _metricasTemp.serialize());
  }

  GrupostreinosStruct _treinosTemp = GrupostreinosStruct();
  GrupostreinosStruct get treinosTemp => _treinosTemp;
  set treinosTemp(GrupostreinosStruct value) {
    _treinosTemp = value;
    prefs.setString('ff_treinosTemp', value.serialize());
  }

  void updateTreinosTempStruct(Function(GrupostreinosStruct) updateFn) {
    updateFn(_treinosTemp);
    prefs.setString('ff_treinosTemp', _treinosTemp.serialize());
  }

  ExerciciosStruct _exercicioTemp = ExerciciosStruct();
  ExerciciosStruct get exercicioTemp => _exercicioTemp;
  set exercicioTemp(ExerciciosStruct value) {
    _exercicioTemp = value;
  }

  void updateExercicioTempStruct(Function(ExerciciosStruct) updateFn) {
    updateFn(_exercicioTemp);
  }

  bool _exercicioEmAndamento = false;
  bool get exercicioEmAndamento => _exercicioEmAndamento;
  set exercicioEmAndamento(bool value) {
    _exercicioEmAndamento = value;
    prefs.setBool('ff_exercicioEmAndamento', value);
  }

  int _treinoExecucaoIdAtivo = 0;
  int get treinoExecucaoIdAtivo => _treinoExecucaoIdAtivo;
  set treinoExecucaoIdAtivo(int value) {
    _treinoExecucaoIdAtivo = value;
    prefs.setInt('ff_treinoExecucaoIdAtivo', value);
  }

  bool _timerDescansando = false;
  bool get timerDescansando => _timerDescansando;
  set timerDescansando(bool value) {
    _timerDescansando = value;
    prefs.setBool('ff_timerDescansando', value);
  }

  int _timerResetTrigger = 0;
  int get timerResetTrigger => _timerResetTrigger;
  set timerResetTrigger(int value) {
    _timerResetTrigger = value;
    prefs.setInt('ff_timerResetTrigger', value);
  }

  String _descansoinicio = '';
  String get descansoinicio => _descansoinicio;
  set descansoinicio(String value) {
    _descansoinicio = value;
    prefs.setString('ff_descansoinicio', value);
  }

  ResumoMesStruct _registro1 = ResumoMesStruct();
  ResumoMesStruct get registro1 => _registro1;
  set registro1(ResumoMesStruct value) {
    _registro1 = value;
    prefs.setString('ff_registro1', value.serialize());
  }

  void updateRegistro1Struct(Function(ResumoMesStruct) updateFn) {
    updateFn(_registro1);
    prefs.setString('ff_registro1', _registro1.serialize());
  }

  ResumoMesStruct _resumo2 = ResumoMesStruct();
  ResumoMesStruct get resumo2 => _resumo2;
  set resumo2(ResumoMesStruct value) {
    _resumo2 = value;
    prefs.setString('ff_resumo2', value.serialize());
  }

  void updateResumo2Struct(Function(ResumoMesStruct) updateFn) {
    updateFn(_resumo2);
    prefs.setString('ff_resumo2', _resumo2.serialize());
  }

  List<NotificacoesStruct> _notificacoes = [];
  List<NotificacoesStruct> get notificacoes => _notificacoes;
  set notificacoes(List<NotificacoesStruct> value) {
    _notificacoes = value;
    prefs.setStringList(
        'ff_notificacoes', value.map((x) => x.serialize()).toList());
  }

  void addToNotificacoes(NotificacoesStruct value) {
    notificacoes.add(value);
    prefs.setStringList(
        'ff_notificacoes', _notificacoes.map((x) => x.serialize()).toList());
  }

  void removeFromNotificacoes(NotificacoesStruct value) {
    notificacoes.remove(value);
    prefs.setStringList(
        'ff_notificacoes', _notificacoes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromNotificacoes(int index) {
    notificacoes.removeAt(index);
    prefs.setStringList(
        'ff_notificacoes', _notificacoes.map((x) => x.serialize()).toList());
  }

  void updateNotificacoesAtIndex(
    int index,
    NotificacoesStruct Function(NotificacoesStruct) updateFn,
  ) {
    notificacoes[index] = updateFn(_notificacoes[index]);
    prefs.setStringList(
        'ff_notificacoes', _notificacoes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInNotificacoes(int index, NotificacoesStruct value) {
    notificacoes.insert(index, value);
    prefs.setStringList(
        'ff_notificacoes', _notificacoes.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

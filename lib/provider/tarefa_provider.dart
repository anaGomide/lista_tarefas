import 'package:flutter/material.dart';
import 'package:lista_tarefas/model/tarefa.dart';

class TarefaProvider extends ChangeNotifier {
  final List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  void adicionarTarefa(String titulo) {
    _tarefas.add(Tarefa(id: _tarefas.length + 1, titulo: titulo));
    notifyListeners();
  }

  void removerTarefa(int id) {
    print("Removendo tarefa $id");
    _tarefas.removeWhere((tarefa) => tarefa.id == id);
    notifyListeners();
  }

  void marcarComoConcluida(int id) {
    final index = _tarefas.indexWhere((tarefa) => tarefa.id == id);
    if (index != -1) {
      _tarefas[index].concluida = true;
      notifyListeners();
    }
  }

  void desmarcarComoConcluida(int id) {
    final index = _tarefas.indexWhere((tarefa) => tarefa.id == id);
    if (index != -1) {
      _tarefas[index].concluida = false;
      notifyListeners();
    }
  }
}

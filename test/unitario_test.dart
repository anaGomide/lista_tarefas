import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tarefas/model/tarefa.dart';
import 'package:lista_tarefas/provider/tarefa_provider.dart';

void main() {
  // Testes para o modelo Tarefa
  group('Tarefa Model Test', () {
    test('Criar Tarefa', () {
      // Criar uma instância de Tarefa
      final tarefa = Tarefa(id: 1, titulo: 'Teste Tarefa');

      // Verificar se os atributos foram definidos corretamente
      expect(tarefa.id, 1);
      expect(tarefa.titulo, 'Teste Tarefa');
      expect(tarefa.concluida, false);
    });
  });

  // Testes para o provedor TarefaProvider
  group('Tarefa Provider Test', () {
    test('Adicionar Tarefa', () {
      // Criar uma instância do TarefaProvider
      final provider = TarefaProvider();

      // Obter o comprimento inicial da lista de tarefas
      final initialLength = provider.tarefas.length;

      // Adicionar uma nova tarefa
      provider.adicionarTarefa('Nova Tarefa');

      // Verificar se a tarefa foi adicionada corretamente
      expect(provider.tarefas.length, initialLength + 1);
      expect(provider.tarefas.last.titulo, 'Nova Tarefa');
    });

    test('Remover Tarefa', () {
      // Criar uma instância do TarefaProvider
      final provider = TarefaProvider();

      // Adicionar uma tarefa para ser removida
      provider.adicionarTarefa('Tarefa para Remover');

      // Obter o comprimento inicial da lista de tarefas
      final initialLength = provider.tarefas.length;

      // Obter o ID da última tarefa adicionada
      final tarefaId = provider.tarefas.last.id;

      // Remover a tarefa
      provider.removerTarefa(tarefaId);

      // Verificar se a tarefa foi removida corretamente
      expect(provider.tarefas.length, initialLength - 1);
      expect(provider.tarefas.any((tarefa) => tarefa.id == tarefaId), isFalse);
    });

    test('Marcar como Concluída', () {
      // Criar uma instância do TarefaProvider
      final provider = TarefaProvider();

      // Adicionar uma tarefa para ser marcada como concluída
      provider.adicionarTarefa('Tarefa para Concluir');

      // Obter o ID da última tarefa adicionada
      final tarefaId = provider.tarefas.last.id;

      // Marcar a tarefa como concluída
      provider.marcarComoConcluida(tarefaId);

      // Verificar se a tarefa foi marcada como concluída corretamente
      expect(
          provider.tarefas
              .any((tarefa) => tarefa.id == tarefaId && tarefa.concluida),
          isTrue);
    });

    test('Desmarcar como Concluída', () {
      // Criar uma instância do TarefaProvider
      final provider = TarefaProvider();

      // Adicionar uma tarefa para ser marcada como concluída e depois desmarcada
      provider.adicionarTarefa('Tarefa para Desmarcar');

      // Obter o ID da última tarefa adicionada
      final tarefaId = provider.tarefas.last.id;

      // Marcar a tarefa como concluída
      provider.marcarComoConcluida(tarefaId);

      // Desmarcar a tarefa
      provider.desmarcarComoConcluida(tarefaId);

      // Verificar se a tarefa foi desmarcada como concluída corretamente
      expect(
          provider.tarefas
              .any((tarefa) => tarefa.id == tarefaId && !tarefa.concluida),
          isTrue);
    });
  });
}

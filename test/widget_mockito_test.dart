import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tarefas/main.dart';
import 'package:lista_tarefas/model/tarefa.dart';
import 'package:lista_tarefas/provider/tarefa_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart'; // Atualize o import de acordo com a estrutura do seu projeto

class MockTarefaProvider extends Mock implements TarefaProvider {
  @override
  List<Tarefa> get tarefas => [];
}

void main() {
  group('Testes de Widgets do TarefasApp', () {
    testWidgets('AdicionarTarefaForm adiciona tarefa corretamente',
        (WidgetTester tester) async {
      // Preparação
      final mockProvider = MockTarefaProvider();
      when(mockProvider.tarefas).thenReturn([]);

      // Ação
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => mockProvider,
            child: const TarefasApp(),
          ),
        ),
      );

      // Inserir uma tarefa no campo de texto
      await tester.enterText(find.byType(TextField), 'Nova Tarefa');

      // Toque no botão de adicionar
      await tester.tap(find.byType(IconButton));

      // Reconstruir o widget após o estado ter mudado
      await tester.pump();

      // Assertiva
      verify(mockProvider.adicionarTarefa('Nova Tarefa')).called(1);
      verify(mockProvider.tarefas).called(
          2); // Verificar se tarefas foi chamado após adicionar uma tarefa
    });

    testWidgets('ListaDeTarefas exibe as tarefas corretamente',
        (WidgetTester tester) async {
      // Preparação
      final mockProvider = MockTarefaProvider();
      when(mockProvider.tarefas).thenReturn([
        Tarefa(id: 1, titulo: 'Tarefa 1', concluida: false),
        Tarefa(id: 2, titulo: 'Tarefa 2', concluida: true),
      ]);

      // Ação
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => mockProvider,
            child: const TarefasApp(),
          ),
        ),
      );

      // Assertiva
      expect(find.text('Tarefa 1'), findsOneWidget);
      expect(find.text('Tarefa 2'), findsOneWidget);
      expect(find.byIcon(Icons.check),
          findsOneWidget); // Verificar o ícone de marcação de verificação
      expect(find.byIcon(Icons.delete),
          findsNWidgets(2)); // Verificar dois ícones de exclusão
      verify(mockProvider.tarefas).called(1);
    });

    // Adicione mais testes conforme necessário
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tarefas/main.dart';
import 'package:lista_tarefas/model/tarefa.dart';
import 'package:lista_tarefas/provider/tarefa_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'widget_mockito_test.mocks.dart';

@GenerateMocks([TarefaProvider])
void main() {
  group('Testes de Widgets do TarefasApp', () {
    testWidgets('Exibir corretamente as tarefas', (WidgetTester tester) async {
      // Preparação
      MockTarefaProvider tarefaProvider = MockTarefaProvider();
      when(tarefaProvider.tarefas).thenReturn([
        Tarefa(id: 1, titulo: "Tarefa 1", concluida: false),
        Tarefa(id: 2, titulo: 'Tarefa 2', concluida: true),
      ]);

      Widget app = MultiProvider(
        providers: [
          ChangeNotifierProvider<TarefaProvider>(
              create: (context) => tarefaProvider)
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: ChangeNotifierProvider(
            create: (context) => tarefaProvider,
            child: const TarefasApp(),
          ),
        ),
      );

      await tester.pumpWidget(app);
      expect(find.text("Tarefa 1"), findsOneWidget);
      expect(find.text("Tarefa 2"), findsOneWidget);
    });

    testWidgets('Adicionar tarefa', (WidgetTester tester) async {
      // Mock the TarefaProvider
      final tarefaProvider = MockTarefaProvider();
      when(tarefaProvider.tarefas).thenReturn([]);

      // Provide the mock TarefaProvider to the widget tree
      Widget app = MultiProvider(
        providers: [
          ChangeNotifierProvider<TarefaProvider>(
            create: (context) => tarefaProvider,
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TarefasApp(),
        ),
      );

      // Pump the widget tree
      await tester.pumpWidget(app);

      // Simulate user input
      await tester.enterText(
          find.byKey(const Key('text_field')), 'Nova Tarefa');

      // Trigger the button press
      await tester.tap(find.byKey(const Key('add_button')));

      // Verify that the adicionarTarefa method is called
      verify(tarefaProvider.adicionarTarefa('Nova Tarefa')).called(1);

      expect(find.text("Nova Tarefa"), findsOneWidget);
    });
    testWidgets('Marcar tarefa como concluída', (WidgetTester tester) async {
      // Mock the TarefaProvider
      final tarefaProvider = MockTarefaProvider();
      when(tarefaProvider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'Tarefa 1', concluida: false)]);
      when(tarefaProvider.marcarComoConcluida(any)).thenAnswer((_) => true);

      // Provide the mock TarefaProvider to the widget tree
      Widget app = MultiProvider(
        providers: [
          ChangeNotifierProvider<TarefaProvider>(
            create: (context) => tarefaProvider,
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TarefasApp(),
        ),
      );

      // Pump the widget tree
      await tester.pumpWidget(app);

      // Pump any pending frames and ensure the widget tree is in a stable state
      await tester.pumpAndSettle();

      // Simulate user input
      await tester.tap(find.byType(Checkbox).first);

      // Verify that the marcarComoConcluida method is called
      verify(tarefaProvider.marcarComoConcluida(1)).called(1);
    });

    testWidgets('Desmarcar tarefa como concluída', (WidgetTester tester) async {
      // Mock the TarefaProvider
      final tarefaProvider = MockTarefaProvider();
      when(tarefaProvider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'Tarefa 1', concluida: true)]);
      when(tarefaProvider.desmarcarComoConcluida(any)).thenAnswer((_) => false);

      // Provide the mock TarefaProvider to the widget tree
      Widget app = MultiProvider(
        providers: [
          ChangeNotifierProvider<TarefaProvider>(
            create: (context) => tarefaProvider,
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TarefasApp(),
        ),
      );

      // Pump the widget tree
      await tester.pumpWidget(app);

      // Pump any pending frames and ensure the widget tree is in a stable state
      await tester.pumpAndSettle();

      // Simulate user input
      await tester.tap(find.byType(Checkbox).first);

      // Verify that the desmarcarComoConcluida method is called
      verify(tarefaProvider.desmarcarComoConcluida(1)).called(1);
    });
    testWidgets('Remover tarefa', (WidgetTester tester) async {
      // Mock the TarefaProvider
      final tarefaProvider = MockTarefaProvider();
      when(tarefaProvider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'Tarefa 1', concluida: false)]);
      when(tarefaProvider.removerTarefa(any)).thenAnswer((_) => true);

      // Provide the mock TarefaProvider to the widget tree
      Widget app = MultiProvider(
        providers: [
          ChangeNotifierProvider<TarefaProvider>(
            create: (context) => tarefaProvider,
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TarefasApp(),
        ),
      );

      // Pump the widget tree
      await tester.pumpWidget(app);

      // Pump any pending frames and ensure the widget tree is in a stable state
      await tester.pumpAndSettle();

      // Simulate user input
      await tester.tap(find.byIcon(Icons.delete).first);

      // Verify that the removerTarefa method is called
      verify(tarefaProvider.removerTarefa(1)).called(1);
    });
  });
}

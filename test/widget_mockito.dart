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
    testWidgets('AdicionarTarefaFormState adiciona tarefa corretamente',
        (WidgetTester tester) async {
      // Preparação
      final mockProvider = MockTarefaProvider();
      when(mockProvider.tarefas).thenReturn([]);

      // Adicione a expectativa para adicionarTarefa
      when(mockProvider.adicionarTarefa('Nova Tarefa')).thenReturn(null);

      // Ação
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => mockProvider,
            child: TarefasApp(),
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

      // Adicione expectativas para os métodos chamados dentro do itemBuilder
      when(mockProvider.marcarComoConcluida(argThat(isNotNull)))
          .thenReturn((_) {});
      // when(mockProvider.desmarcarComoConcluida(any)).thenReturn(null);
      // when(mockProvider.removerTarefa(any)).thenReturn(null);

      // Ação
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => mockProvider,
            child: TarefasApp(),
          ),
        ),
      );

      // Assertiva
      expect(find.text('Tarefa 1'), findsOneWidget);
      expect(find.text('Tarefa 2'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsNWidgets(2));
      verify(mockProvider.tarefas).called(1);
    });
  });
}

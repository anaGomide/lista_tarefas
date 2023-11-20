import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tarefas/main.dart';

void main() {
  testWidgets(
      'Teste de Integração: Adicionar, Remover e Marcar Tarefa como Concluída',
      (WidgetTester tester) async {
    // Construir o aplicativo e disparar uma atualização.
    await tester.pumpWidget(const MyApp());

    // Verificar se o aplicativo inicia com uma lista de tarefas vazia.
    expect(find.byType(ListTile), findsNothing);

    // Adicionar uma nova tarefa.
    await tester.enterText(find.byType(TextField), 'Nova Tarefa');
    await tester.tap(find.byType(IconButton));
    await tester.pump();

// Verificar se a tarefa foi adicionada.
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is ListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Nova Tarefa'),
        findsOneWidget);

// Remover a tarefa adicionada.
    await tester.tap(find.byIcon(Icons.delete));
    await tester
        .pumpAndSettle(); // Aguarde a interface do usuário ser atualizada.

// Verificar se a tarefa foi removida.
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is ListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Nova Tarefa'),
        findsNothing);

    // Adicionar uma nova tarefa.
    await tester.enterText(find.byType(TextField), 'Outra Tarefa');
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    // Verificar se a tarefa foi adicionada.
    expect(find.text('Outra Tarefa'), findsOneWidget);

    // Marcar a tarefa como concluída.
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Verificar se a tarefa está marcada como concluída.
    expect(find.text('Outra Tarefa'), findsOneWidget);
    expect(find.text('Concluída'), findsOneWidget);
  });
}

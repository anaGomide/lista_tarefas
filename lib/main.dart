import 'package:flutter/material.dart';
import 'package:lista_tarefas/provider/tarefa_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => TarefaProvider(),
        child: const TarefasApp(),
      ),
    );
  }
}

class TarefasApp extends StatelessWidget {
  const TarefasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: Column(
        children: [
          AdicionarTarefaForm(),
          ListaDeTarefas(),
        ],
      ),
    );
  }
}

class AdicionarTarefaForm extends StatefulWidget {
  const AdicionarTarefaForm({Key? key}) : super(key: key);

  @override
  _AdicionarTarefaFormState createState() => _AdicionarTarefaFormState();
}

class _AdicionarTarefaFormState extends State<AdicionarTarefaForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nova Tarefa'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final String novaTarefa = _controller.text;
              if (novaTarefa.isNotEmpty) {
                Provider.of<TarefaProvider>(context, listen: false)
                    .adicionarTarefa(novaTarefa);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

class ListaDeTarefas extends StatelessWidget {
  const ListaDeTarefas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tarefaProvider = Provider.of<TarefaProvider>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: tarefaProvider.tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefaProvider.tarefas[index];
          return ListTile(
            title: Text(tarefa.titulo),
            subtitle: tarefa.concluida ? const Text('Concluída') : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: tarefa.concluida,
                  onChanged: (value) {
                    if (value != null && value) {
                      Provider.of<TarefaProvider>(context, listen: false)
                          .marcarComoConcluida(tarefa.id);
                    } else {
                      Provider.of<TarefaProvider>(context, listen: false)
                          .desmarcarComoConcluida(tarefa.id);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<TarefaProvider>(context, listen: false)
                        .removerTarefa(tarefa.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

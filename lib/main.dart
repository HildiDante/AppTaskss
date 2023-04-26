import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final TextEditingController todoController = TextEditingController();

List<String> todos = [];
List<DateTime> datas = [];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex: Estudar Flutter'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        todos.add(todoController.text);
                        datas.add(DateTime.now());
                      });
                      todoController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xff115B98),
                        padding: const EdgeInsets.all(10)),
                    child: const Icon(
                      Icons.add,
                      size: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[200]),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd/MM/yy - HH:mm')
                                    .format(datas[index]),
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                todos[index],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              delMensage(index);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color(0xff115B98),
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Você possui ${todos.length} tarefas pendentes',
                    style: const TextStyle(fontSize: 13),
                  )),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      showDeleteTodosConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xff115B98),
                        padding: const EdgeInsets.all(15)),
                    child: const Text('Limpar tudo'),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  void delMensage(index) {
    setState(() {
      datas.removeAt(index);
      todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todos[index]} foi removido com sucesso',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Color(0xff115B98),
          onPressed: () {},
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Color(0xff115B98)),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style:
                TextButton.styleFrom(primary: Color.fromARGB(255, 245, 0, 0)),
            child: Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }

  deleteAllTodos() {
    setState(() {
      todos.clear();
      datas.clear();
    });
  }
}

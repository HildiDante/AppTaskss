import 'package:apptarefas/repositories/tasks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'models/task.dart';

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

final TextEditingController tasksController = TextEditingController();
final TasksRepository tasksRepository = TasksRepository();

List<Task> tasks = [];
Task? deletedTask;
int? deletedTaskInd;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    tasksRepository.getTasksList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

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
                      controller: tasksController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        hintText: 'Ex: Estudar Flutter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (tasksController.text == '') {
                      } else {
                        setState(() {
                          final newTask = Task(
                              text: tasksController.text, time: DateTime.now());
                          tasks.add(newTask);
                        });
                        tasksController.clear();
                        tasksRepository.saveTasksList(tasks);
                      }
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
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      child: Container(
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
                                      .format(tasks[index].time),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  tasks[index].text,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      endActionPane: ActionPane(
                        extentRatio: 0.22,
                        motion: Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () {
                              delMensage(index);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 231, 233, 235),
                              size: 30,
                            ),
                          ),
                        ),
                        children: [],
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
                    'Você possui ${tasks.length} tarefas pendentes',
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa: ${tasks[index].text} foi removido com sucesso',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Color(0xff115B98),
          onPressed: () {
            setState(() {
              tasks.insert(deletedTaskInd!, deletedTask!);
              // todos.insert(deletedTodoInd!, deletedTodo!);
              // datas.insert(deletedTodoInd!, deletedTodoDate!);
            });
            tasksRepository.saveTasksList(tasks);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
    setState(() {
      deletedTask = tasks[index];
      deletedTaskInd = index;
      tasks.removeAt(index);
    });
    tasksRepository.saveTasksList(tasks);
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
      tasks.clear();
    });
    tasksRepository.saveTasksList(tasks);
  }
}

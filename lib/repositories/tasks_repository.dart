import 'dart:convert';
import 'package:apptarefas/main.dart';
import 'package:apptarefas/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

const tasksListKey = 'tasks';

class TasksRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Task>> getTasksList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(tasksListKey) ?? '[]';
    final List jsonDecoder = json.decode(jsonString) as List;
    return jsonDecoder.map((e) => Task.fromJson(e)).toList();
  }

  void saveTasksList(List<Task> tasks) {
    final jsonString = json.encode(tasks);
    sharedPreferences.setString(tasksListKey, jsonString);
  }
}

class Task {
  Task({required this.text, required this.time});

  Task.fromJson(Map<String, dynamic> json)
      : text = json['Text'],
        time = DateTime.parse(json['time']);

  String text;
  DateTime time;

  Map<String, dynamic> taJson() {
    return {'title': text, 'datetime': time.toIso8601String()};
  }
}

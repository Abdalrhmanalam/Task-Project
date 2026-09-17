class Task {
  String title;
  String description;
  String priority;
  DateTime dueDate;
  double expectedHours;
  List<Task> subtasks;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.expectedHours,
    this.subtasks = const [],
  });

  Task copy() {
    return Task(
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      expectedHours: expectedHours,
      subtasks: subtasks.map((task) => task.copy()).toList(),
    );
  }
}

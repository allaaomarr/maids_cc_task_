class addtask {
  final String todo;
  final bool completed;
  final int userId;

  addtask({
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory addtask.fromJson(Map<String, dynamic> json) {
    return addtask(
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }
}
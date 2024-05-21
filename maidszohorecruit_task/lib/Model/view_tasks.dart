class viewModel {
  final int id;
  final int userId;
  final String title;
  late final bool completed;

  viewModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  factory viewModel.fromJson(Map<String, dynamic> json) {
    return viewModel(
      id: json['id'],
      userId: json['userId'],
      title: json['todo'], // Adjust this field name if necessary
      completed: json['completed'],
    );
  }
}

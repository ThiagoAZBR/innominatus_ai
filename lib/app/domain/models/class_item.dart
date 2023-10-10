class ClassItemModel {
  final String name;
  final bool wasItCompleted;
  final String? content;

  ClassItemModel({
    required this.name,
    required this.wasItCompleted,
    this.content,
  });
}

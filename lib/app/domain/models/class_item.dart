class ClassItemModel {
  final String name;
  final bool wasItCompleted;
  final String? content;

  ClassItemModel({
    required this.name,
    required this.wasItCompleted,
    this.content,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'wasItCompleted': wasItCompleted});
    if (content != null) {
      result.addAll({'content': content});
    }

    return result;
  }

  factory ClassItemModel.fromMap(Map<String, dynamic> map) {
    return ClassItemModel(
      name: map['name'] ?? '',
      wasItCompleted: map['wasItCompleted'] ?? false,
      content: map['content'],
    );
  }
}

class SharedFieldOfStudyItemModel {
  final String name;
  final String description;

  SharedFieldOfStudyItemModel({
    required this.name,
    required this.description,
  });

  factory SharedFieldOfStudyItemModel.fromJson(Map<String, dynamic> map) {
    return SharedFieldOfStudyItemModel(
      name: map['subject'] ?? map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'description': description});

    return result;
  }
}

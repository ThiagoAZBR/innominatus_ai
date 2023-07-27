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
}

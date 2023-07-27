class SharedFieldOfStudyModel {
  final String name;
  final String description;

  SharedFieldOfStudyModel({
    required this.name,
    required this.description,
  });

  factory SharedFieldOfStudyModel.fromJson(Map<String, dynamic> map) {
    return SharedFieldOfStudyModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

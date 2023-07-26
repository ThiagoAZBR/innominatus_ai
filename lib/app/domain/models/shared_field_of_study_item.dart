class SharedFieldOfStudyItemModel {
  final String subject;
  final String description;

  SharedFieldOfStudyItemModel({
    required this.subject,
    required this.description,
  });

  factory SharedFieldOfStudyItemModel.fromJson(Map<String, dynamic> map) {
    return SharedFieldOfStudyItemModel(
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

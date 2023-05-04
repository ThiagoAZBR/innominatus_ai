class SubjectItemModel {
  final String subject;
  final String description;

  SubjectItemModel({
    required this.subject,
    required this.description,
  });

  factory SubjectItemModel.fromJson(Map<String, dynamic> map) {
    return SubjectItemModel(
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

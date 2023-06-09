class SharedSubjectItemModel {
  final String subject;
  final String description;

  SharedSubjectItemModel({
    required this.subject,
    required this.description,
  });

  factory SharedSubjectItemModel.fromJson(Map<String, dynamic> map) {
    return SharedSubjectItemModel(
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

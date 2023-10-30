class LanguageModel {
  final String name;
  final String allFieldsOfStudy;

  LanguageModel({
    required this.name,
    required this.allFieldsOfStudy,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'allFieldsOfStudy': allFieldsOfStudy});
  
    return result;
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      name: map['name'] ?? '',
      allFieldsOfStudy: map['allFieldsOfStudy'] ?? '',
    );
  }

}

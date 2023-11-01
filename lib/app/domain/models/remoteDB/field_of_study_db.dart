class FieldOfStudyRemoteDBModel {
  final String name;
  final List<String> allSubjects;

  FieldOfStudyRemoteDBModel({
    required this.name,
    required this.allSubjects,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'allSubjects': allSubjects});

    return result;
  }

  factory FieldOfStudyRemoteDBModel.fromMap(Map<String, dynamic> map) {
    return FieldOfStudyRemoteDBModel(
      name: map['name'] ?? '',
      allSubjects: List<String>.from(map['allSubjects']),
    );
  }
}

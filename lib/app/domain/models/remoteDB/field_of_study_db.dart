class FieldOfStudyRemoteDB {
  final String name;
  final List<String> allSubjects;

  FieldOfStudyRemoteDB({
    required this.name,
    required this.allSubjects,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'allSubjects': allSubjects});

    return result;
  }

  factory FieldOfStudyRemoteDB.fromMap(Map<String, dynamic> map) {
    return FieldOfStudyRemoteDB(
      name: map['name'] ?? '',
      allSubjects: List<String>.from(map['allSubjects']),
    );
  }
}

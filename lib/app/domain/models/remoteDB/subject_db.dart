class SubjectRemoteDBModel {
  final String name;
  final List<String> allClasses;

  SubjectRemoteDBModel({
    required this.name,
    required this.allClasses,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'allClasses': allClasses});

    return result;
  }

  factory SubjectRemoteDBModel.fromMap(Map<String, dynamic> map) {
    return SubjectRemoteDBModel(
      name: map['name'] ?? '',
      allClasses: List<String>.from(map['allClasses']),
    );
  }
}

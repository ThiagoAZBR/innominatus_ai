import './subject_item.dart';

class FieldOfStudyItemModel {
  final List<SubjectItemModel> allSubjects;
  final String name;

  FieldOfStudyItemModel({
    required this.allSubjects,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'allSubjects': allSubjects.map((x) => x.toMap()).toList()});
    result.addAll({'name': name});

    return result;
  }

  factory FieldOfStudyItemModel.fromMap(Map<String, dynamic> map) {
    return FieldOfStudyItemModel(
      allSubjects: List<SubjectItemModel>.from(
          map['allSubjects']?.map((x) => SubjectItemModel.fromMap(x))),
      name: map['name'] ?? '',
    );
  }
}

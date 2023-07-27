import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/domain/models/subjects_with_subtopics.dart';

import '../../../domain/models/subject_item.dart';

part 'subjects_with_subtopics_local_db.g.dart';

@HiveType(typeId: 1)
class FieldsOfStudyWithSubjectsLocalDB extends FieldsOfStudyWithSubtopicsModel {
  @HiveField(0)
  final List<FieldOfStudyItemModel> fieldsOfStudy;

  FieldsOfStudyWithSubjectsLocalDB({
    required this.fieldsOfStudy,
  }) : super(fieldsOfStudy: fieldsOfStudy);

  factory FieldsOfStudyWithSubjectsLocalDB.fromSubjectsWithSubtopicsModel(
    FieldsOfStudyWithSubtopicsModel subjectsWithSubtopics,
  ) {
    return FieldsOfStudyWithSubjectsLocalDB(
      fieldsOfStudy: subjectsWithSubtopics.fieldsOfStudy
          .map((e) => FieldOfStudyItemLocalDB.fromSubjectItemModel(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 2)
class FieldOfStudyItemLocalDB extends FieldOfStudyItemModel {
  @HiveField(0)
  final List<String> subjects;
  @HiveField(1)
  final String name;

  FieldOfStudyItemLocalDB({
    required this.subjects,
    required this.name,
  }) : super(subjects: subjects, name: name);

  factory FieldOfStudyItemLocalDB.fromSubjectItemModel(
    FieldOfStudyItemModel subjectItem,
  ) {
    return FieldOfStudyItemLocalDB(
      subjects: subjectItem.subjects,
      name: subjectItem.name,
    );
  }
}

import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/domain/models/subjects_with_subtopics.dart';

import '../../../domain/models/subject_item.dart';

part 'subjects_with_subtopics_local_db.g.dart';

@HiveType(typeId: 1)
class SubjectsWithSubtopicsLocalDB extends SubjectsWithSubtopicsModel {
  @HiveField(0)
  final List<SubjectItemModel> subjects;

  SubjectsWithSubtopicsLocalDB({
    required this.subjects,
  }) : super(subjects: subjects);

  factory SubjectsWithSubtopicsLocalDB.fromSubjectsWithSubtopicsModel(
    SubjectsWithSubtopicsModel subjectsWithSubtopics,
  ) {
    return SubjectsWithSubtopicsLocalDB(
      subjects: subjectsWithSubtopics.subjects
          .map((e) => SubjectItemLocalDB.fromSubjectItemModel(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 2)
class SubjectItemLocalDB extends SubjectItemModel {
  @HiveField(0)
  final List<String> subtopics;
  SubjectItemLocalDB({
    required this.subtopics,
  }) : super(subtopics: subtopics);

  factory SubjectItemLocalDB.fromSubjectItemModel(
    SubjectItemModel subjectItem,
  ) {
    return SubjectItemLocalDB(subtopics: subjectItem.subtopics);
  }
}

import 'package:hive/hive.dart';

import '../../../domain/models/subject_item.dart';
import '../../../domain/models/subjects.dart';

part 'subjects_local_db.g.dart';

@HiveType(typeId: 6)
class SubjectsLocalDB extends SubjectsModel {
  @HiveField(0)
  final List<SubjectItemModel> items;

  SubjectsLocalDB({
    required this.items,
  }) : super(items: items);

  factory SubjectsLocalDB.fromSubjectsModel(SubjectsModel subjectsModel) {
    final hiveItems = subjectsModel.items
        .map((subjectItem) => SubjectItemLocalDB.fromSubjectItem(subjectItem))
        .toList();
    return SubjectsLocalDB(items: hiveItems);
  }
}

@HiveType(typeId: 7)
class SubjectItemLocalDB extends SubjectItemModel {
  @HiveField(0)
  final String subject;
  @HiveField(1)
  final String description;

  SubjectItemLocalDB({
    required this.subject,
    required this.description,
  }) : super(subject: subject, description: description);

  factory SubjectItemLocalDB.fromSubjectItem(SubjectItemModel subjectItem) {
    return SubjectItemLocalDB(
      subject: subjectItem.subject,
      description: subjectItem.description,
    );
  }
}

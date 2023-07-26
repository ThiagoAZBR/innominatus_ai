import 'package:hive/hive.dart';

import '../../../domain/models/shared_field_of_study_item.dart';
import '../../../domain/models/shared_fields_of_study.dart';

part 'subjects_local_db.g.dart';

// This class is made to recover the Subjects to show when creating or rearranging the Study Roadmap
// The Subject when it's displayed, it has the name and description of it
@HiveType(typeId: 6)
class SharedSubjectsLocalDB extends SharedFieldsOfStudyModel {
  @HiveField(0)
  final List<SharedFieldOfStudyItemModel> items;

  SharedSubjectsLocalDB({
    required this.items,
  }) : super(items: items);

  factory SharedSubjectsLocalDB.fromSubjectsModel(
      SharedFieldsOfStudyModel subjectsModel) {
    final hiveItems = subjectsModel.items
        .map((subjectItem) =>
            SharedSubjectItemLocalDB.fromSubjectItem(subjectItem))
        .toList();
    return SharedSubjectsLocalDB(items: hiveItems);
  }
}

@HiveType(typeId: 7)
class SharedSubjectItemLocalDB extends SharedFieldOfStudyItemModel {
  @HiveField(0)
  final String subject;
  @HiveField(1)
  final String description;

  SharedSubjectItemLocalDB({
    required this.subject,
    required this.description,
  }) : super(subject: subject, description: description);

  factory SharedSubjectItemLocalDB.fromSubjectItem(
      SharedFieldOfStudyItemModel subjectItem) {
    return SharedSubjectItemLocalDB(
      subject: subjectItem.subject,
      description: subjectItem.description,
    );
  }
}

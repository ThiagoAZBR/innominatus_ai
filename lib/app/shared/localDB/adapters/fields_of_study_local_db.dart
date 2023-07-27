import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/domain/models/fields_of_study.dart';

import '../../../domain/models/subject_item.dart';

part 'fields_of_study_local_db.g.dart';

@HiveType(typeId: 1)
class FieldsOfStudyLocalDB extends FieldsOfStudyModel {
  @HiveField(0)
  final List<FieldOfStudyItemModel> items;

  FieldsOfStudyLocalDB({
    required this.items,
  }) : super(items: items);

  factory FieldsOfStudyLocalDB.fromFieldsOfStudyModel(
    FieldsOfStudyModel fieldsOfStudy,
  ) {
    return FieldsOfStudyLocalDB(
      items: fieldsOfStudy.items
          .map((e) => FieldOfStudyItemLocalDB.fromFieldOfStudyItemModel(e))
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

  factory FieldOfStudyItemLocalDB.fromFieldOfStudyItemModel(
    FieldOfStudyItemModel fieldOfStudyItem,
  ) {
    return FieldOfStudyItemLocalDB(
      subjects: fieldOfStudyItem.subjects,
      name: fieldOfStudyItem.name,
    );
  }
}

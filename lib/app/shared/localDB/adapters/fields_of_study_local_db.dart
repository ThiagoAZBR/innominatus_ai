import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/domain/models/class_item.dart';
import 'package:innominatus_ai/app/domain/models/fields_of_study.dart';
import 'package:innominatus_ai/app/domain/models/subject_item.dart';

import '../../../domain/models/field_of_study_item.dart';

part 'fields_of_study_local_db.g.dart';

@HiveType(typeId: 3)
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

@HiveType(typeId: 4)
class FieldOfStudyItemLocalDB extends FieldOfStudyItemModel {
  @HiveField(0)
  final List<SubjectItemModel> subjects;
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
      subjects: fieldOfStudyItem.subjects
          .map((e) => SubjectItemLocalDB.fromSubjectItemModel(e))
          .toList(),
      name: fieldOfStudyItem.name,
    );
  }
}

@HiveType(typeId: 5)
class SubjectItemLocalDB extends SubjectItemModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final List<ClassItemModel>? classes;

  SubjectItemLocalDB({
    required this.name,
    this.classes,
  }) : super(classes: classes, name: name);

  factory SubjectItemLocalDB.fromSubjectItemModel(
    SubjectItemModel subjectItemModel,
  ) {
    return SubjectItemLocalDB(
      name: subjectItemModel.name,
      classes: subjectItemModel.classes
          ?.map((e) => ClassItemLocalDB.fromClassItemModel(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 6)
class ClassItemLocalDB extends ClassItemModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final bool wasItCompleted;

  ClassItemLocalDB({
    required this.name,
    required this.wasItCompleted,
  }) : super(name: name, wasItCompleted: wasItCompleted);

  factory ClassItemLocalDB.fromClassItemModel(ClassItemModel classItemModel) {
    return ClassItemLocalDB(
      name: classItemModel.name,
      wasItCompleted: classItemModel.wasItCompleted,
    );
  }
}

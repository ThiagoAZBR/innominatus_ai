import 'package:hive_flutter/hive_flutter.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/class_subject.dart';

part 'sub_topic.g.dart';

@HiveType(typeId: 2)
class SubTopic extends HiveObject {
  @HiveField(0)
  String subjectParent;

  @HiveField(1)
  List<ClassSubject> classSubjects;

  SubTopic({
    required this.subjectParent,
    required this.classSubjects,
  });
}

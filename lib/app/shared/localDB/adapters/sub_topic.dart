import 'package:hive_flutter/hive_flutter.dart';

part 'sub_topic.g.dart';

@HiveType(typeId: 1)
class SubTopic extends HiveObject {
  @HiveField(0)
  String subjectParent;

  @HiveField(1)
  List<String> classSubjects;

  SubTopic({
    required this.subjectParent,
    required this.classSubjects,
  });
}

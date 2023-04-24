import 'package:hive_flutter/hive_flutter.dart';

import 'package:innominatus_ai/app/shared/localDB/adapters/sub_topic.dart';

part 'study_roadmap.g.dart';

@HiveType(typeId: 1)
class StudyRoadmap {
  @HiveField(0)
  List<SubTopic> subTopic;

  StudyRoadmap({
    required this.subTopic,
  });
}

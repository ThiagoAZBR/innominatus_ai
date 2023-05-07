import 'package:hive_flutter/hive_flutter.dart';

part 'study_roadmap.g.dart';

@HiveType(typeId: 1)
class StudyRoadmap {
  @HiveField(0)
  List<SubTopic> subTopic;

  StudyRoadmap({
    required this.subTopic,
  });
}

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

@HiveType(typeId: 3)
class ClassSubject {
  @HiveField(0)
  bool hasConclude;
  @HiveField(1)
  String classTitle;
  @HiveField(2)
  ClassContent classContent;

  ClassSubject({
    required this.hasConclude,
    required this.classTitle,
    required this.classContent,
  });
}

@HiveType(typeId: 4)
class ClassContent {
  @HiveField(0)
  String script;
  @HiveField(1)
  List<Question>? questions;
  ClassContent({
    required this.script,
    this.questions,
  });
}

@HiveType(typeId: 5)
class Question {
  @HiveField(0)
  String question;
  @HiveField(1)
  String? answer;

  Question({
    required this.question,
    this.answer,
  });
}

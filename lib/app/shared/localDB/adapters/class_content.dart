import 'package:hive_flutter/hive_flutter.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/question.dart';

part 'class_content.g.dart';

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

import 'package:hive_flutter/hive_flutter.dart';

part 'question.g.dart';

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

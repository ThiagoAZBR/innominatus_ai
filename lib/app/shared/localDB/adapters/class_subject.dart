import 'package:hive_flutter/hive_flutter.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/class_content.dart';

part 'class_subject.g.dart';

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

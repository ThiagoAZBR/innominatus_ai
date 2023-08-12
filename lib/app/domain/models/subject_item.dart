import 'package:innominatus_ai/app/domain/models/class_item.dart';

class SubjectItemModel {
  final String name;
  final List<ClassItemModel>? classes;

  SubjectItemModel({
    required this.name,
    this.classes,
  });
}

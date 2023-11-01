import 'package:innominatus_ai/app/domain/models/class_item.dart';

class SubjectItemModel {
  final String name;
  final List<ClassItemModel>? allClasses;

  SubjectItemModel({
    required this.name,
    this.allClasses,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    if (allClasses != null) {
      result
          .addAll({'allClasses': allClasses?.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory SubjectItemModel.fromMap(Map<String, dynamic> map) {
    return SubjectItemModel(
      name: map['name'] ?? '',
      allClasses: map['allClasses'] != null
          ? List<ClassItemModel>.from(
              map['allClasses']?.map((x) => ClassItemModel.fromMap(x)))
          : null,
    );
  }
}

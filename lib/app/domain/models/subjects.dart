import 'package:innominatus_ai/app/domain/models/subject_item.dart';

class SubjectsModel {
  final List<SubjectItemModel> items;

  SubjectsModel({
    required this.items,
  });

  factory SubjectsModel.fromJson(Map<String, dynamic> map) {
    return SubjectsModel(
      items: List<SubjectItemModel>.from(
          map['items']?.map((x) => SubjectItemModel.fromJson(x))),
    );
  }
}

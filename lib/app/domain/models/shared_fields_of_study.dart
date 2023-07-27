import 'package:innominatus_ai/app/domain/models/shared_field_of_study_item.dart';

class SharedFieldsOfStudyModel {
  final List<SharedFieldOfStudyModel> items;

  SharedFieldsOfStudyModel({
    required this.items,
  });

  factory SharedFieldsOfStudyModel.fromJson(Map<String, dynamic> map) {
    return SharedFieldsOfStudyModel(
      items: List<SharedFieldOfStudyModel>.from(
          map['items']?.map((x) => SharedFieldOfStudyModel.fromJson(x))),
    );
  }
}

import 'shared_field_of_study_item.dart';

class SharedFieldsOfStudyModel {
  final List<SharedFieldOfStudyItemModel> items;

  SharedFieldsOfStudyModel({
    required this.items,
  });

  factory SharedFieldsOfStudyModel.fromJson(Map<String, dynamic> map) {
    return SharedFieldsOfStudyModel(
      items: List<SharedFieldOfStudyItemModel>.from(
          map['items']?.map((x) => SharedFieldOfStudyItemModel.fromJson(x))),
    );
  }
}

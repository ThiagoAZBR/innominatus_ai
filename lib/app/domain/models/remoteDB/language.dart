import 'package:innominatus_ai/app/domain/models/shared_field_of_study_item.dart';

class LanguageModel {
  final String name;
  final List<SharedFieldOfStudyItemModel> allFieldsOfStudy;

  LanguageModel({
    required this.name,
    required this.allFieldsOfStudy,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll(
        {'allFieldsOfStudy': allFieldsOfStudy.map((x) => x.toMap()).toList()});

    return result;
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      name: map['name'] ?? '',
      allFieldsOfStudy:
          List<SharedFieldOfStudyItemModel>.from(map['allFieldsOfStudy']?.map(
        (x) => SharedFieldOfStudyItemModel.fromJson(x),
      )),
    );
  }
}

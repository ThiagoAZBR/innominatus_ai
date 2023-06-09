import 'package:innominatus_ai/app/domain/models/shared_subject_item.dart';

class SharedSubjectsModel {
  final List<SharedSubjectItemModel> items;

  SharedSubjectsModel({
    required this.items,
  });

  factory SharedSubjectsModel.fromJson(Map<String, dynamic> map) {
    return SharedSubjectsModel(
      items: List<SharedSubjectItemModel>.from(
          map['items']?.map((x) => SharedSubjectItemModel.fromJson(x))),
    );
  }
}

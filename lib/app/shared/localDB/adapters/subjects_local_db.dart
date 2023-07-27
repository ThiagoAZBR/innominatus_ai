import 'package:hive/hive.dart';

import '../../../domain/models/shared_field_of_study_item.dart';
import '../../../domain/models/shared_fields_of_study.dart';

part 'subjects_local_db.g.dart';

// This class is made to recover the Fields of Study to show when creating or rearranging the Study Roadmap
// The Field of Study when it's displayed, it has the name and description of it
@HiveType(typeId: 6)
class SharedFieldsOfStudyLocalDB extends SharedFieldsOfStudyModel {
  @HiveField(0)
  final List<SharedFieldOfStudyItemModel> items;

  SharedFieldsOfStudyLocalDB({
    required this.items,
  }) : super(items: items);

  factory SharedFieldsOfStudyLocalDB.fromFieldsOfStudyModel(
      SharedFieldsOfStudyModel fieldsOfStudyModel) {
    final hiveItems = fieldsOfStudyModel.items
        .map((fieldsOfStudyItem) =>
            SharedFieldOfStudyItemLocalDB.fromFieldOfStudyItem(fieldsOfStudyItem))
        .toList();
    return SharedFieldsOfStudyLocalDB(items: hiveItems);
  }
}

@HiveType(typeId: 7)
class SharedFieldOfStudyItemLocalDB extends SharedFieldOfStudyItemModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;

  SharedFieldOfStudyItemLocalDB({
    required this.name,
    required this.description,
  }) : super(name: name, description: description);

  factory SharedFieldOfStudyItemLocalDB.fromFieldOfStudyItem(
      SharedFieldOfStudyItemModel fieldOfStudyItem) {
    return SharedFieldOfStudyItemLocalDB(
      name: fieldOfStudyItem.name,
      description: fieldOfStudyItem.description,
    );
  }
}

import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/models/shared_field_of_study_item.dart';
import '../../domain/models/shared_fields_of_study.dart';
import '../../domain/usecases/chat/get_roadmap.dart';
import '../../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../../domain/usecases/usecase.dart';
import '../localDB/adapters/fields_of_study_local_db.dart';
import '../localDB/adapters/shared_fields_of_study_local_db.dart';
import '../localDB/localdb.dart';
import '../localDB/localdb_constants.dart';
import '../localDB/localdb_instances.dart';

class AppController {
  final GetFieldsOfStudyDB _getFieldsOfStudyDB;
  final GetRoadmap _getRoadmap;
  final LocalDB prefs;

  final fieldsOfStudy$ = RxList<SharedFieldOfStudyItemModel>();

  AppController({
    required GetRoadmap getRoadmap,
    required GetFieldsOfStudyDB getFieldsOfStudyDB,
    required this.prefs,
  })  : _getFieldsOfStudyDB = getFieldsOfStudyDB,
        _getRoadmap = getRoadmap;

  Future<bool> getFieldsOfStudy() async {
    final fieldsOfStudyBox = HiveBoxInstances.sharedFieldsOfStudy;
    final SharedFieldsOfStudyModel? fieldsOfStudy =
        fieldsOfStudyBox.get(LocalDBConstants.sharedFieldsOfStudy);

    if (fieldsOfStudy != null) {
      fieldsOfStudy$.addAll(fieldsOfStudy.items);
      return true;
    }

    final responseDB = await _getFieldsOfStudyDB(params: const NoParams());
    if (responseDB.isRight()) {
      responseDB.map(getFieldsOfStudyOnSuccess);
    }

    return responseDB.isRight();
  }

  void getFieldsOfStudyOnSuccess(SharedFieldsOfStudyModel data) {
    final fieldsOfStudyBox = HiveBoxInstances.sharedFieldsOfStudy;
    fieldsOfStudy$.addAll(data.items);
    fieldsOfStudyBox.put(
      LocalDBConstants.sharedFieldsOfStudy,
      SharedFieldsOfStudyLocalDB.fromFieldsOfStudyModel(data),
    );
  }

  Future<List<String>?> getSubjectsFromFieldOfStudyRoadmap(
    GetRoadmapParams params,
  ) async {
    final fieldsOfStudyBox = HiveBoxInstances.fieldsOfStudy;
    final FieldsOfStudyLocalDB? fieldsOfStudy = fieldsOfStudyBox.get(
      LocalDBConstants.fieldsOfStudy,
    );

    if (fieldsOfStudy != null) {
      final selectedFieldOfStudy = params.topic.toLowerCase();

      final hasSubjectsInSelectedFieldOfStudy = fieldsOfStudy.items.any(
        (fieldOfStudy) =>
            fieldOfStudy.name.toLowerCase() == selectedFieldOfStudy,
      );

      if (hasSubjectsInSelectedFieldOfStudy) {
        return fieldsOfStudy.items
            .firstWhere(
              (fieldOfStudy) =>
                  fieldOfStudy.name.toLowerCase() == selectedFieldOfStudy,
            )
            .subjects;
      }
    }

    final response = await _getRoadmap(params: params);
    return response.fold(
      (failure) => null,
      (subjects) {
        if (fieldsOfStudy != null) {
          fieldsOfStudy.items.add(
            FieldOfStudyItemLocalDB(subjects: subjects, name: params.topic),
          );
          fieldsOfStudyBox.put(
            LocalDBConstants.fieldsOfStudy,
            fieldsOfStudy,
          );
        } else {
          // First Time it's created SubjectsWithSubjects
          fieldsOfStudyBox.put(
            LocalDBConstants.fieldsOfStudy,
            FieldsOfStudyLocalDB(
              items: [
                FieldOfStudyItemLocalDB(subjects: subjects, name: params.topic)
              ],
            ),
          );
        }
        return subjects;
      },
    );
  }
}

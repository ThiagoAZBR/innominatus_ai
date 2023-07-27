import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/models/shared_field_of_study_item.dart';
import '../../domain/models/shared_fields_of_study.dart';
import '../../domain/usecases/chat/get_roadmap.dart';
import '../../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../../domain/usecases/usecase.dart';
import '../localDB/adapters/shared_fields_of_study_local_db.dart';
import '../localDB/adapters/fields_of_study_local_db.dart';
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
    final subjectsBox = HiveBoxInstances.sharedFieldsOfStudy;
    fieldsOfStudy$.addAll(data.items);
    subjectsBox.put(
      LocalDBConstants.sharedFieldsOfStudy,
      SharedFieldsOfStudyLocalDB.fromFieldsOfStudyModel(data),
    );
  }

  Future<List<String>?> getSubjectsFromFieldOfStudyRoadmap(
    GetRoadmapParams params,
  ) async {
    final fieldsOfStudyWithSubjectsBox = HiveBoxInstances.fieldsOfStudy;
    final FieldsOfStudyLocalDB? fieldsOfStudyWithSubjects =
        fieldsOfStudyWithSubjectsBox.get(
      LocalDBConstants.fieldsOfStudy,
    );

    if (fieldsOfStudyWithSubjects != null) {
      final selectedFieldOfStudy = params.topic.toLowerCase();

      final hasSubjectsFromSelectedFieldOfStudy =
          fieldsOfStudyWithSubjects.items.any(
        (fieldOfStudy) =>
            fieldOfStudy.name.toLowerCase() == selectedFieldOfStudy,
      );

      if (hasSubjectsFromSelectedFieldOfStudy) {
        return fieldsOfStudyWithSubjects.items
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
      (data) {
        if (fieldsOfStudyWithSubjects != null) {
          fieldsOfStudyWithSubjects.items.add(
            FieldOfStudyItemLocalDB(subjects: data, name: params.topic),
          );
          fieldsOfStudyWithSubjectsBox.put(
            LocalDBConstants.fieldsOfStudy,
            fieldsOfStudyWithSubjects,
          );
        } else {
          // First Time it's created SubjectsWithSubjects
          fieldsOfStudyWithSubjectsBox.put(
            LocalDBConstants.fieldsOfStudy,
            FieldsOfStudyLocalDB(
              items: [
                FieldOfStudyItemLocalDB(subjects: data, name: params.topic)
              ],
            ),
          );
        }
        return data;
      },
    );
  }
}

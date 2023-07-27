import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/models/shared_field_of_study_item.dart';
import '../../domain/models/shared_fields_of_study.dart';
import '../../domain/usecases/chat/get_roadmap.dart';
import '../../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../../domain/usecases/usecase.dart';
import '../localDB/adapters/subjects_local_db.dart';
import '../localDB/adapters/subjects_with_subtopics_local_db.dart';
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

  Future<List<String>?> getSubtopicsFromSubjectRoadmap(
    GetRoadmapParams params,
  ) async {
    final subjectsWithSubtopicsBox = HiveBoxInstances.subjectsWithSubtopics;
    final SubjectsWithSubtopicsLocalDB? subjectsWithSubtopics =
        subjectsWithSubtopicsBox.get(
      LocalDBConstants.subjectsWithSubtopics,
    );

    if (subjectsWithSubtopics != null) {
      final selectedSubject = params.topic.toLowerCase();

      final hasSubtopicsFromSelectedSubject =
          subjectsWithSubtopics.subjects.any(
        (subject) => subject.name.toLowerCase() == selectedSubject,
      );

      if (hasSubtopicsFromSelectedSubject) {
        return subjectsWithSubtopics.subjects
            .firstWhere(
              (subject) => subject.name.toLowerCase() == selectedSubject,
            )
            .subtopics;
      }
    }
    final response = await _getRoadmap(params: params);
    return response.fold(
      (failure) => null,
      (data) {
        if (subjectsWithSubtopics != null) {
          subjectsWithSubtopics.subjects.add(
            SubjectItemLocalDB(subtopics: data, name: params.topic),
          );
          subjectsWithSubtopicsBox.put(
            LocalDBConstants.subjectsWithSubtopics,
            subjectsWithSubtopics,
          );
        } else {
          // First Time it's created SubjectsWithSubtopics
          subjectsWithSubtopicsBox.put(
            LocalDBConstants.subjectsWithSubtopics,
            SubjectsWithSubtopicsLocalDB(
              subjects: [
                SubjectItemLocalDB(subtopics: data, name: params.topic)
              ],
            ),
          );
        }
        return data;
      },
    );
  }
}

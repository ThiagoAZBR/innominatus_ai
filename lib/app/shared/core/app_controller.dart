import 'package:innominatus_ai/app/domain/models/subject_item.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/subjects_with_subtopics_local_db.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/models/shared_subject_item.dart';
import '../../domain/models/shared_subjects.dart';
import '../../domain/usecases/chat/get_roadmap.dart';
import '../../domain/usecases/remote_db/get_subjects_db.dart';
import '../../domain/usecases/usecase.dart';
import '../localDB/adapters/subjects_local_db.dart';
import '../localDB/localdb.dart';
import '../localDB/localdb_constants.dart';
import '../localDB/localdb_instances.dart';

class AppController {
  final GetSubjectsDB _getSubjectsDB;
  final GetRoadmap _getRoadmap;
  final LocalDB prefs;

  final subjects$ = RxList<SharedSubjectItemModel>();

  AppController({
    required GetRoadmap getRoadmap,
    required GetSubjectsDB getSubjectsDB,
    required this.prefs,
  })  : _getSubjectsDB = getSubjectsDB,
        _getRoadmap = getRoadmap;

  Future<bool> getSubjects() async {
    final subjectsBox = HiveBoxInstances.sharedSubjects;
    final SharedSubjectsModel? subjects =
        subjectsBox.get(LocalDBConstants.sharedSubjects);

    if (subjects != null) {
      subjects$.addAll(subjects.items);
      return true;
    }

    final responseDB = await _getSubjectsDB(params: const NoParams());
    if (responseDB.isRight()) {
      responseDB.map(getSubjectsOnSuccess);
    }

    return responseDB.isRight();
  }

  void getSubjectsOnSuccess(SharedSubjectsModel data) {
    final subjectsBox = HiveBoxInstances.sharedSubjects;
    subjects$.addAll(data.items);
    subjectsBox.put(
      LocalDBConstants.sharedSubjects,
      SharedSubjectsLocalDB.fromSubjectsModel(data),
    );
  }

  Future<List<String>?> getRoadmap(GetRoadmapParams params) async {
    final subjectsWithSubtopicsBox = HiveBoxInstances.subjectsWithSubtopics;
    final SubjectsWithSubtopicsLocalDB? subjectsWithSubtopics =
        subjectsWithSubtopicsBox.get(
      LocalDBConstants.subjectsWithSubtopics,
    );

    if (subjectsWithSubtopics != null) {
      final hasSubtopics = subjectsWithSubtopics.subjects.any(
        (subject) => subject.name.toLowerCase() == params.topic.toLowerCase(),
      );

      if (hasSubtopics) {
        return subjectsWithSubtopics.subjects
            .firstWhere((subject) =>
                subject.name.toLowerCase() == params.topic.toLowerCase())
            .subtopics;
      }
    }
    final response = await _getRoadmap(params: params);
    return response.fold(
      (failure) => null,
      (data) {
        if (subjectsWithSubtopics != null) {
          subjectsWithSubtopics.subjects.add(
            SubjectItemModel(subtopics: data, name: params.topic),
          );
          subjectsWithSubtopicsBox.put(
            LocalDBConstants.subjectsWithSubtopics,
            subjectsWithSubtopics,
          );
        } else {
          // First Time it is created
          subjectsWithSubtopicsBox.put(
            LocalDBConstants.subjectsWithSubtopics,
            SubjectsWithSubtopicsLocalDB(
              subjects: [SubjectItemModel(subtopics: data, name: params.topic)],
            ),
          );
        }
        return data;
      },
    );
  }
}

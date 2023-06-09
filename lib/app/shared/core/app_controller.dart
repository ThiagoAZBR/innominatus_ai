import '../../domain/models/subject_item.dart';
import '../../domain/models/subjects.dart';
import '../../domain/usecases/chat/get_roadmap.dart';
import '../../domain/usecases/remote_db/get_subjects_db.dart';
import '../../domain/usecases/usecase.dart';
import '../localDB/adapters/subjects_local_db.dart';
import '../localDB/localdb.dart';
import '../localDB/localdb_constants.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../localDB/localdb_instances.dart';

class AppController {
  final GetSubjectsDB _getSubjectsDB;
  final GetRoadmap _getRoadmap;
  final LocalDB prefs;

  final subjects$ = RxList<SubjectItemModel>();

  AppController({
    required GetRoadmap getRoadmap,
    required GetSubjectsDB getSubjectsDB,
    required this.prefs,
  })  : _getSubjectsDB = getSubjectsDB,
        _getRoadmap = getRoadmap;

  Future<bool> getSubjects() async {
    final subjectsBox = HiveBoxInstances.sharedSubjects;
    final SubjectsModel? subjects =
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

  void getSubjectsOnSuccess(SubjectsModel data) {
    final subjectsBox = HiveBoxInstances.sharedSubjects;
    subjects$.addAll(data.items);
    subjectsBox.put(
      LocalDBConstants.sharedSubjects,
      SubjectsLocalDB.fromSubjectsModel(data),
    );
  }

  Future<List<String>?> getRoadmap(GetRoadmapParams params) async {
    // TODO: Call Subtopics by using Subject in LocalDB
    // TODO: Add Firestore integration
    final response = await _getRoadmap(params: params);
    return response.fold(
      (failure) => null,
      (data) => data,
    );
  }
}

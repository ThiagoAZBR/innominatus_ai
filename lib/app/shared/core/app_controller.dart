import 'package:innominatus_ai/app/shared/text_constants/localdb_constants.dart';
import 'package:innominatus_ai/app/domain/models/subject_item.dart';
import 'package:innominatus_ai/app/domain/models/subjects.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/get_roadmap.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_subjects_db.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/subjects_local_db.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb.dart';
import 'package:rx_notifier/rx_notifier.dart';

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
    final subjectsBox = HiveBoxInstances.subjects;
    final SubjectsModel? subjects = subjectsBox.get(LocalDBConstants.subjects);

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
    final subjectsBox = HiveBoxInstances.subjects;
    subjects$.addAll(data.items);
    subjectsBox.put(
      LocalDBConstants.subjects,
      SubjectsLocalDB.fromSubjectsModel(data),
    );
  }

  Future<List<String>?> getRoadmap(GetRoadmapParams params) async {
    final subTopics = prefs.get(LocalDBConstants.subTopics);

    if (subTopics != null) {
      return subTopics;
    }
    // TODO: Add Firestore integration
    final response = await _getRoadmap(params: params);
    return response.fold((failure) => null, (data) {
      _saveSubTopicsLocalDB(params.content);
      return data;
    });
  }

  void _saveSubTopicsLocalDB(String subject) {
    prefs.put(LocalDBConstants.subjects, subject);
    prefs.put(LocalDBConstants.subjectsWithSubtopics, subject);
  }
}

import 'package:innominatus_ai/app/domain/usecases/chat/get_roadmap.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/get_subjects.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_subjects_db.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
import 'package:rx_notifier/rx_notifier.dart';

class AppController {
  final GetSubjectsAI _getSubjectsAI;
  final GetSubjectsDB _getSubjectsDB;
  final GetRoadmap _getRoadmap;
  final LocalDB prefs;


  final subjects$ = RxList<String>();

  AppController({
    required GetSubjectsAI getSubjects,
    required GetRoadmap getRoadmap,
    required GetSubjectsDB getSubjectsDB,
    required this.prefs,
  })  : _getSubjectsAI = getSubjects,
        _getSubjectsDB = getSubjectsDB,
        _getRoadmap = getRoadmap;

  Future<bool> getSubjects() async {
    final subjects = prefs.getListString(LocalDBConstants.subject);

    if (subjects != null) {
      subjects$.addAll(subjects);
      return true;
    }

    final responseDB = await _getSubjectsDB(params: const NoParams());
    if (responseDB.isRight()) {
      responseDB.map((data) => onSuccess(data.items));
      return true;
    }

    final responseAI = await _getSubjectsAI(params: const NoParams());
    if (responseAI.isRight()) {
      responseAI.map(onSuccess);
    }
    
    return responseAI.isRight();
  }

  void onSuccess(List<String> data) {
    subjects$.addAll(data);
    prefs.put(LocalDBConstants.subject, data);
  }
}

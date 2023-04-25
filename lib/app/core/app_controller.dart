import 'package:innominatus_ai/app/domain/usecases/chat/get_roadmap.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/get_subjects.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
import 'package:rx_notifier/rx_notifier.dart';

class AppController {
  final GetSubjects _getSubjects;
  final GetRoadmap _getRoadmap;
  final LocalDB prefs;

  List isSelectedList = <bool>[];

  final subjects$ = RxList<String>();

  AppController({
    required GetSubjects getSubjects,
    required GetRoadmap getRoadmap,
    required this.prefs,
  })  : _getSubjects = getSubjects,
        _getRoadmap = getRoadmap;

  Future<bool> getSubjects() async {
    final subjects = prefs.getListString(LocalDBConstants.subject);
    if (subjects != null) {
      subjects$.addAll(subjects);
      return true;
    }
    final response = await _getSubjects(params: const NoParams());
    response.map((data) {
      subjects$.addAll(data);
      prefs.put(LocalDBConstants.subject, data);
      return true;
    });
    return false;
  }

  void resetSelectedCarts() =>
      isSelectedList = List.of(isSelectedList).map((e) => false).toList();
}

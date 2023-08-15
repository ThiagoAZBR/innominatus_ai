import 'package:innominatus_ai/app/domain/usecases/chat/get_roadmap.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/states/classes_state.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/localDB/adapters/fields_of_study_local_db.dart';
import '../../../shared/localDB/localdb_constants.dart';
import '../../../shared/localDB/localdb_instances.dart';

class ClassesController {
  final GetRoadmapUseCase getRoadmapUseCase;
  final RxNotifier _state$ = RxNotifier<ClassesState>(ClassesSelectionState());
  final RxNotifier _isClassesLoading = RxNotifier(true);

  ClassesController({
    required this.getRoadmapUseCase,
  });

  Future<List<String>?> getClassesRoadmap(GetRoadmapParams params) async {
    final studyPlan = recoverStudyPlan();
    final subject = params.topic;

    final localClasses = getLocalCreatedClasses(
      subject: subject,
      studyPlan: studyPlan!,
    );

    if (localClasses != null) {
      return localClasses;
    }

    final result = await getRoadmapUseCase(params: params);

    return result.fold(
      (failure) {
        setError();
        return null;
      },
      (classes) => successInGeneratingClasses(
        classes: classes,
        studyPlan: studyPlan,
        subject: subject,
      ),
    );
  }

  FieldsOfStudyLocalDB? recoverStudyPlan() {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    return studyPlanBox.get(LocalDBConstants.studyPlan);
  }

  List<String>? getLocalCreatedClasses({
    required String subject,
    required FieldsOfStudyLocalDB studyPlan,
  }) {
    late int index;
    for (var i = 0; i < studyPlan.items.length; i++) {
      index = studyPlan.items[i].subjects.indexWhere(
        (e) => e.name.toLowerCase() == subject.toLowerCase(),
      );
      if (index != -1) {
        return studyPlan.items[i].subjects[index].classes
            ?.map((e) => e.name)
            .toList();
      }
    }
    return null;
  }

  List<String> successInGeneratingClasses({
    required List<String> classes,
    required FieldsOfStudyLocalDB studyPlan,
    required String subject,
  }) {
    setLocalClasses(
      subject: subject,
      classes: classes,
      studyPlan: studyPlan,
    );

    return classes;
  }

  void setLocalClasses({
    required String subject,
    required List<String> classes,
    required FieldsOfStudyLocalDB studyPlan,
  }) {
    late int index;

    for (var i = 0; i < studyPlan.items.length; i++) {
      index = studyPlan.items[i].subjects.indexWhere(
        (e) => e.name.toLowerCase() == subject.toLowerCase(),
      );

      if (index != -1) {
        studyPlan.items[i].subjects[index] = SubjectItemLocalDB(
          name: subject,
          classes: classes
              .map((e) => ClassItemLocalDB(name: e, wasItCompleted: false))
              .toList(),
        );

        break;
      }
    }
    
    final studyPlanBox = HiveBoxInstances.studyPlan;
    studyPlanBox.put(LocalDBConstants.studyPlan, studyPlan);
  }

  // Getters and Setters
  bool get isClassesLoading$ => _isClassesLoading.value;
  set isClassesLoading$(bool value) => _isClassesLoading.value = value;

  void startClassesLoading() => isClassesLoading$ = true;
  void endClassesLoading() => isClassesLoading$ = false;

  ClassesState get state$ => _state$.value;
  void setError() => _state$.value = ClassesErrorState();
}

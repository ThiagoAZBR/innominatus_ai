import 'package:innominatus_ai/app/domain/usecases/remote_db/get_classes_db.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_subject_with_classes_db.dart';
import 'package:innominatus_ai/app/domain/usecases/roadmap_creation/get_roadmap.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/states/classes_state.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/localDB/adapters/fields_of_study_local_db.dart';
import '../../../shared/localDB/localdb_constants.dart';
import '../../../shared/localDB/localdb_instances.dart';

class ClassesController {
  AppController appController;
  final GetRoadmapUseCase getRoadmapUseCase;
  final SaveSubjectWithClassesRemoteDB saveSubjectWithClassesRemoteDB;
  final GetClassesRemoteDB getClassesRemoteDB;
  final RxNotifier _state$ = RxNotifier<ClassesState>(ClassesSelectionState());
  final RxNotifier _isClassesLoading = RxNotifier(true);
  final RxList<String> generatedClasses = RxList();
  final RxNotifier _hasAnyClassSelected = RxNotifier(false);
  String? selectedClass;

  List<bool> isSelectedClasses = [];

  ClassesController({
    required this.appController,
    required this.getRoadmapUseCase,
    required this.saveSubjectWithClassesRemoteDB,
    required this.getClassesRemoteDB,
  });

  void changeSelectedClass(int i) {
    final int indexOfPreviousSelectedClass = isSelectedClasses.indexOf(true);
    resetAnySelectedClass();
    if (i == indexOfPreviousSelectedClass) {
      hasAnyClassSelected = false;
      selectedClass = null;
      return;
    }
    isSelectedClasses[i] = !isSelectedClasses[i];
    selectedClass = generatedClasses[i];
    hasAnyClassSelected = true;
  }

  void resetAnySelectedClass() =>
      isSelectedClasses = List.of(isSelectedClasses).map((e) => false).toList();

  Future<List<String>?> getClassesRoadmap(
    GetRoadmapParams params,
    String fieldOfStudy,
  ) async {
    startClassesLoading();
    final studyPlan = recoverStudyPlan();
    final subject = params.topic;

    final localClasses = getLocalCreatedClasses(
      subject: subject,
      studyPlan: studyPlan!,
    );

    if (localClasses != null) {
      setupClasses(localClasses);
      return localClasses;
    }

    final remoteClasses = await getRemoteCreatedClasses(
      subject: subject,
      fieldOfStudy: fieldOfStudy,
      studyPlan: studyPlan,
    );

    if (remoteClasses != null) {
      return remoteClasses;
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

  Future<List<String>?> getRemoteCreatedClasses({
    required String subject,
    required String fieldOfStudy,
    required FieldsOfStudyLocalDB studyPlan,
  }) async {
    final response = await getClassesRemoteDB(
      params: GetClassesDBParams(
        languageCode: appController.languageCode,
        fieldOfStudyName: fieldOfStudy,
        subjectName: subject,
      ),
    );

    return response.fold(
      (failure) => null,
      (classes) {
        setLocalClasses(
          subject: subject,
          classes: classes,
          studyPlan: studyPlan,
        );

        setupClasses(classes);

        return classes;
      },
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
      index = studyPlan.items[i].allSubjects.indexWhere(
        (e) => e.name.toLowerCase() == subject.toLowerCase(),
      );
      if (index != -1) {
        return studyPlan.items[i].allSubjects[index].allClasses
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

    setupClasses(classes);
    return classes;
  }

  void setLocalClasses({
    required String subject,
    required List<String> classes,
    required FieldsOfStudyLocalDB studyPlan,
  }) {
    late int index;

    for (var i = 0; i < studyPlan.items.length; i++) {
      index = studyPlan.items[i].allSubjects.indexWhere(
        (e) => e.name.toLowerCase() == subject.toLowerCase(),
      );

      if (index != -1) {
        studyPlan.items[i].allSubjects[index] = SubjectItemLocalDB(
          name: subject,
          allClasses: classes
              .map((e) => ClassItemLocalDB(name: e, wasItCompleted: false))
              .toList(),
        );

        break;
      }
    }

    final studyPlanBox = HiveBoxInstances.studyPlan;
    studyPlanBox.put(LocalDBConstants.studyPlan, studyPlan);
  }

  void setupClasses(
    List<String> classes,
  ) {
    generatedClasses.addAll(classes);
    setQuantityOfClasses(classes);
    endClassesLoading();
  }

  void setQuantityOfClasses(List<String> classes) {
    for (var i = 0; i < classes.length; i++) {
      isSelectedClasses.add(false);
    }
  }

  // Getters and Setters
  bool get isClassesLoading$ => _isClassesLoading.value;
  set isClassesLoading$(bool value) => _isClassesLoading.value = value;

  void startClassesLoading() => isClassesLoading$ = true;
  void endClassesLoading() => isClassesLoading$ = false;

  ClassesState get state$ => _state$.value;
  void setError() => _state$.value = ClassesErrorState();

  bool get hasAnyClassSelected => _hasAnyClassSelected.value;
  set hasAnyClassSelected(bool value) => _hasAnyClassSelected.value = value;
}

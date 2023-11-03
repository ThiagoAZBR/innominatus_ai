import 'package:innominatus_ai/app/domain/models/field_of_study_item.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/states/study_plan_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/fields_of_study_local_db.dart';
import 'package:innominatus_ai/app/shared/app_constants/localdb_constants.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_instances.dart';
import 'package:innominatus_ai/app/shared/routes/args/study_plan_args.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../domain/models/subject_item.dart';

class StudyPlanController {
  final AppController appController;
  final _state = RxNotifier<StudyPlanState>(
    const StudyPlanIsLoadingState(),
  );
  final _hasAnySelectedCard = RxNotifier(false);
  String? selectedSubject;
  String? selectedFieldOfStudy;

  List<bool> isSubjectSelectedList = <bool>[];

  StudyPlanController(this.appController);

  FieldsOfStudyLocalDB? recoverStudyPlan() {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    final studyPlanLocal = studyPlanBox.get(LocalDBConstants.studyPlan);

    // TODO: When being possible have two or more fields of study, do this reference in selecting/changing subject, selecting the respective field of study
    selectedFieldOfStudy = studyPlanLocal?.items.first.name;

    return studyPlanLocal;
  }

  Future<FieldsOfStudyLocalDB> saveStudyPlan(StudyPlanPageArgs args) async {
    List<SubjectItemModel> subjectsItem = [];

    for (var i = 0; i < args.subjects.length; i++) {
      subjectsItem.add(SubjectItemLocalDB(name: args.subjects[i]));
    }

    final fieldOfStudyItem = FieldOfStudyItemLocalDB(
      name: args.fieldOfStudy,
      allSubjects: subjectsItem,
    );

    final studyPlanBox = HiveBoxInstances.studyPlan;

    final FieldsOfStudyLocalDB? studyPlan = studyPlanBox.get(
      LocalDBConstants.studyPlan,
    );

    // Has already saved Study Plan before
    if (studyPlan != null) {
      final bool hasAlreadySavedFieldOfStudy = hasFieldOfStudy(
        items: studyPlan.items,
        fieldOfStudy: args.fieldOfStudy,
      );

      if (hasAlreadySavedFieldOfStudy) {
        final FieldsOfStudyLocalDB updatedStudyPlan =
            updateStudyPlanWithNewSubjects(
          newSubjects: subjectsItem,
          localStudyPlan: studyPlan,
          indexOfFieldOfStudy: getIndexOfFieldOfStudy(
            items: studyPlan.items,
            fieldOfStudy: args.fieldOfStudy,
          ),
        );

        await studyPlanBox.put(
          LocalDBConstants.studyPlan,
          updatedStudyPlan,
        );

        appController.hasStudyPlan = true;
        selectedFieldOfStudy = studyPlan.items.first.name;
        return updatedStudyPlan;
      }

      studyPlan.items.add(fieldOfStudyItem);

      await studyPlanBox.put(
        LocalDBConstants.studyPlan,
        studyPlan,
      );

      selectedFieldOfStudy = studyPlan.items.first.name;
      appController.hasStudyPlan = true;
      return studyPlan;
    }

    final newStudyPlan = FieldsOfStudyLocalDB(items: [fieldOfStudyItem]);
    // First time it's created
    studyPlanBox.put(
      LocalDBConstants.studyPlan,
      newStudyPlan,
    );

    selectedFieldOfStudy = newStudyPlan.items.first.name;
    return newStudyPlan;
  }

  bool hasFieldOfStudy({
    required List<FieldOfStudyItemModel> items,
    required String fieldOfStudy,
  }) {
    return items.any(
      (fieldOfStudyItem) =>
          fieldOfStudyItem.name.toLowerCase() == fieldOfStudy.toLowerCase(),
    );
  }

  void setQuantityOfSubjects(List<String> subjects) {
    for (var i = 0; i < subjects.length; i++) {
      isSubjectSelectedList.add(false);
    }
  }

  void updateSelectionCard(int index, String subject) {
    final lastSelectedIndex = isSubjectSelectedList.indexOf(true);

    for (var i = 0; i < isSubjectSelectedList.length; i++) {
      isSubjectSelectedList[i] = false;
    }

    if (index != lastSelectedIndex) {
      isSubjectSelectedList[index] = !isSubjectSelectedList[index];
    }
    searchForAnySelectedCard();
    if (hasAnySelectedCard) {
      selectedSubject = subject;
      return;
    }
    selectedSubject = null;
  }

  void searchForAnySelectedCard() =>
      hasAnySelectedCard = isSubjectSelectedList.any((e) => e == true);

  int getIndexOfFieldOfStudy({
    required List<FieldOfStudyItemModel> items,
    required String fieldOfStudy,
  }) {
    return items
        .indexWhere((e) => e.name.toLowerCase() == fieldOfStudy.toLowerCase());
  }

  FieldsOfStudyLocalDB updateStudyPlanWithNewSubjects({
    required List<SubjectItemModel> newSubjects,
    required FieldsOfStudyLocalDB localStudyPlan,
    required int indexOfFieldOfStudy,
  }) {
    final existingSubjects =
        localStudyPlan.items[indexOfFieldOfStudy].allSubjects;

    for (var newSubject in newSubjects) {
      final bool hasAlreadySubject = existingSubjects
          .any((e) => e.name.toLowerCase() == newSubject.name.toLowerCase());

      if (!hasAlreadySubject) {
        localStudyPlan.items[indexOfFieldOfStudy].allSubjects.add(newSubject);
      }
    }

    return localStudyPlan;
  }

  // Getters and Setters
  StudyPlanState get state$ => _state.value;
  set state$(StudyPlanState value) => _state.value = value;

  void setDefaultState([
    FieldsOfStudyLocalDB? fieldsOfStudyLocalDB,
  ]) =>
      state$ = StudyPlanDefaultState(
        fieldsOfStudyLocalDB: fieldsOfStudyLocalDB,
      );

  void setErrorState() => state$ = const StudyPlanWithErrorState();

  void startLoading() => state$ = const StudyPlanIsLoadingState();

  bool get hasAnySelectedCard => _hasAnySelectedCard.value;
  set hasAnySelectedCard(bool value) => _hasAnySelectedCard.value = value;
}

import 'package:innominatus_ai/app/domain/models/field_of_study_item.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/states/study_plan_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/fields_of_study_local_db.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
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

  List<bool> isSubjectSelectedList = <bool>[];

  StudyPlanController(this.appController);

  FieldsOfStudyLocalDB? recoverStudyPlan() {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    return studyPlanBox.get(LocalDBConstants.studyPlan);
  }

  Future<FieldsOfStudyLocalDB> saveStudyPlan(StudyPlanPageArgs args) async {
    List<SubjectItemModel> subjectsItem = [];

    for (var i = 0; i < args.subjects.length; i++) {
      subjectsItem.add(SubjectItemLocalDB(name: args.subjects[i]));
    }
    
    final fieldOfStudyItem = FieldOfStudyItemLocalDB(
      name: args.fieldOfStudy,
      subjects: subjectsItem,
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
        return studyPlan;
      }
      studyPlan.items.add(fieldOfStudyItem);

      await studyPlanBox.put(
        LocalDBConstants.studyPlan,
        studyPlan,
      );

      return studyPlan;
    }

    final newStudyPlan = FieldsOfStudyLocalDB(items: [fieldOfStudyItem]);
    // First time it's created
    studyPlanBox.put(
      LocalDBConstants.studyPlan,
      newStudyPlan,
    );
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

  void fillHasSubjectSelected(List<String> subjects) {
    for (var i = 0; i < subjects.length; i++) {
      isSubjectSelectedList.add(false);
    }
  }

  void updateSelectionCard(int index) {
    final lastSelectedIndex = isSubjectSelectedList.indexOf(true);

    for (var i = 0; i < isSubjectSelectedList.length; i++) {
      isSubjectSelectedList[i] = false;
    }

    if (index != lastSelectedIndex) {
      isSubjectSelectedList[index] = !isSubjectSelectedList[index];
    }
    searchForAnySelectedCard();
  }

  void searchForAnySelectedCard() =>
      hasAnySelectedCard = isSubjectSelectedList.any((e) => e == true);

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

  bool get hasAnySelectedCard => _hasAnySelectedCard.value;
  set hasAnySelectedCard(bool value) => _hasAnySelectedCard.value = value;
}

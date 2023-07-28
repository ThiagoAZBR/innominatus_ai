import 'package:innominatus_ai/app/domain/models/subject_item.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/states/study_plan_states.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/fields_of_study_local_db.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_instances.dart';
import 'package:innominatus_ai/app/shared/routes/args/study_plan_args.dart';
import 'package:rx_notifier/rx_notifier.dart';

class StudyPlanController {
  final _state = RxNotifier<StudyPlanState>(
    const StudyPlanIsLoadingState(),
  );

  List<bool> isSubjectSelectedList = <bool>[];

  FieldsOfStudyLocalDB? recoverStudyPlan() {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    return studyPlanBox.get(LocalDBConstants.studyPlan);
  }

  Future<FieldsOfStudyLocalDB> saveStudyPlan(StudyPlanPageArgs args) async {
    final fieldOfStudyItem = FieldOfStudyItemModel(
      name: args.fieldOfStudy,
      subjects: args.subjects,
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
    for (var i = 0; i < isSubjectSelectedList.length; i++) {
      isSubjectSelectedList[i] = false;
    }
    isSubjectSelectedList[index] = !isSubjectSelectedList[index];
  }

  bool hasAnySelectedCard() => isSubjectSelectedList.any((e) => e == true);

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
}

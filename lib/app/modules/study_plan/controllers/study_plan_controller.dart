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

  FieldsOfStudyLocalDB? recoverStudyPlan() {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    return studyPlanBox.get(LocalDBConstants.studyPlan);
  }

  Future<void> saveStudyPlan(StudyPlanPageArgs args) async {
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
        return;
      }
      studyPlan.items.add(fieldOfStudyItem);

      return await studyPlanBox.put(
        LocalDBConstants.studyPlan,
        studyPlan,
      );
    }

    // First time it's created
    studyPlanBox.put(
      LocalDBConstants.studyPlan,
      FieldsOfStudyLocalDB(items: [fieldOfStudyItem]),
    );
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

  // Getters and Setters
  StudyPlanState get state$ => _state.value;
  set state$(StudyPlanState value) => _state.value = value;

  void setDefaultState() => state$ = const StudyPlanDefaultState();
  void setErrorState() => state$ = const StudyPlanWithErrorState();
}

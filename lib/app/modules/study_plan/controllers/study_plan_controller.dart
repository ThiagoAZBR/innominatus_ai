import 'package:innominatus_ai/app/modules/study_plan/controllers/states/study_plan_states.dart';
import 'package:rx_notifier/rx_notifier.dart';

class StudyPlanController {
  final _state = RxNotifier<StudyPlanState>(const StudyPlanDefaultState());

  // Getters and Setters
  StudyPlanState get state$ => _state.value;
  set state$(StudyPlanState value) => _state.value = value;
}

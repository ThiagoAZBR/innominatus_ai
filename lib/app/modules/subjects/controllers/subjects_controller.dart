import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubjectsController {
  final _state = RxNotifier<SubjectsStates>(const SubjectsPageLoadingState());

  SubjectsStates get state => _state.value;

  void setToTopicsSelectionState() {
    _state.value = const TopicsSelectionState();
  }

  void setToStudyAreaSelectionState() {
    _state.value = const StudyAreasSelectionState();
  }
}

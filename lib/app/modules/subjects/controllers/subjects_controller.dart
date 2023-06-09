import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubjectsController {
  final AppController appController;

  final _isSubjectLoading$ = RxNotifier(false);
  final _state = RxNotifier<SubjectsStates>(const SubjectsPageLoadingState());
  List isSubjectSelectedList = <bool>[];
  List isSubtopicSelectedList = <bool>[];
  final RxNotifier _hasAnySubjectSelected = RxNotifier(false);
  final RxNotifier _hasAnySubtopicSelected = RxNotifier(false);

  SubjectsController(this.appController);

  Future<void> getSubjects() async {
    startLoading();
    if (appController.subjects$.isEmpty) {
      await appController.getSubjects();
    }
    for (var i = 0; i < appController.subjects$.length; i++) {
      isSubjectSelectedList.add(false);
    }
    endLoading();
  }

  void changeSubjectSelectedCard(int i) {
    final int indexOfPreviousSelectedSubject =
        isSubjectSelectedList.indexOf(true);
    resetSelectedCarts();
    if (i == indexOfPreviousSelectedSubject) {
      hasAnySubjectSelected = false;
      return;
    }
    isSubjectSelectedList[i] = !isSubjectSelectedList[i];
    hasAnySubjectSelected = true;
  }

  void setToSubTopicsSelectionState() {
    _state.value = const SubTopicsSelectionState();
  }

  void setToStudyAreaSelectionState() {
    _state.value = const SubjectsSelectionState();
  }

  void resetSelectedCarts() {
    isSubjectSelectedList =
        List.of(isSubjectSelectedList).map((e) => false).toList();
  }

  RxNotifier isFloatingButtonVisible(SubjectsStates state) {
    if (state is SubjectsSelectionState) {
      return _hasAnySubjectSelected;
    }
    return _hasAnySubtopicSelected;
  }

  // Getters and Setters
  SubjectsStates get state$ => _state.value;
  bool get isSubjectLoading$ => _isSubjectLoading$.value;
  startLoading() => _isSubjectLoading$.value = true;
  endLoading() => _isSubjectLoading$.value = false;

  bool get hasAnySubtopicSelected => _hasAnySubtopicSelected.value;
  set hasAnySubtopicSelected(bool value) =>
      _hasAnySubtopicSelected.value = value;

  bool get hasAnySubjectSelected => _hasAnySubjectSelected.value;
  set hasAnySubjectSelected(bool value) => _hasAnySubjectSelected.value = value;
}

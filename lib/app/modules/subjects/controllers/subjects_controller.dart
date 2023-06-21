import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubjectsController {
  final AppController appController;

  final _isSubjectLoading$ = RxNotifier(false);
  final _state = RxNotifier<SubjectsStates>(const SubjectsPageLoadingState());
  List<bool> isSubjectSelectedList = <bool>[];
  final RxNotifier _hasAnySubjectSelected = RxNotifier(false);

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

  void setToSubjectsSelectionState() {
    _state.value = const SubjectsSelectionState();
  }

  void resetSelectedCarts() {
    isSubjectSelectedList =
        List.of(isSubjectSelectedList).map((e) => false).toList();
  }

  RxNotifier isFloatingButtonVisible(SubjectsStates state) {
    return _hasAnySubjectSelected;
  }

  // Getters and Setters
  SubjectsStates get state$ => _state.value;
  bool get isSubjectLoading$ => _isSubjectLoading$.value;
  startLoading() => _isSubjectLoading$.value = true;
  endLoading() => _isSubjectLoading$.value = false;

  bool get hasAnySubjectSelected => _hasAnySubjectSelected.value;
  set hasAnySubjectSelected(bool value) => _hasAnySubjectSelected.value = value;
}

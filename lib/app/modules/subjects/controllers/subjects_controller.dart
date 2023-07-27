import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class FieldsOfStudyController {
  final AppController appController;

  final _isSubjectLoading$ = RxNotifier(false);
  final _state = RxNotifier<SubjectsStates>(const FieldsOfStudyLoadingState());
  List<bool> isFieldOfStudySelectedList = <bool>[];
  final RxNotifier _hasAnySubjectSelected = RxNotifier(false);

  FieldsOfStudyController(this.appController);

  Future<void> getSubjects() async {
    startLoading();
    if (appController.fieldsOfStudy$.isEmpty) {
      await appController.getSubjects();
    }
    for (var i = 0; i < appController.fieldsOfStudy$.length; i++) {
      isFieldOfStudySelectedList.add(false);
    }
    endLoading();
  }

  void changeSubjectSelectedCard(int i) {
    final int indexOfPreviousSelectedSubject =
        isFieldOfStudySelectedList.indexOf(true);
    resetSelectedCarts();
    if (i == indexOfPreviousSelectedSubject) {
      hasAnySubjectSelected = false;
      return;
    }
    isFieldOfStudySelectedList[i] = !isFieldOfStudySelectedList[i];
    hasAnySubjectSelected = true;
  }

  void setToFieldsOfStudySelectionState() {
    _state.value = const FieldsOfStudySelectionState();
  }

  void resetSelectedCarts() {
    isFieldOfStudySelectedList =
        List.of(isFieldOfStudySelectedList).map((e) => false).toList();
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

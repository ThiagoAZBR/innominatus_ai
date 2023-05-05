import 'package:innominatus_ai/app/core/app_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubjectsController {
  final AppController appController;

  final _isSubjectLoading$ = RxNotifier(false);
  final _state = RxNotifier<SubjectsStates>(const SubjectsPageLoadingState());
  List isSelectedList = <bool>[];

  SubjectsController(this.appController);

  Future<void> getSubjects() async {
    startLoading();
    if (appController.subjects$.isEmpty) {
      await appController.getSubjects();
    }
    for (var i = 0; i < appController.subjects$.length; i++) {
      isSelectedList.add(false);
    }
    endLoading();
  }

  void changeSelectedCard(int i) {
    final int indexOfPreviousSelectedSubject = isSelectedList.indexOf(true);
    resetSelectedCarts();
    if (i == indexOfPreviousSelectedSubject) {
      return;
    }
    isSelectedList[i] = !isSelectedList[i];
  }

  void setToTopicsSelectionState() {
    _state.value = const SubTopicsSelectionState();
  }

  void setToStudyAreaSelectionState() {
    _state.value = const SubjectsSelectionState();
  }

  void resetSelectedCarts() {
    isSelectedList = List.of(isSelectedList).map((e) => false).toList();
  }

  SubjectsStates get state$ => _state.value;
  bool get isSubjectLoading$ => _isSubjectLoading$.value;
  startLoading() => _isSubjectLoading$.value = true;
  endLoading() => _isSubjectLoading$.value = false;
}

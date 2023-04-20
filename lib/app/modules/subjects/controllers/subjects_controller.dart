import 'package:innominatus_ai/app/core/app_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/states/subjects_states.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubjectsController {
  final AppController appController;

  final _isSubjectLoading$ = RxNotifier(false);
  final _state = RxNotifier<SubjectsStates>(const SubjectsPageLoadingState());

  SubjectsController(this.appController);

  Future<void> getSubjects() async {
    startLoading();
    await appController.getSubjects();
    for (var i = 0; i < appController.subjects$.length; i++) {
      appController.isSelectedList.add(false);
    }
    endLoading();
  }

  void changeSelectedCard(int i) {
    appController.resetSelectedCarts();
    appController.isSelectedList[i] = !appController.isSelectedList[i];
  }

  void setToTopicsSelectionState() {
    _state.value = const SubTopicsSelectionState();
  }

  void setToStudyAreaSelectionState() {
    _state.value = const SubjectsSelectionState();
  }

  SubjectsStates get state$ => _state.value;
  bool get isSubjectLoading$ => _isSubjectLoading$.value;
  startLoading() => _isSubjectLoading$.value = true;
  endLoading() => _isSubjectLoading$.value = false;
}

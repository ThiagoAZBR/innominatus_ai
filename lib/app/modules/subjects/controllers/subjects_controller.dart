import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubjectsController {
  final AppController appController;
  final RxList<String> subjects$ = RxList();
  List<bool> isSubjectsSelectedList = <bool>[];
  final RxNotifier _isLoading = RxNotifier<bool>(true);
  final RxNotifier _hasAnySubjectsSelected = RxNotifier(false);

  SubjectsController(
    this.appController,
  );

  void changeSubjectsSelectedCard(int i) {
    final List<bool> indexOfPreviousSelectedSubjects =
        isSubjectsSelectedList.where((subject) => subject == true).toList();
    if (isSubjectsSelectedList[i] &&
        indexOfPreviousSelectedSubjects.length == 1) {
      hasAnySubjectsSelected = false;
      resetSelectedCarts();
      return;
    }
    if (indexOfPreviousSelectedSubjects.length == 3) {
      if (isSubjectsSelectedList[i]) {
        isSubjectsSelectedList[i] = !isSubjectsSelectedList[i];
        return;
      }
      final int lastSelectedSubject = isSubjectsSelectedList.lastIndexOf(true);
      isSubjectsSelectedList[lastSelectedSubject] = false;
    }
    isSubjectsSelectedList[i] = !isSubjectsSelectedList[i];
    hasAnySubjectsSelected = true;
  }

  void resetSelectedCarts() {
    isSubjectsSelectedList =
        List.of(isSubjectsSelectedList).map((e) => false).toList();
  }

  List<String> getChosenSubjects({
    required List<String> subjects,
    required List<bool> isChosenList,
  }) {
    List<String> chosenSubjects = [];
    for (var i = 0; i < isChosenList.length; i++) {
      if (isChosenList[i]) {
        chosenSubjects.add(subjects[i]);
      }
    }
    return chosenSubjects;
  }

  // Getters and Setters
  bool get isLoading$ => _isLoading.value;
  void startLoading() => _isLoading.value = true;
  void endLoading() => _isLoading.value = false;

  bool get hasAnySubjectsSelected => _hasAnySubjectsSelected.value;
  set hasAnySubjectsSelected(bool value) =>
      _hasAnySubjectsSelected.value = value;
}

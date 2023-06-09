import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubTopicsController {
  final SubjectsController subjectsController;
  final RxList<String> subTopics$ = RxList();
  final RxNotifier _isLoading = RxNotifier<bool>(true);

  SubTopicsController(this.subjectsController);

  String getTopic() {
    int index = subjectsController.isSubjectSelectedList.indexOf(true);
    return appController.subjects$[index].subject;
  }

  void changeSubTopicsSelectedCard(int i) {
    final int indexOfPreviousSelectedSubject =
        isSubtopicSelectedList.indexOf(true);
    resetSelectedCarts();
    if (i == indexOfPreviousSelectedSubject) {
      subjectsController.hasAnySubtopicSelected = false;
      return;
    }
    isSubtopicSelectedList[i] = !isSubtopicSelectedList[i];
    subjectsController.hasAnySubtopicSelected = true;
  }

  void resetSelectedCarts() {
    isSubtopicSelectedList =
        List.of(isSubtopicSelectedList).map((e) => false).toList();
  }

  // Getters and Setters
  AppController get appController => subjectsController.appController;

  bool get isLoading$ => _isLoading.value;
  void startLoading() => _isLoading.value = true;
  void endLoading() => _isLoading.value = false;
  List<bool> get isSubtopicSelectedList =>
      subjectsController.isSubtopicSelectedList;
  set isSubtopicSelectedList(List<bool> newList) =>
      subjectsController.isSubtopicSelectedList = newList;
}

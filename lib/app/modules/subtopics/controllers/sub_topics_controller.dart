import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubTopicsController {
  final AppController appController;
  final RxList<String> subTopics$ = RxList();
  List<bool> isSubtopicSelectedList = <bool>[];
  final RxNotifier _isLoading = RxNotifier<bool>(true);
  final RxNotifier _hasAnySubtopicSelected = RxNotifier(false);

  SubTopicsController(
    this.appController,
  );

  void changeSubTopicsSelectedCard(int i) {
    final List<bool> indexOfPreviousSelectedSubtopic =
        isSubtopicSelectedList.where((subtopic) => subtopic == true).toList();
    if (isSubtopicSelectedList[i] &&
        indexOfPreviousSelectedSubtopic.length == 1) {
      hasAnySubtopicSelected = false;
      resetSelectedCarts();
      return;
    }
    if (indexOfPreviousSelectedSubtopic.length == 3) {
      if (isSubtopicSelectedList[i]) {
        isSubtopicSelectedList[i] = !isSubtopicSelectedList[i];
        return;
      }
      final int lastSelectedSubtopic = isSubtopicSelectedList.lastIndexOf(true);
      isSubtopicSelectedList[lastSelectedSubtopic] = false;
    }
    isSubtopicSelectedList[i] = !isSubtopicSelectedList[i];
    hasAnySubtopicSelected = true;
  }

  void resetSelectedCarts() {
    isSubtopicSelectedList =
        List.of(isSubtopicSelectedList).map((e) => false).toList();
  }

  // Getters and Setters
  bool get isLoading$ => _isLoading.value;
  void startLoading() => _isLoading.value = true;
  void endLoading() => _isLoading.value = false;

  bool get hasAnySubtopicSelected => _hasAnySubtopicSelected.value;
  set hasAnySubtopicSelected(bool value) =>
      _hasAnySubtopicSelected.value = value;
}

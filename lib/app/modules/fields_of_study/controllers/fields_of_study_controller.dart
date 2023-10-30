import 'package:innominatus_ai/app/modules/fields_of_study/controllers/states/fields_of_study_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';
import 'package:rx_notifier/rx_notifier.dart';

class FieldsOfStudyController {
  final AppController appController;

  final _isFieldOfStudyLoading$ = RxNotifier(false);
  final _state = RxNotifier<FieldOfStudyStates>(
    const FieldsOfStudyLoadingState(),
  );
  List<bool> isFieldOfStudySelectedList = <bool>[];
  final RxNotifier _hasAnyFieldOfStudySelected = RxNotifier(false);

  FieldsOfStudyController(this.appController);

  Future<void> getFieldsOfStudy() async {
    startLoading();
    if (appController.fieldsOfStudy$.isEmpty) {
      final hasException = await appController.getFieldsOfStudy();

      if (hasException != null) {
        final hasSucceed = await hasGetFieldsSecondChance(hasException);
        if (!hasSucceed) {
          return setError();
        }
      }
    }
    for (var i = 0; i < appController.fieldsOfStudy$.length; i++) {
      isFieldOfStudySelectedList.add(false);
    }
    endLoading();
  }

  Future<bool> hasGetFieldsSecondChance(Exception exception) async {
    if (exception is! MissingLanguageCacheException) {
      return false;
    }
    await appController.addLanguageCache(appController.languageCode);

    final hasFailed = await appController.getFieldsOfStudy();

    if (hasFailed != null) {
      return false;
    }
    return true;
  }

  void changeFieldOfStudySelectedCard(int i) {
    final int indexOfPreviousSelectedFieldOfStudy =
        isFieldOfStudySelectedList.indexOf(true);
    resetSelectedCards();
    if (i == indexOfPreviousSelectedFieldOfStudy) {
      hasAnyFieldOfStudySelected = false;
      return;
    }
    isFieldOfStudySelectedList[i] = !isFieldOfStudySelectedList[i];
    hasAnyFieldOfStudySelected = true;
  }

  void setToFieldsOfStudySelectionState() {
    _state.value = const FieldsOfStudySelectionState();
  }

  void resetSelectedCards() {
    isFieldOfStudySelectedList =
        List.of(isFieldOfStudySelectedList).map((e) => false).toList();
  }

  RxNotifier isFloatingButtonVisible(FieldOfStudyStates state) {
    return _hasAnyFieldOfStudySelected;
  }

  // Getters and Setters
  FieldOfStudyStates get state$ => _state.value;
  bool get isFieldOfStudyPageLoading$ => _isFieldOfStudyLoading$.value;
  startLoading() => _isFieldOfStudyLoading$.value = true;
  endLoading() => _isFieldOfStudyLoading$.value = false;
  setError() => _state.value = const FieldsOfStudyErrorState();

  bool get hasAnyFieldOfStudySelected => _hasAnyFieldOfStudySelected.value;
  set hasAnyFieldOfStudySelected(bool value) =>
      _hasAnyFieldOfStudySelected.value = value;
}

import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/fields_of_study/controllers/states/fields_of_study_states.dart';
import 'package:innominatus_ai/app/shared/app_constants/localdb_constants.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../domain/models/shared_field_of_study_item.dart';
import '../../../domain/models/shared_fields_of_study.dart';
import '../../../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../../../shared/localDB/localdb_instances.dart';

class FieldsOfStudyController {
  final GetFieldsOfStudyDB _getFieldsOfStudyDB;
  final AppController appController;

  final _isFieldOfStudyLoading$ = RxNotifier(false);
  final fieldsOfStudy$ = RxList<SharedFieldOfStudyItemModel>();
  final _state = RxNotifier<FieldOfStudyStates>(
    const FieldsOfStudyLoadingState(),
  );
  List<bool> isFieldOfStudySelectedList = <bool>[];
  final RxNotifier _hasAnyFieldOfStudySelected = RxNotifier(false);
  final RxNotifier _hasLocalCachedContent = RxNotifier(false);

  final TextEditingController personalizedFieldOfStudyTextController =
      TextEditingController();

  FieldsOfStudyController(
    this._getFieldsOfStudyDB,
    this.appController,
  );

  Future<void> getFieldsOfStudy() async {
    startLoading();
    if (fieldsOfStudy$.isEmpty) {
      final hasException = await _getFieldsOfStudy();

      if (hasException != null) {
        final hasSucceed = await hasGetFieldsSecondChance(hasException);
        if (!hasSucceed) {
          return setError();
        }
      }
    }
    for (var i = 0; i < fieldsOfStudy$.length; i++) {
      isFieldOfStudySelectedList.add(false);
    }
    endLoading();
  }

  Future<Exception?> _getFieldsOfStudy() async {
    if (appController.isUserPremium) {
      final fieldsOfStudyBox = HiveBoxInstances.sharedFieldsOfStudy;
      final SharedFieldsOfStudyModel? fieldsOfStudy =
          fieldsOfStudyBox.get(LocalDBConstants.sharedFieldsOfStudy);

      if (fieldsOfStudy != null) {
        fieldsOfStudy$.addAll(fieldsOfStudy.items);
        hasLocalCachedContent = true;
        return null;
      }
    }

    final responseDB = await _getFieldsOfStudyDB(
      params: GetFieldsOfStudyDBParams(language: appController.languageCode),
    );
    if (responseDB.isRight()) {
      responseDB.map(getFieldsOfStudyOnSuccess);
      return null;
    }
    Exception? exception;
    responseDB.mapLeft((a) => exception = a);

    return exception;
  }

  void getFieldsOfStudyOnSuccess(SharedFieldsOfStudyModel data) {
    fieldsOfStudy$.addAll(data.items);
  }

  Future<bool> hasGetFieldsSecondChance(Exception exception) async {
    if (exception is! MissingLanguageCacheException) {
      return false;
    }
    final hasErrorInTranslation =
        await appController.addLanguageCache(appController.languageCode);

    if (hasErrorInTranslation != null) {
      return false;
    }

    final hasFailed = await _getFieldsOfStudy();

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

  bool get hasLocalCachedContent => _hasLocalCachedContent.value;
  set hasLocalCachedContent(bool value) => _hasLocalCachedContent.value = value;
}

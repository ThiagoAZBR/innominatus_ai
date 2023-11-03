import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_instances.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/localDB/adapters/fields_of_study_local_db.dart';
import '../../../shared/app_constants/localdb_constants.dart';

class SubjectsController {
  String selectedFieldOfStudy = '';
  final AppController appController;
  final RxList<String> subjects$ = RxList();
  List<bool> isSubjectsSelectedList = <bool>[];
  final RxNotifier _isLoading = RxNotifier<bool>(true);
  final RxNotifier _hasAnySubjectsSelected = RxNotifier(false);

  final TextEditingController personalizedSubjectFieldController =
      TextEditingController();

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

  void updateSubjectsSelection({
    required String subjectToBeAdded,
    required String selectedFieldOfStudy,
  }) {
    startLoading();
    final fieldsOfStudyBox = HiveBoxInstances.fieldsOfStudy;

    final FieldsOfStudyLocalDB? localFieldsOfStudy = fieldsOfStudyBox.get(
      LocalDBConstants.fieldsOfStudy,
    );

    int indexOfSelectedFieldOfStudy = localFieldsOfStudy!.items.indexWhere(
      (fieldOfStudy) =>
          fieldOfStudy.name.toLowerCase() == selectedFieldOfStudy.toLowerCase(),
    );

    localFieldsOfStudy.items[indexOfSelectedFieldOfStudy].allSubjects.add(
      SubjectItemLocalDB(name: subjectToBeAdded),
    );

    fieldsOfStudyBox.put(
      LocalDBConstants.fieldsOfStudy,
      localFieldsOfStudy,
    );

    subjects$.insert(0, subjectToBeAdded);
    resetSelectedCarts();
    isSubjectsSelectedList.add(false);
    endLoading();
  }

  // Getters and Setters
  bool get isLoading$ => _isLoading.value;
  void startLoading() => _isLoading.value = true;
  void endLoading() => _isLoading.value = false;

  bool get hasAnySubjectsSelected => _hasAnySubjectsSelected.value;
  set hasAnySubjectsSelected(bool value) =>
      _hasAnySubjectsSelected.value = value;
}

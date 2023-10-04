import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/models/shared_field_of_study_item.dart';
import '../../domain/models/shared_fields_of_study.dart';
import '../../domain/models/subject_item.dart';
import '../../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../../domain/usecases/roadmap_creation/get_roadmap.dart';
import '../../domain/usecases/usecase.dart';
import '../localDB/adapters/fields_of_study_local_db.dart';
import '../localDB/adapters/shared_fields_of_study_local_db.dart';
import '../localDB/localdb.dart';
import '../localDB/localdb_constants.dart';
import '../localDB/localdb_instances.dart';

class AppController {
  final GetFieldsOfStudyDB _getFieldsOfStudyDB;
  final GetRoadmapUseCase _getRoadmap;
  final RxNotifier _pageIndex = RxNotifier(0);

  final LocalDB prefs;

  final _hasStudyPlan = RxNotifier(false);
  final fieldsOfStudy$ = RxList<SharedFieldOfStudyItemModel>();

  AppController({
    required GetRoadmapUseCase getRoadmap,
    required GetFieldsOfStudyDB getFieldsOfStudyDB,
    required this.prefs,
  })  : _getFieldsOfStudyDB = getFieldsOfStudyDB,
        _getRoadmap = getRoadmap;

  Future<bool> getFieldsOfStudy() async {
    final fieldsOfStudyBox = HiveBoxInstances.sharedFieldsOfStudy;
    final SharedFieldsOfStudyModel? fieldsOfStudy =
        fieldsOfStudyBox.get(LocalDBConstants.sharedFieldsOfStudy);

    if (fieldsOfStudy != null) {
      fieldsOfStudy$.addAll(fieldsOfStudy.items);
      return true;
    }

    final responseDB = await _getFieldsOfStudyDB(params: const NoParams());
    if (responseDB.isRight()) {
      responseDB.map(getFieldsOfStudyOnSuccess);
    }

    return responseDB.isRight();
  }

  void getFieldsOfStudyOnSuccess(SharedFieldsOfStudyModel data) {
    final fieldsOfStudyBox = HiveBoxInstances.sharedFieldsOfStudy;
    fieldsOfStudy$.addAll(data.items);
    fieldsOfStudyBox.put(
      LocalDBConstants.sharedFieldsOfStudy,
      SharedFieldsOfStudyLocalDB.fromFieldsOfStudyModel(data),
    );
  }

  Future<List<String>?> getSubjectsFromFieldOfStudyRoadmap(
    GetRoadmapParams params,
  ) async {
    final fieldsOfStudyBox = HiveBoxInstances.fieldsOfStudy;
    final FieldsOfStudyLocalDB? localFieldsOfStudy = fieldsOfStudyBox.get(
      LocalDBConstants.fieldsOfStudy,
    );

    if (localFieldsOfStudy != null) {
      final selectedFieldOfStudy = params.topic.toLowerCase();

      final hasSubjectsInSelectedFieldOfStudy = localFieldsOfStudy.items.any(
        (fieldOfStudy) =>
            fieldOfStudy.name.toLowerCase() == selectedFieldOfStudy,
      );

      if (hasSubjectsInSelectedFieldOfStudy) {
        return localFieldsOfStudy.items
            .firstWhere(
              (fieldOfStudy) =>
                  fieldOfStudy.name.toLowerCase() == selectedFieldOfStudy,
            )
            .subjects
            .map((e) => e.name)
            .toList();
      }
    }

    final response = await _getRoadmap(params: params);
    return response.fold(
      (failure) => null,
      (subjects) {
        List<SubjectItemModel> subjectsItem = [];

        for (var i = 0; i < subjects.length; i++) {
          subjectsItem.add(SubjectItemLocalDB(name: subjects[i]));
        }

        final fieldOfStudyItemLocalDB = FieldOfStudyItemLocalDB(
          subjects: subjectsItem,
          name: params.topic,
        );

        if (localFieldsOfStudy != null) {
          localFieldsOfStudy.items.add(
            fieldOfStudyItemLocalDB,
          );
          fieldsOfStudyBox.put(
            LocalDBConstants.fieldsOfStudy,
            localFieldsOfStudy,
          );
        } else {
          // First Time it's created FieldsOfStudy cache
          fieldsOfStudyBox.put(
            LocalDBConstants.fieldsOfStudy,
            FieldsOfStudyLocalDB(
              items: [fieldOfStudyItemLocalDB],
            ),
          );
        }
        return subjects;
      },
    );
  }

  bool fetchHasStudyPlan() {
    final studyPlanBox = HiveBoxInstances.studyPlan;
    final studyPlan = studyPlanBox.get(LocalDBConstants.studyPlan);

    bool hasStudyPlan = studyPlan != null;
    if (hasStudyPlan) {
      bool studyPlanIsEmpty = studyPlan.items.isEmpty;

      return !studyPlanIsEmpty;
    }
    return false;
  }

  // Getters and Setters
  bool get hasStudyPlan => _hasStudyPlan.value;
  set hasStudyPlan(bool value) => _hasStudyPlan.value = value;

  int get pageIndex => _pageIndex.value;
  set pageIndex(int value) => _pageIndex.value = value;

  void setPageToStudyPlan() => _pageIndex.value = 1;
}

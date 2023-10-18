import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/models/shared_field_of_study_item.dart';
import '../../domain/models/shared_fields_of_study.dart';
import '../../domain/models/subject_item.dart';
import '../../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../../domain/usecases/roadmap_creation/get_roadmap.dart';
import '../../domain/usecases/usecase.dart';
import '../localDB/adapters/fields_of_study_local_db.dart';
import '../localDB/adapters/non_premium_user_local_db.dart';
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
  final RxNotifier _isHomeLoading = RxNotifier(true);
  final RxNotifier _isUserPremium = RxNotifier(false);

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
    isHomeLoading = true;
    final studyPlanBox = HiveBoxInstances.studyPlan;
    final studyPlan = studyPlanBox.get(LocalDBConstants.studyPlan);

    bool hasStudyPlan = studyPlan != null;
    if (hasStudyPlan) {
      bool studyPlanIsEmpty = studyPlan.items.isEmpty;

      return !studyPlanIsEmpty;
    }

    return false;
  }

  Future<void> checkUserPremiumStatus() async {
    try {
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.active
          .containsKey(AppConstants.premiumPlan)) {
        return activatePremium();
      }

      await deactivatePremium();
    } on PlatformException {
      // TODO: Implement Error Handle, show dialog or error widget
      return;
    }
  }

  // Getters and Setters
  bool get hasStudyPlan => _hasStudyPlan.value;
  set hasStudyPlan(bool value) => _hasStudyPlan.value = value;

  int get pageIndex => _pageIndex.value;
  set pageIndex(int value) => _pageIndex.value = value;

  void setPageToStudyPlan() => _pageIndex.value = 1;
  void setPageToHome() => _pageIndex.value = 0;

  bool get isHomeLoading => _isHomeLoading.value;
  set isHomeLoading(bool value) => _isHomeLoading.value = value;

  bool get isUserPremium => _isUserPremium.value;

  void activatePremium() => _isUserPremium.value = true;

  Future<void> deactivatePremium() async {
    try {
      final nonPremiumUserBox = HiveBoxInstances.nonPremiumUser;
      final nonPremiumUserModel =
          nonPremiumUserBox.get(LocalDBConstants.nonPremiumUser);

      final remoteConfig = FirebaseRemoteConfig.instance;
      await setupRemoteConfig(remoteConfig);

      final int generatedClassesLimit =
          remoteConfig.getInt(AppConstants.generatedClassesLimit);
      final int chatAnswersLimit =
          remoteConfig.getInt(AppConstants.chatAnswersLimit);

      if (nonPremiumUserModel != null) {
        await handleNonPremiumUser(
          nonPremiumUserLocalDB: nonPremiumUserModel,
          generatedClassesLimit: generatedClassesLimit,
          chatAnswersLimit: chatAnswersLimit,
        );
      } else {
        await createNonPremiumLimit(
          generatedClassesLimit: generatedClassesLimit,
          chatAnswersLimit: chatAnswersLimit,
        );
      }

      _isUserPremium.value = false;
    } catch (e) {
      // TODO: Implement Error Handle, show dialog or error widget
      return;
    }
  }

  Future<void> setupRemoteConfig(FirebaseRemoteConfig remoteConfig) async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 12),
      ));
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      return;
    }
  }

  Future<void> createNonPremiumLimit({
    required int generatedClassesLimit,
    required int chatAnswersLimit,
  }) async {
    await HiveBoxInstances.nonPremiumUser.put(
      LocalDBConstants.nonPremiumUser,
      NonPremiumUserLocalDB(
        hasReachedLimit: false,
        generatedClasses: generatedClassesLimit,
        chatAnswers: chatAnswersLimit,
        actualDay: DateTime.now(),
      ),
    );
  }

  Future<void> handleNonPremiumUser({
    required NonPremiumUserLocalDB nonPremiumUserLocalDB,
    required int generatedClassesLimit,
    required int chatAnswersLimit,
  }) async {
    final now = DateTime.now();

    if (!now.eqvYearMonthDay(nonPremiumUserLocalDB.actualDay)) {
      await HiveBoxInstances.nonPremiumUser.put(
        LocalDBConstants.nonPremiumUser,
        nonPremiumUserLocalDB.copyWith(
          actualDay: now,
          chatAnswers: chatAnswersLimit,
          generatedClasses: generatedClassesLimit,
          hasReachedLimit: false,
        ),
      );
    }
  }
}

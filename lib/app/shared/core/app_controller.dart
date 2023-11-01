import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/domain/usecases/fields_of_study/get_fields_of_study.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../domain/models/remoteDB/language.dart';
import '../../domain/models/shared_field_of_study_item.dart';
import '../../domain/models/shared_fields_of_study.dart';
import '../../domain/models/subject_item.dart';
import '../../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../../domain/usecases/roadmap_creation/get_roadmap.dart';
import '../app_constants/remote_db_constants.dart';
import '../localDB/adapters/fields_of_study_local_db.dart';
import '../localDB/adapters/non_premium_user_local_db.dart';
import '../localDB/adapters/shared_fields_of_study_local_db.dart';
import '../localDB/localdb.dart';
import '../localDB/localdb_constants.dart';
import '../localDB/localdb_instances.dart';

class AppController {
  String languageCode = '';
  final GetFieldsOfStudyDB _getFieldsOfStudyDB;
  final GetFieldsOfStudyAI _getFieldsOfStudyAI;
  final GetRoadmapUseCase _getRoadmap;
  final RxNotifier _pageIndex = RxNotifier(0);

  final LocalDB prefs;

  final _hasStudyPlan = RxNotifier(false);
  final fieldsOfStudy$ = RxList<SharedFieldOfStudyItemModel>();
  final RxNotifier _isHomeLoading = RxNotifier(true);
  final RxNotifier _isUserPremium = RxNotifier(false);
  final RxNotifier _isAppUpdated = RxNotifier(false);

  AppController({
    required GetRoadmapUseCase getRoadmap,
    required GetFieldsOfStudyDB getFieldsOfStudyDB,
    required GetFieldsOfStudyAI getFieldsOfStudyAI,
    required this.prefs,
  })  : _getFieldsOfStudyDB = getFieldsOfStudyDB,
        _getRoadmap = getRoadmap,
        _getFieldsOfStudyAI = getFieldsOfStudyAI;

  Future<Exception?> getFieldsOfStudy() async {
    final fieldsOfStudyBox = HiveBoxInstances.sharedFieldsOfStudy;
    final SharedFieldsOfStudyModel? fieldsOfStudy =
        fieldsOfStudyBox.get(LocalDBConstants.sharedFieldsOfStudy);

    if (fieldsOfStudy != null) {
      fieldsOfStudy$.addAll(fieldsOfStudy.items);
      return null;
    }

    final responseDB = await _getFieldsOfStudyDB(
      params: GetFieldsOfStudyDBParams(language: languageCode),
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
    final fieldsOfStudyBox = HiveBoxInstances.sharedFieldsOfStudy;
    fieldsOfStudy$.addAll(data.items);
    fieldsOfStudyBox.put(
      LocalDBConstants.sharedFieldsOfStudy,
      SharedFieldsOfStudyLocalDB.fromFieldsOfStudyModel(data),
    );
  }

  Future<Exception?> addLanguageCache(String language) async {
    try {
      final firebaseInstance = FirebaseFirestore.instance;

      final result = await firebaseInstance
          .collection(RemoteDBConstants.shared)
          .doc(RemoteDBConstants.oldFieldsOfStudy)
          .get();

      final generatedFieldsOfStudy = await _getFieldsOfStudyAI(
        params: GetFieldsOfStudyParams(
          content: AppConstants.generateFieldsOfStudy(
            language,
            result.data()!.toString(),
          ),
        ),
      );

      return generatedFieldsOfStudy.fold(
        (f) {
          throw const CantGenerateTranslatedFieldsOfStudyException();
        },
        (data) async =>
            await firebaseInstance.collection(RemoteDBConstants.languages).add(
                  LanguageModel(
                    name: language,
                    allFieldsOfStudy: data.items,
                  ).toMap(),
                ),
      ).then((_) => null);
    } on FirebaseException {
      return FirebaseException(plugin: 'Firestore');
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return UnexpectedException();
    }
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
            .allSubjects
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
          allSubjects: subjectsItem,
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

  Future<bool> isAppVersionUpdated() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await setupRemoteConfig(remoteConfig);
      final remoteStoreVersion =
          remoteConfig.getInt(AppConstants.remoteVersion);
      final appVersion = await PackageInfo.fromPlatform();

      return (int.tryParse(appVersion.buildNumber) ?? -1) >= remoteStoreVersion;
    } catch (e) {
      return false;
    }
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
      // Because it's not recommended make restorePurchase automatically, in case of error the user must go to PremiumPage to do it himself
      return;
    }
  }

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
      if (now.day > nonPremiumUserLocalDB.actualDay.day) {
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

  // Getters and Setters
  bool get hasStudyPlan => _hasStudyPlan.value;
  set hasStudyPlan(bool value) => _hasStudyPlan.value = value;

  int get pageIndex => _pageIndex.value;
  set pageIndex(int value) => _pageIndex.value = value;

  void setPageToHome() => _pageIndex.value = 0;
  void setPageToStudyPlan() => _pageIndex.value = 1;
  void setPageToPremium() => _pageIndex.value = 2;

  bool get isHomeLoading => _isHomeLoading.value;
  set isHomeLoading(bool value) => _isHomeLoading.value = value;

  bool get isUserPremium => _isUserPremium.value;

  void activatePremium() => _isUserPremium.value = true;

  bool get isAppUpdated => _isAppUpdated.value;
  set isAppUpdated(bool value) => _isAppUpdated.value = value;
}

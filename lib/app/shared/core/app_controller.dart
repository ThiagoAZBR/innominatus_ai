import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/domain/usecases/fields_of_study/get_fields_of_study.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_field_of_study_with_subjects_db.dart';
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
import '../../domain/usecases/remote_db/get_subjects_db.dart';
import '../../domain/usecases/roadmap_creation/get_roadmap.dart';
import '../app_constants/localdb_constants.dart';
import '../app_constants/remote_db_constants.dart';
import '../localDB/adapters/fields_of_study_local_db.dart';
import '../localDB/adapters/non_premium_user_local_db.dart';
import '../localDB/adapters/shared_fields_of_study_local_db.dart';
import '../localDB/localdb.dart';
import '../localDB/localdb_instances.dart';

class AppController {
  String languageCode = '';
  final GetFieldsOfStudyDB _getFieldsOfStudyDB;
  final GetFieldsOfStudyAI _getFieldsOfStudyAI;
  final SaveFieldOfStudyWithSubjects _saveFieldOfStudyWithSubjects;
  final GetFieldOfStudyWithSubjects _getFieldOfStudyWithSubjects;
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
    required SaveFieldOfStudyWithSubjects saveFieldOfStudyWithSubjects,
    required GetFieldOfStudyWithSubjects getFieldOfStudyWithSubjects,
    required this.prefs,
  })  : _getFieldsOfStudyDB = getFieldsOfStudyDB,
        _getRoadmap = getRoadmap,
        _getFieldsOfStudyAI = getFieldsOfStudyAI,
        _saveFieldOfStudyWithSubjects = saveFieldOfStudyWithSubjects,
        _getFieldOfStudyWithSubjects = getFieldOfStudyWithSubjects;

  // Functions
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
    final FieldsOfStudyLocalDB? localFieldsOfStudy =
        HiveBoxInstances.fieldsOfStudy.get(
      LocalDBConstants.fieldsOfStudy,
    );

    // Get LocalDB Subjects
    if (localFieldsOfStudy != null) {
      final localSubjects = getLocalSubjects(localFieldsOfStudy, params.topic);

      if (localSubjects != null) {
        return localSubjects;
      }
    }

    // Get Remote Subjects
    final remoteSubjects = await getRemoteSubjects(
      GetFieldOfStudyWithSubjectsDBParams(
        languageCode: languageCode,
        fieldOfStudyName: params.topic,
      ),
    );

    if (remoteSubjects != null) {
      await saveLocalSubjects(
        localFieldsOfStudy: localFieldsOfStudy,
        subjects: remoteSubjects,
        topic: params.topic,
      );
      return remoteSubjects;
    }

    // Get AI Generated Subjects
    final response = await _getRoadmap(params: params);
    return await response.fold(
      (failure) => null,
      (subjects) async => await _getAISubjectsHandleSuccess(
        subjects: subjects,
        topic: params.topic,
        localFieldsOfStudy: localFieldsOfStudy,
      ),
    );
  }

  Future<List<String>> _getAISubjectsHandleSuccess({
    required List<String> subjects,
    required String topic,
    required FieldsOfStudyLocalDB? localFieldsOfStudy,
  }) async {
    await saveRemoteSubjects(
      SaveFieldOfStudyWithSubjectsDBParams(
        languageCode: languageCode,
        fieldOfStudyName: topic,
        allSubjects: subjects,
      ),
    );

    await saveLocalSubjects(
      localFieldsOfStudy: localFieldsOfStudy,
      subjects: subjects,
      topic: topic,
    );

    return subjects;
  }

  Future<void> saveRemoteSubjects(
    SaveFieldOfStudyWithSubjectsDBParams params,
  ) async =>
      await _saveFieldOfStudyWithSubjects(params: params);

  Future<void> saveLocalSubjects({
    required FieldsOfStudyLocalDB? localFieldsOfStudy,
    required List<String> subjects,
    required String topic,
  }) async {
    List<SubjectItemModel> subjectsItem = [];

    for (var i = 0; i < subjects.length; i++) {
      subjectsItem.add(SubjectItemLocalDB(name: subjects[i]));
    }

    final fieldOfStudyItemLocalDB = FieldOfStudyItemLocalDB(
      allSubjects: subjectsItem,
      name: topic,
    );

    final fieldsOfStudyBox = HiveBoxInstances.fieldsOfStudy;

    if (localFieldsOfStudy != null) {
      localFieldsOfStudy.items.add(
        fieldOfStudyItemLocalDB,
      );
      await fieldsOfStudyBox.put(
        LocalDBConstants.fieldsOfStudy,
        localFieldsOfStudy,
      );
    } else {
      // First Time it's created FieldsOfStudy cache
      await fieldsOfStudyBox.put(
        LocalDBConstants.fieldsOfStudy,
        FieldsOfStudyLocalDB(
          items: [fieldOfStudyItemLocalDB],
        ),
      );
    }
  }

  List<String>? getLocalSubjects(
    FieldsOfStudyLocalDB localFieldsOfStudy,
    String topic,
  ) {
    final selectedFieldOfStudy = topic.toLowerCase();

    final hasSubjectsInSelectedFieldOfStudy = localFieldsOfStudy.items.any(
      (fieldOfStudy) => fieldOfStudy.name.toLowerCase() == selectedFieldOfStudy,
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

    return null;
  }

  Future<List<String>?> getRemoteSubjects(
    GetFieldOfStudyWithSubjectsDBParams params,
  ) async {
    final result = await _getFieldOfStudyWithSubjects(params: params);

    return result.fold(
      (failure) => null,
      (subjects) => subjects,
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
        prefs.put(LocalDBConstants.isUserPremium, true);
        return activatePremium();
      }

      prefs.put(LocalDBConstants.isUserPremium, false);
      await deactivatePremium();
    } catch (e) {
      // Because it's not recommended make restorePurchase automatically, in case of error the user must go to PremiumPage to do it himself
      final localIsUserPremium = prefs.get(LocalDBConstants.isUserPremium);

      if (localIsUserPremium != null) {
        return localIsUserPremium ? activatePremium() : deactivatePremium();
      }

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

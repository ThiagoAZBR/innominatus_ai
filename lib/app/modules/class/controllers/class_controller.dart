import 'package:http/http.dart' as http;
import 'package:innominatus_ai/app/domain/models/class_item.dart';
import 'package:innominatus_ai/app/domain/models/field_of_study_item.dart';
import 'package:innominatus_ai/app/domain/models/subject_item.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/class/stream_create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_class_db.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_class_db.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/fields_of_study_local_db.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/localDB/localdb_instances.dart';

class ClassController {
  final AppController appController;
  final GetClassDB getClassDB;
  final SaveClassDB saveClassDB;
  final CreateClassUseCase createClassUseCase;
  final StreamCreateClassUseCase streamCreateClassUseCase;

  String classContentStream = '';
  Future<http.StreamedResponse>? streamClassContent;

  final RxNotifier _state = RxNotifier<ClassState>(
    const ClassIsLoadingState(),
  );

  ClassController(
    this.appController,
    this.createClassUseCase,
    this.streamCreateClassUseCase,
    this.getClassDB,
    this.saveClassDB,
  );

  Future<void> createClass(
    CreateClassParams params,
    String fieldOfStudy,
  ) async {
    if (!appController.isUserPremium) {
      if (await hasNonPremiumUserLimitation()) {
        return setClassError(isNonPremiumLimitation: true);
      }
    }

    final localContent = recoverClass(params);

    if (localContent != null) {
      return setClassDefault(localContent, params.className);
    }

    final remoteContent = await recoverRemoteClass(
      GetClassDBParams(
        languageCode: appController.languageCode,
        fieldOfStudyName: fieldOfStudy,
        subjectName: params.subject,
        className: params.className,
      ),
    );

    if (remoteContent != null) {
      saveLocalClass(
        remoteContent,
        params,
      );
      return setClassDefault(
        remoteContent,
        params.className,
      );
    }

    final response = await createClassUseCase(params: params);

    response.fold(
      (failure) => setClassError(),
      (data) async {
        saveLocalClass(data, params);
        await saveRemoteClass(
          SaveClassDBParams(
            languageCode: appController.languageCode,
            fieldOfStudyName: fieldOfStudy,
            subjectName: params.subject,
            className: params.className,
            content: data,
          ),
        );
        return setClassDefault(
          data,
          params.className,
        );
      },
    );
  }

  Future<bool> hasNonPremiumUserLimitation() async {
    final nonPremiumUserBox = HiveBoxInstances.nonPremiumUser;
    final nonPremiumUserLocalDB =
        nonPremiumUserBox.get(LocalDBConstants.nonPremiumUser);

    if (!nonPremiumUserLocalDB!.hasReachedLimit) {
      final generatedClasses = nonPremiumUserLocalDB.generatedClasses;

      if (generatedClasses == 0) {
        if (nonPremiumUserLocalDB.chatAnswers == 0) {
          await nonPremiumUserBox.put(
              LocalDBConstants.nonPremiumUser,
              nonPremiumUserLocalDB.copyWith(
                hasReachedLimit: true,
              ));
        }
        return true;
      }

      if (generatedClasses >= 1) {
        await nonPremiumUserBox.put(
            LocalDBConstants.nonPremiumUser,
            nonPremiumUserLocalDB.copyWith(
              generatedClasses: generatedClasses - 1,
            ));
        return false;
      }
    }

    return true;
  }

  Future<void> saveRemoteClass(
    SaveClassDBParams params,
  ) async =>
      saveClassDB(params: params);

  Future<String?> recoverRemoteClass(
    GetClassDBParams params,
  ) async {
    final response = await getClassDB(params: params);

    return response.fold(
      (failure) => null,
      (data) => data,
    );
  }

  String? recoverClass(CreateClassParams params) {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    final FieldsOfStudyLocalDB? studyLocalDB =
        studyPlanBox.get(LocalDBConstants.studyPlan);

    final FieldOfStudyItemModel fieldOfStudyItem = studyLocalDB!.items
        .where((fieldOfStudy) => fieldOfStudy.allSubjects.any(
              (subject) =>
                  subject.name.toLowerCase() == params.subject.toLowerCase(),
            ))
        .first;

    final SubjectItemModel subjectItem = fieldOfStudyItem.allSubjects
        .where((e) => e.name.toLowerCase() == params.subject.toLowerCase())
        .first;

    final ClassItemModel classItem = subjectItem.allClasses!
        .where((e) => e.name.toLowerCase() == params.className.toLowerCase())
        .first;

    return classItem.content;
  }

  void saveLocalClass(
    String classContent,
    CreateClassParams params,
  ) {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    final studyLocalDB = studyPlanBox.get(LocalDBConstants.studyPlan);

    final fieldOfStudyIndex = studyLocalDB!.items
        .indexWhere((fieldOfStudy) => fieldOfStudy.allSubjects.any(
              (subject) =>
                  subject.name.toLowerCase() == params.subject.toLowerCase(),
            ));

    final subjectIndex = studyLocalDB.items[fieldOfStudyIndex].allSubjects
        .indexWhere(
            (e) => e.name.toLowerCase() == params.subject.toLowerCase());

    final classIndex = studyLocalDB
        .items[fieldOfStudyIndex].allSubjects[subjectIndex].allClasses!
        .indexWhere(
            (e) => e.name.toLowerCase() == params.className.toLowerCase());

    final ClassItemModel classItemModel = studyLocalDB.items[fieldOfStudyIndex]
        .allSubjects[subjectIndex].allClasses![classIndex];

    studyLocalDB.items[fieldOfStudyIndex].allSubjects[subjectIndex]
        .allClasses![classIndex] = ClassItemLocalDB(
      name: classItemModel.name,
      wasItCompleted: classItemModel.wasItCompleted,
      content: classContent,
    );

    studyPlanBox.put(LocalDBConstants.studyPlan, studyLocalDB);
  }

  void streamCreateClass(CreateClassParams params) {
    final response = streamCreateClassUseCase(params: params);

    response.fold(
      (failure) => setClassError(),
      (data) {
        streamClassContent = data;
        _state.value = ClassDefaultState(className: params.className);
      },
    );
  }

  // Getters and Setters
  ClassState get state => _state.value;

  void setClassLoading() => _state.value = const ClassIsLoadingState();
  void setClassError({
    isNonPremiumLimitation = false,
  }) =>
      _state.value = ClassWithErrorState(
        isNonPremiumLimitation: isNonPremiumLimitation,
      );
  void setClassDefault([
    String? classContent,
    String? className,
  ]) =>
      _state.value = ClassDefaultState(
        classContent: classContent,
        className: className,
      );
}

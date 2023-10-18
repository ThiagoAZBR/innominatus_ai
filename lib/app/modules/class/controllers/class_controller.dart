import 'package:http/http.dart' as http;
import 'package:rx_notifier/rx_notifier.dart';

import 'package:innominatus_ai/app/domain/models/class_item.dart';
import 'package:innominatus_ai/app/domain/models/field_of_study_item.dart';
import 'package:innominatus_ai/app/domain/models/subject_item.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/class/stream_create_class_use_case.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/fields_of_study_local_db.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';

import '../../../shared/localDB/localdb_instances.dart';

class ClassController {
  final AppController appController;
  final CreateClassUseCase createClassUseCase;
  final StreamCreateClassUseCase streamCreateClassUseCase;

  String classContentStream = '';
  Future<http.StreamedResponse>? streamClassContent;

  final RxNotifier _state = RxNotifier<ClassState>(
    const ClassIsLoadingState(),
  );

  Future<void> createClass(CreateClassParams params) async {
    final localContent = recoverClass(params);

    if (localContent != null) {
      return setClassDefault(localContent, params.className);
    }

    final response = await createClassUseCase(params: params);

    response.fold(
      (failure) => setClassError(),
      (data) {
        saveLocalClass(data, params);
        return setClassDefault(
          data,
          params.className,
        );
      },
    );
  }

  String? recoverClass(CreateClassParams params) {
    final studyPlanBox = HiveBoxInstances.studyPlan;

    final FieldsOfStudyLocalDB? studyLocalDB =
        studyPlanBox.get(LocalDBConstants.studyPlan);

    final FieldOfStudyItemModel fieldOfStudyItem = studyLocalDB!.items
        .where((fieldOfStudy) => fieldOfStudy.subjects.any(
              (subject) =>
                  subject.name.toLowerCase() == params.subject.toLowerCase(),
            ))
        .first;

    final SubjectItemModel subjectItem = fieldOfStudyItem.subjects
        .where((e) => e.name.toLowerCase() == params.subject.toLowerCase())
        .first;

    final ClassItemModel classItem = subjectItem.classes!
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
        .indexWhere((fieldOfStudy) => fieldOfStudy.subjects.any(
              (subject) =>
                  subject.name.toLowerCase() == params.subject.toLowerCase(),
            ));

    final subjectIndex = studyLocalDB.items[fieldOfStudyIndex].subjects
        .indexWhere(
            (e) => e.name.toLowerCase() == params.subject.toLowerCase());

    final classIndex = studyLocalDB
        .items[fieldOfStudyIndex].subjects[subjectIndex].classes!
        .indexWhere(
            (e) => e.name.toLowerCase() == params.className.toLowerCase());

    final ClassItemModel classItemModel = studyLocalDB
        .items[fieldOfStudyIndex].subjects[subjectIndex].classes![classIndex];

    studyLocalDB.items[fieldOfStudyIndex].subjects[subjectIndex]
        .classes![classIndex] = ClassItemLocalDB(
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

  ClassController(
    this.appController,
    this.createClassUseCase,
    this.streamCreateClassUseCase,
  );

  // Getters and Setters
  ClassState get state => _state.value;

  void setClassLoading() => _state.value = const ClassIsLoadingState();
  void setClassError() => _state.value = const ClassWithErrorState();
  void setClassDefault([
    String? classContent,
    String? className,
  ]) =>
      _state.value = ClassDefaultState(
        classContent: classContent,
        className: className,
      );
}

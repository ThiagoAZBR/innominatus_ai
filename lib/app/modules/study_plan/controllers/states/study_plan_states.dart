import 'package:innominatus_ai/app/shared/localDB/adapters/fields_of_study_local_db.dart';

abstract class StudyPlanState {}

class StudyPlanIsLoadingState implements StudyPlanState {
  const StudyPlanIsLoadingState();
}

class StudyPlanDefaultState implements StudyPlanState {
  final FieldsOfStudyLocalDB? fieldsOfStudyLocalDB;
  const StudyPlanDefaultState({
    this.fieldsOfStudyLocalDB,
  });
}

class StudyPlanWithErrorState implements StudyPlanState {
  const StudyPlanWithErrorState();
}

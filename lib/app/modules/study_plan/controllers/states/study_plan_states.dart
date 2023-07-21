abstract class StudyPlanState {}

class StudyPlanIsLoadingState implements StudyPlanState {
  const StudyPlanIsLoadingState();
}

class StudyPlanDefaultState implements StudyPlanState {
  const StudyPlanDefaultState();
}

class StudyPlanWithErrorState implements StudyPlanState {
  const StudyPlanWithErrorState();
}

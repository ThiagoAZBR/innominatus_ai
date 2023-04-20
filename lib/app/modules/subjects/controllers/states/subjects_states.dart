abstract class SubjectsStates {
  const SubjectsStates();
}

class SubjectsSelectionState implements SubjectsStates {
  const SubjectsSelectionState();
}

class SubTopicsSelectionState implements SubjectsStates {
  const SubTopicsSelectionState();
}

class SubjectsPageLoadingState implements SubjectsStates {
  const SubjectsPageLoadingState();
}

class SubjectsPageErrorState implements SubjectsStates {
  const SubjectsPageErrorState();
}

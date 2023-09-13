class SubjectsPageArgs {
  final String fieldOfStudy;
  final bool isAddingSubjectsToExistingStudyPlan;

  SubjectsPageArgs({
    required this.fieldOfStudy,
    this.isAddingSubjectsToExistingStudyPlan = false,
  });
}

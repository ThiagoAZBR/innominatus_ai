class SaveFieldOfStudyWithSubjectsDBParams {
  final String languageCode;
  final String fieldOfStudyName;
  final List<String> allSubjects;

  SaveFieldOfStudyWithSubjectsDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
    required this.allSubjects,
  });
}

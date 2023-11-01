class SaveSubjectsWithClassesDBParams {
  final String languageCode;
  final String fieldOfStudyName;
  final String subjectName;
  final List<String> allClasses;

  SaveSubjectsWithClassesDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
    required this.subjectName,
    required this.allClasses,
  });
}

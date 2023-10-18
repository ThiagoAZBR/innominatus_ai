class NonPremiumUserModel {
  final bool hasReachedLimit;
  final int generatedClasses;
  final int chatAnswers;
  final DateTime actualDay;

  NonPremiumUserModel({
    required this.hasReachedLimit,
    required this.generatedClasses,
    required this.chatAnswers,
    required this.actualDay,
  });
}

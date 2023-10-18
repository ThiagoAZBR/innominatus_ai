import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/domain/models/non_premium_user.dart';

part 'non_premium_user_local_db.g.dart';

@HiveType(typeId: 7)
class NonPremiumUserLocalDB extends NonPremiumUserModel {
  @HiveField(0)
  final bool hasReachedLimit;
  @HiveField(1)
  final int generatedClasses;
  @HiveField(2)
  final int chatAnswers;
  @HiveField(3)
  final DateTime actualDay;

  NonPremiumUserLocalDB({
    required this.hasReachedLimit,
    required this.generatedClasses,
    required this.chatAnswers,
    required this.actualDay,
  }) : super(
          hasReachedLimit: hasReachedLimit,
          generatedClasses: generatedClasses,
          chatAnswers: chatAnswers,
          actualDay: actualDay,
        );

  NonPremiumUserLocalDB copyWith({
    bool? hasReachedLimit,
    int? generatedClasses,
    int? chatAnswers,
    DateTime? actualDay,
  }) {
    return NonPremiumUserLocalDB(
      hasReachedLimit: hasReachedLimit ?? this.hasReachedLimit,
      generatedClasses: generatedClasses ?? this.generatedClasses,
      chatAnswers: chatAnswers ?? this.chatAnswers,
      actualDay: actualDay ?? this.actualDay,
    );
  }

  factory NonPremiumUserLocalDB.fromNonPremiumUserModel(
    NonPremiumUserModel nonPremiumUser,
  ) {
    return NonPremiumUserLocalDB(
      hasReachedLimit: nonPremiumUser.hasReachedLimit,
      generatedClasses: nonPremiumUser.generatedClasses,
      chatAnswers: nonPremiumUser.chatAnswers,
      actualDay: nonPremiumUser.actualDay,
    );
  }
}

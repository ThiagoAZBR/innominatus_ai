import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/domain/models/shared_subjects.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/subjects_local_db.dart';

part 'study_plan_db.g.dart';

@HiveType(typeId: 3)
class StudyPlanLocalDB {
  @HiveField(0)
  final SharedSubjectsModel studyPlan;

  StudyPlanLocalDB({
    required this.studyPlan,
  });

  factory StudyPlanLocalDB.fromSubjectsModel(
    SharedSubjectsModel subjectsModel,
  ) {
    final hiveItems = subjectsModel.items
        .map((subjectItem) =>
            SharedSubjectItemLocalDB.fromSubjectItem(subjectItem))
        .toList();

    return StudyPlanLocalDB(
      studyPlan: SharedSubjectsLocalDB(
        items: hiveItems,
      ),
    );
  }
}

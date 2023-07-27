import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/domain/models/shared_fields_of_study.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/subjects_local_db.dart';

part 'study_plan_db.g.dart';

@HiveType(typeId: 3)
class StudyPlanLocalDB {
  @HiveField(0)
  final SharedFieldsOfStudyModel studyPlan;

  StudyPlanLocalDB({
    required this.studyPlan,
  });

  factory StudyPlanLocalDB.fromSubjectsModel(
    SharedFieldsOfStudyModel subjectsModel,
  ) {
    final hiveItems = subjectsModel.items
        .map((subjectItem) =>
            SharedFieldOfStudyItemLocalDB.fromFieldOfStudyItem(subjectItem))
        .toList();

    return StudyPlanLocalDB(
      studyPlan: SharedFieldsOfStudyLocalDB(
        items: hiveItems,
      ),
    );
  }
}

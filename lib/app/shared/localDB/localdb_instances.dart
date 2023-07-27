import 'package:hive/hive.dart';

import 'localdb_constants.dart';

class HiveBoxInstances {
  static Box get sharedFieldsOfStudy =>
      Hive.box(LocalDBConstants.sharedFieldsOfStudy);
  static Box get fieldsOfStudyWithSubjects => Hive.box(
        LocalDBConstants.fieldsOfStudyWithSubjects,
      );
  static Box get studyPlan => Hive.box(LocalDBConstants.studyPlan);
}

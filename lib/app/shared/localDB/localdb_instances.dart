import 'package:hive/hive.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/fields_of_study_local_db.dart';
import 'package:innominatus_ai/app/shared/localDB/adapters/shared_fields_of_study_local_db.dart';

import 'localdb_constants.dart';

class HiveBoxInstances {
  static Box<SharedFieldsOfStudyLocalDB> get sharedFieldsOfStudy =>
      Hive.box<SharedFieldsOfStudyLocalDB>(
        LocalDBConstants.sharedFieldsOfStudy,
      );
  static Box<FieldsOfStudyLocalDB> get fieldsOfStudy =>
      Hive.box<FieldsOfStudyLocalDB>(
        LocalDBConstants.fieldsOfStudy,
      );
  static Box<FieldsOfStudyLocalDB> get studyPlan =>
      Hive.box<FieldsOfStudyLocalDB>(
        LocalDBConstants.studyPlan,
      );
}

import 'package:hive/hive.dart';

import 'localdb_constants.dart';

class HiveBoxInstances {
  static Box get sharedSubjects => Hive.box(LocalDBConstants.sharedSubjects);
  static Box get subjectsWithSubtopics => Hive.box(
        LocalDBConstants.subjectsWithSubtopics,
      );
}

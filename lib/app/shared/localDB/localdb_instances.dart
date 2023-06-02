import 'package:hive/hive.dart';

import '../text_constants/localdb_constants.dart';

class HiveBoxInstances {
  static Box get subjects => Hive.box(LocalDBConstants.subjects);
  static Box get subTopics => Hive.box(LocalDBConstants.studyRoadmap);
}

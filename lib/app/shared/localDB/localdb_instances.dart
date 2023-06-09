import 'package:hive/hive.dart';

import 'localdb_constants.dart';

class HiveBoxInstances {
  static Box get subjects => Hive.box(LocalDBConstants.subjects);
}

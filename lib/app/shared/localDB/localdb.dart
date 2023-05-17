import 'package:hive_flutter/hive_flutter.dart';
import 'package:innominatus_ai/app/core/text_constants/localdb_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDB {
  get(String key, [defaultValue]);
  List<String>? getListString(String key);
  Future put(String key, value);
  Future putAll(Map json);
  Future delete(String key);
}

class PrefsImpl implements LocalDB {
  final SharedPreferences sharedPreferences;

  PrefsImpl(this.sharedPreferences);

  @override
  Future delete(String key) async {
    return await sharedPreferences.remove(key);
  }

  @override
  get(String key, [defaultValue]) {
    return sharedPreferences.get(key);
  }

  @override
  Future put(String key, value) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    }
  }

  @override
  Future putAll(Map json) async {
    return;
  }

  @override
  List<String>? getListString(String key) {
    return sharedPreferences.getStringList(key);
  }
}

class HiveBoxInstances {
  static Box get subjects => Hive.box(LocalDBConstants.subjects);
  static Box get subTopics => Hive.box(LocalDBConstants.studyRoadmap);
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDB {
  get(String key, [defaultValue]);
  Future put(String key, value);
  Future putAll(Map json);
  Future delete(String key);
}

class HiveImpl<A> implements LocalDB {
  final Box<A> box;

  HiveImpl(this.box);

  @override
  Future delete(String key) async {
    return await box.delete(key);
  }

  @override
  get(String key, [defaultValue]) {
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  Future put(String key, value) async {
    return await box.put(key, value);
  }

  @override
  Future putAll(Map json) async {
    return await putAll(json);
  }
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
    return  sharedPreferences.get(key);
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
}

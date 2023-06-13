// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreference;

  static init() async {
    return sharedPreference = await SharedPreferences.getInstance();
  }

  static dynamic getData({
    required String key,
  }) async {
    return sharedPreference!.get(key);
  }

  static Future<dynamic> setData({required String key, required dynamic value}) async {
    if (value is bool) return await sharedPreference!.setBool(key, value);
    if (value is double) return await sharedPreference!.setDouble(key, value);
    if (value is int) return await sharedPreference!.setInt(key, value);
    return await sharedPreference!.setString(key, value);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreference!.remove(key);
  }
}

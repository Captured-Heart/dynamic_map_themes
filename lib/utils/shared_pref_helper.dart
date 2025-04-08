import 'package:dynamic_map_themes/core/constants/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedKeys {
  myAddress,
  lat,
  long,
  myPosition,
  mapStyle,
  prevMapStyle,
  isOffline,
}

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences instance
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Set methods
  static Future<void> setString({required String key, required String value}) async {
    'key: $key, value: $value'.logError(name: 'setString sharedPref');
    await _preferences?.setString(key, value);
  }

  static Future<void> setBool({required String key, required bool value}) async {
    'key: $key, value: $value'.logError(name: 'setBool sharedPref');
    await _preferences?.setBool(key, value);
  }

  static Future<void> setDouble({required String key, required double value}) async {
    'key: $key, value: $value'.logError(name: 'setDouble sharedPref');
    await _preferences?.setDouble(key, value);
  }

  // Get methods
  static String? getString({required String key}) {
    return _preferences?.getString(key);
  }

  static double? getDouble({required String key}) {
    return _preferences?.getDouble(key);
  }

  // Remove methods
  static Future<void> remove({required String key}) async {
    ' key: $key'.logError(name: 'remove sharedPref');

    await _preferences?.remove(key);
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    await _preferences?.clear();
  }
}

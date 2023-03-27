import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_wave/core/domain/app_preferences.dart';

class AppPreferencesImpl extends AppPreferences {
  late final Future<SharedPreferences> _prefsFuture;

  AppPreferencesImpl() {
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Future<bool> getForceDarkMode() async {
    final prefs = await _prefs;
    final forceDarkMode = prefs.getBool(AppPreferences.forceDarkModeKey);
    return forceDarkMode ?? false;
  }

  @override
  Future<void> setForceDarkMode(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(AppPreferences.forceDarkModeKey, value);
  }

  Future<SharedPreferences> get _prefs async => await _prefsFuture;
}

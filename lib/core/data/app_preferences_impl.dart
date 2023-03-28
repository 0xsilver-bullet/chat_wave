import 'package:chat_wave/core/domain/model/user_info.dart';
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

  @override
  Future<UserInfo?> getUserInfo() async {
    final prefs = await _prefs;
    final hasUserInfo = prefs.getBool(AppPreferences.hasUserInfoKey) ?? false;
    if (!hasUserInfo) {
      return null;
    }
    final userId = prefs.getInt(AppPreferences.userIdKey)!;
    final userName = prefs.getString(AppPreferences.userNameKey)!;
    final username = prefs.getString(AppPreferences.usernameKey)!;
    final userProfilePicUrl = prefs.getString(AppPreferences.userProfilePicKey);
    return UserInfo(
      name: userName,
      username: username,
      profilePicUrl: userProfilePicUrl,
      id: userId,
    );
  }

  @override
  Future<void> saveUserInfo(UserInfo userInfo) async {
    final prefs = await _prefs;
    await prefs.setInt(AppPreferences.userIdKey, userInfo.id);
    await prefs.setString(AppPreferences.userNameKey, userInfo.name);
    await prefs.setString(AppPreferences.usernameKey, userInfo.username);
    if (userInfo.profilePicUrl != null) {
      await prefs.setString(
          AppPreferences.userProfilePicKey, userInfo.profilePicUrl!);
    }
    await prefs.setBool(AppPreferences.hasUserInfoKey, true);
  }

  @override
  Future<int?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getInt(AppPreferences.userIdKey);
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}

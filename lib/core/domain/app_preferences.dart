import 'package:chat_wave/core/domain/model/user_info.dart';

abstract class AppPreferences {
  static const forceDarkModeKey = 'force_dark_mode_key';

  static const hasUserInfoKey = 'has_user_info_key';
  static const userIdKey = 'user_id_key';
  static const userNameKey = 'user_name_key';
  static const usernameKey = 'username_key';
  static const userProfilePicKey = 'user_profile_pic_key';

  Future<void> setForceDarkMode(bool value);

  Future<bool> getForceDarkMode();

  Future<void> saveUserInfo(UserInfo userInfo);

  Future<UserInfo?> getUserInfo();

  Future<int?> getUserId();

  Future<void> clear();
}

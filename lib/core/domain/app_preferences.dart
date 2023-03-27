abstract class AppPreferences {
  static const forceDarkModeKey = 'force_dark_mode_key';

  Future<void> setForceDarkMode(bool value);

  Future<bool> getForceDarkMode();
}

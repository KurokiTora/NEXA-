import 'package:shared_preferences/shared_preferences.dart';

/// SMALL, NON-SENSITIVE app settings only (flags, UI preferences).
///
/// Tokens, passwords and other credentials are forbidden here ->
/// they live in SecureTokenStorage.
class SettingsStorage {
  SettingsStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _rememberMeKey = 'remember_me';

  static Future<SettingsStorage> create() async =>
      SettingsStorage(await SharedPreferences.getInstance());

  /// "Remember me" checkbox on the login page.
  bool get rememberMe => _prefs.getBool(_rememberMeKey) ?? false;

  Future<void> setRememberMe(bool value) =>
      _prefs.setBool(_rememberMeKey, value);

  Future<void> clear() => _prefs.clear();
}

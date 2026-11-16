import 'package:shared_preferences/shared_preferences.dart';

/// SMALL, NON-SENSITIVE app settings only (flags, UI preferences).
///
/// Tokens, passwords and other credentials are forbidden here ->
/// they live in SecureTokenStorage.
class SettingsStorage {
  SettingsStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _rememberMeKey = 'remember_me';
  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _serverBaseUrlKey = 'server_base_url';

  static Future<SettingsStorage> create() async =>
      SettingsStorage(await SharedPreferences.getInstance());

  /// "Remember me" checkbox on the login page.
  bool get rememberMe => _prefs.getBool(_rememberMeKey) ?? false;

  Future<void> setRememberMe(bool value) =>
      _prefs.setBool(_rememberMeKey, value);

  /// Class reminders + new feedback alerts. Defaults to on, but the OS
  /// permission still has to be granted (requested on first launch).
  bool get notificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? true;

  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(_notificationsEnabledKey, value);

  /// Dev-only: backend address typed by the user (e.g. "192.168.1.10:3000")
  /// so a phone on Wi-Fi can reach the PC without a USB cable or a rebuild.
  /// Null / empty means "use the built-in candidates".
  String? get serverBaseUrl {
    final value = _prefs.getString(_serverBaseUrlKey);
    return (value == null || value.isEmpty) ? null : value;
  }

  Future<void> setServerBaseUrl(String? value) async {
    if (value == null || value.isEmpty) {
      await _prefs.remove(_serverBaseUrlKey);
    } else {
      await _prefs.setString(_serverBaseUrlKey, value);
    }
  }

  Future<void> clear() => _prefs.clear();
}

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SECRETS ONLY: access token + refresh token (and any future credential).
///
/// Backed by Android Keystore / iOS Keychain via flutter_secure_storage.
/// Never put these in SharedPreferences or in the Drift database.
///
/// Keep the FlutterSecureStorage options stable between app releases
/// (changing cipher/options can make old values unreadable). If a value
/// ever can't be decrypted we wipe it and treat the user as logged out,
/// instead of crashing the app on startup.
class SecureTokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessKey = 'nexa_access_token';
  static const _refreshKey = 'nexa_refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  Future<String?> readAccessToken() => _safeRead(_accessKey);

  Future<String?> readRefreshToken() => _safeRead(_refreshKey);

  Future<bool> hasSession() async => (await readAccessToken()) != null;

  Future<void> clear() async {
    try {
      await _storage.delete(key: _accessKey);
      await _storage.delete(key: _refreshKey);
    } on PlatformException {
      await _wipe();
    }
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      // Corrupted / undecryptable entry (e.g. after a restore from backup).
      await _wipe();
      return null;
    }
  }

  Future<void> _wipe() async {
    try {
      await _storage.deleteAll();
    } on PlatformException {
      // Nothing more we can do; caller already treats this as "no session".
    }
  }
}

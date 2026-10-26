import 'package:flutter/foundation.dart';

import '../core/storage/secure_token_storage.dart';
import '../core/storage/settings_storage.dart';
import '../data/remote/nexa_api.dart';
import '../data/repositories/nexa_repository.dart';

enum AuthStatus { loggedOut, loggedIn }

/// GLOBAL login status. Splash, Login, Dashboard (logout) and the sync error
/// handling all read/change it, so they always agree on who is signed in.
///
/// Where each kind of data lives:
///   tokens   -> SecureTokenStorage (flutter_secure_storage)
///   settings -> SettingsStorage    (shared_preferences)
///   courses  -> Drift database     (via NexaRepository)
class AuthState extends ChangeNotifier {
  AuthState({
    required NexaApi api,
    required SecureTokenStorage tokens,
    required SettingsStorage settings,
    required NexaRepository repository,
  })  : _api = api,
        _tokens = tokens,
        _settings = settings,
        _repository = repository;

  final NexaApi _api;
  final SecureTokenStorage _tokens;
  final SettingsStorage _settings;
  final NexaRepository _repository;

  AuthStatus _status = AuthStatus.loggedOut;

  AuthStatus get status => _status;
  bool get isLoggedIn => _status == AuthStatus.loggedIn;

  /// Value of the "Remember me" checkbox from the last login.
  bool get rememberMe => _settings.rememberMe;

  /// Call once at app start, before showing the first screen.
  ///
  /// A saved session is only restored when the user ticked "Remember me";
  /// otherwise the leftover token and cached data are discarded.
  Future<void> restore() async {
    final hasSession = await _tokens.hasSession();
    if (hasSession && _settings.rememberMe) {
      _status = AuthStatus.loggedIn;
    } else {
      if (hasSession) {
        await _tokens.clear();
        await _repository.clearLocalData();
      }
      _status = AuthStatus.loggedOut;
    }
    notifyListeners();
  }

  /// Throws AuthFailure (wrong credentials) or NetworkFailure/ServerFailure.
  Future<void> login({
    required String nim,
    required String password,
    required bool rememberMe,
  }) async {
    final session = await _api.login(nim: nim, password: password);

    // Never leave a previous account's data around.
    await _repository.clearLocalData();
    await _tokens.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    await _settings.setRememberMe(rememberMe);

    _status = AuthStatus.loggedIn;
    notifyListeners();
  }

  Future<void> logout() async {
    await _tokens.clear();
    await _repository.clearLocalData();
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }
}

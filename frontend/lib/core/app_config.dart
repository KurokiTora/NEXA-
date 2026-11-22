import 'package:flutter/foundation.dart';

/// Central place for environment switches.
class AppConfig {
  AppConfig._();

  /// true  -> MockNexaApi (built-in sample data, no backend needed)
  /// false -> HttpNexaApi talking to one of [baseUrls]
  ///
  /// The real backend is the default now. To keep using the built-in sample
  /// data run:
  ///
  ///   flutter run --dart-define=NEXA_USE_MOCK=true
  static const bool useMockApi = bool.fromEnvironment(
    'NEXA_USE_MOCK',
    defaultValue: false,
  );

  /// Mock only: make every request fail with NetworkFailure so you can
  /// demo/test the offline behaviour (cached data must still show).
  static const bool mockSimulateOffline = false;

  /// Optional override, e.g. a real phone on the same Wi-Fi as the dev PC:
  ///
  ///   flutter run --dart-define=NEXA_API_BASE_URL=http://192.168.1.10:3000
  static const String _baseUrlOverride = String.fromEnvironment(
    'NEXA_API_BASE_URL',
  );

  /// Candidate base URLs, tried in order until one answers.
  ///
  /// Android:
  ///  * `127.0.0.1` works for a USB phone (or emulator) after
  ///    `adb reverse tcp:3000 tcp:3000`
  ///  * `10.0.2.2` is the host machine as seen from the stock emulator
  ///
  /// Other platforms use localhost.
  ///
  /// A physical phone on Wi-Fi should use the server address saved from the
  /// login page ("Server" button), which takes priority over this list.
  static List<String> get baseUrls {
    if (_baseUrlOverride.isNotEmpty) return [_baseUrlOverride];
    if (kIsWeb) return const ['http://localhost:3000'];
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const ['http://127.0.0.1:3000', 'http://10.0.2.2:3000'];
    }
    return const ['http://localhost:3000', 'http://127.0.0.1:3000'];
  }

  /// Default backend port. Appended automatically, so a user who only types
  /// "10.200.179.74" still reaches the API instead of hitting Apache on :80.
  static const int defaultPort = 3000;

  /// Normalises a server address typed by the user:
  ///   "192.168.1.10"      -> "http://192.168.1.10:3000"
  ///   "192.168.1.10:3000" -> "http://192.168.1.10:3000"
  /// Returns null when [raw] is empty or not a usable http(s) address.
  static String? normalizeBaseUrl(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;

    final withScheme = value.contains('://') ? value : 'http://$value';
    final uri = Uri.tryParse(withScheme);
    if (uri == null || uri.host.isEmpty) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;

    final port = uri.hasPort ? uri.port : defaultPort;
    return '${uri.scheme}://${uri.host}:$port';
  }

  /// Host part shown in the UI, e.g. "10.200.179.74:3000".
  static String displayHost(String baseUrl) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.host.isEmpty) return baseUrl;
    return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
  }

  /// First/default base URL. Kept for callers that only need one value.
  static String get baseUrl => baseUrls.first;

  /// Cached data older than this is refreshed when a screen opens.
  static const Duration cacheTtl = Duration(minutes: 15);

  static const Duration requestTimeout = Duration(seconds: 15);

  /// Chatbot requests wait for the backend -> Groq round trip, so they need a
  /// much longer budget than a normal data request.
  static const Duration chatTimeout = Duration(seconds: 45);

  /// Short timeout used while probing the fallback candidates, so a wrong
  /// address fails in seconds instead of 15s per candidate.
  static const Duration probeTimeout = Duration(seconds: 5);
}

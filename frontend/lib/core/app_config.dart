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
  /// A physical phone on a different Wi-Fi network cannot reach the PC's LAN
  /// IP. Either use the USB reverse command above, or pass the PC's LAN IP
  /// with --dart-define when both devices share the same Wi-Fi.
  static List<String> get baseUrls {
    if (_baseUrlOverride.isNotEmpty) return [_baseUrlOverride];
    if (kIsWeb) return const ['http://localhost:3000'];
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const ['http://127.0.0.1:3000', 'http://10.0.2.2:3000'];
    }
    return const ['http://localhost:3000', 'http://127.0.0.1:3000'];
  }

  /// First/default base URL. Kept for callers that only need one value.
  static String get baseUrl => baseUrls.first;

  /// Cached data older than this is refreshed when a screen opens.
  static const Duration cacheTtl = Duration(minutes: 15);

  static const Duration requestTimeout = Duration(seconds: 15);
}

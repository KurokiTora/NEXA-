/// Central place for environment switches.
class AppConfig {
  AppConfig._();

  /// true  -> MockNexaApi (built-in sample data, no backend needed)
  /// false -> HttpNexaApi talking to [baseUrl]
  ///
  /// Defaults to mock because this branch (NEXA-) does not ship a backend
  /// yet. To run against the real API:
  ///
  ///   flutter run \
  ///     --dart-define=NEXA_USE_MOCK=false \
  ///     --dart-define=NEXA_API_BASE_URL=http://192.168.1.10:3000
  static const bool useMockApi =
      bool.fromEnvironment('NEXA_USE_MOCK', defaultValue: true);

  /// Mock only: make every request fail with NetworkFailure so you can
  /// demo/test the offline behaviour (cached data must still show).
  static const bool mockSimulateOffline = false;

  /// 10.0.2.2 = the host PC from an Android emulator. On a real phone pass
  /// your PC's LAN IP with `--dart-define=NEXA_API_BASE_URL=http://<ip>:3000`
  static const String baseUrl = String.fromEnvironment(
    'NEXA_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  /// Cached data older than this is refreshed when a screen opens.
  static const Duration cacheTtl = Duration(minutes: 15);

  static const Duration requestTimeout = Duration(seconds: 15);
}

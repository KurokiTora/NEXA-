import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_config.dart';
import 'core/services/nexa_notification_service.dart';
import 'core/storage/secure_token_storage.dart';
import 'core/storage/settings_storage.dart';
import 'data/local/app_database.dart';
import 'data/local/nexa_local_data_source.dart';
import 'data/models/course.dart';
import 'data/models/student.dart';
import 'data/remote/http_nexa_api.dart';
import 'data/remote/mock_nexa_api.dart';
import 'data/remote/nexa_api.dart';
import 'data/repositories/nexa_repository.dart';
import 'page/feedback_detail.dart';
import 'page/splash.dart';
import 'state/auth_state.dart';
import 'state/sync_state.dart';

/// Lets a tapped notification open the relevant screen from anywhere.
final navigatorKey = GlobalKey<NavigatorState>();

void _openNotification(String? payload) {
  if (payload == null) return;
  if (payload.startsWith('feedback:')) {
    final courseId = int.tryParse(payload.substring('feedback:'.length));
    if (courseId == null) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => FeedbackDetailPage(courseId: courseId),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Composition root: build the data layer once and share it app-wide.
  //   settings -> shared_preferences   (non-sensitive flags)
  //   tokens   -> flutter_secure_storage (secrets)
  //   database -> Drift / SQLite        (cached backend data)
  final settings = await SettingsStorage.create();
  final tokens = SecureTokenStorage();
  final database = AppDatabase();

  final NexaApi api = AppConfig.useMockApi
      ? MockNexaApi(simulateOffline: AppConfig.mockSimulateOffline)
      : HttpNexaApi(
          baseUrls: AppConfig.baseUrls,
          timeout: AppConfig.requestTimeout,
        );

  final repository = NexaRepository(
    api: api,
    local: NexaLocalDataSource(database),
    tokens: tokens,
  );

  final notifications = NexaNotificationService(settings: settings);
  try {
    await notifications.initialize(onSelect: _openNotification);
  } catch (_) {
    // Notifications are optional; never block the app on plugin setup.
  }

  final auth = AuthState(
    api: api,
    tokens: tokens,
    settings: settings,
    repository: repository,
  );
  await auth.restore(); // decides Login vs Dashboard before the first frame

  // Ask for the OS permission once a user is signed in, then (re)register
  // reminders for the schedules already cached on the device.
  if (auth.isLoggedIn && notifications.enabled) {
    try {
      await notifications.requestPermission();
      await notifications.syncClassReminders(await repository.schedules());
    } catch (_) {
      // Permission denied or scheduling unsupported -> keep using the app.
    }
  }

  final sync = SyncState(repository, notifications: notifications);

  runApp(
    MultiProvider(
      providers: [
        Provider<NexaRepository>.value(value: repository),
        Provider<NexaNotificationService>.value(value: notifications),
        ChangeNotifierProvider<AuthState>.value(value: auth),
        ChangeNotifierProvider<SyncState>.value(value: sync),
        // Live views of the local database: every screen that watches these
        // rebuilds by itself the moment a sync writes new data.
        StreamProvider<Student?>(
          create: (_) => repository.watchStudent(),
          initialData: null,
        ),
        StreamProvider<List<Course>>(
          create: (_) => repository.watchCourses(),
          initialData: const [],
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'NEXA',
      theme: ThemeData(
        useMaterial3: true,
        // A calm fade-through instead of the default zoom keeps pushes to
        // detail pages from feeling heavy/janky on older devices.
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_config.dart';
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
import 'page/splash.dart';
import 'state/auth_state.dart';
import 'state/sync_state.dart';

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
          baseUrl: AppConfig.baseUrl,
          timeout: AppConfig.requestTimeout,
        );

  final repository = NexaRepository(
    api: api,
    local: NexaLocalDataSource(database),
    tokens: tokens,
  );

  final auth = AuthState(
    api: api,
    tokens: tokens,
    settings: settings,
    repository: repository,
  );
  await auth.restore(); // decides Login vs Dashboard before the first frame

  runApp(
    MultiProvider(
      providers: [
        Provider<NexaRepository>.value(value: repository),
        ChangeNotifierProvider<AuthState>.value(value: auth),
        ChangeNotifierProvider<SyncState>(create: (_) => SyncState(repository)),
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
      debugShowCheckedModeBanner: false,
      title: 'NEXA',
      theme: ThemeData(useMaterial3: true),
      home: const SplashPage(),
    );
  }
}

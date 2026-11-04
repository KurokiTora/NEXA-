import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/class_schedule.dart';
import '../../data/models/feedback_alert.dart';
import '../storage/settings_storage.dart';

/// Handles all local notifications for NEXA:
///  - Reminders before class starts (e.g. 30 minutes before)
///  - Alerts when new lecturer feedback appears
class NexaNotificationService {
  NexaNotificationService({required SettingsStorage settings})
      : _settings = settings;

  final SettingsStorage _settings;
  final _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  void Function(String? payload)? _onSelect;

  static const _classChannelId = 'nexa_class_reminders';
  static const _classChannelName = 'Class Reminders';
  static const _classChannelDesc = 'Reminders for upcoming classes';

  static const _feedbackChannelId = 'nexa_feedback';
  static const _feedbackChannelName = 'Feedback Alerts';
  static const _feedbackChannelDesc =
      'Notifications when new lecturer feedback is available';

  /// Whether the user wants notifications (stored preference).
  bool get enabled => _settings.notificationsEnabled;

  /// Call once at app start (after WidgetsFlutterBinding.ensureInitialized()).
  Future<void> initialize({void Function(String? payload)? onSelect}) async {
    _onSelect = onSelect ?? _onSelect;
    if (_initialized || kIsWeb) return;

    tz.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Don't prompt during initialization; [requestPermission] does that.
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const linux = LinuxInitializationSettings(defaultActionName: 'Open NEXA');
    const windows = WindowsInitializationSettings(
      appName: 'NEXA',
      appUserModelId: 'com.example.mobile.NEXA',
      guid: '7f3a6d42-9b82-4e01-b7c1-8a90265ed471',
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
        linux: linux,
        windows: windows,
      ),
      onDidReceiveNotificationResponse: (response) {
        _onSelect?.call(response.payload);
      },
    );

    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }

    _initialized = true;
  }

  Future<void> _createAndroidChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _classChannelId,
        _classChannelName,
        description: _classChannelDesc,
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _feedbackChannelId,
        _feedbackChannelName,
        description: _feedbackChannelDesc,
        importance: Importance.high,
      ),
    );
  }

  /// Persist the user's choice and immediately apply it.
  /// Returns the OS permission state when enabling.
  Future<bool> setEnabled(bool value) async {
    await _settings.setNotificationsEnabled(value);
    if (!value) {
      await cancelAll();
      return false;
    }

    if (!_initialized) await initialize();
    return requestPermission();
  }

  /// Ask for runtime notification permission (Android 13+, iOS).
  Future<bool> requestPermission() async {
    if (kIsWeb) return true;
    if (!_initialized) await initialize();

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? true;
    }

    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? true;
    }

    if (Platform.isMacOS) {
      final macos = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      final granted = await macos?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? true;
    }

    return true;
  }

  /// Schedule weekly reminders for the given schedules. Old pending reminders
  /// are cancelled first so re-syncing doesn't create duplicates.
  Future<void> syncClassReminders(
    List<ClassSchedule> schedules, {
    int minutesBefore = 30,
  }) async {
    if (!enabled || kIsWeb || !_initialized) return;

    await _plugin.cancelAllPendingNotifications();

    for (final s in schedules) {
      var when = s.nextReminder(minutesBefore: minutesBefore);
      if (!when.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
        when = s.nextReminder(
          from: DateTime.now().add(const Duration(days: 7)),
          minutesBefore: minutesBefore,
        );
        if (!when.isAfter(DateTime.now())) continue;
      }
      await _scheduleClassReminder(s, when, minutesBefore);
    }
  }

  Future<void> _scheduleClassReminder(
    ClassSchedule s,
    DateTime when,
    int minutesBefore,
  ) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _classChannelId,
        _classChannelName,
        channelDescription: _classChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'NEXA',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final body = minutesBefore == 0
        ? 'Kelas ${s.courseName} dimulai sekarang di ${s.room}.'
        : 'Kelas ${s.courseName} dimulai dalam $minutesBefore menit '
            'di ${s.room}. (${s.startLabel})';

    await _plugin.zonedSchedule(
      id: _classReminderId(s),
      title: 'Pengingat Jadwal Kelas',
      body: body,
      scheduledDate: tz.TZDateTime.from(when, tz.local),
      notificationDetails: details,
      // inexact avoids requiring the SCHEDULE_EXACT_ALARM permission while
      // still allowing the notification while the phone is idle.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Repeats every week at the same time.
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'class:${s.courseId}:${s.id}',
    );
  }

  int _classReminderId(ClassSchedule s) =>
      100000 + (s.courseId * 500 + s.id % 500);

  /// Show a notification for each newly added feedback note.
  Future<void> notifyNewFeedback(List<FeedbackAlert> alerts) async {
    if (!enabled || kIsWeb || !_initialized || alerts.isEmpty) return;

    for (final a in alerts) {
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _feedbackChannelId,
          _feedbackChannelName,
          channelDescription: _feedbackChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _plugin.show(
        id: _feedbackId(a),
        title: 'Feedback baru: ${a.courseName}',
        body: a.note.title,
        notificationDetails: details,
        payload: 'feedback:${a.courseId}',
      );
    }
  }

  int _feedbackId(FeedbackAlert a) {
    // Deterministic id, so a repeated call replaces instead of duplicating.
    final h = a.signature.hashCode & 0x7fffffff;
    return 200000 + (h % 100000);
  }

  /// Remove pending reminders and any notification already shown.
  Future<void> cancelAll() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
  }
}

import 'package:flutter/foundation.dart';

import '../core/errors.dart';
import '../core/services/nexa_notification_service.dart';
import '../data/models/class_schedule.dart';
import '../data/repositories/nexa_repository.dart';

/// Global "is the app syncing with the backend right now?" state.
/// The data itself is NOT held here: screens read it from Drift streams.
class SyncState extends ChangeNotifier {
  SyncState(this._repository, {NexaNotificationService? notifications})
      : _notifications = notifications;

  final NexaRepository _repository;
  final NexaNotificationService? _notifications;

  bool _isRefreshing = false;
  NexaException? _lastError;

  bool get isRefreshing => _isRefreshing;
  NexaException? get lastError => _lastError;

  /// Pull fresh data from the backend into the local database.
  /// Returns the failure (also kept in [lastError]) or null on success.
  Future<NexaException?> refresh() async {
    if (_isRefreshing) return null;
    _isRefreshing = true;
    _lastError = null;
    notifyListeners();

    try {
      // Remember which feedback notes we already had, so after the fetch we
      // can notify only for genuinely new ones. On the very first sync the
      // cache is empty -> don't notify for the entire history.
      final hadCache = await _repository.hasCachedCourses();
      final seenSignatures =
          hadCache ? await _repository.feedbackSignatures() : <String>{};

      await _repository.refresh();

      if (hadCache) {
        try {
          final alerts = await _repository.feedbackAlertsNotIn(seenSignatures);
          await _notifications?.notifyNewFeedback(alerts);
        } catch (_) {
          // A notification failure must never break syncing.
        }
      }
      await syncClassReminders();
      return null;
    } on NexaException catch (e) {
      _lastError = e;
      return e;
    } catch (e) {
      final failure = ServerFailure(e.toString());
      _lastError = failure;
      return failure;
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Only hits the network when the cache is empty or older than the TTL.
  Future<NexaException?> refreshIfStale() async {
    if (_isRefreshing) return null;
    if (!await _repository.isCacheStale()) return null;
    return refresh();
  }

  /// Re-register class reminders from the schedules already in the cache.
  /// Safe to call on app start and whenever the user enables notifications.
  Future<void> syncClassReminders() async {
    try {
      final schedules = await _repository.schedules();
      await _notifications?.syncClassReminders(schedules);
    } catch (_) {
      // Scheduling is best-effort.
    }
  }

  /// Exposed for tests / callers that want to know whether anything is cached.
  Future<List<ClassSchedule>> cachedSchedules() => _repository.schedules();
}

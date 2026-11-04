import '../../core/app_config.dart';
import '../../core/errors.dart';
import '../../core/storage/secure_token_storage.dart';
import '../local/mappers.dart';
import '../local/nexa_local_data_source.dart';
import '../models/class_schedule.dart';
import '../models/course.dart';
import '../models/course_details.dart';
import '../models/feedback_alert.dart';
import '../models/student.dart';
import '../remote/nexa_api.dart';

/// Single source of truth for the UI (offline-first):
///
///   UI  <--Stream--  Drift (SQLite)  <--write--  API
///
/// The UI only ever READS from the local database. The network is used by
/// [refresh], which writes the response into the database; the streams then
/// push the new data to every screen automatically.
class NexaRepository {
  NexaRepository({
    required NexaApi api,
    required NexaLocalDataSource local,
    required SecureTokenStorage tokens,
    Duration cacheTtl = AppConfig.cacheTtl,
  })  : _api = api,
        _local = local,
        _tokens = tokens,
        _cacheTtl = cacheTtl;

  final NexaApi _api;
  final NexaLocalDataSource _local;
  final SecureTokenStorage _tokens;
  final Duration _cacheTtl;

  // ------------------------------ reactive reads -----------------------------

  Stream<Student?> watchStudent() =>
      _local.watchStudent().map((row) => row?.toModel());

  Stream<List<Course>> watchCourses() => _local
      .watchCourses()
      .map((rows) => rows.map((r) => r.toModel()).toList());

  Stream<Course?> watchCourse(int id) =>
      _local.watchCourse(id).map((row) => row?.toModel());

  Stream<List<Assessment>> watchAssessments(int courseId) => _local
      .watchAssessments(courseId)
      .map((rows) => rows.map((r) => r.toModel()).toList());

  Stream<List<AttendanceLog>> watchAttendance(int courseId) => _local
      .watchAttendance(courseId)
      .map((rows) => rows.map((r) => r.toModel()).toList());

  Stream<List<FeedbackNote>> watchFeedback(int courseId) => _local
      .watchFeedback(courseId)
      .map((rows) => rows.map((r) => r.toModel()).toList());

  Stream<List<ClassSchedule>> watchSchedules() => _local
      .watchAllSchedules()
      .map((rows) => rows.map((r) => r.toModel()).toList());

  /// One-shot read used by the notification scheduler.
  Future<List<ClassSchedule>> schedules() async {
    final rows = await _local.getAllSchedules();
    return rows.map((r) => r.toModel()).toList();
  }

  // ------------------------- feedback change detection -----------------------

  /// True when there is already cached data. On the very first sync every
  /// feedback note is "new", but we don't want to spam the user with
  /// notifications for the whole history.
  Future<bool> hasCachedCourses() async {
    final rows = await _local.getAllCourses();
    return rows.isNotEmpty;
  }

  Future<Set<String>> feedbackSignatures() async {
    final rows = await _local.getAllFeedback();
    return {
      for (final r in rows)
        FeedbackAlert.signatureFor(r.courseId, r.title, r.body),
    };
  }

  /// Feedback rows that were not present in [knownSignatures].
  Future<List<FeedbackAlert>> feedbackAlertsNotIn(
    Set<String> knownSignatures,
  ) async {
    final feedbackRows = await _local.getAllFeedback();
    final courseRows = await _local.getAllCourses();
    final names = {for (final c in courseRows) c.id: c.name};

    final alerts = <FeedbackAlert>[];
    for (final row in feedbackRows) {
      final alert =
          row.toAlert(names[row.courseId] ?? 'Mata Kuliah');
      if (!knownSignatures.contains(alert.signature)) {
        alerts.add(alert);
      }
    }
    return alerts;
  }

  // --------------------------------- syncing ---------------------------------

  int _nowMillis() => DateTime.now().toUtc().millisecondsSinceEpoch;

  /// True when nothing is cached or the oldest `last_fetched` is older than
  /// the TTL.
  Future<bool> isCacheStale() async {
    final oldest = await _local.oldestFetchedMillis();
    if (oldest == null) return true;
    return _nowMillis() - oldest > _cacheTtl.inMilliseconds;
  }

  /// Download everything and replace the cache in one transaction.
  /// Throws NexaException subclasses; the existing cache is untouched on error.
  Future<void> refresh() async {
    final snapshot = await _fetchWithTokenRefresh();
    await _local.saveSnapshot(
      student: snapshot.student,
      courses: snapshot.courses,
      fetchedAtMillis: _nowMillis(),
    );
  }

  Future<RemoteSnapshot> _fetchWithTokenRefresh() async {
    final access = await _tokens.readAccessToken();
    if (access == null) throw const UnauthorizedFailure();

    try {
      return await _api.fetchSnapshot(access);
    } on UnauthorizedFailure {
      final refreshToken = await _tokens.readRefreshToken();
      if (refreshToken == null) rethrow;

      try {
        final session = await _api.refreshSession(refreshToken);
        await _tokens.saveTokens(
          accessToken: session.accessToken,
          refreshToken: session.refreshToken,
        );
        return await _api.fetchSnapshot(session.accessToken);
      } on AuthFailure {
        throw const UnauthorizedFailure();
      }
    }
  }

  /// Wipe cached data (logout / account switch).
  Future<void> clearLocalData() => _local.clearAll();
}

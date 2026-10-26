import 'package:drift/drift.dart';

import '../models/course.dart';
import '../models/student.dart';
import 'app_database.dart';

/// All SQLite access lives here. Reads are Streams (.watch()) so the UI
/// redraws by itself whenever a write below commits.
class NexaLocalDataSource {
  NexaLocalDataSource(this._db);

  final AppDatabase _db;

  // ----------------------------- reactive reads -----------------------------

  Stream<StudentRow?> watchStudent() =>
      (_db.select(_db.students)..limit(1)).watchSingleOrNull();

  Stream<List<CourseRow>> watchCourses() => (_db.select(_db.courses)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .watch();

  Stream<CourseRow?> watchCourse(int id) =>
      (_db.select(_db.courses)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

  Stream<List<AssessmentRow>> watchAssessments(int courseId) =>
      (_db.select(_db.assessments)
            ..where((t) => t.courseId.equals(courseId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .watch();

  Stream<List<AttendanceRow>> watchAttendance(int courseId) =>
      (_db.select(_db.attendanceLogs)
            ..where((t) => t.courseId.equals(courseId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .watch();

  Stream<List<FeedbackRow>> watchFeedback(int courseId) =>
      (_db.select(_db.feedbackNotes)
            ..where((t) => t.courseId.equals(courseId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .watch();

  // ------------------------------ cache metadata ----------------------------

  /// `last_fetched` (UTC millis) of the oldest cached course, or null when
  /// nothing is cached yet.
  Future<int?> oldestFetchedMillis() async {
    final row = await (_db.select(_db.courses)
          ..orderBy([(t) => OrderingTerm.asc(t.lastFetched)])
          ..limit(1))
        .getSingleOrNull();
    return row?.lastFetched;
  }

  // --------------------------------- writes ---------------------------------

  /// Replaces the whole cache with a fresh server response, ATOMICALLY.
  ///
  /// Everything below runs in one transaction: if any insert fails, SQLite
  /// rolls back and the previous cache stays intact (no half-written data).
  /// Stream listeners are notified once, after the commit.
  Future<void> saveSnapshot({
    required Student student,
    required List<CourseBundle> courses,
    required int fetchedAtMillis,
  }) {
    return _db.transaction(() async {
      await _db.delete(_db.students).go();
      await _db.into(_db.students).insert(
            StudentsCompanion.insert(
              nim: student.nim,
              name: student.name,
              sksSemester: student.sksSemester,
              sksTotal: student.sksTotal,
              ipSemester: student.ipSemester,
              ipCumulative: student.ipCumulative,
              lastFetched: fetchedAtMillis,
            ),
          );

      // Detail rows are always rebuilt from the fresh response.
      await _db.delete(_db.assessments).go();
      await _db.delete(_db.attendanceLogs).go();
      await _db.delete(_db.feedbackNotes).go();

      final ids = courses.map((b) => b.course.id).toList();
      if (ids.isEmpty) {
        await _db.delete(_db.courses).go();
        return;
      }
      // Courses that disappeared on the server.
      await (_db.delete(_db.courses)..where((t) => t.id.isNotIn(ids))).go();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(_db.courses, [
          for (final b in courses)
            CoursesCompanion.insert(
              id: Value(b.course.id),
              name: b.course.name,
              code: b.course.code,
              colorIndex: b.course.colorIndex,
              grade: b.course.grade,
              letter: b.course.letter,
              taskScore: b.course.taskScore,
              attendScore: b.course.attendScore,
              utsScore: b.course.utsScore,
              uasScore: b.course.uasScore,
              attendPercent: b.course.attendPercent,
              attendCount: b.course.attendCount,
              permitCount: b.course.permitCount,
              sickCount: b.course.sickCount,
              alphaCount: b.course.alphaCount,
              lastFetched: fetchedAtMillis,
            ),
        ]);

        batch.insertAll(_db.assessments, [
          for (final b in courses)
            for (var i = 0; i < b.assessments.length; i++)
              AssessmentsCompanion.insert(
                courseId: b.course.id,
                title: b.assessments[i].title,
                status: b.assessments[i].status.name,
                score: Value(b.assessments[i].score),
                position: i,
              ),
        ]);

        batch.insertAll(_db.attendanceLogs, [
          for (final b in courses)
            for (var i = 0; i < b.attendance.length; i++)
              AttendanceLogsCompanion.insert(
                courseId: b.course.id,
                title: b.attendance[i].title,
                status: b.attendance[i].status.name,
                position: i,
              ),
        ]);

        batch.insertAll(_db.feedbackNotes, [
          for (final b in courses)
            for (var i = 0; i < b.feedback.length; i++)
              FeedbackNotesCompanion.insert(
                courseId: b.course.id,
                title: b.feedback[i].title,
                body: b.feedback[i].body,
                position: i,
              ),
        ]);
      });
    });
  }

  /// Wipes the cache (logout / switching account).
  Future<void> clearAll() {
    return _db.transaction(() async {
      await _db.delete(_db.assessments).go();
      await _db.delete(_db.attendanceLogs).go();
      await _db.delete(_db.feedbackNotes).go();
      await _db.delete(_db.courses).go();
      await _db.delete(_db.students).go();
    });
  }
}
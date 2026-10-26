import '../models/course.dart';
import '../models/course_details.dart';
import '../models/student.dart';
import 'app_database.dart';

DateTime _fromMillis(int millis) =>
    DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);

/// Drift rows -> plain models, so the UI never imports drift.
extension StudentRowMapper on StudentRow {
  Student toModel() => Student(
        nim: nim,
        name: name,
        sksSemester: sksSemester,
        sksTotal: sksTotal,
        ipSemester: ipSemester,
        ipCumulative: ipCumulative,
        lastFetched: _fromMillis(lastFetched),
      );
}

extension CourseRowMapper on CourseRow {
  Course toModel() => Course(
        id: id,
        name: name,
        code: code,
        colorIndex: colorIndex,
        grade: grade,
        letter: letter,
        taskScore: taskScore,
        attendScore: attendScore,
        utsScore: utsScore,
        uasScore: uasScore,
        attendPercent: attendPercent,
        attendCount: attendCount,
        permitCount: permitCount,
        sickCount: sickCount,
        alphaCount: alphaCount,
        lastFetched: _fromMillis(lastFetched),
      );
}

extension AssessmentRowMapper on AssessmentRow {
  Assessment toModel() => Assessment(
        title: title,
        status: enumFromName(
            AssessmentStatus.values, status, AssessmentStatus.onTime),
        score: score,
      );
}

extension AttendanceRowMapper on AttendanceRow {
  AttendanceLog toModel() => AttendanceLog(
        title: title,
        status: enumFromName(
            AttendanceStatus.values, status, AttendanceStatus.attend),
      );
}

extension FeedbackRowMapper on FeedbackRow {
  FeedbackNote toModel() => FeedbackNote(title: title, body: body);
}

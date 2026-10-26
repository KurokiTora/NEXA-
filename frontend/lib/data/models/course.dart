import 'course_details.dart';

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.code,
    required this.colorIndex,
    required this.grade,
    required this.letter,
    required this.taskScore,
    required this.attendScore,
    required this.utsScore,
    required this.uasScore,
    required this.attendPercent,
    required this.attendCount,
    required this.permitCount,
    required this.sickCount,
    required this.alphaCount,
    this.lastFetched,
  });

  final int id;
  final String name;
  final String code;

  /// Index into the pastel palette (see widgets/course_palette.dart).
  final int colorIndex;
  final int grade;
  final String letter;
  final int taskScore;
  final int attendScore;
  final int utsScore;
  final int uasScore;
  final int attendPercent;
  final int attendCount;
  final int permitCount;
  final int sickCount;
  final int alphaCount;
  final DateTime? lastFetched;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        code: json['code'] as String,
        colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
        grade: (json['grade'] as num).toInt(),
        letter: json['letter'] as String,
        taskScore: (json['taskScore'] as num?)?.toInt() ?? 0,
        attendScore: (json['attendScore'] as num?)?.toInt() ?? 0,
        utsScore: (json['utsScore'] as num?)?.toInt() ?? 0,
        uasScore: (json['uasScore'] as num?)?.toInt() ?? 0,
        attendPercent: (json['attendPercent'] as num?)?.toInt() ?? 0,
        attendCount: (json['attendCount'] as num?)?.toInt() ?? 0,
        permitCount: (json['permitCount'] as num?)?.toInt() ?? 0,
        sickCount: (json['sickCount'] as num?)?.toInt() ?? 0,
        alphaCount: (json['alphaCount'] as num?)?.toInt() ?? 0,
      );
}

/// One course plus its detail lists, exactly as the API returns it.
/// The repository stores these together in a single DB transaction.
class CourseBundle {
  const CourseBundle({
    required this.course,
    required this.assessments,
    required this.attendance,
    required this.feedback,
  });

  final Course course;
  final List<Assessment> assessments;
  final List<AttendanceLog> attendance;
  final List<FeedbackNote> feedback;

  factory CourseBundle.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) parse) =>
        ((json[key] as List?) ?? const [])
            .map((e) => parse(e as Map<String, dynamic>))
            .toList();

    return CourseBundle(
      course: Course.fromJson(json),
      assessments: list('assessments', Assessment.fromJson),
      attendance: list('attendance', AttendanceLog.fromJson),
      feedback: list('feedback', FeedbackNote.fromJson),
    );
  }
}

/// Safely turn a stored/JSON string back into an enum value.
T enumFromName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

enum AssessmentStatus { onTime, late, missing }

enum AttendanceStatus { attend, permit, sick, alpha }

class Assessment {
  const Assessment({required this.title, required this.status, this.score});

  final String title;
  final AssessmentStatus status;

  /// Null when the student didn't submit.
  final int? score;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        title: json['title'] as String,
        status: enumFromName(
            AssessmentStatus.values, json['status'], AssessmentStatus.onTime),
        score: (json['score'] as num?)?.toInt(),
      );
}

class AttendanceLog {
  const AttendanceLog({required this.title, required this.status});

  final String title;
  final AttendanceStatus status;

  factory AttendanceLog.fromJson(Map<String, dynamic> json) => AttendanceLog(
        title: json['title'] as String,
        status: enumFromName(
            AttendanceStatus.values, json['status'], AttendanceStatus.attend),
      );
}

class FeedbackNote {
  const FeedbackNote({required this.title, required this.body});

  final String title;
  final String body;

  factory FeedbackNote.fromJson(Map<String, dynamic> json) => FeedbackNote(
        title: json['title'] as String,
        body: json['body'] as String,
      );
}

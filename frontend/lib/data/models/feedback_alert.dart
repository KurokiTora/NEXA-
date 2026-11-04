import 'course_details.dart';

/// A feedback note that appeared on the server since the last sync.
/// Used to show a system notification on the student's phone.
class FeedbackAlert {
  const FeedbackAlert({
    required this.courseId,
    required this.courseName,
    required this.note,
  });

  final int courseId;
  final String courseName;
  final FeedbackNote note;

  /// Stable identity used to tell "already seen" feedback apart from new one.
  String get signature =>
      signatureFor(courseId, note.title, note.body);

  static String signatureFor(int courseId, String title, String body) =>
      '$courseId|$title|$body';
}

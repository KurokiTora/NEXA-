import 'course.dart';

/// Overall numbers derived from the cached courses. Every screen that shows
/// "EXCELLENT", the average grade or overall attendance reads this, so they
/// all change together the moment the database changes.
class PerformanceSummary {
  const PerformanceSummary({
    required this.hasData,
    required this.averageGrade,
    required this.averageAttendance,
    required this.totalAttend,
    required this.totalPermit,
    required this.totalSick,
    required this.totalAlpha,
  });

  final bool hasData;
  final int averageGrade;
  final int averageAttendance;
  final int totalAttend;
  final int totalPermit;
  final int totalSick;
  final int totalAlpha;

  String get label {
    if (!hasData) return 'NO DATA';
    if (averageGrade >= 85) return 'EXCELLENT';
    if (averageGrade >= 70) return 'GOOD';
    return 'FAIR';
  }

  factory PerformanceSummary.fromCourses(List<Course> courses) {
    if (courses.isEmpty) {
      return const PerformanceSummary(
        hasData: false,
        averageGrade: 0,
        averageAttendance: 0,
        totalAttend: 0,
        totalPermit: 0,
        totalSick: 0,
        totalAlpha: 0,
      );
    }
    int sum(int Function(Course) pick) =>
        courses.fold(0, (total, c) => total + pick(c));

    return PerformanceSummary(
      hasData: true,
      averageGrade: (sum((c) => c.grade) / courses.length).round(),
      averageAttendance: (sum((c) => c.attendPercent) / courses.length).round(),
      totalAttend: sum((c) => c.attendCount),
      totalPermit: sum((c) => c.permitCount),
      totalSick: sum((c) => c.sickCount),
      totalAlpha: sum((c) => c.alphaCount),
    );
  }
}

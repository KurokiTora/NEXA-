import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/course.dart';
import 'package:mobile/data/models/course_details.dart';
import 'package:mobile/data/models/student.dart';

void main() {
  group('CourseBundle.fromJson', () {
    test('parses course fields and nested detail lists', () {
      final bundle = CourseBundle.fromJson({
        'id': 1,
        'name': 'Pemrograman Mobile',
        'code': 'IT301',
        'colorIndex': 2,
        'grade': 88,
        'letter': 'A',
        'taskScore': 80,
        'attendScore': 99,
        'utsScore': 100,
        'uasScore': 99,
        'attendPercent': 99,
        'attendCount': 16,
        'permitCount': 2,
        'sickCount': 1,
        'alphaCount': 0,
        'assessments': [
          {'title': 'Meeting 1 Assignment', 'status': 'onTime', 'score': 80},
        ],
        'attendance': [
          {'title': 'Class Meeting 1', 'status': 'attend'},
        ],
        'feedback': [
          {'title': 'Feedback', 'body': 'Good work.'},
        ],
      });

      expect(bundle.course.name, 'Pemrograman Mobile');
      expect(bundle.course.colorIndex, 2);
      expect(bundle.assessments.single.status, AssessmentStatus.onTime);
      expect(bundle.assessments.single.score, 80);
      expect(bundle.attendance.single.status, AttendanceStatus.attend);
      expect(bundle.feedback.single.body, 'Good work.');
    });

    test('treats missing optional lists as empty', () {
      final bundle = CourseBundle.fromJson({
        'id': 2,
        'name': 'Basis Data',
        'code': 'IT302',
        'grade': 80,
        'letter': 'B+',
      });

      expect(bundle.assessments, isEmpty);
      expect(bundle.attendance, isEmpty);
      expect(bundle.feedback, isEmpty);
      expect(bundle.course.colorIndex, 0);
    });
  });

  test('Student.fromJson parses numbers as int/double', () {
    final student = Student.fromJson({
      'nim': '253100000000',
      'name': 'Nexa User',
      'sksSemester': 24,
      'sksTotal': 500,
      'ipSemester': 3.89,
      'ipCumulative': 3,
    });

    expect(student.sksSemester, 24);
    expect(student.ipSemester, 3.89);
    expect(student.ipCumulative, 3.0);
  });
}

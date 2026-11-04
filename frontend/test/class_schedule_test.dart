import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/class_schedule.dart';
import 'package:mobile/data/models/course.dart';

void main() {
  group('ClassSchedule', () {
    test('parses day and times from JSON', () {
      final schedule = ClassSchedule.fromJson(
        {
          'id': 7,
          'dayOfWeek': 'Senin',
          'start': '08:30',
          'end': '10:10',
          'room': 'Ruang 3.01',
        },
        courseId: 1,
        courseName: 'Pemrograman Mobile',
      );

      expect(schedule.id, 7);
      expect(schedule.dayOfWeek, DateTime.monday);
      expect(schedule.startMinutes, 8 * 60 + 30);
      expect(schedule.endMinutes, 10 * 60 + 10);
      expect(schedule.startLabel, '08:30');
      expect(schedule.endLabel, '10:10');
      expect(schedule.room, 'Ruang 3.01');
    });

    test('nextStart moves to next week when today has already started', () {
      // Monday 2026-11-02, 09:00 -> class at 08:00 is next Monday.
      final schedule = ClassSchedule(
        id: 1,
        courseId: 1,
        courseName: 'Basis Data',
        room: 'R1',
        dayOfWeek: DateTime.monday,
        startMinutes: 8 * 60,
        endMinutes: 9 * 60 + 40,
      );

      final from = DateTime(2026, 11, 2, 9, 0);
      final next = schedule.nextStart(from: from);

      expect(next, DateTime(2026, 11, 9, 8, 0));
    });

    test('nextReminder is 30 minutes before the class', () {
      final schedule = ClassSchedule(
        id: 1,
        courseId: 1,
        courseName: 'Basis Data',
        room: 'R1',
        dayOfWeek: DateTime.tuesday,
        startMinutes: 10 * 60,
        endMinutes: 11 * 60 + 40,
      );

      // Monday -> reminder on Tuesday 09:30.
      final next = schedule.nextReminder(from: DateTime(2026, 11, 2, 12));

      expect(next, DateTime(2026, 11, 3, 9, 30));
    });

    test('nextReminder skips to next week if reminder time already passed', () {
      final schedule = ClassSchedule(
        id: 1,
        courseId: 1,
        courseName: 'Basis Data',
        room: 'R1',
        dayOfWeek: DateTime.monday,
        startMinutes: 8 * 60,
        endMinutes: 9 * 60 + 40,
      );

      // Monday 07:45 -> the 07:30 reminder has passed, so next Monday.
      final next = schedule.nextReminder(from: DateTime(2026, 11, 2, 7, 45));

      expect(next, DateTime(2026, 11, 9, 7, 30));
    });
  });

  test('CourseBundle parses the nested schedule list', () {
    final bundle = CourseBundle.fromJson({
      'id': 3,
      'name': 'Kecerdasan Buatan',
      'code': 'IT303',
      'grade': 88,
      'letter': 'A',
      'schedule': [
        {'dayOfWeek': 3, 'start': '13:00', 'end': '14:40', 'room': 'Lab AI'},
      ],
    });

    expect(bundle.schedules, hasLength(1));
    expect(bundle.schedules.single.courseId, 3);
    expect(bundle.schedules.single.courseName, 'Kecerdasan Buatan');
    expect(bundle.schedules.single.dayOfWeek, DateTime.wednesday);
    expect(bundle.schedules.single.startMinutes, 13 * 60);
  });
}

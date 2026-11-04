/// One weekly class session, used to schedule the "class starts soon"
/// reminder on the student's phone.
///
/// Times are stored as minutes since midnight so they are independent of the
/// device's clock and easy to persist in SQLite.
class ClassSchedule {
  const ClassSchedule({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.room,
    required this.dayOfWeek,
    required this.startMinutes,
    required this.endMinutes,
  });

  /// Stable id from the backend (fallback: courseId * 100 + position).
  final int id;
  final int courseId;
  final String courseName;
  final String room;

  /// DateTime.monday (1) .. DateTime.sunday (7).
  final int dayOfWeek;

  /// Minutes since midnight, e.g. 08:30 = 510.
  final int startMinutes;
  final int endMinutes;

  String get startLabel => _hhmm(startMinutes);
  String get endLabel => _hhmm(endMinutes);

  /// The next time this class starts, in the device's local time.
  DateTime nextStart({DateTime? from}) {
    final now = from ?? DateTime.now();
    var daysAhead = (dayOfWeek - now.weekday) % 7;
    if (daysAhead < 0) daysAhead += 7;

    var candidate = _dateOn(now, daysAhead, startMinutes);
    if (!candidate.isAfter(now)) {
      candidate = _dateOn(now, daysAhead + 7, startMinutes);
    }
    return candidate;
  }

  /// Next reminder time for this class (default: 30 minutes before start).
  /// If the reminder time has already passed today, it moves to next week.
  DateTime nextReminder({DateTime? from, int minutesBefore = 30}) {
    final now = from ?? DateTime.now();
    var daysAhead = (dayOfWeek - now.weekday) % 7;
    if (daysAhead < 0) daysAhead += 7;

    final reminderMinutes =
        (startMinutes - minutesBefore).clamp(0, 24 * 60 - 1);
    var candidate = _dateOn(now, daysAhead, reminderMinutes);
    if (!candidate.isAfter(now)) {
      candidate = _dateOn(now, daysAhead + 7, reminderMinutes);
    }
    return candidate;
  }

  factory ClassSchedule.fromJson(
    Map<String, dynamic> json, {
    required int courseId,
    required String courseName,
    int position = 0,
  }) {
    return ClassSchedule(
      id: (json['id'] as num?)?.toInt() ?? (courseId * 100 + position),
      courseId: courseId,
      courseName: courseName,
      room: (json['room'] as String?) ?? '-',
      dayOfWeek: _parseDay(json['dayOfWeek'] ?? json['day']),
      startMinutes: _parseMinutes(
        json['startMinutes'] ?? json['start'] ?? json['startTime'],
      ),
      endMinutes: _parseMinutes(
        json['endMinutes'] ?? json['end'] ?? json['endTime'],
      ),
    );
  }

  static DateTime _dateOn(DateTime base, int addDays, int minutes) {
    final day = DateTime(base.year, base.month, base.day + addDays);
    return DateTime(day.year, day.month, day.day, minutes ~/ 60, minutes % 60);
  }

  static String _hhmm(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  static int _parseMinutes(Object? raw) {
    if (raw is num) {
      final value = raw.toInt();
      // Accept both "8" (hour) and "480" (minutes since midnight).
      return value <= 24 ? value * 60 : value;
    }
    if (raw is String) {
      final parts = raw.trim().split(RegExp(r'[:.]'));
      if (parts.isNotEmpty) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        return h * 60 + m;
      }
    }
    return 0;
  }

  static int _parseDay(Object? raw) {
    if (raw is num) {
      final day = raw.toInt();
      return day >= 1 && day <= 7 ? day : DateTime.monday;
    }
    if (raw is String) {
      const names = {
        'monday': DateTime.monday,
        'senin': DateTime.monday,
        'tuesday': DateTime.tuesday,
        'selasa': DateTime.tuesday,
        'wednesday': DateTime.wednesday,
        'rabu': DateTime.wednesday,
        'thursday': DateTime.thursday,
        'kamis': DateTime.thursday,
        'friday': DateTime.friday,
        'jumat': DateTime.friday,
        "jum'at": DateTime.friday,
        'saturday': DateTime.saturday,
        'sabtu': DateTime.saturday,
        'sunday': DateTime.sunday,
        'minggu': DateTime.sunday,
      };
      return names[raw.trim().toLowerCase()] ?? DateTime.monday;
    }
    return DateTime.monday;
  }
}

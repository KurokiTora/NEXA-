import '../../core/errors.dart';
import '../models/auth_session.dart';
import '../models/course.dart';
import '../models/course_details.dart';
import '../models/student.dart';
import 'nexa_api.dart';

/// Offline sample backend so the whole offline-first pipeline
/// (API -> Drift -> Stream -> UI) works before the real backend exists.
class MockNexaApi implements NexaApi {
  MockNexaApi({
    this.simulateOffline = false,
    this.latency = const Duration(milliseconds: 700),
  });

  /// Every call throws NetworkFailure (see AppConfig.mockSimulateOffline).
  final bool simulateOffline;
  final Duration latency;

  String _nim = '253100000000';

  Future<void> _network() async {
    await Future<void>.delayed(latency);
    if (simulateOffline) throw const NetworkFailure();
  }

  @override
  Future<AuthSession> login({
    required String nim,
    required String password,
  }) async {
    await _network();
    if (nim.trim().isEmpty || password.isEmpty) throw const AuthFailure();
    _nim = nim.trim();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return AuthSession(
      accessToken: 'mock-access-$stamp',
      refreshToken: 'mock-refresh-$stamp',
    );
  }

  @override
  Future<AuthSession> refreshSession(String refreshToken) async {
    await _network();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return AuthSession(
      accessToken: 'mock-access-$stamp',
      refreshToken: refreshToken,
    );
  }

  @override
  Future<RemoteSnapshot> fetchSnapshot(String accessToken) async {
    await _network();
    if (accessToken.isEmpty) throw const UnauthorizedFailure();

    return RemoteSnapshot(
      student: Student(
        nim: _nim,
        name: 'Nexa User',
        sksSemester: 24,
        sksTotal: 500,
        ipSemester: 3.89,
        ipCumulative: 3.90,
      ),
      courses: [for (final s in _seeds) _bundleFor(s)],
    );
  }

  CourseBundle _bundleFor(_Seed s) {
    return CourseBundle(
      course: Course(
        id: s.id,
        name: s.name,
        code: s.code,
        colorIndex: s.colorIndex,
        grade: s.grade,
        letter: s.letter,
        taskScore: 80,
        attendScore: 99,
        utsScore: 100,
        uasScore: 99,
        attendPercent: s.attendPercent,
        attendCount: 16,
        permitCount: s.permit,
        sickCount: s.sick,
        alphaCount: s.alpha,
      ),
      assessments: const [
        Assessment(title: 'Meeting 1 Assignment', status: AssessmentStatus.onTime, score: 80),
        Assessment(title: 'Meeting 2 Assignment', status: AssessmentStatus.onTime, score: 90),
        Assessment(title: 'Meeting 3 Assignment', status: AssessmentStatus.late, score: 40),
        Assessment(title: 'Meeting 4 Assignment', status: AssessmentStatus.missing),
        Assessment(title: 'Meeting 5 Assignment', status: AssessmentStatus.onTime, score: 60),
        Assessment(title: 'Meeting 6 Assignment', status: AssessmentStatus.onTime, score: 55),
      ],
      attendance: const [
        AttendanceLog(title: 'Class Meeting 1', status: AttendanceStatus.attend),
        AttendanceLog(title: 'Class Meeting 2', status: AttendanceStatus.attend),
        AttendanceLog(title: 'Class Meeting 3', status: AttendanceStatus.permit),
        AttendanceLog(title: 'Class Meeting 4', status: AttendanceStatus.alpha),
        AttendanceLog(title: 'Class Meeting 5', status: AttendanceStatus.attend),
        AttendanceLog(title: 'Class Meeting 6', status: AttendanceStatus.attend),
      ],
      feedback: const [
        FeedbackNote(
          title: 'Feedback Mid-Term Task',
          body: 'Overall your mid-term work shows a solid understanding of the core '
              'concepts. Keep an eye on submission timing and double-check edge '
              'cases before turning work in.',
        ),
        FeedbackNote(
          title: 'Feedback Final-Term Task',
          body: 'Great improvement compared to the mid-term. Your final submission '
              'was well structured and on time. Keep up this consistency for the '
              'next semester.',
        ),
      ],
    );
  }
}

class _Seed {
  const _Seed(this.id, this.name, this.code, this.colorIndex, this.grade,
      this.letter, this.attendPercent, this.permit, this.sick, this.alpha);

  final int id;
  final String name;
  final String code;
  final int colorIndex;
  final int grade;
  final String letter;
  final int attendPercent;
  final int permit;
  final int sick;
  final int alpha;
}

const _seeds = [
  _Seed(1, 'Pemrograman Mobile', 'IT301', 0, 88, 'A', 99, 2, 1, 0),
  _Seed(2, 'Jaringan Komputer', 'IT302', 1, 88, 'A', 98, 1, 1, 0),
  _Seed(3, 'Kecerdasan Buatan', 'IT301', 2, 88, 'A', 100, 1, 1, 0),
  _Seed(4, 'Basis Data', 'IT301', 3, 86, 'B+', 96, 1, 0, 1),
  _Seed(5, 'Sistem Operasi', 'IT301', 4, 78, 'B+', 97, 1, 0, 0),
  _Seed(6, 'Pemrograman Web', 'IT306', 1, 88, 'A', 99, 1, 1, 0),
  _Seed(7, 'Statistika', 'IT301', 5, 88, 'A', 98, 1, 0, 1),
];

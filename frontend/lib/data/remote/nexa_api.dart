import '../models/auth_session.dart';
import '../models/course.dart';
import '../models/student.dart';

/// Everything the app downloads in one refresh.
class RemoteSnapshot {
  const RemoteSnapshot({required this.student, required this.courses});

  final Student student;
  final List<CourseBundle> courses;
}

/// What the app needs from the backend. Two implementations:
///  - MockNexaApi  : built-in sample data (default while backend is not ready)
///  - HttpNexaApi  : real HTTP calls
abstract class NexaApi {
  Future<AuthSession> login({required String nim, required String password});

  Future<AuthSession> refreshSession(String refreshToken);

  /// Throws UnauthorizedFailure when the access token is rejected,
  /// NetworkFailure when offline.
  Future<RemoteSnapshot> fetchSnapshot(String accessToken);
}

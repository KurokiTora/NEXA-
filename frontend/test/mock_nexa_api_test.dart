import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors.dart';
import 'package:mobile/data/remote/mock_nexa_api.dart';

void main() {
  group('MockNexaApi', () {
    final api = MockNexaApi(latency: Duration.zero);

    test('login rejects empty credentials', () async {
      expect(
        () => api.login(nim: ' ', password: 'secret'),
        throwsA(isA<AuthFailure>()),
      );
      expect(
        () => api.login(nim: '253100000000', password: ''),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('login returns a session for valid credentials', () async {
      final session = await api.login(nim: '253100000000', password: 'secret');

      expect(session.accessToken, isNotEmpty);
      expect(session.refreshToken, isNotEmpty);
    });

    test('fetchSnapshot returns the student and all sample courses', () async {
      final snapshot = await api.fetchSnapshot('any-token');

      expect(snapshot.student.nim, '253100000000');
      expect(snapshot.student.name, 'Nexa User');
      expect(snapshot.courses, isNotEmpty);
      // Every course must come with its detail lists populated so the
      // detail screens have something to render.
      for (final bundle in snapshot.courses) {
        expect(bundle.assessments, isNotEmpty);
        expect(bundle.attendance, isNotEmpty);
      }
    });

    test('fetchSnapshot rejects an empty access token', () async {
      expect(() => api.fetchSnapshot(''), throwsA(isA<UnauthorizedFailure>()));
    });

    test('simulateOffline makes every call fail with NetworkFailure', () async {
      final offline = MockNexaApi(
        latency: Duration.zero,
        simulateOffline: true,
      );

      expect(
        () => offline.login(nim: '253100000000', password: 'secret'),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });
}

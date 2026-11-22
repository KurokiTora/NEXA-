import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile/core/errors.dart';
import 'package:mobile/data/remote/http_nexa_api.dart';

HttpNexaApi _apiWith(MockClient client) => HttpNexaApi(
      baseUrls: const ['http://test.local'],
      client: client,
    );

void main() {
  group('HttpNexaApi.sendChatMessage', () {
    test('posts the message with the bearer token and returns the reply', () async {
      late http.Request captured;
      final api = _apiWith(
        MockClient((request) async {
          captured = request;
          return http.Response(
            jsonEncode({'reply': 'Nilai kamu aman.'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final reply = await api.sendChatMessage(
        accessToken: 'token-123',
        message: '/performance',
      );

      expect(reply, 'Nilai kamu aman.');
      expect(captured.method, 'POST');
      expect(captured.url.path, '/chatbot/message');
      expect(captured.headers['Authorization'], 'Bearer token-123');
      expect(jsonDecode(captured.body), {'message': '/performance'});
    });

    test('accepts the older {data: {reply}} envelope', () async {
      final api = _apiWith(
        MockClient(
          (_) async => http.Response(
            jsonEncode({
              'success': true,
              'data': {'role': 'assistant', 'reply': 'Halo dari NEXA.'},
            }),
            200,
          ),
        ),
      );

      expect(
        await api.sendChatMessage(accessToken: 't', message: 'halo'),
        'Halo dari NEXA.',
      );
    });

    test('surfaces the backend error message', () async {
      final api = _apiWith(
        MockClient(
          (_) async => http.Response(
            jsonEncode({'error': 'GROQ_API_KEY belum diatur'}),
            503,
          ),
        ),
      );

      expect(
        () => api.sendChatMessage(accessToken: 't', message: 'halo'),
        throwsA(
          isA<ServerFailure>().having(
            (e) => e.message,
            'message',
            'GROQ_API_KEY belum diatur',
          ),
        ),
      );
    });

    test('throws UnauthorizedFailure on 401', () async {
      final api = _apiWith(
        MockClient((_) async => http.Response('{"error":"nope"}', 401)),
      );

      expect(
        () => api.sendChatMessage(accessToken: 'expired', message: 'halo'),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });
}

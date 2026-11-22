import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors.dart';
import '../models/auth_session.dart';
import '../models/course.dart';
import '../models/student.dart';
import 'nexa_api.dart';

/// Real backend client.
///
/// Expected contract (adjust paths/field names here when the backend differs):
///
///   POST /auth/login     {nim, password}   -> {accessToken, refreshToken}
///   POST /auth/refresh   {refreshToken}    -> {accessToken, refreshToken}
///   GET  /student/me      (Bearer token)   -> {nim, name, sksSemester, sksTotal,
///                                              ipSemester, ipCumulative}
///   GET  /student/courses (Bearer token)   -> [ {id, name, code, colorIndex,
///                                              grade, letter, taskScore,
///                                              attendScore, utsScore, uasScore,
///                                              attendPercent, attendCount,
///                                              permitCount, sickCount, alphaCount,
///                                              assessments:[{title,status,score}],
///                                              attendance:[{title,status}],
///                                              feedback:[{title,body}],
///                                              schedule:[{id,dayOfWeek,
///                                                start,startMinutes,room,end}] } ]
///
///   assessments.status : "onTime" | "late" | "missing"
///   attendance.status  : "attend" | "permit" | "sick" | "alpha"
///   schedule.dayOfWeek : 1 (Monday) .. 7 (Sunday)
///   schedule.start/end : "HH:mm" (local campus time)
class HttpNexaApi implements NexaApi {
  HttpNexaApi({
    required List<String> baseUrls,
    String? preferredBaseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
    this.probeTimeout = const Duration(seconds: 5),
    this.chatTimeout = const Duration(seconds: 45),
  }) : assert(baseUrls.isNotEmpty),
       _baseUrls = List.unmodifiable(baseUrls),
       _preferredBaseUrl = preferredBaseUrl,
       _currentBaseUrl = preferredBaseUrl ?? baseUrls.first,
       _client = client ?? http.Client();

  final List<String> _baseUrls;
  final Duration timeout;

  /// Per-candidate limit used while more than one candidate is in play.
  final Duration probeTimeout;

  /// Chatbot replies go through the backend -> Groq, so they get a longer
  /// budget than ordinary data requests.
  final Duration chatTimeout;
  final http.Client _client;

  /// Server address saved from the login page (null -> platform defaults).
  String? _preferredBaseUrl;

  /// The candidate that answered last. Reusing it avoids probing every URL on
  /// each request once the emulator/phone/host has been identified.
  String _currentBaseUrl;

  /// True once a request has actually been answered by [_currentBaseUrl].
  /// While false, every candidate is probed; while true we talk only to the
  /// known-good server (important for slow chatbot replies).
  bool _baseConfirmed = false;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  /// Point the client at [baseUrl] without restarting the app, and remember
  /// it as the first candidate. Pass null to go back to the defaults.
  void preferBaseUrl(String? baseUrl) {
    final trimmed = baseUrl?.trim().replaceAll(RegExp(r'/+$'), '');
    final normalized = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    _preferredBaseUrl = normalized;
    _currentBaseUrl = normalized ?? _baseUrls.first;
    _baseConfirmed = false;
  }

  Uri _uri(String baseUrl, String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _bearer(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  Future<AuthSession> login({
    required String nim,
    required String password,
  }) async {
    final res = await _send(
      (base) => _client.post(
        _uri(base, '/auth/login'),
        headers: _jsonHeaders,
        body: jsonEncode({'nim': nim, 'password': password}),
      ),
    );
    if (res.statusCode == 400 || res.statusCode == 401) {
      throw const AuthFailure();
    }
    if (res.statusCode == 404) {
      // Port 80 is usually Apache/XAMPP, not this API.
      throw const ServerFailure(
        'Alamat ini bukan NEXA API. Pastikan port 3000 ikut ditulis, '
        'contoh: 10.200.179.74:3000',
      );
    }
    _ensureOk(res);
    return AuthSession.fromJson(_decodeMap(res));
  }

  @override
  Future<AuthSession> refreshSession(String refreshToken) async {
    final res = await _send(
      (base) => _client.post(
        _uri(base, '/auth/refresh'),
        headers: _jsonHeaders,
        body: jsonEncode({'refreshToken': refreshToken}),
      ),
    );
    if (res.statusCode == 400 || res.statusCode == 401) {
      throw const UnauthorizedFailure();
    }
    _ensureOk(res);
    return AuthSession.fromJson(_decodeMap(res));
  }

  @override
  Future<RemoteSnapshot> fetchSnapshot(String accessToken) async {
    final results = await Future.wait([
      _send(
        (base) => _client.get(
          _uri(base, '/student/me'),
          headers: _bearer(accessToken),
        ),
        requestTimeout: timeout,
      ),
      _send(
        (base) => _client.get(
          _uri(base, '/student/courses'),
          headers: _bearer(accessToken),
        ),
        requestTimeout: timeout,
      ),
    ]);
    final meRes = results[0];
    final coursesRes = results[1];
    _ensureOk(meRes);
    _ensureOk(coursesRes);

    final courses = _decodeList(coursesRes)
        .map((e) => CourseBundle.fromJson(e as Map<String, dynamic>))
        .toList();
    return RemoteSnapshot(
      student: Student.fromJson(_decodeMap(meRes)),
      courses: courses,
    );
  }

  @override
  Future<String> sendChatMessage({
    required String accessToken,
    required String message,
  }) async {
    final res = await _send(
      (base) => _client.post(
        _uri(base, '/chatbot/message'),
        headers: {..._jsonHeaders, ..._bearer(accessToken)},
        body: jsonEncode({'message': message}),
      ),
      requestTimeout: chatTimeout,
    );

    if (res.statusCode == 401) throw const UnauthorizedFailure();
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ServerFailure(_errorMessage(res));
    }

    final body = _decodeMap(res);
    final data = body['data'];
    final reply = data is Map<String, dynamic> ? data['reply'] : body['reply'];
    if (reply is! String || reply.trim().isEmpty) {
      throw const ServerFailure('Chatbot returned an empty reply');
    }
    return reply.trim();
  }

  /// Prefer the backend's human-readable error over a bare status code.
  String _errorMessage(http.Response res) {
    try {
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (body is Map<String, dynamic>) {
        final error = body['error'] ?? body['message'];
        if (error is String && error.trim().isNotEmpty) return error.trim();
      }
    } on Object {
      // Fall through to the generic message.
    }
    return 'Chatbot request failed (${res.statusCode})';
  }

  // ------------------------------- helpers -------------------------------

  Future<http.Response> _send(
    Future<http.Response> Function(String baseUrl) request, {
    Duration? requestTimeout,
  }) async {
    // Once a server has answered, stick to it. Probing several addresses
    // gives each one the short probe timeout, which is too aggressive for a
    // chatbot reply that waits on Groq.
    final candidates = _baseConfirmed
        ? <String>[_currentBaseUrl]
        : <String>{
            ?_preferredBaseUrl,
            _currentBaseUrl,
            ..._baseUrls,
          }.toList(growable: false);

    Object? lastError;

    for (var i = 0; i < candidates.length; i++) {
      final base = candidates[i];

      // The first candidate gets the caller's full budget; the fallbacks are
      // just quick probes so a wrong address fails fast.
      final perCandidateTimeout = requestTimeout != null
          ? (i == 0 ? requestTimeout : probeTimeout)
          : (candidates.length > 1 ? probeTimeout : timeout);

      try {
        final res = await request(base).timeout(perCandidateTimeout);
        _currentBaseUrl = base;
        _baseConfirmed = true;
        return res;
      } on TimeoutException {
        lastError = const NetworkFailure('Request timed out');
      } on SocketException {
        lastError = const NetworkFailure();
      } on http.ClientException {
        lastError = const NetworkFailure();
      }
    }

    // The known-good server just failed; probe every candidate next time.
    _baseConfirmed = false;
    throw lastError ?? const NetworkFailure();
  }

  void _ensureOk(http.Response res) {
    if (res.statusCode == 401) {
      throw const UnauthorizedFailure();
    }
    if (res.statusCode >= 500) {
      throw ServerFailure('Server error ${res.statusCode}');
    }
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ServerFailure('Unexpected response ${res.statusCode}');
    }
  }

  Map<String, dynamic> _decodeMap(http.Response res) {
    try {
      return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    } on Object {
      throw const ServerFailure('Malformed response');
    }
  }

  List<dynamic> _decodeList(http.Response res) {
    try {
      return jsonDecode(utf8.decode(res.bodyBytes)) as List<dynamic>;
    } on Object {
      throw const ServerFailure('Malformed response');
    }
  }
}

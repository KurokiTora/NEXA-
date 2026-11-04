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
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
  }) : assert(baseUrls.isNotEmpty),
       _baseUrls = List.unmodifiable(baseUrls),
       _currentBaseUrl = baseUrls.first,
       _client = client ?? http.Client();

  final List<String> _baseUrls;
  final Duration timeout;
  final http.Client _client;

  /// The candidate that answered last. Reusing it avoids probing every URL on
  /// each request once the emulator/phone/host has been identified.
  String _currentBaseUrl;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Uri _uri(String path) => Uri.parse('$_currentBaseUrl$path');

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
      () => _client.post(
        _uri('/auth/login'),
        headers: _jsonHeaders,
        body: jsonEncode({'nim': nim, 'password': password}),
      ),
    );
    if (res.statusCode == 400 || res.statusCode == 401) {
      throw const AuthFailure();
    }
    _ensureOk(res);
    return AuthSession.fromJson(_decodeMap(res));
  }

  @override
  Future<AuthSession> refreshSession(String refreshToken) async {
    final res = await _send(
      () => _client.post(
        _uri('/auth/refresh'),
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
        () => _client.get(_uri('/student/me'), headers: _bearer(accessToken)),
      ),
      _send(
        () => _client.get(
          _uri('/student/courses'),
          headers: _bearer(accessToken),
        ),
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

  // ------------------------------- helpers -------------------------------

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    final candidates = [
      _currentBaseUrl,
      ..._baseUrls.where((base) => base != _currentBaseUrl),
    ];
    Object? lastError;

    for (final base in candidates) {
      _currentBaseUrl = base;
      try {
        return await request().timeout(timeout);
      } on TimeoutException {
        lastError = const NetworkFailure('Request timed out');
      } on SocketException {
        lastError = const NetworkFailure();
      } on http.ClientException {
        lastError = const NetworkFailure();
      }
    }

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

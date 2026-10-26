class AuthSession {
  const AuthSession({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      );
}

/// Base type for every failure the data layer can surface to the UI.
class NexaException implements Exception {
  const NexaException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// No connection / timeout. The UI keeps showing cached data.
class NetworkFailure extends NexaException {
  const NetworkFailure([super.message = 'Network unavailable']);
}

/// Wrong NIM / password at login.
class AuthFailure extends NexaException {
  const AuthFailure([super.message = 'Invalid Student ID or Password']);
}

/// Token rejected and could not be refreshed -> user must log in again.
class UnauthorizedFailure extends NexaException {
  const UnauthorizedFailure([super.message = 'Session expired']);
}

/// Server answered with 5xx or something we can't parse.
class ServerFailure extends NexaException {
  const ServerFailure([super.message = 'Server error']);
}

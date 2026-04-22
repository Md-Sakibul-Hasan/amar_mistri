import 'failures.dart';

abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  Failure toFailure();
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred.']);

  @override
  Failure toFailure() => ServerFailure(message);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred.']);

  @override
  Failure toFailure() => CacheFailure(message);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed.']);

  @override
  Failure toFailure() => AuthFailure(message);
}

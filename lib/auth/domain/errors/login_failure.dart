class LoginFailure implements Exception {
  static const userNotFound = 3;
  static const invalidCredentials = 4;
}

class UserNotFound extends LoginFailure {}

class InvalidCredentials extends LoginFailure {}

class UnknownLoginError extends LoginFailure {}

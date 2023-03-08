abstract class SignupFailure implements Exception {
  static const usernameAlreadyExistsCode = 2;
}

class UsernameAlreadyExists extends SignupFailure {}

class UnknownSignupError extends SignupFailure {}

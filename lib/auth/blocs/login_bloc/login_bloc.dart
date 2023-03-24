import 'package:bloc/bloc.dart';
import 'package:chat_wave/auth/blocs/login_bloc/fields_state.dart';
import 'package:chat_wave/auth/data/repository/auth_repository_impl.dart';
import 'package:chat_wave/auth/domain/errors/login_failure.dart';
import 'package:chat_wave/auth/utils/password.dart';
import 'package:chat_wave/auth/utils/username.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final repository = AuthRepositoryImpl();

  LoginBloc()
      : super(
          const NotLoggedIn(
            loginFieldsState: LoginFieldsState.empty,
          ),
        ) {
    on<Submit>(_handleSubmitEvent);
    on<UsernameFieldChanged>(_handleUsernameChanged);
    on<PasswordFieldChanged>(_handlePasswordFieldChanged);
  }

  Future<void> _handleUsernameChanged(
    UsernameFieldChanged event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginLoading || state is LoginLoading) {
      return;
    }
    final current = (state as NotLoggedIn).loginFieldsState;
    emit(
      NotLoggedIn(
        loginFieldsState: current.copyWith(
          username: Username.dirty(event.value),
          usernameError: null,
          passwordError: current.passwordError,
        ),
      ),
    );
  }

  Future<void> _handlePasswordFieldChanged(
    PasswordFieldChanged event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginLoading || state is LoginLoading) {
      return;
    }
    final current = (state as NotLoggedIn).loginFieldsState;
    emit(
      NotLoggedIn(
        loginFieldsState: current.copyWith(
          password: Password.dirty(event.value),
          passwordError: null,
          usernameError: current.usernameError,
        ),
      ),
    );
  }

  Future<void> _handleSubmitEvent(
    Submit event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginLoading || state is LoggedIn) {
      return;
    }
    final currentLoginFieldsState = (state as NotLoggedIn).loginFieldsState;
    final username = currentLoginFieldsState.username;
    final password = currentLoginFieldsState.password;
    if (username.isNotValid || password.isNotValid) {
      emit(
        NotLoggedIn(
          loginFieldsState: currentLoginFieldsState.copyWith(
            usernameError: username.error,
            passwordError: password.error,
          ),
        ),
      );
      return;
    }
    emit(LoginLoading());
    try {
      final isUserLoggedIn =
          await repository.login(username.value, password.value);
      if (isUserLoggedIn) {
        emit(LoggedIn());
      }
    } on UserNotFound catch (_) {
      emit(
        NotLoggedIn(
          loginFieldsState: currentLoginFieldsState.copyWith(
              usernameError: 'invalid username'),
        ),
      );
    } on InvalidCredentials catch (_) {
      emit(
        NotLoggedIn(
          loginFieldsState: currentLoginFieldsState.copyWith(
            passwordError: 'wrong password',
          ),
        ),
      );
    }
  }
}

import 'package:chat_wave/auth/blocs/login_bloc/login_bloc.dart';
import 'package:chat_wave/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widgets.dart';
import 'auth_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Route get route {
    return MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: screenHeight,
            width: double.infinity,
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.4),
                    AuthField(
                      title: 'Username',
                      onValueChange: (newValue) =>
                          BlocProvider.of<LoginBloc>(context).add(
                        UsernameFieldChanged(newValue),
                      ),
                      textInputAction: TextInputAction.next,
                      enabled: state is! LoginLoading,
                      errorText: (state is NotLoggedIn)
                          ? (state).loginFieldsState.usernameError
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    AuthField(
                      title: 'Password',
                      obsecureText: _hidePassword,
                      onValueChange: (newValue) =>
                          BlocProvider.of<LoginBloc>(context).add(
                        PasswordFieldChanged(newValue),
                      ),
                      onSubmitted: (_) =>
                          BlocProvider.of<LoginBloc>(context).add(Submit()),
                      trailingIcon: IconButton(
                        onPressed: _toggleShowPassword,
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        splashRadius: 16,
                      ),
                      enabled: state is! LoginLoading,
                      errorText: (state is NotLoggedIn)
                          ? (state).loginFieldsState.passwordError
                          : null,
                    ),
                    const SizedBox(height: 40),
                    AnimatedLock(
                      color: Theme.of(context).textTheme.titleLarge?.color ??
                          Colors.grey,
                      onClick: () =>
                          BlocProvider.of<LoginBloc>(context).add(Submit()),
                      lockEnabled: (state is NotLoggedIn)
                          ? state.loginFieldsState.username.isValid &&
                              state.loginFieldsState.password.isValid
                          : false,
                      locked: state is! LoggedIn,
                      onLockOpenCallback: () {
                        Navigator.of(context).pushReplacement(HomeScreen.route);
                      },
                    ),
                    const Expanded(child: SizedBox()),
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      onTap: () => Navigator.push(context, SignupScreen.route),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Signup',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0)
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _toggleShowPassword() => setState(() {
        _hidePassword = !_hidePassword;
      });
}

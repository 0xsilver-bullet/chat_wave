import 'package:chat_wave/auth/blocs/signup_bloc/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/auth_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static Route get route {
    return MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    );
  }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocConsumer<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state is SignedUp) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.4),
                  AuthField(
                    title: 'Name',
                    textInputAction: TextInputAction.next,
                    onValueChange: (newValue) =>
                        BlocProvider.of<SignupBloc>(context).add(
                      NameFieldChanged(newValue),
                    ),
                    errorText: (state is NotSignedUp)
                        ? state.signupFieldsState.nameError
                        : null,
                    enabled: state is NotSignedUp,
                  ),
                  const SizedBox(height: 16.0),
                  AuthField(
                    title: 'Username',
                    onValueChange: (newValue) =>
                        BlocProvider.of<SignupBloc>(context).add(
                      UsernameFieldChanged(newValue),
                    ),
                    errorText: (state is NotSignedUp)
                        ? state.signupFieldsState.usernameError
                        : null,
                    textInputAction: TextInputAction.next,
                    enabled: state is NotSignedUp,
                  ),
                  const SizedBox(height: 16.0),
                  AuthField(
                    title: 'Password',
                    obsecureText: _hidePassword,
                    onValueChange: (newValue) =>
                        BlocProvider.of<SignupBloc>(context).add(
                      PasswordFieldChanged(newValue),
                    ),
                    trailingIcon: IconButton(
                      onPressed: _toggleShowPassword,
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      splashRadius: 16,
                    ),
                    errorText: (state is NotSignedUp)
                        ? state.signupFieldsState.passwordError
                        : null,
                    enabled: state is NotSignedUp,
                  ),
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () =>
                        BlocProvider.of<SignupBloc>(context).add(Submit()),
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _toggleShowPassword() => setState(() {
        _hidePassword = !_hidePassword;
      });
}

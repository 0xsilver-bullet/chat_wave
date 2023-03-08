import 'package:chat_wave/blocs/signup_bloc/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:chat_wave/widget/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  static Route get route {
    return MaterialPageRoute(
      builder: (context) => SignupScreen(),
    );
  }

  final nameFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

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
            buildWhen: (previous, current) => false,
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.4),
                  AuthField(
                    title: 'Name',
                    controller: widget.nameFieldController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<SignupBloc, SignupState>(
                    builder: (context, state) {
                      String? fieldError;
                      if (state is SignupFailed) {
                        fieldError = "usernam already exists";
                      }
                      return AuthField(
                        title: 'Username',
                        controller: widget.usernameFieldController,
                        errorText: fieldError,
                        textInputAction: TextInputAction.next,
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  AuthField(
                    title: 'Password',
                    controller: widget.passwordFieldController,
                    obsecureText: _hidePassword,
                    trailingIcon: IconButton(
                      onPressed: _toggleShowPassword,
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      splashRadius: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<SignupBloc>(context).add(
                        SignUserUp(
                            name: widget.nameFieldController.text,
                            username: widget.usernameFieldController.text,
                            password: widget.passwordFieldController.text),
                      );
                    },
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

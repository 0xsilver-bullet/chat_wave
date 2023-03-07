import 'package:chat_wave/screens/screens.dart';
import 'package:chat_wave/widget/animated_lock.dart';
import 'package:chat_wave/widget/auth_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: screenHeight,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.4),
              AuthField(
                title: 'Username',
                controller: widget.usernameFieldController,
                textInputAction: TextInputAction.next,
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
              AnimatedLock(
                color: Theme.of(context).textTheme.titleLarge?.color ??
                    Colors.grey,
                onClick: () =>
                    Navigator.of(context).pushReplacement(HomeScreen.route),
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
          ),
        ),
      ),
    );
  }

  void _toggleShowPassword() => setState(() {
        _hidePassword = !_hidePassword;
      });
}
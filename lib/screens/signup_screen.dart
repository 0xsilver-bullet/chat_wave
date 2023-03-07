import 'package:flutter/material.dart';
import 'package:chat_wave/widget/widgets.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight * 0.4),
            AuthField(
              title: 'Name',
              controller: widget.nameFieldController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16.0),
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
          ],
        ),
      ),
    );
  }

  void _toggleShowPassword() => setState(() {
        _hidePassword = !_hidePassword;
      });
}

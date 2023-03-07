import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.title,
    this.onValueChange,
    this.borderRadius = 24,
    this.textInputAction,
    this.focusNode,
    this.onSubmitted,
    this.controller,
    this.obsecureText = false,
    this.trailingIcon,
    this.errorText,
  });

  final String title;
  final ValueChanged<String>? onValueChange;
  final double borderRadius;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final bool obsecureText;
  final Widget? trailingIcon;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            decoration: InputDecoration(
              errorText: errorText,
              suffixIcon: trailingIcon,
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
            onChanged: onValueChange,
            textInputAction: textInputAction,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            obscureText: obsecureText,
            controller: controller,
          ),
        ),
        Positioned(
          left: 16.0,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        )
      ],
    );
  }
}

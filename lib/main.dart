import 'package:chat_wave/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:chat_wave/theme.dart';

void main() {
  runApp(const ChatWaveApp());
}

class ChatWaveApp extends StatelessWidget {
  const ChatWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}

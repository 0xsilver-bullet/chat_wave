import 'package:flutter/material.dart';

void main() {
  runApp(const ChatWaveApp());
}

class ChatWaveApp extends StatelessWidget {
  const ChatWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatWaveHome(),
    );
  }
}

class ChatWaveHome extends StatelessWidget {
  const ChatWaveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Chat Wave'),
      ),
    );
  }
}

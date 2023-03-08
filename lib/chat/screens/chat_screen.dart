import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final _messageFieldController = TextEditingController();

  static Route get route {
    return MaterialPageRoute(
      builder: (context) => ChatScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatTop(
              onCloseCallback: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Container(
                color: isDarkMode ? Colors.black : const Color(0xFFF4F4F4),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: 10000,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final isOwnMessage = Random().nextBool();
                    return Container(
                      alignment: isOwnMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: MessageItem(
                        isOwnMessage: isOwnMessage,
                        message: faker.lorem.sentence(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Theme(
              data: ThemeData(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              child: TextField(
                controller: _messageFieldController,
                textInputAction: TextInputAction.send,
                decoration: const InputDecoration(
                  hintText: 'Message...',
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

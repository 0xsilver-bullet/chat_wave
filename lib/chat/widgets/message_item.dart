import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.isOwnMessage,
    required this.message,
  });

  final bool isOwnMessage;
  final String message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(32),
          topRight: const Radius.circular(32),
          bottomRight: isOwnMessage ? Radius.zero : const Radius.circular(32),
          bottomLeft: isOwnMessage ? const Radius.circular(32) : Radius.zero,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeTop extends StatelessWidget {
  const HomeTop({
    super.key,
    required this.onAddClick,
    required this.onShareClick,
  });

  final VoidCallback onAddClick;
  final VoidCallback onShareClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Chats',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.ios_share),
                splashRadius: 18,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
                splashRadius: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

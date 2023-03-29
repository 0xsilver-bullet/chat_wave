import 'package:flutter/material.dart';

class EditableName extends StatelessWidget {
  const EditableName({super.key, required this.name, this.onTap});

  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        name,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

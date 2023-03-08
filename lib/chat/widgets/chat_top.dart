import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ChatTop extends StatelessWidget {
  const ChatTop({
    super.key,
    this.onCloseCallback,
  });

  final VoidCallback? onCloseCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: CachedNetworkImageProvider(
              faker.image.image(),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faker.person.name(),
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4.0),
                if (Random().nextBool())
                  Text(
                    'online',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.green),
                  )
              ],
            ),
          ),
          IconButton(
            onPressed: onCloseCallback,
            splashRadius: 18.0,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

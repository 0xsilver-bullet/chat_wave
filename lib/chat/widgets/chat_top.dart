import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:flutter/material.dart';

class ChatTop extends StatelessWidget {
  const ChatTop({
    super.key,
    required this.channel,
    this.online,
    this.onCloseCallback,
  });

  final Channel channel;
  final bool? online;
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
              channel.imageUrl ??
                  'https://h-o-m-e.org/wp-content/uploads/2022/04/Blank-Profile-Picture-1.jpg',
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.name,
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4.0),
                if (online ?? false)
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

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_wave/theme.dart';
import 'package:flutter/material.dart';

import '../../core/domain/model/channel.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.channel,
    this.onClick,
  });

  final Channel channel;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundImage: CachedNetworkImageProvider(
                'https://h-o-m-e.org/wp-content/uploads/2022/04/Blank-Profile-Picture-1.jpg',
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          channel.channelName,
                          style: Theme.of(context).textTheme.displayMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (channel.lastMessage != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check, color: Colors.green),
                            const SizedBox(width: 4.0),
                            Text(
                              channel.lastMessage?.formattedDate ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        )
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  if (channel.lastMessage?.text != null)
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          if (Random().nextBool())
                            const TextSpan(
                              text: 'You: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGrey,
                              ),
                            ),
                          TextSpan(text: channel.lastMessage?.text),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

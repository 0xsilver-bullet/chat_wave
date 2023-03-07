import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_wave/theme.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    this.onClick,
  });

  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          faker.person.name(),
                          style: Theme.of(context).textTheme.displayMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, color: Colors.green),
                          const SizedBox(width: 4.0),
                          Text(
                            '12:00',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 4.0),
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
                        TextSpan(text: faker.lorem.sentence()),
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

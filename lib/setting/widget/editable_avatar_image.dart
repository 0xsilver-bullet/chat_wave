import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EditableAvatarImage extends StatelessWidget {
  const EditableAvatarImage.network({
    super.key,
    required String picUrl,
    this.radius = 72,
    this.onTap,
  })  : url = picUrl,
        isNetworkImage = true,
        path = null;

  const EditableAvatarImage.local({
    super.key,
    required String picPath,
    this.radius = 72,
    this.onTap,
  })  : path = picPath,
        isNetworkImage = false,
        url = null;

  final String? url;
  final String? path;
  final bool isNetworkImage;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (isNetworkImage)
          CircleAvatar(
            radius: radius,
            backgroundImage: CachedNetworkImageProvider(url!),
          )
        else
          CircleAvatar(
            radius: radius,
            backgroundImage: FileImage(File(path!)),
          ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            radius: 18,
            child: const Icon(
              Icons.camera_alt,
              size: 30,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

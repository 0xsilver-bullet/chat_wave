import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({
    super.key,
    required this.heroTag,
    required this.url,
  });

  final Object heroTag;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: CircleAvatar(
            radius: 120,
            backgroundImage: CachedNetworkImageProvider(url),
          ),
        ),
      ),
    );
  }
}

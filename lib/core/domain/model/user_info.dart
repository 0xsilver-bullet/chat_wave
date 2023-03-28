import 'package:flutter/foundation.dart';

@immutable
class UserInfo {
  const UserInfo({
    required this.name,
    required this.username,
    required this.profilePicUrl,
    required this.id,
  });

  final String name;
  final String username;
  final String? profilePicUrl;
  final int id;
}

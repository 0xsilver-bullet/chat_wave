import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserInfo extends Equatable {
  const UserInfo({
    required this.name,
    required this.username,
    required this.profilePicUrl,
    required this.id,
  });

  final int id;
  final String name;
  final String username;
  final String? profilePicUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        profilePicUrl,
      ];
}

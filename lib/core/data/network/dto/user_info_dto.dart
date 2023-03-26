import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserInfoDto extends Equatable {
  const UserInfoDto({
    required this.name,
    required this.username,
    this.profilePicUrl,
    required this.id,
  });

  UserInfoDto.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        username = json['username'],
        profilePicUrl = json['profilePicUrl'],
        id = json['id'];

  final String name;
  final String username;
  final String? profilePicUrl;
  final int id;

  @override
  List<Object?> get props => [
        name,
        username,
        profilePicUrl,
        id,
      ];
}

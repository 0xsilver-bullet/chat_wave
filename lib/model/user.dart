import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class User extends Equatable {
  const User(
      {required this.id,
      required this.name,
      required this.username,
      this.profileImageUrl});

  final int id;
  final String name;
  final String username;
  final String? profileImageUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        profileImageUrl,
      ];
}

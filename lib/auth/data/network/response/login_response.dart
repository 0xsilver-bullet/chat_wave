import 'package:chat_wave/auth/data/network/dto/tokens_dto.dart';
import 'package:chat_wave/auth/data/network/dto/user_info_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class LoginResponse extends Equatable {
  const LoginResponse({
    required this.userInfo,
    required this.tokens,
  });

  LoginResponse.fromJson(Map<String, dynamic> json)
      : userInfo = UserInfoDto.fromJson(json['user']),
        tokens = TokensDto.fromJson(json['tokens']);

  final UserInfoDto userInfo;
  final TokensDto tokens;

  @override
  List<Object> get props => [];
}

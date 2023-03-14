import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:chat_wave/auth/data/network/dto/user_info_dto.dart';

@immutable
class SignupResponse extends Equatable {
  const SignupResponse({required this.userInfo});

  SignupResponse.fromJson(Map<String, dynamic> json)
      : userInfo = UserInfoDto.fromJson(json['user']);

  final UserInfoDto userInfo;

  @override
  List<Object> get props => [];
}

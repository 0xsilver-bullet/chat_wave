class TokensDto {
  TokensDto({
    required this.accessToken,
    required this.refreshToken,
  });

  TokensDto.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];

  final String accessToken;
  final String refreshToken;
}

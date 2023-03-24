class FriendDto {
  const FriendDto({
    required this.name,
    required this.username,
    this.profilePicUrl,
    required this.id,
  });

  FriendDto.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        username = json['username'],
        profilePicUrl = json['profilePicUrl'],
        id = json['id'];

  final String name;
  final String username;
  final String? profilePicUrl;
  final int id;
}

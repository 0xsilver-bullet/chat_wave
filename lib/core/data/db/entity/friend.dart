class FriendEntity {
  FriendEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.profilePicUrl,
  });

  FriendEntity.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        username = map['username'],
        profilePicUrl = map['profile_pic_url'];

  final int id;
  final String name;
  final String username;
  final String? profilePicUrl;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profile_pic_url': profilePicUrl,
    };
  }
}

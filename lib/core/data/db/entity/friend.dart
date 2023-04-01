class FriendEntity {
  FriendEntity({
    required this.name,
    required this.username,
    this.profilePicUrl,
    required this.id,
  });

  final String name;
  final String username;
  final String? profilePicUrl;
  final int id;

  FriendEntity.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        username = map['username'],
        profilePicUrl = map['profile_pic_url'],
        id = map['id'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'profile_pic_url': profilePicUrl,
      'id': id,
    };
  }
}

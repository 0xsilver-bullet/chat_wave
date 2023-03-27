import 'package:floor/floor.dart';

@entity
class Friend {
  Friend({
    required this.name,
    required this.username,
    this.profilePicUrl,
    required this.id,
  });

  final String name;
  final String username;
  @ColumnInfo(name: 'profile_pic_url')
  final String? profilePicUrl;

  @PrimaryKey(autoGenerate: false)
  final int id;
}

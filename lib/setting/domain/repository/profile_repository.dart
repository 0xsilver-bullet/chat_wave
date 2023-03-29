import 'package:chat_wave/core/domain/model/user_info.dart';

abstract class ProfileRepository {
  Future<UserInfo> updateProfile(
    String? name,
    String? newPicPath,
  );
}

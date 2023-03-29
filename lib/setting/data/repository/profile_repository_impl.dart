import 'package:chat_wave/core/data/mapper/user_info_mapper.dart';
import 'package:chat_wave/core/domain/app_preferences.dart';
import 'package:chat_wave/core/domain/model/user_info.dart';
import 'package:chat_wave/setting/domain/errors/profile_update_error.dart';

import '../../domain/repository/profile_repository.dart';
import '../network/profile_api.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(this._pref);

  final _api = ProfileApi();
  final AppPreferences _pref;

  @override
  Future<UserInfo> updateProfile(String? name, String? newPicPath) async {
    final newUserInfoDto = await _api.updateUserProfile(name, newPicPath);
    if (newUserInfoDto == null) throw FailedToUpdateProfile();
    // we need to update update user info in the storage
    final userInfo = newUserInfoDto.toUserInfo();
    await _pref.saveUserInfo(userInfo);
    return userInfo;
  }
}

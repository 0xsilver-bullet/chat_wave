part of 'profile_pic_bloc.dart';

@immutable
abstract class ProfilePicState extends Equatable {
  const ProfilePicState(this.profilePicUrl);

  final String? profilePicUrl;

  @override
  List<Object?> get props => [profilePicUrl];
}

@immutable
class DefaultProfilePic extends ProfilePicState {
  const DefaultProfilePic(String? profilePicUrl) : super(profilePicUrl);
}

@immutable
class LocalProfilePic extends ProfilePicState {
  const LocalProfilePic(this.imagePath, String? profilePicurl)
      : super(profilePicurl);

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}

// when the api request failed to update the user profiel pic
@immutable
class FailedToUpdateProfilePic extends ProfilePicState {
  const FailedToUpdateProfilePic(String? profilePicUrl) : super(profilePicUrl);
}

@immutable
class UpdatedProfilePic extends ProfilePicState {
  const UpdatedProfilePic(String profilePicUrl) : super(profilePicUrl);
}

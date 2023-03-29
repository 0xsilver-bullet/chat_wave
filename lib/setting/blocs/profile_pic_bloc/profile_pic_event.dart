part of 'profile_pic_bloc.dart';

@immutable
abstract class ProfilePicEvent extends Equatable {
  const ProfilePicEvent();

  @override
  List<Object> get props => [];
}

@immutable
class ChangeProfilePic extends ProfilePicEvent {}

@immutable
class CropPickedPic extends ProfilePicEvent {
  const CropPickedPic(this.imagePath);

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}

class SubmitNewProfilePic extends ProfilePicEvent {}

// Emitted when the current state is UpdatedProfilePic to roll back to our
// main DefaultProfilePicState.
class FinishedUpdating extends ProfilePicEvent {}

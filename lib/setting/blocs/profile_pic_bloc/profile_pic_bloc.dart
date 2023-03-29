import 'package:bloc/bloc.dart';
import 'package:chat_wave/setting/domain/repository/profile_repository.dart';
import 'package:chat_wave/utils/blocs/app_bloc/app_bloc.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

part 'profile_pic_event.dart';
part 'profile_pic_state.dart';

class ProfilePicBloc extends Bloc<ProfilePicEvent, ProfilePicState> {
  ProfilePicBloc(this.profilePicUrl, this._appBloc)
      : super(DefaultProfilePic(profilePicUrl)) {
    on<ChangeProfilePic>(_handleChangeProfilePicEvent);
    on<CropPickedPic>(_handleCropPickedPicEvent);
    on<SubmitNewProfilePic>(_handleSubmitNewProfilePicEvent);
    on<FinishedUpdating>(_handleFinishedUpdatingEvent);
  }

  final _picker = ImagePicker();
  final _cropper = ImageCropper();
  final _profileRepository = locator<ProfileRepository>();

  final String? profilePicUrl;
  final AppBloc _appBloc;

  Future<void> _handleChangeProfilePicEvent(
    ChangeProfilePic event,
    Emitter<ProfilePicState> emit,
  ) async {
    final newImagePath = await _picker.pickImage(source: ImageSource.gallery);
    if (newImagePath == null) return;
    add(CropPickedPic(newImagePath.path));
  }

  Future<void> _handleCropPickedPicEvent(
    CropPickedPic event,
    Emitter<ProfilePicState> emit,
  ) async {
    final croppedPic = await _cropper.cropImage(
      sourcePath: event.imagePath,
      cropStyle: CropStyle.circle,
    );
    if (croppedPic == null) return;

    emit(LocalProfilePic(croppedPic.path, state.profilePicUrl));
  }

  Future<void> _handleFinishedUpdatingEvent(
    FinishedUpdating event,
    Emitter<ProfilePicState> emit,
  ) async {
    if (state is! UpdatedProfilePic) return;
    emit(DefaultProfilePic(state.profilePicUrl));
  }

  Future<void> _handleSubmitNewProfilePicEvent(
    SubmitNewProfilePic event,
    Emitter<ProfilePicState> emit,
  ) async {
    // only local state needs to be submitted
    if (state is! LocalProfilePic) return;
    try {
      final imagePath = (state as LocalProfilePic).imagePath;
      final newUserInfo =
          await _profileRepository.updateProfile(null, imagePath);
      emit(UpdatedProfilePic(newUserInfo.profilePicUrl!));
      _appBloc.add(UserInfoChanged(newUserInfo));
    } catch (e) {
      emit(FailedToUpdateProfilePic(state.profilePicUrl));
    }
  }
}

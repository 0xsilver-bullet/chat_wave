import 'package:bloc/bloc.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'share_profile_event.dart';
part 'share_profile_state.dart';

class ShareProfileBloc extends Bloc<ShareProfileEvent, ShareProfileState> {
  ShareProfileBloc() : super(const NoFriendshipSecret()) {
    on<GenerateFrienshipSecret>(_handleGenerateFrienshipSecretEvent);
    add(GenerateFrienshipSecret());
  }

  final _friendRepository = locator<FriendRepository>();

  Future<void> _handleGenerateFrienshipSecretEvent(
    GenerateFrienshipSecret event,
    Emitter<ShareProfileState> emit,
  ) async {
    if (state is LoadingSecret) return;
    emit(LoadingSecret());
    try {
      final secret = await _friendRepository.generateFriendshipSecret();
      emit(LoadedSecret(secret));
    } catch (err) {
      emit(FailedToLoad());
    }
  }
}

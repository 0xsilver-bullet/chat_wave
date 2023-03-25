import 'package:bloc/bloc.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/error/add_friend_error.dart';

part 'add_friend_event.dart';
part 'add_friend_state.dart';

class AddFriendBloc extends Bloc<AddFriendEvent, AddFriendState> {
  AddFriendBloc() : super(const AddFriendIdle(username: '')) {
    on<UsernameFieldChanged>(_handleUsernameFieldChange);
    on<AddFriend>(_handleAddFriend);
  }

  final repository = locator<FriendRepository>();

  Future<void> _handleUsernameFieldChange(
    UsernameFieldChanged event,
    Emitter<AddFriendState> emit,
  ) async {
    // prevent update if not idle
    if (state is! AddFriendIdle) {
      return;
    }
    emit(AddFriendIdle(username: event.username));
  }

  Future<void> _handleAddFriend(
    AddFriend event,
    Emitter<AddFriendState> emit,
  ) async {
    if (state is Loading) {
      return;
    }
    emit(Loading(state.username));
    try {
      // it will succeed scilent or throw an error
      await repository.addFriend(state.username);
      emit(const Added());
    } on UserNotFound catch (_) {
      emit(
        AddFriendIdle(
          username: state.username,
          fieldError: 'user not found',
        ),
      );
    } on AlreadyFriends catch (_) {
      emit(
        AddFriendIdle(
          username: state.username,
          fieldError: 'you are already friends',
        ),
      );
    } catch (error) {
      emit(
        AddFriendIdle(
          username: state.username,
          fieldError: 'unexpected error',
        ),
      );
    }
  }
}

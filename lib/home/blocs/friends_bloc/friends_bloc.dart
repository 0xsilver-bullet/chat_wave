import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(const FriendsList([])) {
    on<LoadedUserFriends>(
      (event, emit) => emit(
        FriendsList(event.friends),
      ),
    );
    _streamSubscription = repo.watchUserFriends().listen((friends) {
      add(LoadedUserFriends(friends));
    });
  }

  final repo = locator<FriendRepository>();
  late StreamSubscription _streamSubscription;

  @override
  Future<void> close() async {
    _streamSubscription.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/model/dm_channel.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'channels_event.dart';
part 'channels_state.dart';

class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  ChannelsBloc() : super(const ChannelsList([])) {
    on<ChannelsLoaded>((event, emit) {
      emit(ChannelsList(event.channels));
    });
    _streamSubscription = repo.watchUserFriends().listen((friends) {
      final channels = friends
          .map(
            (friend) => DmChannel(
              friendId: friend.id,
              friendName: friend.name,
              lastMessage: null,
              online: true,
            ),
          )
          .toList();
      add(ChannelsLoaded(channels));
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

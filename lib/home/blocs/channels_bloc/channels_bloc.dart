import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/model/dm_channel.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:chat_wave/utils/blocs/online_status_bloc/online_status_bloc.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'channels_event.dart';
part 'channels_state.dart';

class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  ChannelsBloc(this._onlineBloc) : super(const ChannelsList([])) {
    on<ChannelsLoaded>((event, emit) {
      emit(ChannelsList(event.channels));
    });
    _initializeFriendsStreamSubscription();
    _initializeOnlineStreamSubscription();
  }

  final OnlineStatusBloc _onlineBloc;

  final repo = locator<FriendRepository>();
  late StreamSubscription _friendsStreamSubscription;
  late StreamSubscription _onlineStatusSubscription;

  void _initializeFriendsStreamSubscription() {
    _friendsStreamSubscription = repo.watchUserFriends().listen(
      (friends) {
        final channels = friends
            .map(
              (friend) => DmChannel(
                friendId: friend.id,
                friendName: friend.name,
                profilePicUrl: friend.profilePicUrl,
                lastMessage: null,
                online: false,
              ),
            )
            .toList();
        add(ChannelsLoaded(channels));
      },
    );
  }

  void _initializeOnlineStreamSubscription() {
    _onlineStatusSubscription = _onlineBloc.stream.listen(
      (event) {
        final currentList = (state as ChannelsList).channels;
        final newList = currentList.map(
          (channel) {
            if (channel is DmChannel) {
              return channel.copyWith(
                online: event.onlineUsers.contains(channel.friendId),
              );
            }
            return channel;
          },
        ).toList();
        add(ChannelsLoaded(newList));
      },
    );
  }

  @override
  Future<void> close() async {
    _friendsStreamSubscription.cancel();
    _onlineStatusSubscription.cancel();
    return super.close();
  }
}

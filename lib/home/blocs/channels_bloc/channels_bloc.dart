import 'dart:async';

import 'package:chat_wave/core/data/db/entity/dm_channel.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/model/dm_channel.dart';
import 'package:chat_wave/home/data/mapper/message_mapper.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:chat_wave/utils/blocs/online_status_bloc/online_status_bloc.dart';
import 'package:chat_wave/utils/locator.dart';

part 'channels_event.dart';
part 'channels_state.dart';

class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  ChannelsBloc(this._onlineBloc) : super(const ChannelsList([])) {
    on<ChannelsLoaded>(_handleChannelsLoadedEvent);
    _channelsStreamSubscribtion = _channelsStream.listen(
      (channels) {
        add(ChannelsLoaded(channels));
      },
    );
  }

  final OnlineStatusBloc _onlineBloc;

  final repo = locator<FriendRepository>();
  late final StreamSubscription<List<Channel>> _channelsStreamSubscribtion;

  Stream<List<Channel>> get _channelsStream => Rx.combineLatest2(
        repo.watchDmChannels(),
        _onlineBloc.stream,
        (channels, onlineIds) => _buildChannelsList(
          channels,
          onlineIds.onlineUsers,
        ),
      );

  void _handleChannelsLoadedEvent(
    ChannelsLoaded event,
    Emitter<ChannelsState> emit,
  ) async {
    final List<Channel> newList = [];
    newList.addAll(event.channels);
    emit(ChannelsList(newList));
  }

  List<Channel> _buildChannelsList(
    List<DmChannelEntity> channels,
    List<int> onlineUsers,
  ) {
    return channels
        .map(
          (channel) => DmChannel(
            friendId: channel.id,
            friendName: channel.name,
            profilePicUrl: channel.profilePicUrl,
            lastMessage: channel.lastMessage?.toDmMessage(),
            online: onlineUsers.contains(channel.id),
          ),
        )
        .toList();
  }

  @override
  Future<void> close() async {
    _channelsStreamSubscribtion.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:chat_wave/home/domain/repository/channel_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/utils/locator.dart';

part 'channels_event.dart';
part 'channels_state.dart';

class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  ChannelsBloc() : super(const ChannelsList([])) {
    on<ChannelsLoaded>(_handleChannelsLoadedEvent);
    _channelsStreamSubscribtion = _repo.watchChannels.listen(
      (channels) {
        add(ChannelsLoaded(channels));
      },
    );
  }
  final _repo = locator<ChannelRepository>();
  late final StreamSubscription<List<Channel>> _channelsStreamSubscribtion;

  void _handleChannelsLoadedEvent(
    ChannelsLoaded event,
    Emitter<ChannelsState> emit,
  ) async {
    final List<Channel> newList = [];
    newList.addAll(event.channels);
    emit(ChannelsList(newList));
  }

  @override
  Future<void> close() async {
    _channelsStreamSubscribtion.cancel();
    return super.close();
  }
}

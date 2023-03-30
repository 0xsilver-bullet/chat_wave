import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/domain/online_status_provider.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'online_status_event.dart';
part 'online_status_state.dart';

class OnlineStatusBloc extends Bloc<UpdateOnlineStateEvent, OnlineStatusState> {
  OnlineStatusBloc() : super(const OnlineStatusState([])) {
    on<UpdateOnlineStateEvent>((event, emit) {
      final List<int> newList = [];
      newList.addAll(event.newOnlineList);
      emit(OnlineStatusState(newList));
    });

    _onlineStatusProvider.onlineUsersStream.listen(
      (event) {
        add(UpdateOnlineStateEvent(event));
      },
    );
  }

  final _onlineStatusProvider = locator<OnlineStatusProvider>();

  @override
  Future<void> close() {
    _onlineStatusProvider.dispose();
    return super.close();
  }
}

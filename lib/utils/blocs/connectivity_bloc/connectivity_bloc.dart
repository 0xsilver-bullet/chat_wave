import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(const InitializingConnectvityState()) {
    on<UpdateConnectivityState>((event, emit) {
      emit(ConnectivityStatus(event.connected));
    });
    _subscription = Connectivity().onConnectivityChanged.listen(
      (connectivityStatus) {
        if (connectivityStatus != ConnectivityResult.none) {
          add(const UpdateConnectivityState(true));
        } else {
          add(const UpdateConnectivityState(false));
        }
      },
    );
  }

  late final StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

part of 'connect_bloc.dart';

abstract class ConnectEvent extends Equatable {
  const ConnectEvent();

  @override
  List<Object> get props => [];
}

class ScanSecret extends ConnectEvent {}

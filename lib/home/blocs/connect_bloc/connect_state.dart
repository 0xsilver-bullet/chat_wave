part of 'connect_bloc.dart';

abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class Idle extends ConnectState {}

class ScanningQrCode extends ConnectState {}

/// Emitted when sending the scanned secret to API to applly a specific action
/// currently this action is adding a user as a friend.
class Loading extends ConnectState {}

/// Emitted when connection to friend succeed
class ConnectedToFriend extends ConnectState {}

class FailedToConnect extends ConnectState {}

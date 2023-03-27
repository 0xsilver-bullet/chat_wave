part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

@immutable
class UpdateConnectivityState extends ConnectivityEvent {
  final bool connected;

  const UpdateConnectivityState(this.connected);

  @override
  List<Object> get props => [connected];
}

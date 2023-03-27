part of 'connectivity_bloc.dart';

@immutable
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

@immutable
class InitializingConnectvityState extends ConnectivityState {
  const InitializingConnectvityState();
}

@immutable
class ConnectivityStatus extends ConnectivityState {
  const ConnectivityStatus(this.connected);

  final bool connected;

  @override
  List<Object> get props => [connected];
}

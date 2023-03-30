part of 'online_status_bloc.dart';

@immutable
class OnlineStatusState extends Equatable {
  const OnlineStatusState(this.onlineUsers);

  final List<int> onlineUsers;

  @override
  List<Object> get props => [onlineUsers];
}

part of 'online_status_bloc.dart';

@immutable
class UpdateOnlineStateEvent extends Equatable {
  const UpdateOnlineStateEvent(this.newOnlineList);

  final List<int> newOnlineList;

  @override
  List<Object> get props => [newOnlineList];
}

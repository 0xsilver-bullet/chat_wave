part of 'channels_bloc.dart';

abstract class ChannelsEvent extends Equatable {
  const ChannelsEvent();

  @override
  List<Object> get props => [];
}

@immutable
class ChannelsLoaded extends ChannelsEvent {
  const ChannelsLoaded(this.channels);

  final List<Channel> channels;

  @override
  List<Object> get props => [channels];
}

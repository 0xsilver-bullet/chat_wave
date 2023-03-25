part of 'channels_bloc.dart';

abstract class ChannelsState extends Equatable {
  const ChannelsState();

  @override
  List<Object> get props => [];
}

@immutable
class ChannelsList extends ChannelsState {
  const ChannelsList(this.channels);

  final List<Channel> channels;

  @override
  List<Object> get props => [channels];
}

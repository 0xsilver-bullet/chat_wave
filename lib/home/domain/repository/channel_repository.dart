import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/synchronizable.dart';

abstract class ChannelRepository implements Synchronizable {
  Stream<List<Channel>> get watchChannels;
}

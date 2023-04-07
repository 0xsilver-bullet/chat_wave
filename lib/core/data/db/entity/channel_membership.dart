class ChannelMembership {
  ChannelMembership(this.channelId, this.friendId);

  final int channelId;
  final int friendId;

  Map<String, dynamic> toMap() {
    return {
      'channel_id': channelId,
      'friend_id': friendId,
    };
  }
}

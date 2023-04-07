import 'dart:async';
import 'dart:convert';

import 'package:chat_wave/core/data/db/dao/channel_full_dao.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/dao/message_dao.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/core/data/mapper/message_mapper.dart';
import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:chat_wave/core/domain/online_status_provider.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/core/event/domain/model/client_event.dart';
import 'package:chat_wave/core/event/domain/model/server_event.dart';
import 'package:chat_wave/home/data/mapper/channel_full_mapper.dart';
import 'package:web_socket_channel/io.dart';

import '../domain/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  EventRepositoryImpl(
    this._tokenManager,
    this._friendDao,
    this._messageDao,
    this._channelFullDao,
    this._onlineStatusProvider,
  );

  final TokenManager _tokenManager;
  final FriendDao _friendDao;
  final MessageDao _messageDao;
  final ChannelFullDao _channelFullDao;
  final OnlineStatusProvider _onlineStatusProvider;

  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;

  @override
  Future<void> initialize() async {
    if (_channel != null) return;
    final accessToken = _tokenManager.accessToken;
    if (accessToken == null) return;
    _channel = IOWebSocketChannel.connect(
      BWaveApi.eventsUrl,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    // TODO: refactor this.
    // the following code is to check if connection is established.
    // the connection might fail due to auth error but currently the package doesn't provide
    // a way to detect the cause for connection failure so right now just check if the
    // connection has failed and in this case refresh the token.
    try {
      await _channel?.ready;
    } catch (e) {
      // Then we (probably) need to refresh.
      final isTokenRefreshed = await _tokenManager.refresh();
      if (!isTokenRefreshed) return;
      final newToken = _tokenManager.accessToken!;
      _channel = IOWebSocketChannel.connect(
        BWaveApi.eventsUrl,
        headers: {'Authorization': 'Bearer $newToken'},
      );
    }
    _subscription = _channel?.stream.listen(
      _handleEvent,
      cancelOnError: true,
    );
  }

  @override
  void clear() {
    _channel?.sink.close();
    _subscription?.cancel();
    _channel = null;
    _subscription = null;
  }

  @override
  bool emitClientEvent(ClientEvent event) {
    if (_channel == null) return false;
    final eventJson = event.toJson();
    try {
      _channel?.sink.add(eventJson);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleEvent(dynamic event) async {
    final eventJson = jsonDecode(event);
    final serverEvent = ServerEvent.parse(eventJson);
    if (serverEvent is ReceivedMessageEvent) {
      await _handleReceivedMessageEvent(serverEvent);
    } else if (serverEvent is ConnectedToUserEvent) {
      await _handleConnectedToUserEvent(serverEvent);
    } else if (serverEvent is MessageSentEvent) {
      await _handleMessageSent(serverEvent);
    } else if (serverEvent is FriendOnlineStatusEvent) {
      await _handleFriendOnlineStatusEvent(serverEvent);
    } else if (serverEvent is AddedToChannel) {
      await _handleAddedToChannelEvent(serverEvent);
    }
  }

  Future<void> _handleReceivedMessageEvent(ReceivedMessageEvent event) async {
    final message = event.messageDto.toMessageEntity(false);
    await _messageDao.insert(message);
  }

  Future<void> _handleConnectedToUserEvent(ConnectedToUserEvent event) async {
    final friend = FriendEntity(
      id: event.user.id,
      profilePicUrl: event.user.profilePicUrl,
      name: event.user.name,
      username: event.user.username,
    );
    await _friendDao.insert(friend);
  }

  Future<void> _handleMessageSent(MessageSentEvent event) async {
    final message = event.messageDto.toMessageEntity(true);
    if (event.provisionalId != null) {
      await _messageDao.replace(event.provisionalId!, message);
    } else {
      await _messageDao.insert(message);
    }
  }

  Future<void> _handleFriendOnlineStatusEvent(
    FriendOnlineStatusEvent event,
  ) async {
    if (event.online) {
      // then user is online
      _onlineStatusProvider.markUserAsOnline(event.friendId);
    } else {
      // then he is offline
      _onlineStatusProvider.markUserAsOffline(event.friendId);
    }
  }

  Future<void> _handleAddedToChannelEvent(AddedToChannel event) async {
    final channelFull = event.channelDto.toFullChannelEntity();
    await _channelFullDao.insertAll([channelFull]);
  }
}

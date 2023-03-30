import 'dart:async';
import 'dart:convert';

import 'package:chat_wave/core/data/db/dao/dm_message_dao.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/entity/dm_message.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:chat_wave/core/domain/online_status_provider.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/core/event/domain/model/client_event.dart';
import 'package:chat_wave/core/event/domain/model/server_event.dart';
import 'package:web_socket_channel/io.dart';

import '../domain/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  EventRepositoryImpl(
    this._tokenManager,
    this._dmDao,
    this._friendDao,
    this._onlineStatusProvider,
  );

  final TokenManager _tokenManager;
  final DmMessageDao _dmDao;
  final FriendDao _friendDao;
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
    if (serverEvent is ReceivedDmMessageEvent) {
      await _handleReceivedMessageEvent(serverEvent);
    } else if (serverEvent is ConnectedToUserEvent) {
      await _handleConnectedToUserEvent(serverEvent);
    } else if (serverEvent is DmSentEvent) {
      await _handleDmSent(serverEvent);
    } else if (serverEvent is FriendOnlineStatusEvent) {
      await _handleFriendOnlineStatusEvent(serverEvent);
    }
  }

  Future<void> _handleReceivedMessageEvent(ReceivedDmMessageEvent event) async {
    final message = DmMessageEntity(
      id: event.messageDto.id,
      text: event.messageDto.text,
      senderId: event.messageDto.senderId,
      receiverId: event.messageDto.receiverId,
      timestamp: event.messageDto.timestamp,
      isOwnMessage: false,
      seen: false,
    );
    await _dmDao.insertDmMessage(message);
  }

  Future<void> _handleConnectedToUserEvent(ConnectedToUserEvent event) async {
    final friend = Friend(
      name: event.user.name,
      username: event.user.username,
      id: event.user.id,
    );
    await _friendDao.insertFriend(friend);
  }

  Future<void> _handleDmSent(DmSentEvent event) async {
    final message = DmMessageEntity(
      id: event.messageDto.id,
      text: event.messageDto.text,
      senderId: event.messageDto.senderId,
      receiverId: event.messageDto.receiverId,
      timestamp: event.messageDto.timestamp,
      isOwnMessage: true,
      seen: false,
    );
    if (event.provisionalId != null) {
      await _dmDao.completeReplace(event.provisionalId!, message);
    } else {
      await _dmDao.insertDmMessage(message);
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
}

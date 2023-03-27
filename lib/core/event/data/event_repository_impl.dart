import 'dart:async';

import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/core/event/domain/model/client_event.dart';
import 'package:web_socket_channel/io.dart';

import '../domain/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  EventRepositoryImpl(this._tokenManager);

  final TokenManager _tokenManager;

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

  void _handleEvent(dynamic event) {
    // TODO: remove this print statement form here.
    print(event);
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
}

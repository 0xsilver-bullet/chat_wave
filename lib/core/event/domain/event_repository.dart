import 'model/client_event.dart';

abstract class EventRepository {
  // this method is supposed to connect to the events websocket, and start to
  // handle coming events and process them.
  // also when in initialized it will enable other classes to use this repository to send
  // client events.
  Future<void> initialize();

  // this method will cancel all the listeners and close the websocket connection.
  void clear();

  bool emitClientEvent(ClientEvent event);
}

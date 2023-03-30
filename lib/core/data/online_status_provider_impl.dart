import 'dart:async';

import '../domain/online_status_provider.dart';

class OnlineStatusProviderImpl extends OnlineStatusProvider {
  late final StreamController<List<int>> _onlineStreamControlelr;
  final List<int> _onlineList = [];

  OnlineStatusProviderImpl() {
    _onlineStreamControlelr = StreamController<List<int>>();
    _onlineStreamControlelr.add([]);
  }

  @override
  Future<void> markUserAsOnline(int userId) async {
    _onlineList.add(userId);
    _onlineStreamControlelr.add(_onlineList);
  }

  @override
  Future<void> markUserAsOffline(int userId) async {
    _onlineList.remove(userId);
    _onlineStreamControlelr.add(_onlineList);
  }

  @override
  Stream<List<int>> get onlineUsersStream => _onlineStreamControlelr.stream;

  @override
  void dispose() {
    _onlineStreamControlelr.close();
  }
}

import 'package:chat_wave/core/data/db/dao/db_message_dao.dart';
import 'package:chat_wave/core/data/db/entity/dm_message.dart';
import 'package:chat_wave/core/domain/app_preferences.dart';
import 'package:chat_wave/core/domain/model/dm_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'dm_repository.dart';

class DmRepositoryImpl extends DmRepository {
  DmRepositoryImpl(this._dmDao, this._pref) {
    _userIdFuture = _pref.getUserId();
  }

  late final Future<int?> _userIdFuture;

  final DmMessageDao _dmDao;
  final AppPreferences _pref;
  Future<int> get _userId async => (await _userIdFuture)!;

  @override
  Future<void> saveMessage(
    String text,
    int receiverId,
    String provisionalId,
  ) async {
    final userId = await _userId;
    final message = DmMessageEntity(
      id: provisionalId,
      text: text,
      senderId: userId,
      receiverId: receiverId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      isOwnMessage: true,
      seen: false,
    );
    return await _dmDao.insert(message);
  }

  @override
  Stream<List<DmMessage>> watchFriendDms(int friendId) {
    return _dmDao.watchDmChannel(friendId).map(
          (dmsEntityList) => dmsEntityList
              .map(
                (dmEntity) => DmMessage(
                  id: dmEntity.id,
                  text: dmEntity.text,
                  senderId: dmEntity.senderId,
                  formattedDate: timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(dmEntity.timestamp),
                  ),
                  isOwnMessage: dmEntity.isOwnMessage,
                  receiverId: dmEntity.receiverId,
                  seen: dmEntity.seen,
                ),
              )
              .toList(),
        );
  }
}

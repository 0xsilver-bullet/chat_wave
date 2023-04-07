import 'package:chat_wave/chat/data/repository/message_repository.dart';
import 'package:chat_wave/core/data/db/dao/message_dao.dart';
import 'package:chat_wave/core/data/db/entity/message.dart';
import 'package:chat_wave/core/domain/app_preferences.dart';
import 'package:chat_wave/core/domain/model/message.dart';
import 'package:chat_wave/home/data/mapper/message_mapper.dart';

class MessageRepositoryImpl extends MessageRepository {
  MessageRepositoryImpl(AppPreferences pref, MessageDao messageDao)
      : _pref = pref,
        _messageDao = messageDao {
    _userIdFuture = _pref.getUserId();
  }

  final AppPreferences _pref;
  final MessageDao _messageDao;
  late final Future<int?> _userIdFuture;

  Future<int> get _userId async => (await _userIdFuture)!;

  @override
  Future<void> saveMessage(
    String text,
    int channelId,
    String provisionalId,
  ) async {
    final userId = await _userId;
    final localMessage = MessageEntity.createLocalMessage(
      provisionalId,
      text,
      channelId,
      userId,
    );
    await _messageDao.insert(localMessage);
  }

  @override
  Stream<List<Message>> watchChannelMessages(int channelId) {
    return _messageDao.watchChannelMessages(channelId).map(
      (event) {
        return event.map((msg) => msg.toMessage()).toList();
      },
    );
  }
}

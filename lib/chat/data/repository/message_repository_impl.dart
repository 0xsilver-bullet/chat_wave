import 'package:chat_wave/chat/data/repository/message_repository.dart';
import 'package:chat_wave/core/data/db/dao/channel_full_dao.dart';
import 'package:chat_wave/core/data/db/dao/message_dao.dart';
import 'package:chat_wave/core/data/db/entity/message.dart';
import 'package:chat_wave/core/domain/app_preferences.dart';
import 'package:chat_wave/core/domain/model/message.dart';
import 'package:chat_wave/home/data/mapper/message_mapper.dart';

class MessageRepositoryImpl extends MessageRepository {
  MessageRepositoryImpl(
    AppPreferences pref,
    MessageDao messageDao,
    ChannelFullDao channelFullDao,
  )   : _pref = pref,
        _messageDao = messageDao,
        _channelFullDao = channelFullDao {
    _userIdFuture = _pref.getUserId();
  }

  final AppPreferences _pref;
  final MessageDao _messageDao;
  final ChannelFullDao _channelFullDao;
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
    await _channelFullDao.insertMessage(localMessage);
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

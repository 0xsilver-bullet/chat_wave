import 'package:chat_wave/chat/blocs/message_input_bloc/message_input_bloc.dart';
import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/model/dm_channel.dart';
import 'package:chat_wave/core/event/events_bloc/events_bloc.dart';
import 'package:chat_wave/utils/blocs/app_bloc/app_bloc.dart';
import 'package:chat_wave/utils/blocs/online_status_bloc/online_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/messages_bloc/messages_bloc.dart';
import '../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.channel});

  final Channel channel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _messageFieldController;

  @override
  void initState() {
    _messageFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forceDarkMode = BlocProvider.of<AppBloc>(context).state.forceDarkMode;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MessagesBloc(channelId: (widget.channel as DmChannel).friendId),
        ),
        BlocProvider(
          create: (_) => MessageInputBloc(
            eventsBloc: BlocProvider.of<EventsBloc>(context),
            sendChannelId: (widget.channel as DmChannel).friendId,
          ),
        )
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<OnlineStatusBloc, OnlineStatusState>(
                builder: (context, state) {
                  bool? online;
                  // only check online or not in case of dm channel
                  if (widget.channel is DmChannel) {
                    final friendId = (widget.channel as DmChannel).friendId;
                    online = state.onlineUsers.contains(friendId);
                  }
                  return ChatTop(
                    channel: widget.channel,
                    online: online,
                    onCloseCallback: () => Navigator.of(context).pop(),
                  );
                },
              ),
              BlocBuilder<MessagesBloc, MessagesState>(
                builder: (context, state) {
                  final messages = (state as MessagesList).messages;
                  return Expanded(
                    child: Container(
                      color: isDarkMode || forceDarkMode
                          ? Colors.black
                          : const Color(0xFFF4F4F4),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Container(
                            alignment: message.isOwnMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: MessageItem(message: message),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              Theme(
                data: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      hintStyle: TextStyle(
                        color: isDarkMode || forceDarkMode
                            ? Colors.white
                            : Colors.black,
                      )),
                ),
                child: BlocBuilder<MessageInputBloc, MessageInputState>(
                  buildWhen: (_, __) => false,
                  builder: (ctx, state) {
                    return TextField(
                      controller: _messageFieldController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        BlocProvider.of<MessageInputBloc>(ctx).add(Send(value));
                        _messageFieldController.text = '';
                      },
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: isDarkMode || forceDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

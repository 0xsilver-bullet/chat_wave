import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/model/dm_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/messages_bloc/messages_bloc.dart';
import '../blocs/online_bloc/online_bloc.dart';
import '../widgets/widgets.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.channel});

  final Channel channel;
  final _messageFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OnlineBloc(),
        ),
        BlocProvider(
          create: (context) => MessagesBloc(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<OnlineBloc, OnlineState>(
                builder: (context, state) {
                  bool? online;
                  // only check online or not in case of dm channel
                  if (channel is DmChannel) {
                    online = state is Online;
                  }
                  return ChatTop(
                    channel: channel,
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
                      color:
                          isDarkMode ? Colors.black : const Color(0xFFF4F4F4),
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
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                child: TextField(
                  controller: _messageFieldController,
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                    hintText: 'Message...',
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

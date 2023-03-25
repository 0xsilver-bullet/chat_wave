import 'package:chat_wave/chat/screens/chat_screen.dart';
import 'package:chat_wave/home/blocs/channels_bloc/channels_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static Route get route {
    return MaterialPageRoute(
      builder: (context) => HomeScreen(),
    );
  }

  final _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomeTop(
              onAddClick: () {},
              onShareClick: () {},
              onSettingsClick: () {},
            ),
            const SizedBox(height: 18),
            _searchField(context),
            const SizedBox(height: 4.0),
            Expanded(
              child: BlocProvider(
                create: (_) => ChannelsBloc(),
                child: BlocBuilder<ChannelsBloc, ChannelsState>(
                  builder: (ctx, state) {
                    final channels = (state as ChannelsList).channels;
                    return ListView.builder(
                      itemCount: channels.length,
                      itemBuilder: (_, index) {
                        return ChatItem(
                          channel: channels[index],
                          onClick: () =>
                              Navigator.of(context).push(ChatScreen.route),
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: _searchFieldController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search for chat or messages',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}

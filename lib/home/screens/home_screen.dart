import 'package:chat_wave/chat/screens/chat_screen.dart';
import 'package:chat_wave/home/blocs/friends_bloc/friends_bloc.dart';
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
                create: (_) => FriendsBloc(),
                child: BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (ctx, state) {
                    final friends = (state as FriendsList).friends;
                    return ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (_, index) {
                        return ChatItem(
                          name: friends[index].name,
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

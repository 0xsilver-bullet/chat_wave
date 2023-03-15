import 'package:chat_wave/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

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
              child: ListView.builder(
                itemCount: 100000,
                itemBuilder: (context, index) {
                  return ChatItem(
                    onClick: () => Navigator.of(context).push(ChatScreen.route),
                  );
                },
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

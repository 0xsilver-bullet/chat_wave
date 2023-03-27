import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_wave/auth/screen/auth_screens.dart';
import 'package:chat_wave/setting/widget/setting_tile.dart';
import 'package:chat_wave/utils/blocs/app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Route get route =>
      MaterialPageRoute(builder: (_) => const SettingsScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundImage: CachedNetworkImageProvider(
                'https://h-o-m-e.org/wp-content/uploads/2022/04/Blank-Profile-Picture-1.jpg',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Name',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 32),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'GENERAL',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SettingTile(
              icon: Icons.person,
              name: 'Edit Profile',
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onClick: () {},
            ),
            SettingTile(
              icon: Icons.notifications,
              name: 'Notifications',
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onClick: () {},
            ),
            SettingTile(
              icon: Icons.fingerprint,
              name: 'Security',
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onClick: () {},
            ),
            BlocBuilder<AppBloc, AppState>(
              builder: (ctx, state) {
                return SettingTile(
                  icon: Icons.dark_mode,
                  name: 'Dark Mode',
                  trailing: Switch(
                    value: state.forceDarkMode,
                    onChanged: (_) {
                      BlocProvider.of<AppBloc>(ctx).add(ToggleForceDarkMode());
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SettingTile(
              icon: Icons.logout,
              name: 'Logout',
              onClick: () {
                BlocProvider.of<AppBloc>(context).add(Logout());
                Navigator.of(context).pushAndRemoveUntil(
                  LoginScreen.route,
                  (route) => false,
                );
              },
              iconColor: Colors.red,
              textTheme: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

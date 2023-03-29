import 'package:chat_wave/setting/blocs/name_bloc/name_bloc.dart';
import 'package:chat_wave/setting/blocs/profile_pic_bloc/profile_pic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_wave/auth/screen/auth_screens.dart';
import 'package:chat_wave/utils/blocs/app_bloc/app_bloc.dart';

import '../widget/settings_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Route get route =>
      MaterialPageRoute(builder: (_) => const SettingsScreen());

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final userInfo = (appBloc.state as AppAuthenticated).userInfo;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfilePicBloc(userInfo.profilePicUrl, appBloc),
        ),
        BlocProvider(
          create: (context) => NameBloc(userInfo.name, appBloc),
        ),
      ],
      child: BlocConsumer<ProfilePicBloc, ProfilePicState>(
        listener: (ctx, state) {
          if (state is UpdatedProfilePic) {
            BlocProvider.of<ProfilePicBloc>(ctx).add(FinishedUpdating());
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: state is LocalProfilePic ? 1.0 : 0.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: state is LocalProfilePic ? 56.0 : 0.0,
                width: state is LocalProfilePic ? 56.0 : 0.0,
                child: FloatingActionButton(
                  child: const Icon(Icons.check),
                  onPressed: () {
                    BlocProvider.of<ProfilePicBloc>(ctx)
                        .add(SubmitNewProfilePic());
                  },
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  if (state is DefaultProfilePic)
                    EditableAvatarImage.network(
                      picUrl: state.profilePicUrl ??
                          'https://h-o-m-e.org/wp-content/uploads/2022/04/Blank-Profile-Picture-1.jpg',
                      onTap: () {
                        BlocProvider.of<ProfilePicBloc>(ctx)
                            .add(ChangeProfilePic());
                      },
                    )
                  else if (state is LocalProfilePic)
                    EditableAvatarImage.local(
                      picPath: state.imagePath,
                      onTap: () {
                        BlocProvider.of<ProfilePicBloc>(ctx)
                            .add(ChangeProfilePic());
                      },
                    )
                  else
                    Container(),
                  const SizedBox(height: 8),
                  BlocBuilder<NameBloc, NameState>(
                    builder: (ctx, state) {
                      return EditableName(
                        name: state.name,
                        onTap: () => _startEditUserName(ctx),
                      );
                    },
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
                            BlocProvider.of<AppBloc>(ctx)
                                .add(ToggleForceDarkMode());
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
                    textTheme: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _startEditUserName(BuildContext ctx) {
    showBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return BlocBuilder<NameBloc, NameState>(
          builder: (context, state) {
            return EditNameForm(state.name);
          },
        );
      },
    );
  }
}

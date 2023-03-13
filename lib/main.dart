import 'package:chat_wave/home/screens/home_screen.dart';
import 'package:chat_wave/utils/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:chat_wave/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'auth/screen/auth_screens.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ChatWaveApp());
}

class ChatWaveApp extends StatelessWidget {
  const ChatWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (_) => AppBloc(),
        child: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state is! LoadingAppState) {
              FlutterNativeSplash.remove();
            }
          },
          builder: (context, state) {
            if (state is AppNeedsAuthentication) {
              return const LoginScreen();
            } else if (state is AppAuthenticated) {
              return HomeScreen();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

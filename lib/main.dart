import 'package:chat_wave/core/event/events_bloc/events_bloc.dart';
import 'package:chat_wave/home/screens/home_screen.dart';
import 'package:chat_wave/utils/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:chat_wave/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'auth/screen/auth_screens.dart';
import 'utils/blocs/app_bloc/app_bloc.dart';
import 'utils/blocs/online_status_bloc/online_status_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setupServiceLocator();
  await locator.allReady();
  runApp(const ChatWaveApp());
}

class ChatWaveApp extends StatelessWidget {
  const ChatWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppBloc(),
        ),
        BlocProvider(
          create: (_) => EventsBloc(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => ConnectivityBloc(),
        ),
        BlocProvider(
          create: (context) => OnlineStatusBloc(),
          child: Container(),
        )
      ],
      child: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state is! LoadingAppState) {
            FlutterNativeSplash.remove();
          }
        },
        builder: (context, state) {
          Widget home;
          if (state is AppNeedsAuthentication) {
            home = const LoginScreen();
          } else if (state is AppAuthenticated) {
            home = const HomeScreen();
          } else {
            home = Container();
          }
          return MaterialApp(
            theme:
                state.forceDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: home,
          );
        },
      ),
    );
  }
}

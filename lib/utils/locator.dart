import 'package:chat_wave/auth/data/repository/auth_repository_impl.dart';
import 'package:chat_wave/auth/domain/repository/auth_repository.dart';
import 'package:chat_wave/chat/data/repository/message_repository.dart';
import 'package:chat_wave/chat/data/repository/message_repository_impl.dart';
import 'package:chat_wave/core/data/app_preferences_impl.dart';
import 'package:chat_wave/core/data/db/chat_wave_db.dart';
import 'package:chat_wave/core/data/network/auth_interceptor.dart';
import 'package:chat_wave/core/data/online_status_provider_impl.dart';
import 'package:chat_wave/core/data/secure_local_storage_impl.dart';
import 'package:chat_wave/core/data/token_manager_impl.dart';
import 'package:chat_wave/core/domain/app_preferences.dart';
import 'package:chat_wave/core/domain/online_status_provider.dart';
import 'package:chat_wave/core/domain/secure_local_storage.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/core/event/data/event_repository_impl.dart';
import 'package:chat_wave/core/event/domain/event_repository.dart';
import 'package:chat_wave/home/data/repository/channel_repository_impl.dart';
import 'package:chat_wave/home/data/repository/connection_repository_impl.dart';
import 'package:chat_wave/home/data/repository/friend_repository_impl.dart';
import 'package:chat_wave/home/domain/repository/channel_repository.dart';
import 'package:chat_wave/home/domain/repository/connection_repository.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:chat_wave/setting/data/repository/profile_repository_impl.dart';
import 'package:chat_wave/setting/domain/repository/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerLazySingleton<Dio>(_configureDioClient);
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  locator.registerLazySingleton<SecureStorage>(() => SecureStorageImpl());
  locator.registerSingletonAsync<TokenManager>(
    () async {
      final manager = TokenManagerImpl();
      await manager.init();
      return manager;
    },
  );
  locator.registerSingletonWithDependencies(
    () => AuthInterceptor(),
    dependsOn: [TokenManager],
  );

  locator.registerSingletonAsync<ChatWaveDb>(
    () async {
      final db = ChatWaveDb();
      await db.initialize();
      return db;
    },
  );

  locator.registerLazySingleton<FriendRepository>(
    () {
      return FriendRepositoryImpl();
    },
  );

  locator.registerLazySingleton<ConnectionRepository>(
    () {
      final db = locator<ChatWaveDb>();
      return ConnectionRepositoryImpl(db.friendDao);
    },
  );

  locator.registerLazySingleton<OnlineStatusProvider>(
    () => OnlineStatusProviderImpl(),
  );

  locator.registerLazySingleton<EventRepository>(
    () {
      final tokenManager = locator<TokenManager>();
      final db = locator<ChatWaveDb>();
      final onlineStatusProiver = locator<OnlineStatusProvider>();
      return EventRepositoryImpl(
        tokenManager,
        db.friendDao,
        db.messageDao,
        db.channelFullDao,
        onlineStatusProiver,
      );
    },
  );

  locator.registerLazySingleton<ChannelRepository>(
    () {
      final db = locator<ChatWaveDb>();
      final onlineStatusProvider = locator<OnlineStatusProvider>();
      return ChannelRepositoryImpl(
        db.channelFullDao,
        onlineStatusProvider,
      );
    },
  );

  locator.registerFactory<AuthRepository>(() => AuthRepositoryImpl());

  locator.registerFactory<MessageRepository>(
    () {
      final db = locator<ChatWaveDb>();
      final prefs = locator<AppPreferences>();
      return MessageRepositoryImpl(
        prefs,
        db.messageDao,
        db.channelFullDao,
      );
    },
  );

  locator.registerLazySingleton<AppPreferences>(() => AppPreferencesImpl());

  locator.registerLazySingleton<ProfileRepository>(
    () {
      final prefs = locator<AppPreferences>();
      return ProfileRepositoryImpl(prefs);
    },
  );
}

Dio _configureDioClient() {
  final dio = Dio();
  dio.options.validateStatus = (_) => true;
  dio.options.responseType = ResponseType.json;
  final interceptor = locator<AuthInterceptor>();
  dio.interceptors.add(interceptor);
  return dio;
}

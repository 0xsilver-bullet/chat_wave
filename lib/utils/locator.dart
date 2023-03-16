import 'package:chat_wave/core/data/network/auth_interceptor.dart';
import 'package:chat_wave/core/data/secure_local_storage_impl.dart';
import 'package:chat_wave/core/data/token_manager_impl.dart';
import 'package:chat_wave/core/domain/secure_local_storage.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
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
}

Dio _configureDioClient() {
  final dio = Dio();
  dio.options.validateStatus = (_) => true;
  dio.options.responseType = ResponseType.json;
  final interceptor = locator<AuthInterceptor>();
  dio.interceptors.add(interceptor);
  return dio;
}
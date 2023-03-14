import 'package:chat_wave/core/data/secure_local_storage_impl.dart';
import 'package:chat_wave/core/domain/secure_local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerLazySingleton<Dio>(_configureDioClient);
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  locator.registerLazySingleton<SecureStorage>(() => SecureStorageImpl());
}

Dio _configureDioClient() {
  final dio = Dio();
  dio.options.validateStatus = (_) => true;
  dio.options.responseType = ResponseType.json;
  return dio;
}

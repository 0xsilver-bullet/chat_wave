import 'package:chat_wave/core/data/network/api_error.dart';

class ApiResponse<T> {
  ApiResponse({
    required this.isSuccessful,
    this.data,
    this.error,
  });

  final bool isSuccessful;
  final T? data;
  final ApiError? error;
}

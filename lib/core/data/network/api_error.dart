class ApiError {
  const ApiError({required this.errorCode, this.message});

  ApiError.fromJson(Map<String, dynamic> json)
      : errorCode = json['errorCode'],
        message = json['message'];

  final int errorCode;
  final String? message;
}

import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final tokenManager = locator<TokenManager>();

  final interceptorClient = Dio();

  AuthInterceptor() {
    interceptorClient.options.validateStatus = (status) => true;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = tokenManager.accessToken;
    if (accessToken != null) {
      // just attach the access token
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      // then we probably need to refresh the token.
      final tokenHasRefreshed = await tokenManager.refresh();
      if (!tokenHasRefreshed) {
        // we can't refresh token so just return the failed resposne.
        handler.next(response);
        return;
      }
      // then token has been updated and we can resend the request.
      final accessToken = tokenManager.accessToken;
      if (accessToken == null) {
        handler.next(response);
        return;
      }
      interceptorClient.options.headers['Authorization'] =
          'Bearer $accessToken';
      final requestOpts = response.requestOptions;
      final newResponse = await interceptorClient.request(
        requestOpts.path,
        data: requestOpts.data,
        queryParameters: requestOpts.queryParameters,
        cancelToken: requestOpts.cancelToken,
        options: Options(method: requestOpts.method),
      );
      handler.next(newResponse);
      return;
    }
    handler.next(response);
  }
}

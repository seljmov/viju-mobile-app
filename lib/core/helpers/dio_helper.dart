import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../repositories/tokens/tokens_repository_impl.dart';
import 'env_helper.dart';

/// Помощник работы с Dio
abstract class DioHelper {
  static final _tokensRepository = TokensRepositoryImpl();
  static const _localBaseUrl = "https://dev.waste.v1ju.ru/api";

  static String get baseUrl => EnvHelper.mainApiUrl ?? _localBaseUrl;

  /// Отправить данные
  static Future<Response> postData({
    required String url,
    dynamic data,
    bool useAuthrorization = true,
    bool useLoggerInterceptor = true,
    bool useAuthErrorInterceptor = true,
  }) async {
    final dio = getDioClient(useLoggerInterceptor, useAuthErrorInterceptor);
    if (useAuthrorization) {
      final accessToken = await _tokensRepository.getAccessToken();
      final body = Map.from(data ?? {});
      body['accessToken'] = accessToken;
      data = body;
    }
    return await dio.post(url, data: data);
  }

  /// Получить клиент с найстройками
  static Dio getDioClient(
    bool useLoggerInterceptor,
    bool useAuthErrorInterceptor,
  ) {
    final client = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 32),
        receiveTimeout: const Duration(seconds: 32),
      ),
    );

    if (useLoggerInterceptor) {
      client.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
        ),
      );
    }

    if (useAuthErrorInterceptor) {
      client.interceptors.add(InterceptorsWrapper(
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 ||
              error.response?.statusCode == 400) {
            try {
              final tokensRepository = TokensRepositoryImpl();
              await tokensRepository.updateTokensFromServer();

              final options = Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
                responseType: error.requestOptions.responseType,
              );

              final accessToken = await tokensRepository.getAccessToken();
              final headers = error.requestOptions.headers;
              if (headers.containsKey('access_token')) {
                headers['Authorization'] = 'Bearer: $accessToken';
                options.headers = headers;
              }

              final response = await Dio().request<dynamic>(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: options,
              );

              debugPrint("Refresh-токен успешно обновлен.");
              return handler.resolve(response);
            } on DioException catch (e) {
              debugPrint("DioInterceptorError -> $e");
              debugPrint("Refresh-токен не обновлен.");
              navService.pushNamedAndRemoveUntil('/welcome');
              rethrow;
            }
          }
        },
      ));
    }

    client.options.followRedirects = false;
    client.options.validateStatus = (status) {
      return true;
    };

    return client;
  }
}

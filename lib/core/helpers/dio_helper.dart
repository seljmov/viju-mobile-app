import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../constants/routes_constants.dart';
import '../repositories/tokens/tokens_repository_impl.dart';
import 'env_helper.dart';
import 'my_logger.dart';

/// Помощник работы с Dio
abstract class DioHelper {
  static final _tokensRepository = TokensRepositoryImpl();
  static const _localBaseUrl = "https://dev.waste.v1ju.ru/api";

  static String get baseUrl => EnvHelper.mainApiUrl ?? _localBaseUrl;

  /// Отправить данные
  static Future<Response> postData({
    required String url,
    dynamic data = const {},
    bool useAuthErrorInterceptor = true,
  }) async {
    final dio = _getDioClient(useAuthErrorInterceptor);
    return await dio.post(url, data: data);
  }

  static Dio get getBaseDioClient => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 32),
          receiveTimeout: const Duration(seconds: 32),
        ),
      );

  /// Получить клиент с найстройками
  static Dio _getDioClient(bool useAuthErrorInterceptor) {
    final client = getBaseDioClient;

    if (useAuthErrorInterceptor) {
      client.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _tokensRepository.getAccessToken();
          debugPrint('accessToken -> $accessToken');

          final headers = Map<String, dynamic>.from(options.headers);
          headers['Accept'] = 'application/json';
          headers['Content-Type'] = 'application/json';

          if (accessToken != null) {
            if (options.data is Map) {
              final body = Map.from(options.data ?? {});
              body['accessToken'] = accessToken;
              options.data = body;
            }
            headers['Authorization'] = 'Bearer $accessToken';
            headers['accessToken'] = accessToken;
          }

          options.headers = headers;
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 400) {
            try {
              final tokensRepository = TokensRepositoryImpl();
              await tokensRepository.updateTokensFromServer();

              final accessToken = await tokensRepository.getAccessToken();
              final data = error.requestOptions.data;
              if (data is Map && data.containsKey('accessToken')) {
                data['accessToken'] = accessToken;
              }

              final headers = error.requestOptions.headers;
              if (headers.containsKey('Authorization')) {
                headers['Authorization'] = 'Bearer $accessToken';
                headers['accessToken'] = accessToken;
              }

              final options = Options(
                method: error.requestOptions.method,
                headers: headers,
                responseType: error.requestOptions.responseType,
              );

              final client = Dio();
              final path =
                  '${error.requestOptions.baseUrl}${error.requestOptions.path}';
              final response = await client.request<dynamic>(
                path,
                data: data,
                options: options,
                queryParameters: error.requestOptions.queryParameters,
              );

              MyLogger.i('Refresh-токен успешно обновлен.');
              return handler.resolve(response);
            } on DioException catch (e) {
              MyLogger.i('Refresh-токен не обновлен.');
              MyLogger.e('DioInterceptorError -> $e');
              navService.pushNamedAndRemoveUntil(AppRoutes.start);
              rethrow;
            }
          }
        },
      ));
    }

    return client;
  }
}

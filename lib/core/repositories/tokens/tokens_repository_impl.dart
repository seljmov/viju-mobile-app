import 'package:flutter/foundation.dart';

import '../../constants/constants.dart';
import '../../extension/formatted_message.dart';
import '../../helpers/dio_helper.dart';
import '../../helpers/my_logger.dart';
import 'tokens_repository.dart';

/// Репозиторий работы с токенами
@immutable
class TokensRepositoryImpl implements TokensRepository {
  String get _accessToken => TokensRepository.accessTokenKey;
  String get _refreshToken => TokensRepository.refreshTokenKey;

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await storage.write(key: _accessToken, value: accessToken);
    await storage.write(key: _refreshToken, value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await storage.read(key: _accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await storage.read(key: _refreshToken);
  }

  @override
  Future<bool> deleteTokens() async {
    try {
      await storage.delete(key: _accessToken);
      await storage.delete(key: _refreshToken);
      return true;
    } catch (e) {
      MyLogger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> updateTokensFromServer() async {
    try {
      final data = {
        'refreshToken': await getRefreshToken(),
      };

      final response = await DioHelper.postData(
        url: '/auth/refresh',
        data: data,
        useAuthErrorInterceptor: false,
      );

      switch (response.statusCode) {
        case 200:
          await saveTokens(
            response.data['accessToken'],
            response.data['refreshToken'],
          );
          return true;
        case 400:
          throw Exception('Не задан токен обновления. Попробуйте снова.');
        case 404:
          throw Exception('Пользователь не найден или отключен.');
        default:
          throw Exception('Не удалось обновить токены! Попробуйте снова.');
      }
    } on Exception catch (e) {
      await deleteTokens();
      MyLogger.e(e.getMessage);
      rethrow;
    }
  }
}

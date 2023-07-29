import 'package:flutter/foundation.dart';

/// Интерфейс репозиторий работы с токенами
abstract class TokensRepository {
  @protected
  static const String accessTokenKey = '_access_token';

  @protected
  static const String refreshTokenKey = '_refresh_token';

  /// Сохранить токены
  Future<void> saveTokens(String accessToken, String refreshToken);

  /// Получить токен доступа
  Future<String?> getAccessToken();

  /// Получить токен обновления
  Future<String?> getRefreshToken();

  /// Удалить токены
  Future<bool> deleteTokens();

  /// Обновить токены с сервера
  Future<bool> updateTokensFromServer();
}
